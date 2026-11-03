extends GutTest
## T13: balance simulator (testing.md §5). Uses the real CSVs through the
## importer instead of game/data (testing.md §2).


func _data() -> SimData:
	var imp: BalanceImporter = RealData.importer()
	return SimData.create(RealData.catalog(), RealData._keys(imp.saints), RealData._keys(imp.encounters))


func test_all_policies_play_every_m0_encounter_with_valid_commands() -> void:
	var data := _data()
	var sim := BattleSimulator.new(data)
	sim.run(data.encounter_ids("m0"), 2, SimPolicy.ALL, 7)
	assert_eq(sim.battles.size(), 3 * 4 * 2)
	for b: Dictionary in sim.battles:
		assert_eq(b["errors"], 0, "sem erros do motor")
		assert_gt(b["saint_turns"], 0)
	assert_eq(sim.expeditions.size(), 2, "expedição só com a heurística")


func test_same_seed_gives_the_same_results() -> void:
	var data := _data()
	var a := BattleSimulator.new(data)
	var b := BattleSimulator.new(data)
	a.run(["m0_hard_02"] as Array[String], 3, SimPolicy.ALL, 99)
	b.run(["m0_hard_02"] as Array[String], 3, SimPolicy.ALL, 99)
	assert_eq(JSON.stringify(a.battles), JSON.stringify(b.battles))
	assert_eq(JSON.stringify(a.expeditions), JSON.stringify(b.expeditions))


func test_report_has_every_target_and_a_csv() -> void:
	var data := _data()
	var sim := BattleSimulator.new(data)
	sim.run(data.encounter_ids("m0"), 1, SimPolicy.ALL, 3)
	var report := SimReport.build(sim)
	for t: Array in SimReport.TARGETS:
		assert_true(report.metrics.has(t[0]), "métrica %s" % t[0])
	var csv: String = report.to_csv()
	assert_true(csv.begins_with("section,policy,encounter,key,value\n"))
	assert_true(csv.contains("metric,,,win_easy,"))
	assert_true(csv.contains("encounter,heuristic,m0_easy_01,win_rate,"))
	assert_true(report.summary().contains("Fora da meta"))


func test_out_of_target_lists_only_metrics_outside_their_range() -> void:
	var report := SimReport.new()
	report.metrics = {"rounds_easy": 3.5, "win_hard": 0.95, "random_win_hard": 0.30, "top_ability_share": 0.41}
	var off: Array[String] = report.out_of_target()
	assert_eq(off.size(), 2)
	assert_true(off[0].begins_with("Vitória da heurística em combate difícil"))
	assert_true(off[1].begins_with("Maior participação"))


func test_heuristic_heals_an_ally_below_40_percent() -> void:
	var ctrl := BattleController.new(RealData.battle("m0_easy_01", 1))
	ctrl.start()
	var george: Combatant = ctrl.state.find(&"saint_george")
	var benedict: Combatant = ctrl.state.find(&"saint_benedict")
	george.has_acted = true
	benedict.has_acted = true
	george.hp = 5
	ctrl.fervor.amount = 0
	var choice: Dictionary = SimPolicy.new(SimPolicy.HEURISTIC, RngStream.new(1, &"t")).next(ctrl)
	assert_eq(choice["saint"], &"saint_therese")
	assert_eq((choice["cmd"] as BattleCommand).ability_id, &"therese_petal")


func test_greedy_picks_the_biggest_immediate_damage() -> void:
	var ctrl := BattleController.new(RealData.battle("m0_easy_01", 1))
	ctrl.start()
	ctrl.fervor.amount = 0
	var choice: Dictionary = SimPolicy.new(SimPolicy.GREEDY, RngStream.new(1, &"t")).next(ctrl)
	var cmd: BattleCommand = choice["cmd"]
	assert_eq(cmd.actor_id, ctrl.state.party_at(1).id)
	assert_eq(cmd.ability_id, &"george_spear_thrust", "Estocada (7 Golpe) é o maior dano de custo 0")
