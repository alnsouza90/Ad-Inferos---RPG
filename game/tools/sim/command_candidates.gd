class_name CommandCandidates
extends RefCounted
## Every command that would be accepted right now, in a stable order:
## abilities (equipped order), miracle, provisions, swaps, pass, end turn.
## Used by the simulator policies and by the integration tests.

const SLOT_SETS: Array = [[], [1], [2], [3], [4], [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]


static func all_valid(ctrl: BattleController, include_provisions: bool = true) -> Array[BattleCommand]:
	var result: Array[BattleCommand] = []
	for cmd: BattleCommand in all_candidates(ctrl, include_provisions):
		if ctrl.validate(cmd) == &"":
			result.append(cmd)
	return result


## Saint-specific valid commands (no end turn), for policies that act per saint.
static func for_saint(ctrl: BattleController, saint: Combatant, include_provisions: bool = true) -> Array[BattleCommand]:
	var result: Array[BattleCommand] = []
	for cmd: BattleCommand in _saint_candidates(ctrl, saint, include_provisions):
		if ctrl.validate(cmd) == &"":
			result.append(cmd)
	return result


static func all_candidates(ctrl: BattleController, include_provisions: bool) -> Array[BattleCommand]:
	var cmds: Array[BattleCommand] = []
	for saint: Combatant in ctrl.state.party:
		cmds.append_array(_saint_candidates(ctrl, saint, include_provisions))
	cmds.append(BattleCommand.end_party_turn())
	return cmds


static func _saint_candidates(ctrl: BattleController, saint: Combatant, include_provisions: bool) -> Array[BattleCommand]:
	var cmds: Array[BattleCommand] = []
	for ability_id: StringName in saint.equipped:
		for slots: Array in SLOT_SETS:
			cmds.append(BattleCommand.use_ability(saint.id, ability_id, _ints(slots)))
	for slots: Array in SLOT_SETS:
		cmds.append(BattleCommand.use_miracle(saint.id, _ints(slots)))
	if include_provisions:
		var seen: Dictionary = {}
		for provision: StringName in ctrl.state.provisions:
			if seen.has(provision):
				continue
			seen[provision] = true
			for slot: int in [1, 2, 3]:
				cmds.append(BattleCommand.use_provision(provision, slot, saint.id))
	cmds.append(BattleCommand.swap_slots(saint.id, -1))
	cmds.append(BattleCommand.swap_slots(saint.id, 1))
	cmds.append(BattleCommand.pass_turn(saint.id))
	return cmds


static func _ints(values: Array) -> Array[int]:
	var result: Array[int] = []
	for v: Variant in values:
		result.append(int(v))
	return result
