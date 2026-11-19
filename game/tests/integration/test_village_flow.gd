extends GutTest
## T49, D-514: the campaign's cycle on screen: village → building → Gate's
## "Partir" → Map of Hell → expedition → back to the village, the week
## turned; and the village saved and loaded with no expedition.

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _flow() -> VillageFlow:
	var flow := VillageFlow.new()
	flow.use_game_state = false
	flow.speed_index = BattleScreen.SPEED_INSTANT
	flow.setup(data, cat, Campaign.start(cat, 7))
	add_child_autofree(flow)
	return flow


func test_it_opens_on_the_village_and_a_building_opens_and_closes() -> void:
	var flow := _flow()
	assert_true(flow.screen is VillageScreen)
	(flow.screen as VillageScreen).building_chosen.emit(&"pantry")
	assert_true(flow.screen is BuildingScreen)
	(flow.screen as BuildingScreen).press_back()
	assert_true(flow.screen is VillageScreen)


func test_the_gate_opens_the_map_and_the_map_starts_the_expedition() -> void:
	var flow := _flow()
	flow.open_building(&"gate")
	var gate: BuildingScreen = flow.screen
	assert_eq(gate.depart(), &"")
	assert_true(flow.screen is HellMapScreen)
	assert_eq(flow.party, gate.party_ids())
	var map: HellMapScreen = flow.screen
	map.tap_point(&"circle_02", 0)
	map.depart_here()
	assert_true(flow.screen is LegScreen, "a expedição começa")
	assert_eq((flow.screen as LegScreen).ctrl.state.party, flow.party)
	assert_eq((flow.screen as LegScreen).ctrl.state.circle, &"circle_02")


func test_the_map_goes_back_to_the_gate() -> void:
	var flow := _flow()
	flow.open_map(RealData.m0_party_ids())
	(flow.screen as HellMapScreen).press_back()
	assert_true(flow.screen is BuildingScreen)
	assert_eq((flow.screen as BuildingScreen).building, &"gate")


func test_the_end_of_the_expedition_comes_back_to_the_village_a_week_later() -> void:
	var flow := _flow()
	var week: int = flow.campaign.week
	flow.open_map(RealData.m0_party_ids())
	flow.start_expedition(&"circle_02", 0)
	var leg: LegScreen = flow.screen
	leg.press_title()
	assert_true(flow.screen is VillageScreen)
	assert_eq(flow.campaign.week, week + 1, "a semana virou")


func test_a_refused_departure_stays_on_the_map_with_its_reason() -> void:
	var flow := _flow()
	flow.open_map([&"saint_george"] as Array[StringName])
	flow.start_expedition(&"circle_02", 0)
	assert_true(flow.screen is HellMapScreen)
	assert_eq(flow.last_refusal, Campaign.WRONG_PARTY)


func test_a_village_save_has_no_expedition_and_reads_back() -> void:
	var c := Campaign.start(cat, 7)
	c.alms = 123
	var saved: Dictionary = ExpeditionSave.build_village(c)
	assert_true(ExpeditionSave.is_village(saved))
	assert_null(ExpeditionSave.restore(cat, saved))
	var back := ExpeditionSave.campaign_of(cat, JSON.parse_string(JSON.stringify(saved)))
	assert_eq(back.alms, 123)
	assert_eq(back.week, c.week)


func test_the_save_service_writes_and_reads_the_village() -> void:
	var service: Node = (load("res://autoload/save_service.gd") as GDScript).new()
	service.set("store", SaveStore.new("user://test_village_flow"))
	(service.get("store") as SaveStore).delete_all()
	add_child_autofree(service)
	var c := Campaign.start(cat, 9)
	c.alms = 77
	assert_true(service.call("save_village", c))
	var result: Dictionary = service.call("load_expedition", cat)
	assert_eq(result["status"], SaveStore.STATUS_OK, "a vila sem expedição é um save válido")
	assert_null(result["controller"])
	assert_eq(ExpeditionSave.campaign_of(cat, result["data"]).alms, 77)
	(service.get("store") as SaveStore).delete_all()
