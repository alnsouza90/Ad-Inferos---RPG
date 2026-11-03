extends GutTest
## T11 acceptance: preview and real execution give the same result in 1,000
## random valid commands, with the real M0 kits against the m0_* encounters.

const COMMANDS: int = 1000
const SEED: int = 20261103


func _entries(ctrl: BattleController, cmd: BattleCommand) -> Array:
	var before: Dictionary = {}
	for intent: Intent in ctrl.state.intents:
		before[intent.enemy_id] = intent.kind
	var result: CommandResult = ctrl.execute(cmd)
	assert_true(result.ok, "comando válido recusado: %s (%s)" % [cmd.to_dict(), result.reason])
	var cancelled: Array[StringName] = []
	for intent: Intent in ctrl.state.intents:
		if before.get(intent.enemy_id, &"") == Intent.KIND_ACTION and intent.kind != Intent.KIND_ACTION:
			cancelled.append(intent.enemy_id)
	var list: Array = []
	for e: PreviewEntry in PreviewEntry.from_events(result.events, cancelled):
		list.append(e.to_dict())
	return list


func _candidates(ctrl: BattleController) -> Array[BattleCommand]:
	var cmds: Array[BattleCommand] = []
	var slot_sets: Array = [[], [1], [2], [3], [4], [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]
	for saint: Combatant in ctrl.state.party:
		var abilities: Array[StringName] = saint.equipped.duplicate()
		for ability_id: StringName in abilities:
			for slots: Array in slot_sets:
				cmds.append(BattleCommand.use_ability(saint.id, ability_id, Array(slots, TYPE_INT, "", null)))
		for slots: Array in slot_sets:
			cmds.append(BattleCommand.use_miracle(saint.id, Array(slots, TYPE_INT, "", null)))
		cmds.append(BattleCommand.swap_slots(saint.id, -1))
		cmds.append(BattleCommand.swap_slots(saint.id, 1))
		cmds.append(BattleCommand.pass_turn(saint.id))
		for provision: StringName in [&"bread", &"holy_water", &"bandages"]:
			for slot: int in [1, 2, 3]:
				cmds.append(BattleCommand.use_provision(provision, slot, saint.id))
	cmds.append(BattleCommand.end_party_turn())
	return cmds.filter(func(cmd: BattleCommand) -> bool: return ctrl.validate(cmd) == &"")


func test_preview_equals_execution_for_1000_random_valid_commands() -> void:
	var picker := RngStream.new(SEED, &"test_picker")
	var encounters: Array[String] = RealData.m0_encounter_ids()
	var done := 0
	var battles := 0
	var provisions: Array[StringName] = [&"bread", &"bread", &"holy_water", &"bandages"]
	while done < COMMANDS:
		var ctrl := BattleController.new(RealData.battle(encounters[battles % encounters.size()], SEED + battles, provisions))
		ctrl.start()
		battles += 1
		while not ctrl.is_over() and done < COMMANDS and ctrl.state.round_number < 30:
			var options: Array[BattleCommand] = _candidates(ctrl)
			var cmd: BattleCommand = options[picker.pick_index(options.size())]
			var snapshot: String = JSON.stringify(ctrl.state.to_dict(), "", true)
			var predicted: Array = []
			for e: PreviewEntry in ctrl.preview(cmd):
				predicted.append(e.to_dict())
			assert_eq(JSON.stringify(ctrl.state.to_dict(), "", true), snapshot, "prévia alterou o estado")
			var actual: Array = _entries(ctrl, cmd)
			if JSON.stringify(predicted) != JSON.stringify(actual):
				fail_test("divergência em %s: prévia %s, execução %s" % [cmd.to_dict(), predicted, actual])
				return
			done += 1
	assert_eq(done, COMMANDS)
	gut.p("%d comandos em %d combates" % [done, battles])
