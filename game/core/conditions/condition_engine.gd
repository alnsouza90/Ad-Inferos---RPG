class_name ConditionEngine
extends RefCounted
## Generic condition rules driven by ConditionDef data (conditions.md §3).
## It knows no condition by name except through its `hook` (§4). Freeze,
## Fury and Torpor hooks belong to Circles 5 and 9 (M3) and are inert here.

const STUN_HOOK: StringName = &"stun_cancel"
const BLEED_HOOK: StringName = &"bleed_tick"
const CORRUPTION_HOOK: StringName = &"corruption_tick"
const DUEL_HOOK: StringName = &"duel_mark"
const DUEL: StringName = &"duel"
const STUN: StringName = &"stun"
## How many icons a character shows before the "+N" badge (conditions §7).
const MAX_VISIBLE_ICONS: int = 3

## Held weakly: BattleState owns this engine, so a strong reference back
## would keep both alive forever (RefCounted cycle).
var state: BattleState:
	get:
		return _state_ref.get_ref() as BattleState
## Callable(type: StringName, data: Dictionary); set by the controller.
var emit: Callable = func(_type: StringName, _data: Dictionary) -> void: pass


var _state_ref: WeakRef


func _init(p_state: BattleState) -> void:
	_state_ref = weakref(p_state)


func def_of(condition_id: StringName) -> ConditionDef:
	return state.condition_defs.get(condition_id)


# --- application (§3.1) ---------------------------------------------------------------

## Applies `stacks` of a condition. Returns the stacks actually added
## (0 when immune, resisted or ignored). `source` is who applied it.
func apply(target: Combatant, condition_id: StringName, stacks: int, source: Combatant = null) -> int:
	var def: ConditionDef = def_of(condition_id)
	if def == null or stacks <= 0 or not target.is_standing():
		return 0
	if is_immune(target, condition_id):
		emit.call(&"condition_immune", {"target": target.id, "condition": condition_id})
		return 0
	var incoming: int = stacks
	if def.resisted_by_will:
		incoming = maxi(0, stacks - target.will)
		if incoming == 0:
			emit.call(&"condition_resisted", {"target": target.id, "condition": condition_id})
			return 0
	var before: int = target.stacks(condition_id)
	var after: int
	match def.stacking:
		&"add":
			after = mini(before + incoming, def.max_stacks)
		&"refresh":
			after = mini(maxi(before, incoming), def.max_stacks)
		_:
			after = before if before > 0 else mini(incoming, def.max_stacks)
	if def.hook == DUEL_HOOK and source != null:
		_end_other_duels(source, target)
	target.conditions[condition_id] = after
	if source != null:
		target.condition_sources[condition_id] = source.id
	if def.decay == &"expire_round_end":
		# Applied during the enemy turn or hazard, it lasts until the next
		# round end, so it always protects through one enemy turn (§3.3).
		target.condition_expiry[condition_id] = state.round_number + (1 if state.in_enemy_phase else 0)
	emit.call(&"condition_applied", {"target": target.id, "condition": condition_id, "stacks": after - before, "total": after})
	return after - before


func is_immune(target: Combatant, condition_id: StringName) -> bool:
	if target.immune.has(condition_id):
		return true
	var def: ConditionDef = def_of(condition_id)
	if def != null and def.hook == CORRUPTION_HOOK and not target.is_saint():
		return true
	if def != null and def.hook == STUN_HOOK and target.stun_immune_until >= state.round_number:
		return true
	return false


## Only one enemy at a time is in Duel with the same saint (§5).
func _end_other_duels(source: Combatant, new_target: Combatant) -> void:
	for enemy: Combatant in state.enemies:
		if enemy != new_target and enemy.has_condition(DUEL) and enemy.condition_sources.get(DUEL) == source.id:
			remove_all(enemy, DUEL)
			emit.call(&"condition_removed", {"target": enemy.id, "condition": DUEL, "stacks": 1})


func remove_all(target: Combatant, condition_id: StringName) -> void:
	target.conditions.erase(condition_id)
	target.condition_sources.erase(condition_id)
	target.condition_expiry.erase(condition_id)


