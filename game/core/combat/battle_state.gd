class_name BattleState
extends RefCounted
## Complete state of one battle: formation, combatants, round and intents
## (combat §2 and §8). Pure data plus the formation rules; the round flow and
## commands live in BattleController (T04/T05).
##
## Saints: `party[i]` stands in slot i + 1 and never leaves its slot when it
## falls. Enemies: `enemies` is a queue; slots are derived from the order and
## each enemy's size, so when one dies the ones behind move up by themselves.

const CAUSE_HP: StringName = &"hp"
const CAUSE_PROSTRATION: StringName = &"prostration"
const STUN: StringName = &"stun"
## Formation size (combat §2.1): a structural rule, not a balance number.
const MAX_ENEMY_SLOTS: int = 4

var catalog: BattleCatalog
var constants: ConstantsDef
## condition_id -> ConditionDef
var condition_defs: Dictionary = {}
## Expedition provisions carried into battle, one entry per unit.
var provisions: Array[StringName] = []
## &"common", &"elite" or &"boss" (retreat is not allowed against bosses).
var encounter_type: StringName = &"common"
var provisions_used_this_turn: int = 0
## True during ENEMY_TURN and HAZARD (affects expire_round_end, conditions §3.3).
var in_enemy_phase: bool = false
var engine: ConditionEngine
## Affinities with at least two members in the party (combat §12), set at SETUP.
var active_affinities: Array[StringName] = []
## Random streams of this battle; only the Faith check and AI ties use them.
var rng: RngStreams
## Expedition Light during this battle, or -1 for the arena (desolation §2).
var light: int = -1
## Extra Fervor at round 1 from camp Prayers (expedition §6, already capped).
var prayer_fervor: int = 0
## Callable(type, data) for desolation events; set by the controller.
var emit: Callable = func(_type: StringName, _data: Dictionary) -> void: pass
var party: Array[Combatant] = []
var enemies: Array[Combatant] = []
var round_number: int = 0
var intents: Array[Intent] = []

var _enemy_serial: int = 0


func _init(p_catalog: BattleCatalog) -> void:
	catalog = p_catalog
	constants = p_catalog.constants
	condition_defs = p_catalog.conditions
	engine = ConditionEngine.new(self)
	rng = RngStreams.new(0)


static func create(p_catalog: BattleCatalog, saints: Array[SaintDef], enemy_defs: Array[EnemyDef], p_provisions: Array[StringName] = [], p_encounter_type: StringName = &"common", seed: int = 0) -> BattleState:
	var state := BattleState.new(p_catalog)
	state.rng = RngStreams.new(seed)
	state.provisions = p_provisions.duplicate()
	state.encounter_type = p_encounter_type
	for saint: SaintDef in saints:
		state.party.append(Combatant.from_saint(saint))
	for enemy: EnemyDef in enemy_defs:
		if not p_catalog.enemies.has(enemy.id):
			p_catalog.enemies[enemy.id] = enemy
		state.add_enemy(enemy)
	return state


## Adds an enemy at the back of the queue (also used by summons).
func add_enemy(def: EnemyDef) -> Combatant:
	_enemy_serial += 1
	var c := Combatant.from_enemy(def, StringName("%s_%d" % [def.id, _enemy_serial]))
	enemies.append(c)
	return c


# --- slots -------------------------------------------------------------------

func party_size() -> int:
	return party.size()


func party_at(slot: int) -> Combatant:
	if slot < 1 or slot > party.size():
		return null
	return party[slot - 1]


func party_slot_of(c: Combatant) -> int:
	return party.find(c) + 1


func enemy_at(slot: int) -> Combatant:
	var first := 1
	for c: Combatant in enemies:
		if slot >= first and slot < first + c.size:
			return c
		first += c.size
	return null


## Anchor slot (lowest slot) of an enemy; 0 if it is not in the queue.
func enemy_slot_of(c: Combatant) -> int:
	var first := 1
	for e: Combatant in enemies:
		if e == c:
			return first
		first += e.size
	return 0


func occupied_enemy_slots() -> int:
	var total := 0
	for c: Combatant in enemies:
		total += c.size
	return total


func intent_of(enemy: Combatant) -> Intent:
	for intent: Intent in intents:
		if intent.enemy_id == enemy.id:
			return intent
	return null


