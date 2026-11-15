extends GutTest
## T39: the common encounters of Circle 2 (bosses.md §6) and the Vendaval in
## the expedition and on the battle screen, with the real data.

var cat: ExpeditionCatalog
var data: GameData


func before_all() -> void:
	cat = RealData.expedition_catalog()
	data = RealData.game_data()


func test_the_ten_encounters_of_bosses_md_section_6_exist_with_the_vendaval() -> void:
	var easy: Array[StringName] = cat.encounter_pool(2, &"easy")
	var hard: Array[StringName] = cat.encounter_pool(2, &"hard")
	assert_eq(easy.size(), 5, "5 fáceis")
	assert_eq(hard.size(), 5, "5 difíceis")
	for id: StringName in easy + hard:
		var enc: EncounterDef = cat.encounter(id)
		assert_eq(enc.hazard, &"gale", "%s com Vendaval" % id)
		assert_eq(enc.type, &"common")
		for enemy_id: StringName in enc.slots:
			assert_eq((cat.battle_catalog.enemies[enemy_id] as EnemyDef).family, &"a", "%s só com a Família A" % id)
	assert_eq(cat.encounter(&"c02_hard_02").slots, [&"enemy_infernal_scarab", &"enemy_mud_devil", &"enemy_swarm_mother", &"enemy_shade_of_desire"] as Array[StringName])


func test_the_arena_has_no_vendaval() -> void:
	for id: StringName in data.arena_encounter_ids():
		assert_eq(data.battle(id, 1).hazard, &"", String(id))


func test_the_expedition_draws_circle_2_battles_with_the_vendaval() -> void:
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 11, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)
	for i: int in 30:
		match ctrl.phase:
			ExpeditionController.Phase.AT_FORK:
				var pick: MapNode = ctrl.entrances()[0]
				for n: MapNode in ctrl.entrances():
					if n.is_battle_like():
						pick = n
				ctrl.execute(ExpeditionCommand.choose_path(pick.id))
			ExpeditionController.Phase.PENDING:
				ctrl.execute(ExpeditionCommand.engage_node())
			ExpeditionController.Phase.IN_NODE:
				ctrl.execute(ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_EVENT:
				ctrl.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
			ExpeditionController.Phase.IN_RELIC:
				ctrl.execute(ExpeditionCommand.place_relic())
		if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			break
	assert_eq(ctrl.phase, ExpeditionController.Phase.IN_BATTLE, "um combate no trecho")
	assert_eq(ctrl.battle.state.hazard, &"gale")
	assert_eq(ctrl.battle.state.gale_slots.size(), 2, "Vendaval marcado na 1ª rodada")


func test_the_screen_shows_the_vendaval_and_stand_firm() -> void:
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	var state: BattleState = data.battle(&"m0_easy_01", 3)
	state.hazard = &"gale"
	screen.setup(data, BattleController.new(state))
	add_child_autofree(screen)
	var slots: Array[int] = screen.ctrl.state.gale_slots
	assert_eq(slots.size(), 2)
	# Benedict in the middle does not hold the wind (D-402).
	assert_eq(screen.gale_text(), screen.texts.t(&"gale_mark"))
	assert_true(screen._stand_firm_button.visible)
	var marked: Combatant = screen.ctrl.state.party_at(slots[0])
	screen.tap(marked.id)
	assert_eq(screen.selection.stand_firm_reason(), &"", "Firmar o pé disponível para o marcado")


func test_the_marked_saint_can_stand_firm_on_screen() -> void:
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	var state: BattleState = data.battle(&"m0_easy_01", 3)
	state.hazard = &"gale"
	for c: Combatant in state.party:
		if c.trait_hook() == &"clausura":
			c.trait_def = null
	screen.setup(data, BattleController.new(state))
	add_child_autofree(screen)
	assert_eq(screen.gale_text(), screen.texts.t(&"gale_mark"))
	var marked: Combatant = screen.ctrl.state.party_at(screen.ctrl.state.gale_slots[0])
	screen.tap(marked.id)
	screen.press_stand_firm()
	assert_eq(screen.selection.mode, BattleSelection.Mode.STAND_FIRM)
	assert_string_contains(screen.hint_text(), screen.texts.t(&"stand_firm_desc", {"fervor": 1}))
	screen.press_stand_firm()
	assert_true(marked.has_acted)
	assert_eq(screen.gale_text(), screen.texts.t(&"gale_held_firm"))
