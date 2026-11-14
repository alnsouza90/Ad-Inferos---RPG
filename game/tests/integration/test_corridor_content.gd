extends GutTest
## T37: content that waits in the corridor (expedition §2.3 item 4) —
## ChoosePath only enters the node; EngageNode starts the content; PassBy
## applies the Temptation's first safe option; the save keeps the corridor
## place outside the log; old saves are migrated (save-load §3.1 and §7).

const DIR: String = "user://test_corridor_content"

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func after_all() -> void:
	SaveStore.new(DIR).delete_all()


func _new(seed: int = 1) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


## Enters the first layer-1 node turned into `type`.
func _entered(type: StringName) -> ExpeditionController:
	var first := _new()
	first.entrances()[0].type = type
	first.state.map = first.map.to_dict()
	# Rebuilt so the starting snapshot (what replays use) has the new type.
	var c := ExpeditionController.from_snapshot(cat, first.snapshot())
	var n: MapNode = c.entrances()[0]
	assert_eq(c.execute(ExpeditionCommand.choose_path(n.id)), &"")
	return c


func _battle_seed() -> int:
	for seed: int in 30:
		for n: MapNode in _new(seed).entrances():
			if n.is_battle_like():
				return seed
	return -1


# --- ChoosePath and EngageNode ------------------------------------------------------

func test_entering_a_node_with_content_spends_light_and_waits() -> void:
	for type: StringName in [MapNode.TYPE_TEMPTATION, MapNode.TYPE_RELIC, MapNode.TYPE_SOUL]:
		var c := _entered(type)
		assert_eq(c.phase, ExpeditionController.Phase.PENDING, String(type))
		assert_eq(c.state.light, 95, "o Lume já caiu")
		assert_eq(c.pending_node().type, type)
		assert_eq(c.entrances(), [] as Array[MapNode], "sem bifurcação enquanto o conteúdo espera")


func test_engage_starts_each_kind_of_content() -> void:
	var expected: Dictionary = {
		MapNode.TYPE_TEMPTATION: [ExpeditionController.Phase.IN_EVENT],
		MapNode.TYPE_RELIC: [ExpeditionController.Phase.IN_RELIC, ExpeditionController.Phase.IN_BATTLE],
		MapNode.TYPE_SOUL: [ExpeditionController.Phase.IN_NODE],
	}
	for type: StringName in expected:
		var c := _entered(type)
		assert_eq(c.execute(ExpeditionCommand.engage_node()), &"")
		assert_true((expected[type] as Array).has(c.phase), "%s → fase %d" % [type, c.phase])
		assert_eq(c.command_log.back()["type"], "EngageNode")


func test_E17_battle_waits_until_engaged() -> void:
	var seed: int = _battle_seed()
	if seed < 0:
		pass_test("nenhuma semente com combate na camada 1")
		return
	var c := _new(seed)
	var target: MapNode
	for n: MapNode in c.entrances():
		if n.is_battle_like():
			target = n
	c.execute(ExpeditionCommand.choose_path(target.id))
	assert_eq(c.phase, ExpeditionController.Phase.PENDING)
	assert_null(c.battle)
	c.execute(ExpeditionCommand.engage_node())
	assert_eq(c.phase, ExpeditionController.Phase.IN_BATTLE)
	assert_not_null(c.battle)


func test_engage_and_pass_by_are_refused_without_pending_content() -> void:
	var c := _new()
	assert_eq(c.execute(ExpeditionCommand.engage_node()), ExpeditionController.REJECT_WRONG_PHASE)
	assert_eq(c.execute(ExpeditionCommand.pass_by()), ExpeditionController.REJECT_WRONG_PHASE)
	assert_eq(c.command_log.size(), 0)


func test_choose_path_is_refused_while_content_waits() -> void:
	var c := _entered(MapNode.TYPE_SOUL)
	assert_eq(c.execute(ExpeditionCommand.choose_path(&"l2_n0")), ExpeditionController.REJECT_WRONG_PHASE)


# --- PassBy (E18) ----------------------------------------------------------------

func test_E18_pass_by_applies_the_safe_option_without_opening_the_event() -> void:
	var c := _entered(MapNode.TYPE_TEMPTATION)
	assert_eq(str(c.pass_by_option().get("id", "")), "follow_tracks", "primeira opção safe: true")
	assert_eq(c.execute(ExpeditionCommand.pass_by()), &"")
	assert_eq(c.state.light, 90, "−5 da entrada e −5 da opção segura")
	assert_eq(c.phase, ExpeditionController.Phase.AT_FORK)
	assert_null(c.event)
	var types: Array[String] = []
	for entry: Dictionary in c.command_log:
		types.append(str(entry["type"]))
	assert_eq(types, ["ChoosePath", "PassBy"] as Array[String], "um comando no log")


