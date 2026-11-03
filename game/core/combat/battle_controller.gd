class_name BattleController
extends RefCounted
## The round state machine (combat §3):
##   SETUP → ROUND_START → PARTY_TURN ⇄ commands → ENEMY_TURN → HAZARD → ROUND_END
##   ROUND_END → VICTORY | DEFEAT | (next ROUND_START)
## Steps owned by later tasks (conditions T07, enemy AI T09, hazards M2) are
## empty hooks that still emit their step event, so the order is testable now.

signal events_emitted(events: Array[BattleEvent])

enum Phase { SETUP, ROUND_START, PARTY_TURN, ENEMY_TURN, HAZARD, ROUND_END, VICTORY, DEFEAT, RETREAT }

const EV_BATTLE_STARTED: StringName = &"battle_started"
const EV_ROUND_STARTED: StringName = &"round_started"
const EV_FERVOR_GAINED: StringName = &"fervor_gained"
const EV_INTENTS_CHOSEN: StringName = &"intents_chosen"
const EV_ROUND_START_CONDITIONS: StringName = &"round_start_conditions"
const EV_PARTY_TURN_STARTED: StringName = &"party_turn_started"
const EV_PARTY_TURN_CONDITIONS: StringName = &"party_turn_conditions"
const EV_PARTY_TURN_ENDED: StringName = &"party_turn_ended"
const EV_ENEMY_TURN_STARTED: StringName = &"enemy_turn_started"
const EV_ENEMY_TURN_CONDITIONS: StringName = &"enemy_turn_conditions"
const EV_ENEMY_ACTION: StringName = &"enemy_action"
const EV_HAZARD: StringName = &"hazard"
const EV_CONDITIONS_DECAYED: StringName = &"conditions_decayed"
const EV_FALLS_COUNTED: StringName = &"falls_counted"
const EV_BATTLE_ENDED: StringName = &"battle_ended"
const EV_ABILITY_USED: StringName = &"ability_used"
const EV_SWAPPED: StringName = &"swapped"
const EV_PASSED: StringName = &"passed"
const EV_PROVISION_USED: StringName = &"provision_used"

var state: BattleState
var fervor: FervorPool
var phase: Phase = Phase.SETUP
## Every event of the battle, in order.
var history: Array[BattleEvent] = []
## Accepted commands, in order (BattleCommand.to_dict()). Replaying them on the
## same starting state rebuilds the battle exactly (ADR-0005).
var command_log: Array[Dictionary] = []
## Engine errors recorded during the battle (e.g. effect queue overflow).
var errors: Array[String] = []

var _batch: Array[BattleEvent] = []


func _init(p_state: BattleState) -> void:
	state = p_state
	fervor = FervorPool.new(p_state.constants)
	state.engine.emit = _emit


## Starts round 1 with Fervor 0 and runs until the party can act.
func start() -> Array[BattleEvent]:
	assert(phase == Phase.SETUP, "start() called twice")
	fervor.reset()
	_emit(EV_BATTLE_STARTED)
	_begin_round()
	return _flush()


## Ends the party turn and runs the enemy turn, hazard and round end, then the
## next ROUND_START. Returns no events if it is not the party turn.
func end_party_turn() -> Array[BattleEvent]:
	if phase != Phase.PARTY_TURN:
		return []
	command_log.append(BattleCommand.end_party_turn().to_dict())
	_emit(EV_PARTY_TURN_ENDED)
	for saint: Combatant in state.party:
		# A stunned saint who did not pass still loses this action.
		if not saint.has_acted and saint.is_standing():
			state.engine.consume_stun(saint)
		saint.has_acted = true
	if _run_enemy_turn() and _run_hazard() and _end_round():
		_begin_round()
	return _flush()


## Validates and runs one player command (combat §4). A rejected command
## changes nothing and is not logged.
func execute(cmd: BattleCommand) -> CommandResult:
	if cmd.type == BattleCommand.END_PARTY_TURN:
		if phase != Phase.PARTY_TURN:
			return CommandResult.rejected(CommandResult.NOT_PARTY_TURN)
		return CommandResult.accepted(end_party_turn())
	if phase != Phase.PARTY_TURN:
		return CommandResult.rejected(CommandResult.NOT_PARTY_TURN)
	var reason: StringName
	match cmd.type:
		BattleCommand.USE_ABILITY, BattleCommand.USE_MIRACLE:
			reason = _run_ability(cmd)
		BattleCommand.SWAP_SLOTS:
			reason = _run_swap(cmd)
		BattleCommand.PASS:
			reason = _run_pass(cmd)
		BattleCommand.USE_PROVISION:
			reason = _run_provision(cmd)
		BattleCommand.RETREAT_BATTLE:
			reason = _run_retreat()
		_:
			reason = CommandResult.UNKNOWN_COMMAND
	if reason != &"":
		return CommandResult.rejected(reason)
	command_log.append(cmd.to_dict())
	return CommandResult.accepted(_flush())