# --- ticks and decay (§3.2, §3.3) --------------------------------------------------------

## `owner_turn_start`: saints at the start of the party turn, an enemy right
## before its action. Each tick is followed by its decay.
func tick_owner_turn_start(c: Combatant) -> void:
	if not c.is_standing():
		return
	for condition_id: StringName in _sorted_ids(c):
		var def: ConditionDef = def_of(condition_id)
		if def.tick != &"owner_turn_start" or not c.has_condition(condition_id):
			continue
		var stacks: int = c.stacks(condition_id)
		match def.hook:
			BLEED_HOOK:
				# Ignores armor and Ward: hit points are removed directly.
				var lost: int = state.lose_hp(c, stacks)
				emit.call(&"bleed_tick", {"target": c.id, "amount": lost, "hp": c.hp})
				if not c.is_standing():
					emit.call(&"fell" if c.is_saint() else &"enemy_died", {"target": c.id})
			CORRUPTION_HOOK:
				if c.is_saint():
					state.add_desolation(c, stacks * state.constants.get_int(&"corruption_desolation_per_stack"), condition_id)
		if def.decay == &"minus_one_after_tick":
			_decrement(c, condition_id)
		if not c.is_standing():
			return


## ROUND_END step 8: conditions with `expire_round_end` leave when their
## round has ended.
func end_round() -> void:
	for c: Combatant in _everyone():
		for condition_id: StringName in c.condition_expiry.keys():
			if int(c.condition_expiry[condition_id]) <= state.round_number:
				remove_all(c, condition_id)
				emit.call(&"condition_expired", {"target": c.id, "condition": condition_id})


func _decrement(c: Combatant, condition_id: StringName) -> void:
	var left: int = c.stacks(condition_id) - 1
	if left <= 0:
		remove_all(c, condition_id)
		emit.call(&"condition_expired", {"target": c.id, "condition": condition_id})
	else:
		c.conditions[condition_id] = left


# --- stun (§4 stun_cancel) ----------------------------------------------------------------

## The stunned combatant loses this action or intent. Consuming the token
## grants immunity until the end of the following round (decision of 03/11/2026
## for saints; K05 for enemies).
func consume_stun(c: Combatant) -> bool:
	if not c.has_condition(STUN):
		return false
	remove_all(c, STUN)
	c.stun_immune_until = state.round_number + 1
	emit.call(&"stun_consumed", {"target": c.id, "immune_until_round": c.stun_immune_until})
	return true


# --- falling and end of battle (§3.4) -------------------------------------------------------

## A saint who falls stops dueling: the Duel ends on every enemy (§5).
func on_saint_fallen(saint: Combatant) -> void:
	for enemy: Combatant in state.enemies:
		if enemy.has_condition(DUEL) and enemy.condition_sources.get(DUEL) == saint.id:
			remove_all(enemy, DUEL)


## At the end of a battle every condition is removed.
func clear_all() -> void:
	for c: Combatant in _everyone():
		c.conditions.clear()
		c.condition_sources.clear()
		c.condition_expiry.clear()
		c.stun_immune_until = 0


# --- display (§7) ---------------------------------------------------------------------------

## Up to MAX_VISIBLE_ICONS conditions by display priority, and how many more.
func visible_conditions(c: Combatant) -> Dictionary:
	var ids: Array[StringName] = _sorted_ids(c)
	var shown: Array[StringName] = ids.slice(0, MAX_VISIBLE_ICONS)
	return {"shown": shown, "more": maxi(0, ids.size() - MAX_VISIBLE_ICONS)}


func _sorted_ids(c: Combatant) -> Array[StringName]:
	var ids: Array[StringName] = []
	for condition_id: StringName in c.conditions:
		if def_of(condition_id) != null:
			ids.append(condition_id)
	ids.sort_custom(func(a: StringName, b: StringName) -> bool:
		var pa: int = def_of(a).display_priority
		var pb: int = def_of(b).display_priority
		return pa < pb if pa != pb else String(a) < String(b))
	return ids


func _everyone() -> Array[Combatant]:
	var all: Array[Combatant] = []
	all.append_array(state.party)
	all.append_array(state.enemies)
	return all