func test_pass_by_has_the_same_effect_as_choosing_the_safe_option() -> void:
	var by := _entered(MapNode.TYPE_TEMPTATION)
	by.execute(ExpeditionCommand.pass_by())
	var opened := _entered(MapNode.TYPE_TEMPTATION)
	opened.execute(ExpeditionCommand.engage_node())
	opened.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
	assert_eq(by.state.to_dict(), opened.state.to_dict())
	assert_eq(by.virtues.to_dict(), opened.virtues.to_dict())


func test_pass_by_is_only_for_a_temptation() -> void:
	for type: StringName in [MapNode.TYPE_RELIC, MapNode.TYPE_SOUL]:
		var c := _entered(type)
		assert_eq(c.execute(ExpeditionCommand.pass_by()), ExpeditionController.REJECT_CANNOT_PASS_BY, String(type))
		assert_eq(c.phase, ExpeditionController.Phase.PENDING)


func test_pending_content_replays_and_restores_exactly() -> void:
	var c := _entered(MapNode.TYPE_TEMPTATION)
	var replayed := ExpeditionController.replay(cat, c.initial_snapshot(), c.command_log)
	assert_eq(replayed.phase, ExpeditionController.Phase.PENDING)
	assert_eq(replayed.snapshot(), c.snapshot())


# --- save: corridor place and migration ----------------------------------------------

func test_E21_the_corridor_place_is_saved_outside_the_log() -> void:
	var store := SaveStore.new(DIR)
	store.delete_all()
	store.validator = func(data: Dictionary) -> bool: return ExpeditionSave.restore(cat, data) != null
	var c := _entered(MapNode.TYPE_TEMPTATION)
	assert_true(store.write(ExpeditionSave.build(c, 7, &"expedition", {"node": String(c.state.current_node), "x": CorridorWalk.CONTENT_AT})))
	var result: Dictionary = store.read()
	assert_eq(result["status"], SaveStore.STATUS_OK)
	var place: Dictionary = ExpeditionSave.corridor_place(result["data"])
	assert_eq(place["node"], String(c.state.current_node))
	assert_almost_eq(float(place["x"]), CorridorWalk.CONTENT_AT, 0.0001)
	var restored := ExpeditionSave.restore(cat, result["data"])
	assert_eq(restored.phase, ExpeditionController.Phase.PENDING)
	assert_eq(restored.command_log.size(), c.command_log.size(), "a posição não entra no log")


func test_a_missing_or_invalid_place_is_not_a_corrupt_save() -> void:
	assert_eq(ExpeditionSave.corridor_place({}), {})
	assert_eq(ExpeditionSave.corridor_place({"presentation": {"corridor_x": 3.0}}), {})
	assert_eq(ExpeditionSave.corridor_place({"presentation": "x"}), {})


func test_a_version_1_save_is_migrated_and_lands_on_the_same_point() -> void:
	var c := _new()
	var target: MapNode = c.entrances()[0]
	target.type = MapNode.TYPE_TEMPTATION
	c.state.map = c.map.to_dict()
	var start := ExpeditionController.from_snapshot(cat, c.snapshot())
	# What the M1 logged: ChoosePath opened the event at once.
	var old_commands: Array = [{"type": "ChoosePath", "node": String(target.id)}, {"type": "ChooseOption", "node": "follow_tracks"}]
	var now := ExpeditionController.replay(cat, start.initial_snapshot(), [old_commands[0], {"type": "EngageNode"}, old_commands[1]])
	var v1: Dictionary = {
		"save_version": 1,
		"expedition": {"initial": start.initial_snapshot(), "commands": old_commands, "check": ExpeditionSave._plain(now.snapshot())},
	}
	var migrated: Dictionary = SaveMigrations.new().migrate(v1)
	assert_eq(int(migrated["save_version"]), SaveMigrations.CURRENT_VERSION)
	var types: Array[String] = []
	for entry: Dictionary in migrated["expedition"]["commands"]:
		types.append(str(entry["type"]))
	assert_eq(types, ["ChoosePath", "EngageNode", "ChooseOption"] as Array[String])
	assert_not_null(ExpeditionSave.restore(cat, migrated), "reabre no mesmo ponto")


func test_the_migration_leaves_nodes_without_content_alone() -> void:
	var data: Dictionary = {"expedition": {"initial": {"expedition": {"map": {"layers": [[{"id": "l1_n0", "type": "node_camp"}]]}}}, "commands": [{"type": "ChoosePath", "node": "l1_n0"}]}}
	var out: Dictionary = SaveMigrations.migrate_v1_to_v2(data)
	assert_eq((out["expedition"]["commands"] as Array).size(), 1)