## Checks a command without running it: "" when it would be accepted.
func validate(cmd: BattleCommand) -> StringName:
	if phase != Phase.PARTY_TURN:
		return CommandResult.NOT_PARTY_TURN
	match cmd.type:
		BattleCommand.USE_ABILITY, BattleCommand.USE_MIRACLE:
			var actor: Combatant = _saint(cmd.actor_id)
			if actor == null:
				return CommandResult.UNKNOWN_ACTOR
			var ability: AbilityDef = _ability_for(cmd, actor)
			var reason: StringName = _check_ability(cmd, actor, ability)
			if reason == &"" and _resolve_targets(actor, ability, cmd.target_slots).is_empty():
				return CommandResult.INVALID_TARGET
			return reason
		BattleCommand.PASS:
			return _check_pass(_saint(cmd.actor_id))
		BattleCommand.SWAP_SLOTS:
			var mover: Combatant = _saint(cmd.actor_id)
			if mover == null:
				return CommandResult.UNKNOWN_ACTOR
			if not mover.is_standing():
				return CommandResult.NOT_STANDING
			if mover.has_acted:
				return CommandResult.ALREADY_ACTED
			if mover.has_condition(BattleState.STUN):
				return CommandResult.STUNNED
			if (cmd.direction != -1 and cmd.direction != 1) or state.party_at(state.party_slot_of(mover) + cmd.direction) == null:
				return &"no_slot"
			return &""
		BattleCommand.USE_PROVISION:
			return _check_provision(cmd)
		BattleCommand.RETREAT_BATTLE:
			return CommandResult.RETREAT_NOT_ALLOWED if state.encounter_type == &"boss" else &""
		BattleCommand.END_PARTY_TURN:
			return &""
	return CommandResult.UNKNOWN_COMMAND


func is_over() -> bool:
	return phase == Phase.VICTORY or phase == Phase.DEFEAT or phase == Phase.RETREAT


# --- steps ------------------------------------------------------------------------

func _begin_round() -> void:
	phase = Phase.ROUND_START
	state.in_enemy_phase = false
	state.round_number += 1
	_emit(EV_ROUND_STARTED, {"round": state.round_number})
	for saint: Combatant in state.party:
		saint.has_acted = false
	var gained: int = fervor.start_round()
	_emit(EV_FERVOR_GAINED, {"amount": gained, "total": fervor.amount, "bonus": false})
	_choose_intents()
	_emit(EV_INTENTS_CHOSEN, {"count": state.intents.size()})
	_apply_round_start_conditions()
	_emit(EV_ROUND_START_CONDITIONS)
	if _check_outcome():
		return
	phase = Phase.PARTY_TURN
	state.provisions_used_this_turn = 0
	_emit(EV_PARTY_TURN_STARTED, {"round": state.round_number})
	_apply_party_turn_start_conditions()
	_emit(EV_PARTY_TURN_CONDITIONS)
	_check_outcome()


## Returns false when the battle ended during the step.
func _run_enemy_turn() -> bool:
	phase = Phase.ENEMY_TURN
	state.in_enemy_phase = true
	_emit(EV_ENEMY_TURN_STARTED)
	# Snapshot in slot order: enemies summoned this turn act from the next round.
	for enemy: Combatant in state.enemies.duplicate():
		if not enemy.is_alive_enemy():
			continue
		var slot: int = state.enemy_slot_of(enemy)
		_apply_enemy_turn_start_conditions(enemy)
		_emit(EV_ENEMY_TURN_CONDITIONS, {"enemy": enemy.id, "slot": slot})
		if _check_outcome():
			return false
		if not enemy.is_alive_enemy():
			continue
		var acted: bool = _execute_intent(enemy)
		_emit(EV_ENEMY_ACTION, {"enemy": enemy.id, "slot": slot, "acted": acted})
		if _check_outcome():
			return false
	return true