func find(combatant_id: StringName) -> Combatant:
	for c: Combatant in party:
		if c.id == combatant_id:
			return c
	for c: Combatant in enemies:
		if c.id == combatant_id:
			return c
	return null


# --- movement (combat §2.2 and §2.3) ------------------------------------------

## Voluntary swap with the adjacent ally (direction -1 = toward slot 1, +1 = back).
## Spends the actor's action only; the displaced ally keeps its acted flag.
## Returns "" on success or a reason code; on failure nothing changes.
func swap_party(actor: Combatant, direction: int) -> String:
	if not actor.is_standing():
		return "not_standing"
	if actor.has_acted:
		return "already_acted"
	if actor.has_condition(STUN):
		return "stunned"
	if direction != -1 and direction != 1:
		return "bad_direction"
	var from_slot: int = party_slot_of(actor)
	var to_slot: int = from_slot + direction
	if party_at(to_slot) == null:
		return "no_slot"
	_swap_party_slots(from_slot, to_slot)
	actor.has_acted = true
	return ""


## Forced movement of a saint: positive `delta` pushes back, negative pulls
## forward. Spends no action. Returns how many slots it actually moved.
func move_party(c: Combatant, delta: int, protected: Array[Combatant] = []) -> int:
	var moved := 0
	var step: int = signi(delta)
	for i: int in absi(delta):
		var from_slot: int = party_slot_of(c)
		var other: Combatant = party_at(from_slot + step)
		if other == null or protected.has(other):
			break
		_swap_party_slots(from_slot, from_slot + step)
		moved += 1
	return moved


## Forced movement of an enemy along the queue. Large enemies ignore it.
func move_enemy(c: Combatant, delta: int) -> int:
	if c.size > 1:
		return 0
	var moved := 0
	var step: int = signi(delta)
	for i: int in absi(delta):
		var index: int = enemies.find(c)
		var other_index: int = index + step
		if other_index < 0 or other_index >= enemies.size() or enemies[other_index].size > 1:
			break
		enemies[index] = enemies[other_index]
		enemies[other_index] = c
		moved += 1
	return moved


## Swaps two saints' slots without spending anyone's action (e.g. Fuga de Toledo).
func swap_party_members(a: Combatant, b: Combatant) -> void:
	var slot_a: int = party_slot_of(a)
	var slot_b: int = party_slot_of(b)
	if slot_a > 0 and slot_b > 0 and slot_a != slot_b:
		_swap_party_slots(slot_a, slot_b)


func _swap_party_slots(slot_a: int, slot_b: int) -> void:
	var a: Combatant = party[slot_a - 1]
	party[slot_a - 1] = party[slot_b - 1]
	party[slot_b - 1] = a


# --- intents (combat §6.3) ------------------------------------------------------

## Who an intent would hit right now: whoever stands in its slot. Null when the
## slot is empty or holds a Fallen saint (retargeting is enemy-ai §4, T09).
func intent_target(intent: Intent) -> Combatant:
	var c: Combatant = party_at(intent.target_slot)
	if c == null or not c.is_standing():
		return null
	return c


# --- hit points, falling and reviving (combat §8) --------------------------------

## Removes hit points without any formula (the damage formula is T06).
## Returns the hit points actually lost.
func lose_hp(c: Combatant, amount: int) -> int:
	if amount <= 0 or not c.is_standing():
		return 0
	var lost: int = mini(amount, c.hp)
	c.hp -= lost
	if c.hp <= 0:
		if c.is_saint():
			fall(c, CAUSE_HP)
		else:
			kill(c)
	return lost


## Heals a standing combatant, or revives a Fallen saint inside the window with
## the healed amount (combat §10). Returns the hit points gained.
func heal(c: Combatant, amount: int) -> int:
	if amount <= 0:
		return 0
	if c.is_fallen():
		return revive(c, amount)
	if not c.is_standing():
		return 0
	var gained: int = mini(amount, c.max_hp - c.hp)
	c.hp += gained
	return gained


## Raises a Fallen saint with `hp_amount` (at least 1). Returns hp gained.
func revive(c: Combatant, hp_amount: int) -> int:
	if not c.is_fallen() or not c.revivable:
		return 0
	c.state = Combatant.State.STANDING
	c.hp = clampi(hp_amount, 1, c.max_hp)
	c.fallen_rounds = 0
	return c.hp


