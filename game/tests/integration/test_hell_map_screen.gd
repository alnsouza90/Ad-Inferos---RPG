extends GutTest
## T49, D-511: the Map of Hell screen: Alan's bands and medallions, the
## locked places, the trail of Circle 2 and the choice of the start point.

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _screen(c: CampaignState = null) -> HellMapScreen:
	if c == null:
		c = Campaign.start(cat, 1)
	var m := HellMapScreen.new()
	m.setup(data, cat, c)
	add_child_autofree(m)
	return m


func test_every_band_has_its_art_medallion_and_name() -> void:
	for i: int in HellMap.PLACES.size():
		assert_true(ResourceLoader.exists(HellMapScreen.BAND_PATH % i), "faixa %d" % i)
		assert_true(ResourceLoader.exists(HellMapScreen.MEDALLION_PATH % i), "medalhão %d" % i)
		assert_true(data.ui.has_text(StringName("map_place_%s" % HellMap.PLACES[i])), "nome %d" % i)
	assert_eq(HellMapScreen.MEDALLION_CENTRES.size(), HellMap.PLACES.size())
	for kind: String in ["gate", "camp", "boss"]:
		assert_true(ResourceLoader.exists(HellMapScreen.POINT_PATH % kind), kind)
	assert_true(ResourceLoader.exists(HellMapScreen.CHAIN_PATH))


func test_the_gate_of_circle_two_starts_an_expedition() -> void:
	var m := _screen()
	watch_signals(m)
	m.tap_point(&"circle_02", 0)
	assert_eq(m.plate_shown(), m.point_text(&"circle_02", 0))
	m.depart_here()
	assert_signal_emitted_with_parameters(m, "start_chosen", [&"circle_02", 0])


func test_a_camp_not_consecrated_only_says_so() -> void:
	var m := _screen()
	watch_signals(m)
	m.tap_point(&"circle_02", 1)
	assert_string_contains(m.plate_shown(), data.ui.text(&"map_camp_not_consecrated", {"camp": 1}))
	m.depart_here()
	assert_signal_not_emitted(m, "start_chosen")


func test_a_consecrated_camp_starts_there() -> void:
	var c := Campaign.start(cat, 1)
	c.flags.append(ExpeditionController.consecrated_flag(&"circle_02", 1))
	var m := _screen(c)
	watch_signals(m)
	m.tap_point(&"circle_02", 1)
	m.depart_here()
	assert_signal_emitted_with_parameters(m, "start_chosen", [&"circle_02", 1])


func test_a_locked_place_tells_why() -> void:
	var m := _screen()
	m.tap_medallion(&"circle_01")
	assert_string_contains(m.plate_shown(), data.ui.text(&"map_locked"))


func test_back_goes_to_the_gate() -> void:
	var m := _screen()
	watch_signals(m)
	m.press_back()
	assert_signal_emitted(m, "back_pressed")


func test_the_first_visit_brings_the_lantern_down_from_the_gate_of_hell_once() -> void:
	var c := Campaign.start(cat, 1)
	assert_eq(c.map_lantern_band, -1)
	var m := _screen(c)
	await wait_process_frames(1)
	assert_true(m.descending, "a lanterna desce na primeira vez")
	assert_eq(m.lantern_shown_band, HellMap.lantern_band(c, cat))
	assert_eq(c.map_lantern_band, HellMap.lantern_band(c, cat), "lembrada na campanha")
	var again := _screen(c)
	await wait_process_frames(1)
	assert_false(again.descending, "da segunda vez ela já está lá")


func test_the_lantern_band_is_kept_in_the_save() -> void:
	var c := Campaign.start(cat, 1)
	c.map_lantern_band = 3
	assert_eq(CampaignState.from_dict(JSON.parse_string(JSON.stringify(c.to_dict()))).map_lantern_band, 3)
	assert_eq(CampaignState.from_dict({}).map_lantern_band, -1, "save antigo: nunca aberto")
