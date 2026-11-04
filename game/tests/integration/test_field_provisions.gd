extends GutTest
## T22: provisions outside battle and the starting kit (expedition §5,
## D-123, D-129, D-136, D-137), with the real M0 data.

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(seed: int = 1) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


func _count(list: Array[StringName], id: StringName) -> int:
	return list.count(id)


func test_m1_kit_has_at_least_one_of_each_provision_and_fits_the_pack() -> void:
	var kit: Array[StringName] = cat.kit_provisions(&"m1_kit")
	assert_eq(kit.size(), 7)
	for id: StringName in [&"bread", &"candle", &"holy_water", &"bandages", &"incense"]:
		assert_gt(_count(kit, id), 0, "kit sem %s" % id)
	assert_eq(_count(kit, &"bread"), 2)
	assert_eq(_count(kit, &"holy_water"), 2)
	var ctrl := _new()
	assert_eq(ctrl.state.provisions, kit)


func test_E04_ninth_provision_with_gate_level_1_is_refused() -> void:
	var state := ExpeditionState.create(cat.constants, &"circle_02", 1, RealData.m0_party_ids())
	for i: int in 8:
		assert_true(state.add_provision(&"bread", cat.constants), "item %d" % (i + 1))
	assert_false(state.add_provision(&"bread", cat.constants), "9º item")
	assert_eq(state.provisions.size(), 8)


func test_candle_adds_25_light_and_is_consumed() -> void:
	var ctrl := _new()
	ctrl.state.light = 60
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"candle")), &"")
	assert_eq(ctrl.state.light, 85)
	assert_eq(_count(ctrl.state.provisions, &"candle"), 0)


func test_holy_water_lowers_one_saints_desolation_by_15() -> void:
	var ctrl := _new()
	ctrl.saints[&"saint_benedict"].desolation = 40
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"holy_water", &"saint_benedict")), &"")
	assert_eq(ctrl.saints[&"saint_benedict"].desolation, 25)
	assert_eq(_count(ctrl.state.provisions, &"holy_water"), 1)


func test_holy_water_can_purify_a_saint_in_dark_night() -> void:
	var ctrl := _new()
	var status: SaintStatus = ctrl.saints[&"saint_george"]
	status.desolation = 60
	status.spirit_state = &"dark_night"
	ctrl.execute(ExpeditionCommand.use_provision(&"holy_water", &"saint_george"))
	assert_eq(status.desolation, 45)
	assert_eq(status.spirit_state, &"normal")
	assert_true(status.purified)


func test_holy_water_needs_a_target_saint() -> void:
	var ctrl := _new()
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"holy_water")), FieldProvisions.REJECT_NEEDS_TARGET)


func test_D136_bandages_and_bread_are_not_usable_outside_battle() -> void:
	var ctrl := _new()
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"bandages", &"saint_george")), FieldProvisions.REJECT_NOT_USABLE_HERE)
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"bread", &"saint_george")), FieldProvisions.REJECT_NOT_USABLE_HERE)
	assert_eq(ctrl.state.provisions.size(), 7)
	assert_eq(ctrl.command_log.size(), 0)


func test_provision_not_carried_is_refused() -> void:
	var ctrl := _new()
	ctrl.state.provisions.erase(&"candle")
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"candle")), FieldProvisions.REJECT_NOT_CARRIED)


func test_field_provisions_only_at_a_bifurcation() -> void:
	var ctrl := _new()
	ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"candle")), ExpeditionController.REJECT_WRONG_PHASE)


func test_E14_incense_with_gate_1_reveals_the_nodes_after_the_entrances() -> void:
	var ctrl := _new()
	var layer2: Array[MapNode] = ctrl.map.layer_nodes(2)
	for n: MapNode in layer2:
		assert_false(ctrl.content_visible(n), "camada 2 escondida antes do Incenso")
	assert_eq(ctrl.execute(ExpeditionCommand.use_provision(&"incense")), &"")
	for n: MapNode in layer2:
		assert_true(ctrl.content_visible(n), "camada 2 revelada pelo Incenso")
	assert_false(ctrl.content_visible(ctrl.map.node(3, 0)))
	assert_eq(_count(ctrl.state.provisions, &"incense"), 0)


func test_D137_what_incense_revealed_stays_known_after_moving_on() -> void:
	var ctrl := _new()
	ctrl.execute(ExpeditionCommand.use_provision(&"incense"))
	var revealed: Array[StringName] = ctrl.state.revealed_nodes.duplicate()
	assert_false(revealed.is_empty())
	var first: MapNode = ctrl.entrances()[0]
	ctrl.execute(ExpeditionCommand.choose_path(first.id))
	assert_eq(ctrl.state.revealed_nodes, revealed)
	for id: StringName in revealed:
		assert_true(ctrl.content_visible(ctrl.map.find(id)))


func test_field_provision_uses_are_logged_and_replay_exactly() -> void:
	var ctrl := _new(3)
	ctrl.execute(ExpeditionCommand.use_provision(&"candle"))
	ctrl.execute(ExpeditionCommand.use_provision(&"incense"))
	assert_eq(ctrl.command_log.size(), 2)
	var again := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
	assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(ctrl.snapshot()))
