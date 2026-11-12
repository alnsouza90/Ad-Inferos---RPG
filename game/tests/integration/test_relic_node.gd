extends GutTest
## T25: the M1 variable node (D-124, D-146): relic or battle, the three
## sacramental relics and their modifiers, the guard battle and the loss on
## defeat (expedition §3, §8 and §9; data-schemas §4).

const G: StringName = &"saint_george"

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(seed: int = 1) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


## A controller that just found `relic_id` (built directly at a layer 2 node).
func _found(relic_id: StringName) -> ExpeditionController:
	var ctrl := _new()
	ctrl.state.current_node = ctrl.map.node(2, 0).id
	ctrl.state.pending_relic = relic_id
	ctrl._award_relic()
	return ctrl


func test_all_25_relics_import_and_the_node_pool_is_the_three_of_d124() -> void:
	assert_eq(cat.relics.size(), 25)
	assert_eq(cat.relic_node_pool(), [&"relic_candlemas_candle", &"relic_tau_cross", &"relic_wooden_crucifix"] as Array[StringName])


func test_relic_node_gives_40_alms_and_waits_for_a_carrier() -> void:
	var ctrl := _found(&"relic_wooden_crucifix")
	assert_eq(ctrl.phase, ExpeditionController.Phase.IN_RELIC)
	assert_eq(ctrl.state.alms_unbanked, 40)
	assert_true(ctrl.state.relics_found.has(&"relic_wooden_crucifix"))


func test_wooden_crucifix_adds_1_faith_in_battle() -> void:
	var ctrl := _found(&"relic_wooden_crucifix")
	assert_eq(ctrl.execute(ExpeditionCommand.place_relic(G)), &"")
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_FORK)
	ctrl._start_battle(&"m0_easy_01", &"test")
	var george: Combatant = ctrl.battle.state.party_at(1)
	assert_eq(george.id, G)
	assert_eq(george.faith, cat.saint(G).faith + 1)


func test_tau_cross_raises_max_hp_by_5_percent_and_heals_the_gain() -> void:
	var ctrl := _found(&"relic_tau_cross")
	var status: SaintStatus = ctrl.saints[G]
	var base: int = cat.saint(G).max_hp
	ctrl.execute(ExpeditionCommand.place_relic(G))
	assert_eq(status.max_hp, Damage.round_half_up(base * 1.05))
	assert_eq(status.hp, status.max_hp)


func test_candlemas_candle_makes_light_fall_4_per_node() -> void:
	var ctrl := _new()
	ctrl.saints[G].relics.append(&"relic_candlemas_candle")
	var light: int = ctrl.state.light
	ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
	assert_eq(ctrl.state.light, light - 4)


func test_each_saint_has_one_relic_slot_in_the_m1() -> void:
	var ctrl := _found(&"relic_tau_cross")
	ctrl.saints[G].relics.append(&"relic_wooden_crucifix")
	assert_eq(ctrl.execute(ExpeditionCommand.place_relic(G)), ExpeditionController.REJECT_NO_SLOT)
	assert_eq(ctrl.execute(ExpeditionCommand.place_relic(&"saint_benedict")), &"")


func test_D146_relic_kept_in_the_pack_has_no_effect() -> void:
	var ctrl := _found(&"relic_candlemas_candle")
	ctrl.execute(ExpeditionCommand.place_relic())
	assert_true(ctrl.state.relic_pack.has(&"relic_candlemas_candle"))
	assert_true(ctrl.carried_relics().is_empty())


func test_defeat_loses_the_relics_found_and_their_effects() -> void:
	var ctrl := _found(&"relic_tau_cross")
	ctrl.execute(ExpeditionCommand.place_relic(G))
	ctrl._start_battle(&"m0_easy_01", &"test_defeat")
	var bs: BattleState = ctrl.battle.state
	for c: Combatant in bs.party:
		bs.fall(c, BattleState.CAUSE_HP)
	ctrl.execute(ExpeditionCommand.battle(BattleCommand.end_party_turn()))
	assert_eq(ctrl.ended_reason, ExpeditionController.END_DEFEATED)
	assert_true(ctrl.saints[G].relics.is_empty())
	assert_eq(ctrl.saints[G].max_hp, cat.saint(G).max_hp)
	assert_true(ctrl.state.relics_found.is_empty())


func test_about_30_percent_of_relic_nodes_are_guarded() -> void:
	var guarded: int = 0
	var total: int = 400
	for seed: int in total:
		var ctrl := _new(seed)
		var n: MapNode = ctrl.map.node(1, 0)
		n.type = MapNode.TYPE_RELIC
		ctrl.execute(ExpeditionCommand.choose_path(n.id))
		ctrl.execute(ExpeditionCommand.engage_node())
		if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			guarded += 1
		else:
			assert_eq(ctrl.phase, ExpeditionController.Phase.IN_RELIC)
	assert_almost_eq(float(guarded) / total, 0.3, 0.07)


func test_winning_the_guard_battle_gives_the_relic() -> void:
	for seed: int in 60:
		var ctrl := _new(seed)
		var n: MapNode = ctrl.map.node(1, 0)
		n.type = MapNode.TYPE_RELIC
		ctrl.execute(ExpeditionCommand.choose_path(n.id))
		ctrl.execute(ExpeditionCommand.engage_node())
		if ctrl.phase != ExpeditionController.Phase.IN_BATTLE:
			continue
		while ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
		if ctrl.last_battle.phase == BattleController.Phase.VICTORY:
			assert_eq(ctrl.phase, ExpeditionController.Phase.IN_RELIC)
			assert_eq(ctrl.state.alms_unbanked, 70 + 40)
			return
	fail_test("nenhuma relíquia guardada vencida em 60 sementes")


func test_relic_choices_replay_exactly() -> void:
	var ctrl := _new(4)
	var n: MapNode = ctrl.map.node(1, 0)
	var steps: int = 0
	while not ctrl.is_over() and ctrl.phase != ExpeditionController.Phase.AT_CAMP and steps < 3000:
		steps += 1
		match ctrl.phase:
			ExpeditionController.Phase.AT_FORK:
				ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
			ExpeditionController.Phase.PENDING:
				ctrl.execute(ExpeditionCommand.engage_node())
			ExpeditionController.Phase.IN_NODE:
				ctrl.execute(ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_EVENT:
				ctrl.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
			ExpeditionController.Phase.IN_RELIC:
				ctrl.execute(ExpeditionCommand.place_relic(G))
			ExpeditionController.Phase.IN_BATTLE:
				ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	var again := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
	assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(ctrl.snapshot()))
	assert_not_null(n)