## A saint falls: positive conditions are lost, negative ones stay, and the
## allies still standing gain desolation, except when the cause is Prostration.
func fall(c: Combatant, cause: StringName) -> void:
	if not c.is_saint() or not c.is_standing():
		return
	c.state = Combatant.State.FALLEN
	c.hp = 0
	c.fallen_rounds = 0
	c.revivable = cause != CAUSE_PROSTRATION
	_remove_positive_conditions(c)
	engine.on_saint_fallen(c)
	if cause != CAUSE_PROSTRATION:
		var amount: int = constants.get_int(&"desolation_ally_fallen")
		for ally: Combatant in party:
			if ally != c and ally.is_standing():
				add_desolation(ally, amount, &"ally_fallen")


## Prostration in battle (desolation §5): Fallen with no way to be raised.
func prostrate(c: Combatant) -> void:
	fall(c, CAUSE_PROSTRATION)


## An enemy at 0 hp leaves the queue, or stays as remains if its data says so.
func kill(c: Combatant) -> void:
	if c.is_saint():
		return
	c.hp = 0
	if c.leaves_remains and c.remains_rounds > 0:
		c.state = Combatant.State.REMAINS
		c.remains_left = c.remains_rounds
	else:
		c.state = Combatant.State.DEAD
		enemies.erase(c)


## Every desolation change in battle goes through the desolation rules
## (multipliers, Faith check, Purification, Prostration).
func add_desolation(c: Combatant, amount: int, source: StringName = &"") -> void:
	Desolation.change(c, amount, source, desolation_context(c))


func desolation_context(saint: Combatant = null) -> DesolationContext:
	var ctx := DesolationContext.new()
	ctx.constants = constants
	ctx.rng = rng.faith()
	ctx.light = light
	ctx.battle = self
	ctx.emit = emit
	if saint != null:
		if has_affinity_bonus(saint, &"carmel"):
			ctx.affinity_mult = constants.get_float(&"affinity_carmel_desolation_mult")
		var benedict: Combatant = clausura_holder()
		if benedict != null and is_clausura_protected(saint):
			ctx.trait_mult = benedict.trait_param("adjacent_desolation_mult", 1.0)
	return ctx


# --- affinities and traits (combat §12 and §13) ---------------------------------------

## SETUP: an affinity is active with at least two members in the party,
## Fallen ones included.
func compute_affinities() -> void:
	active_affinities.clear()
	var counts: Dictionary = {}
	for c: Combatant in party:
		for affinity: StringName in c.affinities:
			counts[affinity] = int(counts.get(affinity, 0)) + 1
	for affinity: StringName in counts:
		if int(counts[affinity]) >= 2:
			active_affinities.append(affinity)


## Affinity bonuses apply only to the affinity's members (decision of 03/11/2026).
func has_affinity_bonus(c: Combatant, affinity: StringName) -> bool:
	return c != null and c.is_saint() and active_affinities.has(affinity) and c.affinities.has(affinity)


## The standing saint whose trait is Clausura, if any (it only works while
## that saint stands; decision of 03/11/2026).
func clausura_holder() -> Combatant:
	for c: Combatant in party:
		if c.is_standing() and c.trait_hook() == &"clausura":
			return c
	return null


## Allies adjacent to the Clausura holder (not the holder itself).
func is_clausura_protected(c: Combatant) -> bool:
	var holder: Combatant = clausura_holder()
	if holder == null or c == holder or not c.is_saint():
		return false
	return absi(party_slot_of(c) - party_slot_of(holder)) == 1


## ROUND_END step 9: count Fallen saints and expire remains.
func end_round_falls() -> void:
	var window: int = constants.get_int(&"fallen_revive_window")
	for c: Combatant in party:
		if c.is_fallen() and c.revivable:
			c.fallen_rounds += 1
			if c.fallen_rounds >= window:
				c.state = Combatant.State.OUT
	for c: Combatant in enemies.duplicate():
		if c.state == Combatant.State.REMAINS:
			c.remains_left -= 1
			if c.remains_left <= 0:
				c.state = Combatant.State.DEAD
				enemies.erase(c)


# --- condition stacks (minimal; the full engine with Will, immunity and
# stacking modes is conditions.md, T07) ---------------------------------------------

