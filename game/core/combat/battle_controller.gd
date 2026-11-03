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

var state: BattleState
var fervor: FervorPool
var phase: Phase = Phase.SETUP
## Every event of the battle, in order.
var history: Array[BattleEvent] = []

var _batch: Array[BattleEvent] = []


func _init(p_state: BattleState) -> void:
	state = p_state
	fervor = FervorPool.new(p_state.constants)


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
	_emit(EV_PARTY_TURN_ENDED)
	for saint: Combatant in state.party:
		saint.has_acted = true
	if _run_enemy_turn() and _run_hazard() and _end_round():
		_begin_round()
	return _flush()


func is_over() -> bool:
	return phase == Phase.VICTORY or phase == Phase.DEFEAT or phase == Phase.RETREAT


# --- steps ------------------------------------------------------------------------

func _begin_round() -> void:
	phase = Phase.ROUND_START
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
	_emit(EV_PARTY_TURN_STARTED, {"round": state.round_number})
	_apply_party_turn_start_conditions()
	_emit(EV_PARTY_TURN_CONDITIONS)
	_check_outcome()


## Returns false when the battle ended during the step.
func _run_enemy_turn() -> bool:
	phase = Phase.ENEMY_TURN
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
	_emit(EV_BATTLE_ENDED, {"result": result, "round": state.round_number})


# --- hooks filled by later tasks --------------------------------------------------

## enemy-ai §3 (T09).
func _choose_intents() -> void:
	state.intents.clear()


## conditions §3.2, moment "start of round" (T07).
func _apply_round_start_conditions() -> void:
	pass


## conditions §3.2, `owner_turn_start` for saints (T07).
func _apply_party_turn_start_conditions() -> void:
	pass


## conditions §3.2, `owner_turn_start` for one enemy (T07).
func _apply_enemy_turn_start_conditions(_enemy: Combatant) -> void:
	pass


## enemy-ai §4 (T09). Returns true if the enemy did something.
func _execute_intent(_enemy: Combatant) -> bool:
	return false


## expedition §10 (from M2); the M0 arena has no hazard.
func _apply_hazard() -> void:
	pass


## conditions §3.3, step 8 (T07).
func _decay_conditions() -> void:
	pass


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
