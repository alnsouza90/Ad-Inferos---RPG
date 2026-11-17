extends GutTest
## T42 part 2: the screens of the whole expedition (expedition §1, §7):
## "Seguir" from a camp opens the next leg, the Vigil before the boss on the
## camp screen (only Vigil and Share, no way back) and the end summary.

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _new() -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)


func _leg(ctrl: ExpeditionController) -> LegScreen:
	var leg := LegScreen.new()
	leg.use_game_state = false
	leg.speed_index = BattleScreen.SPEED_INSTANT
	leg.setup(data, cat, ctrl)
	add_child_autofree(leg)
	return leg


## Plays the rules on, winning every battle at once, until `stop` is true.
func _walk(c: ExpeditionController, stop: Callable) -> void:
	for i: int in 2000:
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
			ExpeditionController.Phase.AT_VIGIL:
				var plan: Array[Dictionary] = []
				for id: StringName in c.state.party:
					plan.append({"saint": id, "activity": ExpeditionController.ACTIVITY_VIGIL, "target": &""})
				c.execute(ExpeditionCommand.rest(plan))


func test_seguir_at_the_first_camp_names_and_opens_leg_2() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.AT_CAMP)
	var leg := _leg(c)
	assert_eq(leg.screen_kind(), &"camp")
	var camp: CampScreen = leg.current
	var go: Button = camp.fixed_button(CampScreen.FIXED_CONTINUE)
	assert_eq(go.text, data.ui.text(&"camp_continue_leg", {"leg": 2}))
	assert_true(camp.fixed_button(CampScreen.FIXED_RETREAT).visible, "no Pouso, a retirada continua")
	camp.press_continue()
	camp.press_continue()
	assert_eq(c.state.leg, 2)
	assert_eq(leg.screen_kind(), &"walk", "o trecho 2 abre na caminhada")


func test_the_vigil_screen_offers_only_vigil_and_share_and_leads_to_the_boss() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.AT_VIGIL)
	var leg := _leg(c)
	assert_eq(leg.screen_kind(), &"camp", "a Vigília usa a tela do Pouso")
	var camp: CampScreen = leg.current
	assert_true(camp.is_vigil())
	assert_eq(camp.info_text(), data.ui.text(&"camp_vigil_info"))
	assert_false(camp.fixed_button(CampScreen.FIXED_CONTINUE).visible, "sem Seguir")
	assert_false(camp.fixed_button(CampScreen.FIXED_RETREAT).visible, "sem retirada")
	assert_eq(camp.fixed_button(CampScreen.FIXED_REST).text, data.ui.text(&"camp_vigil_rest"))
	for id: StringName in c.state.party:
		assert_not_null(camp.activity_button(id, ExpeditionController.ACTIVITY_VIGIL))
		assert_not_null(camp.activity_button(id, ExpeditionController.ACTIVITY_SHARE))
		assert_null(camp.activity_button(id, ExpeditionController.ACTIVITY_PRAYER), "sem Oração")
		assert_null(camp.activity_button(id, ExpeditionController.ACTIVITY_OWN), "sem habilidade própria")
		camp.choose_activity(id, ExpeditionController.ACTIVITY_VIGIL)
	camp.press_rest()
	assert_eq(camp.info_text(), data.ui.text(&"camp_vigil_confirm"))
	camp.press_rest()
	assert_true(camp.result_shown())
	assert_string_contains(camp.result_text(), data.ui.text(&"camp_vigil_after"))
	camp.press_result_continue()
	assert_eq(leg.screen_kind(), &"battle")
	assert_eq(c.battle.state.encounter_type, &"boss", "depois, Asmodeu")


func test_the_end_summary_of_the_whole_expedition() -> void:
	var c := _new()
	_walk(c, func(_x: ExpeditionController) -> bool: return false)
	assert_eq(c.ended_reason, ExpeditionController.END_CIRCLE_COMPLETE)
	var leg := _leg(c)
	assert_eq(leg.screen_kind(), &"summary")
	var text: String = leg.panel_text()
	assert_string_contains(text, data.ui.text(&"summary_title_expedition", {"reason": data.ui.text(&"walk_end_circle_complete")}))
	var xp: int = (c.saints[c.state.party[0]] as SaintStatus).xp
	assert_string_contains(text, data.ui.text(&"summary_saint_xp", {"xp": xp}))
