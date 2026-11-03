class_name BattleSelection
extends RefCounted
## The touch flow of the battle screen (screens §3), without any Node:
## tap a saint → tap an action → valid targets light up → tap a target to see
## the preview → tap again to confirm. It never decides a rule: every option
## comes from BattleController.validate() and every preview from
## BattleController.preview().

enum Mode { NONE, ABILITY, MIRACLE, SWAP, PASS, PROVISION }

## Answers of tap_combatant().
const IGNORED: StringName = &"ignored"
const PICKED: StringName = &"picked"
const PREVIEW: StringName = &"preview"
const CONFIRM: StringName = &"confirm"

const SIDE_PARTY: StringName = &"party"
const SIDE_ENEMY: StringName = &"enemy"
const PARTY_TARGETING: Array[StringName] = [&"self", &"ally", &"ally_fallen", &"all_allies"]

var ctrl: BattleController
var actor_id: StringName = &""
var mode: Mode = Mode.NONE
## Ability (or miracle) being aimed.
var ability_id: StringName = &""
var provision_id: StringName = &""
## Which side the chosen action aims at.
var side: StringName = &""
## Every accepted target slot set for the chosen action (Array of Array[int]).
var valid_sets: Array = []
## Slots tapped so far (chosen_enemy_slots needs several taps).
var picked: Array[int] = []
## Complete command waiting for the confirming tap, or null.
var pending: BattleCommand
var preview: Array[PreviewEntry] = []


func _init(p_ctrl: BattleController) -> void:
	ctrl = p_ctrl


## Every subset of slots 1..4, smallest first ([] for actions without target).
static func slot_sets() -> Array:
	var sets: Array = [[] as Array[int]]
	for size: int in range(1, 5):
		for mask: int in range(1, 16):
			var slots: Array[int] = []
			for bit: int in 4:
				if (mask & (1 << bit)) != 0:
					slots.append(bit + 1)
			if slots.size() == size:
				sets.append(slots)
	return sets


func actor() -> Combatant:
	return ctrl.state.find(actor_id) if actor_id != &"" else null


## Saints that can still do something this turn, in slot order.
func ready_saints() -> Array[Combatant]:
	var result: Array[Combatant] = []
	for saint: Combatant in ctrl.state.party:
		if saint.is_standing() and not saint.has_acted:
			result.append(saint)
	return result


func reset() -> void:
	actor_id = &""
	clear_choice()


func clear_choice() -> void:
	mode = Mode.NONE
	ability_id = &""
	provision_id = &""
	side = &""
	valid_sets = []
	picked = []
	pending = null
	preview = []


func select_actor(id: StringName) -> bool:
	var c: Combatant = ctrl.state.find(id)
	if c == null or not c.is_saint():
		return false
	actor_id = id
	clear_choice()
	return true


## "" when the actor could use the ability (or miracle) on some target now,
## otherwise the refusal code shown on the greyed button.
func ability_reason(id: StringName, is_miracle: bool) -> StringName:
	if actor() == null:
		return CommandResult.UNKNOWN_ACTOR
	for slots: Array[int] in slot_sets():
		var reason: StringName = ctrl.validate(_ability_command(id, is_miracle, slots))
		if reason == &"":
			return &""
		# Every check but the target gives the same answer for any slots.
		if reason != CommandResult.INVALID_TARGET:
			return reason
	return CommandResult.INVALID_TARGET


func swap_reason() -> StringName:
	if actor() == null:
		return CommandResult.UNKNOWN_ACTOR
	var reason: StringName = &""
	for direction: int in [-1, 1]:
		reason = ctrl.validate(BattleCommand.swap_slots(actor_id, direction))
		if reason == &"":
			return &""
	return reason


func pass_reason() -> StringName:
	if actor() == null:
		return CommandResult.UNKNOWN_ACTOR
	return ctrl.validate(BattleCommand.pass_turn(actor_id))


func provision_reason(id: StringName) -> StringName:
	if actor() == null:
		return CommandResult.UNKNOWN_ACTOR
	var reason: StringName = &""
	for slot: int in range(1, ctrl.state.party_size() + 1):
		reason = ctrl.validate(BattleCommand.use_provision(id, slot, actor_id))
		if reason == &"":
			return &""
	return reason


func choose_ability(id: StringName) -> bool:
	return _choose_aimed(Mode.ABILITY, id)


func choose_miracle() -> bool:
	return actor() != null and _choose_aimed(Mode.MIRACLE, actor().miracle)


func choose_swap() -> bool:
	if actor() == null:
		return false
	clear_choice()
	var from_slot: int = ctrl.state.party_slot_of(actor())
	for direction: int in [-1, 1]:
		if ctrl.validate(BattleCommand.swap_slots(actor_id, direction)) == &"":
			valid_sets.append([from_slot + direction] as Array[int])
	if valid_sets.is_empty():
		return false
	mode = Mode.SWAP
	side = SIDE_PARTY
	return true


func choose_pass() -> bool:
	if pass_reason() != &"":
		return false
	clear_choice()
	mode = Mode.PASS
	_set_pending([] as Array[int])
	return true


