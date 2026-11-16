extends GutTest
## T42: the whole expedition of Circle 2 (expedition §1, §7, §8): three
## legs, the camps between them, the Vigil and Asmodeus; the soul meeting,
## the fish's liver and the Domínio; experience and the circle's completion.

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(seed: int = 3) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)


## Plays on, winning every battle at once, until `stop` is true or the
## expedition ends. The test is about the flow, not the fights.
func _walk(c: ExpeditionController, stop: Callable, limit: int = 400) -> void:
	for i: int in limit:
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
				var opt: Dictionary = c.event.options[0]
				c.execute(ExpeditionCommand.choose_option(StringName(str(opt["id"]))))
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


func test_the_camp_leads_to_leg_2_with_the_hard_pool_and_the_soul_meeting() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.state.leg == 2)
	assert_eq(c.state.leg, 2)
	assert_eq(c.phase, ExpeditionController.Phase.AT_FORK)
	var soul: Array[MapNode] = c.map.layer_nodes(3)
	assert_eq(soul.size(), 1, "camada 3 de um nó só")
	assert_eq(soul[0].type, MapNode.TYPE_SOUL)
	for n: MapNode in c.map.all_nodes():
		if n.type == MapNode.TYPE_BATTLE:
			assert_true(cat.encounter_pool(2, &"hard").has(n.encounter_id), "trecho 2: grupo difícil")


func test_leg_3_holds_the_fish_on_one_node_and_ends_at_the_vigil() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.state.leg == 3)
	var fish: Array = c.map.all_nodes().filter(func(n: MapNode) -> bool: return n.content == MapGenerator.CONTENT_FISH)
	assert_eq(fish.size(), 1, "um só peixe do Tigre (D-414)")
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.AT_VIGIL)
	assert_eq(c.phase, ExpeditionController.Phase.AT_VIGIL, "depois do trecho 3, a Vigília")


func test_the_vigil_takes_no_bread_and_offers_only_vigil_or_share() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.AT_VIGIL)
	var prayer: Array[Dictionary] = []
	for id: StringName in c.state.party:
		prayer.append({"saint": id, "activity": ExpeditionController.ACTIVITY_PRAYER, "target": &""})
	assert_eq(c.rest_problem(prayer), ExpeditionController.REJECT_BAD_ACTIVITY, "na Vigília, sem Oração")
	c.state.provisions.erase(&"bread")
	c.state.provisions.erase(&"bread")
	var vigil: Array[Dictionary] = []
	for id: StringName in c.state.party:
		vigil.append({"saint": id, "activity": ExpeditionController.ACTIVITY_VIGIL, "target": &""})
	assert_eq(c.rest_problem(vigil), &"", "sem Pão, tudo bem")
	assert_eq(c.execute(ExpeditionCommand.rest(vigil)), &"")
	assert_eq(c.phase, ExpeditionController.Phase.IN_BATTLE, "depois, Asmodeu")
	assert_eq(c.battle.state.encounter_type, &"boss")


func test_the_boss_comes_with_the_dominion_the_company_earned() -> void:
	var c := _new()
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.IN_BATTLE and x.battle.state.encounter_type == &"boss")
	var claws: Array[StringName] = Dominion.claws(c.state.dominion_reached, c.state.has_liver)
	assert_eq(c.battle.state.dominion_claws, claws)
	assert_eq(c.battle.state.has_liver, c.state.has_liver)


func test_reaching_the_pilgrim_yields_at_most_two_claws() -> void:
	var c := _new()
	for i: int in 4:
		c._apply_outcome({"type": "dominion"})
	assert_eq(c.state.dominion_reached, 2, "no máximo 2 alcances (o fígado é a 3ª garra)")


func test_beating_the_boss_completes_the_circle_with_its_rewards() -> void:
	var c := _new()
	_walk(c, func(_x: ExpeditionController) -> bool: return false, 2000)
	assert_eq(c.ended_reason, ExpeditionController.END_CIRCLE_COMPLETE)
	assert_true(c.flags.has(&"circle_02_completed"), "primeira conclusão marcada")
	assert_eq(c.state.alms_unbanked, 0, "as Esmolas ficam garantidas")
	for id: StringName in c.saints:
		assert_gt((c.saints[id] as SaintStatus).xp, 0, "experiência por combate")


func test_the_whole_expedition_replays_from_its_log_and_saves() -> void:
	var c := _new(5)
	var plays := 0
	for i: int in 600:
		if c.is_over() or c.state.leg == 3:
			break
		var before: int = c.command_log.size()
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
				c.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(c.battle)))
			ExpeditionController.Phase.AT_CAMP:
				c.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))
		plays += c.command_log.size() - before
	var again := ExpeditionController.replay(cat, c.initial_snapshot(), c.command_log)
	assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(c.snapshot()), "o log refaz a expedição")
	assert_not_null(ExpeditionSave.restore(cat, JSON.parse_string(JSON.stringify(ExpeditionSave.build(c, 1)))), "o save abre")
	assert_gt(plays, 0)


func test_the_arena_keeps_the_one_leg_shape() -> void:
	var c := ExpeditionController.start_new(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	_walk(c, func(x: ExpeditionController) -> bool: return x.phase == ExpeditionController.Phase.AT_CAMP)
	c.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))
	assert_eq(c.ended_reason, ExpeditionController.END_LEG_COMPLETE)
