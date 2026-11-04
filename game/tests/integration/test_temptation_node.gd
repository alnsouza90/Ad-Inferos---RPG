extends GutTest
## T23: the Temptation node of the expedition, with the draft Circle 2
## Temptation (docs/narrative/events) and the real M0 data.

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(catalog: ExpeditionCatalog, seed: int = 1) -> ExpeditionController:
	return ExpeditionController.start_new(catalog, &"circle_02", seed, RealData.m0_party_ids(), catalog.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


func _ok(ctrl: ExpeditionController, cmd: ExpeditionCommand) -> void:
	assert_eq(ctrl.execute(cmd), &"", "comando recusado: %s" % [cmd.to_dict()])


## Walks the leg until a Temptation starts (refusing nothing on the way).
func _go_to_temptation(ctrl: ExpeditionController) -> void:
	for i: int in 400:
		match ctrl.phase:
			ExpeditionController.Phase.IN_EVENT:
				return
			ExpeditionController.Phase.AT_FORK:
				var pick: MapNode = ctrl.entrances()[0]
				for n: MapNode in ctrl.entrances():
					if n.type == MapNode.TYPE_TEMPTATION:
						pick = n
				_ok(ctrl, ExpeditionCommand.choose_path(pick.id))
			ExpeditionController.Phase.IN_NODE:
				_ok(ctrl, ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_BATTLE:
				_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
			_:
				break
	fail_test("nenhuma Tentação alcançada")


func test_temptation_node_opens_the_circle_2_temptation() -> void:
	var ctrl := _new(cat)
	_go_to_temptation(ctrl)
	assert_eq(ctrl.event.id, &"c02_temptation_wind_shelter")
	assert_eq(ctrl.option_problem(&"refuse"), &"")


func test_refusing_costs_5_light_and_moves_on() -> void:
	var ctrl := _new(cat)
	_go_to_temptation(ctrl)
	var light: int = ctrl.state.light
	_ok(ctrl, ExpeditionCommand.choose_option(&"refuse"))
	assert_eq(ctrl.state.light, light - 5)
	assert_null(ctrl.event)
	assert_true(ctrl.phase == ExpeditionController.Phase.AT_FORK or ctrl.phase == ExpeditionController.Phase.AT_CAMP)


func test_N01_praying_needs_faith_3_and_is_refused_with_faith_2() -> void:
	var ctrl := _new(cat)
	_go_to_temptation(ctrl)
	assert_eq(ctrl.option_problem(&"pray_through"), ExpeditionController.REJECT_REQUIREMENT)
	assert_eq(ctrl.execute(ExpeditionCommand.choose_option(&"pray_through")), ExpeditionController.REJECT_REQUIREMENT)
	ctrl.virtues.change(Virtues.FAITH, 1, cat.constants)
	assert_eq(ctrl.option_problem(&"pray_through"), &"")


func test_N03_benedict_and_holy_water_raise_the_shelter_chance_to_90() -> void:
	var ctrl := _new(cat)
	_go_to_temptation(ctrl)
	assert_almost_eq(ctrl.option_chance(&"watchful_shelter"), 0.9, 0.0001, "0,5 + Bento 0,2 + Água Benta 0,2")
	ctrl.state.provisions.clear()
	assert_almost_eq(ctrl.option_chance(&"watchful_shelter"), 0.7, 0.0001)


func test_shelter_consumes_holy_water_and_applies_success_or_failure() -> void:
	for seed: int in 6:
		var ctrl := _new(cat, seed)
		_go_to_temptation(ctrl)
		var waters: int = ctrl.state.provisions.count(&"holy_water")
		var before: Dictionary = {}
		for id: StringName in ctrl.saints:
			before[id] = (ctrl.saints[id] as SaintStatus).desolation
		_ok(ctrl, ExpeditionCommand.choose_option(&"watchful_shelter"))
		assert_eq(ctrl.state.provisions.count(&"holy_water"), waters - 1, "Água Benta gasta pelo modificador")
		var resolved: Dictionary = ctrl.history.filter(func(h: Dictionary) -> bool: return h["type"] == ExpeditionController.EV_EVENT_RESOLVED)[0]
		var success: bool = resolved["data"]["success"]
		assert_eq(ctrl.virtues.get_value(Virtues.HOPE), 2 if success else 1)
		for id: StringName in ctrl.saints:
			var now: int = (ctrl.saints[id] as SaintStatus).desolation
			if success:
				assert_lte(now, int(before[id]))
			else:
				assert_gt(now, int(before[id]))


func test_event_choices_are_logged_and_replay_exactly() -> void:
	var ctrl := _new(cat, 2)
	_go_to_temptation(ctrl)
	_ok(ctrl, ExpeditionCommand.choose_option(&"watchful_shelter"))
	var again := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
	assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(ctrl.snapshot()))


func test_start_battle_outcome_fights_on_the_node_then_moves_on() -> void:
	var custom := RealData.expedition_catalog()
	var e := EventDef.new()
	e.id = &"t_ambush"
	e.type = &"temptation"
	e.circle = 2
	e.options = [{"id": "fight", "text_pt": "Lutar", "safe": true, "requires": [], "chance": {}, "outcomes": [{"type": "start_battle", "id": "m0_easy_01", "target": "", "amount": 0.0}, {"type": "set_flag", "id": "c02_fought", "target": "", "amount": 0.0}], "on_success": [], "on_failure": []}]
	custom.events = {&"t_ambush": e}
	var ctrl := _new(custom)
	_go_to_temptation(ctrl)
	_ok(ctrl, ExpeditionCommand.choose_option(&"fight"))
	assert_eq(ctrl.phase, ExpeditionController.Phase.IN_BATTLE)
	assert_true(ctrl.flags.has(&"c02_fought"))
	while ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	assert_true(ctrl.phase == ExpeditionController.Phase.AT_FORK or ctrl.phase == ExpeditionController.Phase.AT_CAMP or ctrl.is_over())