func choose_provision(id: StringName) -> bool:
	if actor() == null:
		return false
	clear_choice()
	var def: ProvisionDef = ctrl.state.catalog.provision(id)
	for slot: int in range(1, ctrl.state.party_size() + 1):
		if ctrl.validate(BattleCommand.use_provision(id, slot, actor_id)) == &"":
			valid_sets.append([slot] as Array[int])
	if valid_sets.is_empty():
		return false
	mode = Mode.PROVISION
	provision_id = id
	side = SIDE_PARTY
	if def != null and def.targeting == &"self":
		_set_pending([ctrl.state.party_slot_of(actor())] as Array[int])
	return true


## A tap on a combatant while an action is chosen: picks a target, shows the
## preview when the targets are complete, or confirms when tapped again.
func tap_combatant(id: StringName) -> StringName:
	if mode == Mode.NONE:
		return IGNORED
	var c: Combatant = ctrl.state.find(id)
	if c == null:
		return IGNORED
	if pending != null and pending_ids().has(id):
		return CONFIRM
	var tapped_side: StringName = SIDE_PARTY if c.is_saint() else SIDE_ENEMY
	if tapped_side != side:
		return IGNORED
	for slot: int in _slots_of(c):
		var result: StringName = _tap_slot(slot)
		if result != IGNORED:
			return result
	return IGNORED


## Takes the confirmed command and clears the choice (the actor stays).
func take_pending() -> BattleCommand:
	var cmd: BattleCommand = pending
	clear_choice()
	return cmd


## Combatants that would be affected by the pending command (preview), plus
## the tapped targets.
func pending_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for entry: PreviewEntry in preview:
		ids.append(entry.target_id)
	for slot: int in picked:
		var c: Combatant = _at(side, slot)
		if c != null and not ids.has(c.id):
			ids.append(c.id)
	return ids


## Combatants that can be tapped as the next target.
func targetable_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for slots: Array[int] in valid_sets:
		if slots.is_empty() or not _contains_all(slots, picked):
			continue
		for slot: int in slots:
			var c: Combatant = _at(side, slot)
			if c != null and not ids.has(c.id):
				ids.append(c.id)
	return ids


# --- internals ---------------------------------------------------------------

func _choose_aimed(p_mode: Mode, id: StringName) -> bool:
	if actor() == null or id == &"":
		return false
	clear_choice()
	var is_miracle: bool = p_mode == Mode.MIRACLE
	for slots: Array[int] in slot_sets():
		if ctrl.validate(_ability_command(id, is_miracle, slots)) == &"":
			valid_sets.append(slots)
	if valid_sets.is_empty():
		return false
	mode = p_mode
	ability_id = id
	var ability: AbilityDef = ctrl.state.catalog.ability(id)
	side = SIDE_PARTY if ability != null and PARTY_TARGETING.has(ability.targeting) else SIDE_ENEMY
	if _has_set([] as Array[int]):
		_set_pending([] as Array[int])
	return true


func _tap_slot(slot: int) -> StringName:
	var grown: Array[int] = picked.duplicate()
	if not grown.has(slot):
		grown.append(slot)
	grown.sort()
	var next: Array[int] = []
	if _is_prefix_of_some_set(grown):
		next = grown
	elif _is_prefix_of_some_set([slot] as Array[int]):
		next = [slot] as Array[int]
	else:
		return IGNORED
	picked = next
	pending = null
	preview = []
	if _has_set(picked):
		_set_pending(picked)
		return PREVIEW
	return PICKED


func _set_pending(slots: Array[int]) -> void:
	picked = slots.duplicate()
	pending = _command(slots)
	preview = ctrl.preview(pending)


func _command(slots: Array[int]) -> BattleCommand:
	match mode:
		Mode.ABILITY:
			return _ability_command(ability_id, false, slots)
		Mode.MIRACLE:
			return _ability_command(ability_id, true, slots)
		Mode.SWAP:
			return BattleCommand.swap_slots(actor_id, slots[0] - ctrl.state.party_slot_of(actor()))
		Mode.PROVISION:
			return BattleCommand.use_provision(provision_id, slots[0], actor_id)
		Mode.PASS:
			return BattleCommand.pass_turn(actor_id)
	return null


func _ability_command(id: StringName, is_miracle: bool, slots: Array[int]) -> BattleCommand:
	if is_miracle:
		return BattleCommand.use_miracle(actor_id, slots)
	return BattleCommand.use_ability(actor_id, id, slots)


func _has_set(slots: Array[int]) -> bool:
	for candidate: Array[int] in valid_sets:
		if candidate == slots:
			return true
	return false


func _is_prefix_of_some_set(slots: Array[int]) -> bool:
	for candidate: Array[int] in valid_sets:
		if not slots.is_empty() and _contains_all(candidate, slots):
			return true
	return false


func _contains_all(container: Array[int], items: Array[int]) -> bool:
	for item: int in items:
		if not container.has(item):
			return false
	return true


func _slots_of(c: Combatant) -> Array[int]:
	var slots: Array[int] = []
	if c.is_saint():
		slots.append(ctrl.state.party_slot_of(c))
		return slots
	var anchor: int = ctrl.state.enemy_slot_of(c)
	if anchor == 0:
		return slots
	for i: int in c.size:
		slots.append(anchor + i)
	return slots


func _at(p_side: StringName, slot: int) -> Combatant:
	return ctrl.state.party_at(slot) if p_side == SIDE_PARTY else ctrl.state.enemy_at(slot)
