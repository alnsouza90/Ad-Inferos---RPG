extends GutTest
## T49, D-511: the Map of Hell's rules: only Circle 2 open in the M2, the
## lantern and the pale light, and where an expedition can start.

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func test_eleven_bands_from_the_gate_of_hell_to_the_cocytus() -> void:
	assert_eq(HellMap.PLACES.size(), 11)
	assert_eq(HellMap.PLACES[0], &"gate_of_hell")
	assert_eq(HellMap.PLACES[10], &"circle_09")
	assert_eq(HellMap.circle_of(&"antehell"), 1, "o Antinferno é parte do Círculo 1 (D-459)")
	assert_eq(HellMap.circle_of(&"circle_07"), 7)


func test_only_circle_two_is_open_in_the_m2() -> void:
	var c := Campaign.start(cat, 1)
	for place: StringName in HellMap.PLACES:
		var expected: StringName = HellMap.OPEN if place == &"circle_02" else HellMap.LOCKED
		assert_eq(HellMap.state(c, cat, place), expected, String(place))


func test_a_circle_whose_boss_fell_is_completed() -> void:
	var c := Campaign.start(cat, 1)
	c.flags.append(&"circle_02_completed")
	assert_eq(HellMap.state(c, cat, &"circle_02"), HellMap.COMPLETED)


func test_the_lantern_hangs_at_the_deepest_open_band_and_the_pale_light_one_ahead() -> void:
	var c := Campaign.start(cat, 1)
	assert_eq(HellMap.lantern_band(c, cat), HellMap.PLACES.find(&"circle_02"))
	assert_eq(HellMap.pale_light_band(c, cat), HellMap.PLACES.find(&"circle_03"))


func test_start_points_are_the_gate_and_each_consecrated_camp() -> void:
	var c := Campaign.start(cat, 1)
	assert_eq(HellMap.start_points(c, cat, &"circle_02"), [0] as Array[int])
	c.flags.append(ExpeditionController.consecrated_flag(&"circle_02", 1))
	assert_eq(HellMap.start_points(c, cat, &"circle_02"), [0, 1] as Array[int])
	assert_true(HellMap.start_points(c, cat, &"circle_03").is_empty(), "fechado não tem partida")
	assert_eq(HellMap.camps(), [1, 2] as Array[int])
