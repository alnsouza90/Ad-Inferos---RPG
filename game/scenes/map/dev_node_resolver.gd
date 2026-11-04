class_name DevNodeResolver
extends RefCounted
## Test tool (dev builds only, like the arena): finishes the node the party
## entered while its screens do not exist yet (T28 to T30), so the whole leg
## can be walked on the phone. It only sends ordinary commands, through the
## same `run` callable the corridor uses, so they are logged and saved:
## battles with "first valid ability, else pass", the first option of an
## event that can be taken, relics into the pack.

## Ability target sets tried in order (positions 1 to 4, then pairs).
const SLOT_SETS: Array = [[], [1], [2], [3], [4], [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]
## Safety stop for a battle that would never end.
const MAX_COMMANDS: int = 2000


## Runs commands until the party is back at a fork, at camp or the
## expedition is over. `run` takes an ExpeditionCommand and returns the
## refusal reason (&"" when accepted).
static func resolve(ctrl: ExpeditionController, run: Callable) -> void:
	for i: int in MAX_COMMANDS:
		var cmd: ExpeditionCommand = next_command(ctrl)
		if cmd == null or run.call(cmd) != &"":
			return


static func next_command(ctrl: ExpeditionController) -> ExpeditionCommand:
	match ctrl.phase:
		ExpeditionController.Phase.IN_BATTLE:
			return ExpeditionCommand.battle(_battle_command(ctrl.battle))
		ExpeditionController.Phase.IN_NODE:
			return ExpeditionCommand.complete_node()
		ExpeditionController.Phase.IN_RELIC:
			return ExpeditionCommand.place_relic()
		ExpeditionController.Phase.IN_EVENT:
			for option: Dictionary in ctrl.event.options:
				var id := StringName(str(option.get("id", "")))
				if ctrl.option_problem(id) == &"":
					return ExpeditionCommand.choose_option(id)
	return null


static func _battle_command(battle: BattleController) -> BattleCommand:
	for saint: Combatant in battle.state.party:
		if not saint.is_standing() or saint.has_acted:
			continue
		for ability_id: StringName in saint.equipped:
			for slots: Array in SLOT_SETS:
				var cmd := BattleCommand.use_ability(saint.id, ability_id, _ints(slots))
				if battle.validate(cmd) == &"":
					return cmd
		var pass_cmd := BattleCommand.pass_turn(saint.id)
		if battle.validate(pass_cmd) == &"":
			return pass_cmd
	return BattleCommand.end_party_turn()


static func _ints(values: Array) -> Array[int]:
	var result: Array[int] = []
	for v: Variant in values:
		result.append(int(v))
	return result