func _run_hazard() -> bool:
	phase = Phase.HAZARD
	_apply_hazard()
	_emit(EV_HAZARD)
	return not _check_outcome()


func _end_round() -> bool:
	phase = Phase.ROUND_END
	_decay_conditions()
	_emit(EV_CONDITIONS_DECAYED)
	state.end_round_falls()
	_emit(EV_FALLS_COUNTED)
	return not _check_outcome()


## Victory and defeat are checked at the end of every step (combat §8).
func _check_outcome() -> bool:
	if state.is_defeat():
		_finish(Phase.DEFEAT, &"defeat")
		return true
	if state.is_victory():
		_finish(Phase.VICTORY, &"victory")
		return true
	return false


func _finish(final_phase: Phase, result: StringName) -> void:
	phase = final_phase
	fervor.reset()
	state.engine.clear_all()
	_emit(EV_BATTLE_ENDED, {"result": result, "round": state.round_number})


# --- commands (combat §4) ------------------------------------------------------------

func _saint(actor_id: StringName) -> Combatant:
	for c: Combatant in state.party:
		if c.id == actor_id:
			return c
	return null


func _ability_for(cmd: BattleCommand, actor: Combatant) -> AbilityDef:
	var ability_id: StringName = actor.miracle if cmd.type == BattleCommand.USE_MIRACLE else cmd.ability_id
	return state.catalog.ability(ability_id)


## The 8 checks of combat §4.2, except the target (checked by _resolve_targets).
func _check_ability(cmd: BattleCommand, actor: Combatant, ability: AbilityDef) -> StringName:
	if not actor.is_standing():
		return CommandResult.NOT_STANDING
	if actor.has_condition(BattleState.STUN):
		return CommandResult.STUNNED
	if actor.has_acted:
		return CommandResult.ALREADY_ACTED
	if ability == null:
		return CommandResult.UNKNOWN_ABILITY
	if cmd.type == BattleCommand.USE_ABILITY and not actor.equipped.has(ability.id):
		return CommandResult.NOT_EQUIPPED
	if not ability.use_slots.has(state.party_slot_of(actor)):
		return CommandResult.WRONG_SLOT
	if not fervor.can_afford(ability.cost):
		return CommandResult.NOT_ENOUGH_FERVOR
	if actor.is_dark_night() and ability.cost > 0:
		return CommandResult.DARK_NIGHT
	if ability.once_per_battle and actor.used_once.has(ability.id):
		return CommandResult.ALREADY_USED
	return &""


## Turns the chosen slots into the combatants the ability will affect
## (combat §6.1). Empty means the target is invalid.
func _resolve_targets(actor: Combatant, ability: AbilityDef, slots: Array[int]) -> Array[Combatant]:
	var targets: Array[Combatant] = []
	match ability.targeting:
		&"self":
			if slots.is_empty():
				targets.append(actor)
		&"ally", &"ally_fallen":
			if slots.size() != 1 or not ability.target_slots.has(slots[0]):
				return targets
			var ally: Combatant = state.party_at(slots[0])
			if ally == null:
				return targets
			if ability.targeting == &"ally":
				if ally.is_standing() and (ally != actor or ability.allow_self):
					targets.append(ally)
			elif ally.is_fallen() and ally.revivable:
				targets.append(ally)
		&"all_allies":
			if slots.is_empty():
				for ally: Combatant in state.party:
					if ally.is_standing():
						targets.append(ally)
		&"enemy":
			if slots.size() == 1 and ability.target_slots.has(slots[0]):
				var enemy: Combatant = state.enemy_at(slots[0])
				if enemy != null and enemy.is_alive_enemy():
					targets.append(enemy)
		&"enemy_group":
			if slots.is_empty():
				targets = _enemies_in_slots(ability.target_slots)
		&"all_enemies":
			if slots.is_empty():
				for enemy: Combatant in state.enemies:
					if enemy.is_alive_enemy():
						targets.append(enemy)
		&"chosen_enemy_slots":
			targets = _resolve_chosen_slots(ability, slots)
	return targets


func _enemies_in_slots(slots: Array[int]) -> Array[Combatant]:
	var result: Array[Combatant] = []
	var sorted_slots: Array[int] = slots.duplicate()
	sorted_slots.sort()
	for slot: int in sorted_slots:
		var enemy: Combatant = state.enemy_at(slot)
		if enemy != null and enemy.is_alive_enemy() and not result.has(enemy):
			result.append(enemy)
	return result


