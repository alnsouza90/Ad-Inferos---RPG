extends GutTest
## T42 (D-435): consecrated camps (expedition §1, §9; E03, E09). Reaching a
## camp of the whole expedition marks it in the campaign flags; the mark
## survives a defeat; a new expedition can start there with the resumed
## Light and goes on from the next leg.

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(seed: int = 3) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)


## Plays on, winning every battle at once, until `stop` is true.
func _walk(c: ExpeditionController, stop: Callable) -> void:
	for i: int in 400:
		if c.is_over() or stop.call(c):
			return
		match c.phase:
			ExpeditionController.Phase.AT_FORK:
				c.execute(ExpeditionCommand.choose_path(c.entrances()[0].id))
			ExpeditionController.Phase.PENDING:
				c.execute(ExpeditionCommand.engage_node())
			ExpeditionController.Phase.IN_NODE:
				c.execute(ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_EVENT:
				c.execute(ExpeditionCommand.choose_option(StringName(str(c.event.options[0]["id"]))))
			ExpeditionController.Phase.IN_RELIC:
				c.execute(ExpeditionCommand.place_relic())
			ExpeditionController.Phase.IN_BATTLE:
				for e: Combatant in c.battle.state.enemies:
					e.hp = 0
					e.state = Combatant.State.DEAD
				c.battle.phase = BattleController.Phase.VICTORY
				c._resolve_battle()
			ExpeditionController.Phase.AT_CAMP:
				c.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))


func test_reaching_a_camp_consecrates_it() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.AT_CAMP)
	assert_true(c.flags.has(&"circle_02_camp_1"))
	assert_eq(ExpeditionController.last_consecrated_camp(c.flags, &"circle_02"), 1)


func test_E09_a_defeat_keeps_the_consecrated_camps() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.state.leg == 2 and x.phase == ExpeditionController.Phase.IN_BATTLE)
	assert_eq(c.phase, ExpeditionController.Phase.IN_BATTLE, "um combate no trecho 2")
	var bs: BattleState = c.battle.state
	for saint: Combatant in bs.party:
		bs.fall(saint, BattleState.CAUSE_HP)
	c.execute(ExpeditionCommand.battle(BattleCommand.end_party_turn()))
	assert_eq(c.ended_reason, ExpeditionController.END_DEFEATED)
	assert_true(c.flags.has(&"circle_02_camp_1"), "o Pouso consagrado fica")


func test_E03_starting_at_a_consecrated_camp_with_the_resumed_light() -> void:
	var flags: Array[StringName] = [&"circle_02_camp_1"]
	var c := ExpeditionController.start_resumed(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE, 1, flags)
	assert_not_null(c)
	assert_eq(c.state.light, cat.constants.get_int(&"light_resume"), "Lume 75")
	assert_eq(c.phase, ExpeditionController.Phase.AT_CAMP, "começa no Pouso")
	assert_eq(c.state.leg, 1)
	c.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))
	assert_eq(c.state.leg, 2, "segue para o trecho 2")
	assert_eq(c.phase, ExpeditionController.Phase.AT_FORK)


func test_a_camp_never_consecrated_cannot_be_a_start() -> void:
	var none: Array[StringName] = []
	assert_null(ExpeditionController.start_resumed(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE, 1, none))
	assert_eq(ExpeditionController.last_consecrated_camp(none, &"circle_02"), 0, "sem Pouso, começa no Portão")


func test_a_resumed_expedition_replays_from_its_log() -> void:
	var flags: Array[StringName] = [&"circle_02_camp_1", &"circle_02_camp_2"]
	var c := ExpeditionController.start_resumed(cat, &"circle_02", 5, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE, 2, flags)
	assert_eq(ExpeditionController.last_consecrated_camp(flags, &"circle_02"), 2)
	_walk(c, func(x: ExpeditionController) -> bool: return x.state.leg == 3 and x.phase == ExpeditionController.Phase.IN_BATTLE)
	var again := ExpeditionController.replay(cat, c.initial_snapshot(), c.command_log)
	assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(c.snapshot()), "o log refaz a expedição retomada")
