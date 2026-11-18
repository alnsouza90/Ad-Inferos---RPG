extends GutTest
## T49, D-492: the village is Alan's picture with the engine on top: touch
## per building, closed ones darkened, night in Advent and Lent.

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _screen(week: int = 5) -> VillageScreen:
	var c := Campaign.start(cat, 1)
	c.week = week
	var v := VillageScreen.new()
	v.setup(data, c, cat.economy)
	add_child_autofree(v)
	return v


## A point inside the outline: the centre of its largest triangle (some
## outlines, like the cathedral's spires, are not convex).
func _centre(id: StringName) -> Vector2:
	var points: PackedVector2Array = VillageLayout.area(id)
	var tris: PackedInt32Array = Geometry2D.triangulate_polygon(points)
	var best := Vector2.ZERO
	var best_area: float = -1.0
	for i: int in range(0, tris.size(), 3):
		var a: Vector2 = points[tris[i]]
		var b: Vector2 = points[tris[i + 1]]
		var c: Vector2 = points[tris[i + 2]]
		var area: float = absf((b - a).cross(c - a))
		if area > best_area:
			best_area = area
			best = (a + b + c) / 3.0
	return best


func test_every_outline_is_found_by_its_centre_and_has_a_name() -> void:
	for id: StringName in VillageLayout.AREAS:
		assert_eq(VillageLayout.building_at(_centre(id)), id)
		assert_true(data.ui.has_text(StringName("building_%s" % id)), String(id))


func test_the_sky_and_the_scenery_house_are_not_buildings() -> void:
	assert_eq(VillageLayout.building_at(Vector2(800, 100)), &"", "o céu")
	assert_eq(VillageLayout.building_at(Vector2(480, 470)), &"", "a praça com Nossa Senhora é só cenário")


func test_an_open_building_is_chosen_and_a_closed_one_only_says_so() -> void:
	var v := _screen()
	watch_signals(v)
	v.tap_at(_centre(&"pantry"))
	assert_signal_emitted_with_parameters(v, "building_chosen", [&"pantry"])
	assert_eq(v.name_shown(), data.ui.text(&"building_pantry"))
	v.tap_at(_centre(&"library"))
	assert_signal_emit_count(v, "building_chosen", 1)
	assert_string_contains(v.name_shown(), data.ui.text(&"building_closed"))


func test_closed_buildings_only_say_so_when_touched() -> void:
	# D-494: nothing is darkened; a closed building shows it on the touch.
	var v := _screen()
	for id: StringName in VillageLayout.AREAS:
		v.tap_at(_centre(id))
		assert_eq(v.name_shown().contains(data.ui.text(&"building_closed")), not Campaign.M2_FACILITIES.has(id), String(id))


func test_a_touch_lights_only_that_outline() -> void:
	# D-495: Alan's outline of the touched building, and only that one.
	var v := _screen()
	assert_eq(v.outline_shown(), &"")
	v.tap_at(_centre(&"gate"))
	assert_eq(v.outline_shown(), &"gate")
	v.tap_at(_centre(&"library"))
	assert_eq(v.outline_shown(), &"library")


func test_every_building_has_its_outline() -> void:
	for id: StringName in VillageLayout.AREAS:
		assert_true(ResourceLoader.exists(VillageLayout.OUTLINE_PATH % id), String(id))


func test_the_sky_drifts_and_wraps() -> void:
	var v := _screen()
	var before: float = v.sky_x()
	v.drift_sky(1.0)
	assert_lt(v.sky_x(), before)
	for i: int in 2000:
		v.drift_sky(1.0)
	assert_gt(v.sky_x(), -2000.0, "o céu dá a volta sem sair da tela")


func test_grey_sky_in_advent_and_lent_clear_otherwise() -> void:
	# D-495: in Advent and Lent the sky turns grey and the light misty.
	var starts: Array[float] = cat.economy.get_list(&"season_start_weeks")
	assert_eq(LiturgicalCalendar.season(1, cat.economy), &"advent")
	assert_eq(LiturgicalCalendar.season(int(starts[3]), cat.economy), &"lent")
	assert_eq(LiturgicalCalendar.season(int(starts[3]) - 1, cat.economy), &"ordinary_1")
	assert_gt(_screen(1).grey_amount(), 0.0)
	assert_gt(_screen(int(starts[3])).grey_amount(), 0.0)
	assert_eq(_screen(int(starts[2])).grey_amount(), 0.0)
	assert_string_contains(_screen(1).week_shown(), data.ui.text(&"season_advent"))