## n distinct slots holding a living enemy; fewer when fewer such slots exist
## (decision of 03/11/2026: a lone enemy can still be targeted).
func _resolve_chosen_slots(ability: AbilityDef, slots: Array[int]) -> Array[Combatant]:
	var empty: Array[Combatant] = []
	var available: Array[int] = []
	for slot: int in ability.target_slots:
		var enemy: Combatant = state.enemy_at(slot)
		if enemy != null and enemy.is_alive_enemy():
			available.append(slot)
	var required: int = mini(ability.target_count, available.size())
	if required == 0 or slots.size() != required:
		return empty
	var seen: Dictionary = {}
	for slot: int in slots:
		if not available.has(slot) or seen.has(slot):
			return empty
		seen[slot] = true
	return _enemies_in_slots(slots)


func _run_ability(cmd: BattleCommand) -> StringName:
	var actor: Combatant = _saint(cmd.actor_id)
	if actor == null:
		return CommandResult.UNKNOWN_ACTOR
	var ability: AbilityDef = _ability_for(cmd, actor)
	var reason: StringName = _check_ability(cmd, actor, ability)
	if reason != &"":
		return reason
	var targets: Array[Combatant] = _resolve_targets(actor, ability, cmd.target_slots)
	if targets.is_empty():
		return CommandResult.INVALID_TARGET
	fervor.spend(ability.cost)
	actor.has_acted = true
	if ability.once_per_battle:
		actor.used_once.append(ability.id)
	var target_ids: Array[String] = []
	for t: Combatant in targets:
		target_ids.append(String(t.id))
	_emit(EV_ABILITY_USED, {"actor": actor.id, "ability": ability.id, "kind": ability.kind, "cost": ability.cost, "targets": target_ids, "fervor": fervor.amount})
	_resolve_ability_effects(actor, ability, targets)
	_check_outcome()
	return &""


func _run_swap(cmd: BattleCommand) -> StringName:
	var actor: Combatant = _saint(cmd.actor_id)
	if actor == null:
		return CommandResult.UNKNOWN_ACTOR
	var from_slot: int = state.party_slot_of(actor)
	var reason: String = state.swap_party(actor, cmd.direction)
	if reason != "":
		return StringName(reason)
	_emit(EV_SWAPPED, {"actor": actor.id, "from": from_slot, "to": state.party_slot_of(actor)})
	return &""


## A stunned saint may only pass: the stun makes it lose the turn (decision of 03/11/2026).
func _check_pass(actor: Combatant) -> StringName:
	if actor == null:
		return CommandResult.UNKNOWN_ACTOR
	if not actor.is_standing():
		return CommandResult.NOT_STANDING
	if actor.has_acted:
		return CommandResult.ALREADY_ACTED
	return &""


func _run_pass(cmd: BattleCommand) -> StringName:
	var actor: Combatant = _saint(cmd.actor_id)
	var reason: StringName = _check_pass(actor)
	if reason != &"":
		return reason
	actor.has_acted = true
	_emit(EV_PASSED, {"actor": actor.id})
	state.engine.consume_stun(actor)
	return &""


## Provisions spend no action, but a stunned saint cannot apply one
## (decision of 03/11/2026). Targets must be standing, like ally abilities.
func _check_provision(cmd: BattleCommand) -> StringName:
	var actor: Combatant = _saint(cmd.actor_id)
	if actor == null:
		return CommandResult.UNKNOWN_ACTOR
	if not actor.is_standing():
		return CommandResult.NOT_STANDING
	if actor.has_condition(BattleState.STUN):
		return CommandResult.STUNNED
	if not state.provisions.has(cmd.provision_id):
		return CommandResult.NO_PROVISION
	var def: ProvisionDef = state.catalog.provision(cmd.provision_id)
	if def == null or not def.usable_in_battle:
		return CommandResult.NOT_USABLE_IN_BATTLE
	if state.provisions_used_this_turn >= state.constants.get_int(&"provisions_per_turn"):
		return CommandResult.PROVISION_LIMIT
	if _provision_target(def, actor, cmd.target_slots) == null:
		return CommandResult.INVALID_TARGET
	return &""


