class_name EnemyBrain
extends RefCounted
## Enemy intents (enemy-ai.md). Simple, readable and predictable: an ordered
## list of actions with conditions, no learning and no search. Choices happen
## at ROUND_START and are shown as intents during the party turn.

const SINGLE: StringName = &"single"


# --- choice (§3) ---------------------------------------------------------------------

static func choose_intents(state: BattleState) -> void:
	state.intents.clear()
	for enemy: Combatant in state.enemies:
		if enemy.is_alive_enemy():
			state.intents.append(choose(state, enemy))


static func choose(state: BattleState, enemy: Combatant) -> Intent:
	if enemy.has_condition(&"stun"):
		return Intent.idle(enemy.id, Intent.KIND_STUNNED)
	var def: EnemyDef = state.catalog.enemies.get(enemy.def_id)
	if def == null:
		return Intent.idle(enemy.id, Intent.KIND_WAIT)
	var slot: int = state.enemy_slot_of(enemy)
	for action: EnemyActionDef in def.actions:
		if not action.use_slots.has(slot) or not cooldown_ready(state, enemy, action):
			continue
		if not conditions_met(state, enemy, action):
			continue
		var intent := _build(state, enemy, action)
		if intent != null:
			return intent
	return Intent.idle(enemy.id, Intent.KIND_WAIT)


static func _build(state: BattleState, enemy: Combatant, action: EnemyActionDef) -> Intent:
	var intent := Intent.create(enemy.id, action.id, 0)
	intent.intent_icon = action.intent_icon
	match action.targeting:
		SINGLE:
			var target: Combatant = pick(state, valid_party_targets(state, action), action.target_rule)
			if target == null:
				return null
			intent.target_slot = state.party_slot_of(target)
			_apply_taunt(state, action, intent)
		&"all_party":
			if valid_party_targets(state, action).is_empty():
				return null
		&"ally_enemy":
			var ally: Combatant = pick(state, other_enemies(state, enemy), action.target_rule)
			if ally == null:
				return null
			intent.target_enemy_id = ally.id
	refresh_preview(state, enemy, action, intent)
	return intent


static func cooldown_ready(state: BattleState, enemy: Combatant, action: EnemyActionDef) -> bool:
	return state.round_number >= int(enemy.cooldowns.get(action.id, 0))


## §2.1: every condition must be true.
static func conditions_met(state: BattleState, enemy: Combatant, action: EnemyActionDef) -> bool:
	for cond: Dictionary in action.conditions:
		var param: Variant = cond["param"]
		var ok: bool = true
		match String(cond["name"]):
			"always":
				ok = true
			"self_hp_below":
				ok = enemy.hp * 100 < int(param) * enemy.max_hp
			"ally_hp_below":
				ok = other_enemies(state, enemy).any(func(e: Combatant) -> bool: return e.hp * 100 < int(param) * e.max_hp)
			"allies_alive_below":
				ok = state.enemies.filter(func(e: Combatant) -> bool: return e.is_alive_enemy()).size() < int(param)
			"round_at_least":
				ok = state.round_number >= int(param)
			"every_n_rounds":
				ok = state.round_number % int(param) == 0
			"party_has_condition":
				ok = state.party.any(func(c: Combatant) -> bool: return c.is_standing() and c.has_condition(StringName(str(param))))
			"free_enemy_slot":
				ok = state.occupied_enemy_slots() < BattleState.MAX_ENEMY_SLOTS
			_:
				ok = false
		if not ok:
			return false
	return true


static func valid_party_targets(state: BattleState, action: EnemyActionDef) -> Array[Combatant]:
	var result: Array[Combatant] = []
	for slot: int in range(1, state.party_size() + 1):
		var c: Combatant = state.party_at(slot)
		if c != null and c.is_standing() and (action.targeting != SINGLE or action.target_slots.has(slot)):
			result.append(c)
	return result


static func other_enemies(state: BattleState, enemy: Combatant) -> Array[Combatant]:
	var result: Array[Combatant] = []
	for e: Combatant in state.enemies:
		if e != enemy and e.is_alive_enemy():
			result.append(e)
	return result


## §3.4 target rules; ties (except random) go to the lowest slot.
static func pick(state: BattleState, candidates: Array[Combatant], rule: StringName) -> Combatant:
	if candidates.is_empty():
		return null
	var ordered: Array[Combatant] = candidates.duplicate()
	ordered.sort_custom(func(a: Combatant, b: Combatant) -> bool: return _slot(state, a) < _slot(state, b))
	if rule == &"random":
		return ordered[state.rng.battle().pick_index(ordered.size())]
	if rule == &"back_most":
		return ordered.back()
	var best: Combatant = ordered[0]
	for c: Combatant in ordered:
		if _better(c, best, rule):
			best = c
	return best