## Adds stacks up to max_stacks. Returns the stacks actually added.
func add_condition_stacks(c: Combatant, condition_id: StringName, amount: int) -> int:
	var def: ConditionDef = condition_defs.get(condition_id)
	var max_stacks: int = def.max_stacks if def != null else amount
	var before: int = c.stacks(condition_id)
	var after: int = mini(before + amount, max_stacks)
	if after > before:
		c.conditions[condition_id] = after
	return after - before


## Removes up to `amount` stacks of one condition. Returns stacks removed.
func remove_condition_stacks(c: Combatant, condition_id: StringName, amount: int) -> int:
	var before: int = c.stacks(condition_id)
	var removed: int = mini(amount, before)
	if before - removed <= 0:
		c.conditions.erase(condition_id)
	else:
		c.conditions[condition_id] = before - removed
	return removed


## Removes up to `amount` stacks among conditions of a polarity, highest
## display priority first (lower number first). Returns stacks removed.
func remove_stacks_by_polarity(c: Combatant, polarity: StringName, amount: int) -> int:
	var ids: Array[StringName] = []
	for condition_id: StringName in c.conditions:
		var def: ConditionDef = condition_defs.get(condition_id)
		if def != null and def.polarity == polarity:
			ids.append(condition_id)
	ids.sort_custom(func(a: StringName, b: StringName) -> bool:
		return (condition_defs[a] as ConditionDef).display_priority < (condition_defs[b] as ConditionDef).display_priority)
	var removed := 0
	for condition_id: StringName in ids:
		if removed >= amount:
			break
		removed += remove_condition_stacks(c, condition_id, amount - removed)
	return removed


## Removes every positive token condition (Ward, Strength, Taunt...). Returns
## the condition ids removed.
func strip_positive_tokens(c: Combatant) -> Array[StringName]:
	var removed: Array[StringName] = []
	for condition_id: StringName in c.conditions.keys():
		var def: ConditionDef = condition_defs.get(condition_id)
		if def != null and def.polarity == &"positive" and def.kind == &"token":
			c.conditions.erase(condition_id)
			removed.append(condition_id)
	return removed


func _remove_positive_conditions(c: Combatant) -> void:
	for condition_id: StringName in c.conditions.keys():
		var def: ConditionDef = condition_defs.get(condition_id)
		if def != null and def.polarity == &"positive":
			engine.remove_all(c, condition_id)


# --- outcome ----------------------------------------------------------------------

## Defeat: no saint can act (all Fallen or out of battle).
func is_defeat() -> bool:
	return not party.any(func(c: Combatant) -> bool: return c.is_standing())


## Victory: no enemy fighting (remains do not count).
func is_victory() -> bool:
	return not enemies.any(func(c: Combatant) -> bool: return c.is_alive_enemy())


## Plain snapshot of the whole battle state (determinism tests, save-load).
func to_dict() -> Dictionary:
	var party_list: Array = []
	for c: Combatant in party:
		party_list.append(c.to_dict())
	var enemy_list: Array = []
	for c: Combatant in enemies:
		enemy_list.append(c.to_dict())
	var intent_list: Array = []
	for intent: Intent in intents:
		intent_list.append(intent.to_dict())
	var provision_list: Array[String] = []
	for p: StringName in provisions:
		provision_list.append(String(p))
	return {
		"round": round_number, "party": party_list, "enemies": enemy_list, "intents": intent_list,
		"provisions": provision_list, "provisions_used_this_turn": provisions_used_this_turn,
		"encounter_type": String(encounter_type), "light": light,
		"rng": rng.get_counters(),
	}


## Independent copy of the whole battle for previews (combat §15): same
## combatants, intents, counters and RNG position. Shares only the read-only
## catalog. Never shares Combatant objects with the original.
func clone() -> BattleState:
	var copy := BattleState.new(catalog)
	var skip: Array[String] = ["catalog", "constants", "condition_defs", "party", "enemies", "intents", "engine", "rng", "emit"]
	for prop: Dictionary in get_property_list():
		var prop_name: String = prop["name"]
		if int(prop["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0 or skip.has(prop_name):
			continue
		var value: Variant = get(prop_name)
		if value is Array or value is Dictionary:
			value = value.duplicate(true)
		copy.set(prop_name, value)
	for c: Combatant in party:
		copy.party.append(c.clone())
	for c: Combatant in enemies:
		copy.enemies.append(c.clone())
	for intent: Intent in intents:
		copy.intents.append(intent.clone())
	copy.rng = RngStreams.from_dict(rng.to_dict())
	return copy
