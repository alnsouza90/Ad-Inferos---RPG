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
	var points: PackedVector2Array = VillageLayout.outline(id)
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
	for id: StringName in VillageLayout.OUTLINES:
		assert_eq(VillageLayout.building_at(_centre(id)), id)
		assert_true(data.ui.has_text(StringName("building_%s" % id)), String(id))


func test_the_sky_and_the_scenery_house_are_not_buildings() -> void:
	assert_eq(VillageLayout.building_at(Vector2(800, 100)), &"", "o céu")
	assert_eq(VillageLayout.building_at(Vector2(355, 365)), &"", "a casa 7 é só cenário (D-492)")


func test_an_open_building_is_chosen_and_a_closed_one_only_says_so() -> void:
	var v := _screen()
	watch_signals(v)
	v.tap_at(_centre(&"pantry"))
	assert_signal_emitted_with_parameters(v, "building_chosen", [&"pantry"])
	assert_eq(v.name_shown(), data.ui.text(&"building_pantry"))
	v.tap_at(_centre(&"library"))
	assert_signal_emit_count(v, "building_chosen", 1)
	assert_string_contains(v.name_shown(), data.ui.text(&"building_closed"))


func test_the_closed_buildings_of_the_m2_are_darkened() -> void:
	var v := _screen()
	for id: StringName in VillageLayout.OUTLINES:
		assert_eq(v.closed_shown().has(id), not Campaign.M2_FACILITIES.has(id), String(id))


func test_night_in_advent_and_lent_day_otherwise() -> void:
	var starts: Array[float] = cat.economy.get_list(&"season_start_weeks")
	assert_eq(LiturgicalCalendar.season(1, cat.economy), &"advent")
	assert_eq(LiturgicalCalendar.season(int(starts[3]), cat.economy), &"lent")
	assert_eq(LiturgicalCalendar.season(int(starts[3]) - 1, cat.economy), &"ordinary_1")
	assert_eq(_screen(1).night_amount(), 1.0)
	assert_eq(_screen(int(starts[3])).night_amount(), 1.0)
	assert_eq(_screen(int(starts[2])).night_amount(), 0.0)
	assert_string_contains(_screen(1).week_shown(), data.ui.text(&"season_advent"))
