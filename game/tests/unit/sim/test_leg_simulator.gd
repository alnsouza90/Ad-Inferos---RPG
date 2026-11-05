extends GutTest
## T31: leg simulator (testing.md §5.3) — whole M1 legs with the real
## expedition controller, deterministic by seed, with the metrics the report
## needs (battles inside legs, ambushes from the hard pool, Dark Night).

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func test_legs_end_and_record_their_battles() -> void:
	var sim := LegSimulator.new(cat)
	sim.run(20, [SimPolicy.HEURISTIC] as Array[StringName], LegSimulator.PATH_RANDOM, 1)
	assert_eq(sim.legs.size(), 20)
	for leg: Dictionary in sim.legs:
		assert_true([ExpeditionController.END_LEG_COMPLETE, ExpeditionController.END_DEFEATED, ExpeditionController.END_RETREATED].has(leg["end"]), "trecho terminou: %s" % [leg])
		assert_gt(int(leg["battles"]), 0, "todo caminho tem combates (expedition §2.1)")
	assert_gt(sim.battles.size(), 20)
	for b: Dictionary in sim.battles:
		assert_true(b["pool"] == &"easy" or b["pool"] == &"hard")


func test_same_seed_same_leg() -> void:
	var a := LegSimulator.new(cat)
	var b := LegSimulator.new(cat)
	assert_eq(JSON.stringify(a.play_leg(SimPolicy.HEURISTIC, LegSimulator.PATH_RANDOM, 7)), JSON.stringify(b.play_leg(SimPolicy.HEURISTIC, LegSimulator.PATH_RANDOM, 7)))


func test_ambush_battles_count_as_hard() -> void:
	var sim := LegSimulator.new(cat)
	sim.incense_policy = LegSimulator.INCENSE_REVEAL
	sim.run(200, [SimPolicy.HEURISTIC] as Array[StringName], LegSimulator.PATH_RANDOM, 1)
	var ambushed: int = sim.legs.filter(func(l: Dictionary) -> bool: return l["ambush"]).size()
	var hard: int = sim.battles.filter(func(b: Dictionary) -> bool: return b["pool"] == &"hard").size()
	assert_eq(hard, ambushed, "cada emboscada é um combate difícil (M1, expedition §13)")


func test_keeping_incense_cancels_every_first_ambush() -> void:
	var sim := LegSimulator.new(cat)
	sim.incense_policy = LegSimulator.INCENSE_KEEP
	sim.run(100, [SimPolicy.HEURISTIC] as Array[StringName], LegSimulator.PATH_RANDOM, 1)
	assert_eq(sim.legs.filter(func(l: Dictionary) -> bool: return l["ambush"]).size(), 0, "o Incenso anula a emboscada (E07)")


func test_report_has_the_m1_metrics() -> void:
	var sim := LegSimulator.new(cat)
	sim.run(30, [SimPolicy.HEURISTIC, SimPolicy.RANDOM] as Array[StringName], LegSimulator.PATH_RANDOM, 3)
	var report := LegReport.build(sim)
	for key: String in ["win_hard", "win_easy", "dark_night_per_leg", "leg_complete", "peak_desolation", "random_leg_complete"]:
		assert_true(report.metrics.has(key), key)
	assert_eq(report.to_csv().split("\n", false).size(), 61, "cabeçalho + 60 trechos")
	assert_true(report.summary().contains("Noite Escura"))