func _provision_target(def: ProvisionDef, actor: Combatant, slots: Array[int]) -> Combatant:
	if def.targeting == &"self":
		return actor
	if slots.size() != 1:
		return null
	var target: Combatant = state.party_at(slots[0])
	if target == null or not target.is_standing():
		return null
	return target


func _run_provision(cmd: BattleCommand) -> StringName:
	var reason: StringName = _check_provision(cmd)
	if reason != &"":
		return reason
	var actor: Combatant = _saint(cmd.actor_id)
	var def: ProvisionDef = state.catalog.provision(cmd.provision_id)
	var target: Combatant = _provision_target(def, actor, cmd.target_slots)
	state.provisions.erase(cmd.provision_id)
	state.provisions_used_this_turn += 1
	_emit(EV_PROVISION_USED, {"actor": actor.id, "provision": def.id, "target": target.id})
	_resolve_provision_effects(actor, def, target)
	_check_outcome()
	return &""


## Emergency retreat (combat §4.1), never against a boss.
func _run_retreat() -> StringName:
	if state.encounter_type == &"boss":
		return CommandResult.RETREAT_NOT_ALLOWED
	_finish(Phase.RETREAT, &"retreat")
	return &""


# --- hooks filled by later tasks --------------------------------------------------

## Queues the ability's effects in data order and resolves them (combat §7).
func _resolve_ability_effects(actor: Combatant, ability: AbilityDef, targets: Array[Combatant]) -> void:
	_resolve_effects(actor, ability.id, ability.effects, targets)


## Provisions use the same effect queue, applied by `actor` on `target`.
func _resolve_provision_effects(actor: Combatant, def: ProvisionDef, target: Combatant) -> void:
	_resolve_effects(actor, def.id, def.effects, [target] as Array[Combatant])


## Runs a list of effects for one action through a fresh queue. Exposed so
## enemy actions (T09) and tests can use the same path.
func resolve_effects(actor: Combatant, source_id: StringName, effects: Array[EffectDef], targets: Array[Combatant]) -> void:
	_resolve_effects(actor, source_id, effects, targets)


func _resolve_effects(actor: Combatant, source_id: StringName, effects: Array[EffectDef], targets: Array[Combatant]) -> void:
	var ctx := new_effect_context(actor, source_id, targets)
	for effect: EffectDef in effects:
		ctx.queue.enqueue(ctx, effect)
	ctx.queue.process()
	errors.append_array(ctx.queue.errors)


func new_effect_context(actor: Combatant, source_id: StringName, targets: Array[Combatant]) -> EffectContext:
	var ctx := EffectContext.new()
	ctx.state = state
	ctx.fervor = fervor
	ctx.actor = actor
	ctx.source_id = source_id
	ctx.targets = targets
	ctx.queue = EffectQueue.new(state.constants.get_int(&"effect_queue_limit"))
	ctx.emit = _emit
	return ctx


## enemy-ai §3 (T09).
func _choose_intents() -> void:
	state.intents.clear()


## conditions §3.2, moment "start of round" (T07).
func _apply_round_start_conditions() -> void:
	pass


## conditions §3.2, `owner_turn_start` for saints (bleed, corruption...).
func _apply_party_turn_start_conditions() -> void:
	for saint: Combatant in state.party.duplicate():
		state.engine.tick_owner_turn_start(saint)


## conditions §3.2, `owner_turn_start` for one enemy, right before it acts.
func _apply_enemy_turn_start_conditions(enemy: Combatant) -> void:
	state.engine.tick_owner_turn_start(enemy)


## enemy-ai §4 (T09). A stunned enemy loses its intent (conditions §4).
## Returns true if the enemy did something.
func _execute_intent(enemy: Combatant) -> bool:
	if state.engine.consume_stun(enemy):
		return false
	return false


## expedition §10 (from M2); the M0 arena has no hazard.
func _apply_hazard() -> void:
	pass


## conditions §3.3, step 8: expire_round_end conditions leave.
func _decay_conditions() -> void:
	state.engine.end_round()


# --- events ------------------------------------------------------------------------

func _emit(type: StringName, data: Dictionary = {}) -> void:
	var event := BattleEvent.create(type, data)
	history.append(event)
	_batch.append(event)


func _flush() -> Array[BattleEvent]:
	var batch: Array[BattleEvent] = _batch
	_batch = []
	if not batch.is_empty():
		events_emitted.emit(batch)
	return batch