static func _better(a: Combatant, b: Combatant, rule: StringName) -> bool:
	match rule:
		&"lowest_hp":
			return a.hp < b.hp
		&"lowest_hp_pct":
			return a.hp * b.max_hp < b.hp * a.max_hp
		&"highest_desolation":
			return a.desolation > b.desolation
	return false


static func _slot(state: BattleState, c: Combatant) -> int:
	return state.party_slot_of(c) if c.is_saint() else state.enemy_slot_of(c)


# --- taunt and preview (§3.5, §5) -----------------------------------------------------------

## Single-target actions must aim at a saint with Taunt they can reach.
static func _apply_taunt(state: BattleState, action: EnemyActionDef, intent: Intent) -> void:
	if action.targeting != SINGLE:
		return
	for slot: int in action.target_slots:
		var c: Combatant = state.party_at(slot)
		if c != null and c.is_standing() and c.has_condition(&"taunt"):
			intent.target_slot = slot
			return


## Recomputed whenever the state changes during the party turn: taunt may
## redirect, stuns cancel, and the damage preview follows Ward and armor.
static func refresh_intents(state: BattleState) -> void:
	for intent: Intent in state.intents:
		var enemy: Combatant = state.find(intent.enemy_id)
		if enemy == null or not enemy.is_alive_enemy():
			continue
		if intent.kind == Intent.KIND_ACTION and enemy.has_condition(&"stun"):
			intent.kind = Intent.KIND_STUNNED
			intent.preview_value = 0
			continue
		var action: EnemyActionDef = action_of(state, enemy, intent.action_id)
		if action == null or intent.kind != Intent.KIND_ACTION:
			continue
		_apply_taunt(state, action, intent)
		refresh_preview(state, enemy, action, intent)


static func refresh_preview(state: BattleState, enemy: Combatant, action: EnemyActionDef, intent: Intent) -> void:
	intent.preview_value = 0
	var target: Combatant = null
	if action.targeting == SINGLE:
		target = state.party_at(intent.target_slot)
	elif action.targeting == &"all_party":
		var all: Array[Combatant] = valid_party_targets(state, action)
		target = all[0] if not all.is_empty() else null
	if target == null:
		return
	for effect: EffectDef in action.effects:
		if effect.type == &"damage":
			intent.preview_value = int(Damage.compute(state, enemy, target, effect, enemy.has_condition(&"strength"))["damage"])
			return


static func action_of(state: BattleState, enemy: Combatant, action_id: StringName) -> EnemyActionDef:
	var def: EnemyDef = state.catalog.enemies.get(enemy.def_id)
	if def == null:
		return null
	for action: EnemyActionDef in def.actions:
		if action.id == action_id:
			return action
	return null


# --- execution (§4) -----------------------------------------------------------------------------

## Targets at execution time, or an empty list when the intent has no valid
## target ("sem alvo"). Whoever stands in the aimed slot receives the action;
## if it is Fallen or out of reach, the same rule picks another valid saint.
static func execution_targets(state: BattleState, enemy: Combatant, action: EnemyActionDef, intent: Intent) -> Array[Combatant]:
	var result: Array[Combatant] = []
	match action.targeting:
		SINGLE:
			_apply_taunt(state, action, intent)
			var occupant: Combatant = state.party_at(intent.target_slot)
			if occupant == null or not occupant.is_standing() or not action.target_slots.has(intent.target_slot):
				occupant = pick(state, valid_party_targets(state, action), action.target_rule)
				if occupant != null:
					intent.target_slot = state.party_slot_of(occupant)
			if occupant != null:
				result.append(occupant)
		&"all_party":
			result = valid_party_targets(state, action)
		&"self":
			result.append(enemy)
		&"ally_enemy":
			var ally: Combatant = state.find(intent.target_enemy_id)
			if ally == null or not ally.is_alive_enemy():
				ally = pick(state, other_enemies(state, enemy), action.target_rule)
			if ally != null:
				result.append(ally)
		&"all_enemies":
			for e: Combatant in state.enemies:
				if e.is_alive_enemy():
					result.append(e)
	return result


static func start_cooldown(state: BattleState, enemy: Combatant, action: EnemyActionDef) -> void:
	if action.cooldown > 0:
		enemy.cooldowns[action.id] = state.round_number + action.cooldown + 1
