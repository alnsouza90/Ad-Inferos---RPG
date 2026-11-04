extends GutTest
## T19: Light (expedition §4). Numbers come from the fixture constants
## (start 100, resume 75, −5 per node, candle +25, high ≥ 75, low ≤ 24).

var k: ConstantsDef


func before_each() -> void:
	k = CombatFixture.constants()


func _party() -> Array[StringName]:
	var p: Array[StringName] = [&"saint_a", &"saint_b", &"saint_c"]
	return p


func test_E02_eleven_nodes_without_candle_reach_the_boss_with_45() -> void:
	var e := ExpeditionState.create(k, &"circle_02", 1, _party())
	for i: int in 11:
		e.enter_node(StringName("n%d" % i), k)
	assert_eq(e.light, 45)


func test_E03_resume_from_consecrated_camp_starts_with_75() -> void:
	var e := ExpeditionState.create_resumed(k, &"circle_02", 1, _party())
	assert_eq(e.light, 75)


func test_new_expedition_starts_with_full_light() -> void:
	assert_eq(ExpeditionState.create(k, &"circle_02", 1, _party()).light, 100)


func test_light_never_goes_below_zero() -> void:
	assert_eq(ExpeditionLight.after_entering_node(3, k), 0)


func test_candle_adds_25_up_to_100() -> void:
	assert_eq(ExpeditionLight.after_candle(50, k), 75)
	assert_eq(ExpeditionLight.after_candle(90, k), 100)


func test_entering_a_node_records_the_previous_one_as_visited() -> void:
	var e := ExpeditionState.create(k, &"circle_02", 1, _party())
	e.enter_node(&"l1_n0", k)
	e.enter_node(&"l2_n1", k)
	assert_eq(e.current_node, &"l2_n1")
	assert_eq(e.visited, [&"l1_n0"] as Array[StringName])


func test_high_band_from_75_to_100() -> void:
	assert_eq(ExpeditionLight.band(75, k), ExpeditionLight.BAND_HIGH)
	assert_eq(ExpeditionLight.band(100, k), ExpeditionLight.BAND_HIGH)
	assert_almost_eq(ExpeditionLight.desolation_multiplier(80, k), 0.8, 0.0001)
	assert_almost_eq(ExpeditionLight.ambush_multiplier(80, k), 0.5, 0.0001)
	assert_almost_eq(ExpeditionLight.enemy_damage_multiplier(80, k), 1.0, 0.0001)
	assert_almost_eq(ExpeditionLight.alms_multiplier(80, k), 1.0, 0.0001)


func test_neutral_band_from_25_to_74() -> void:
	for light: int in [25, 50, 74]:
		assert_eq(ExpeditionLight.band(light, k), ExpeditionLight.BAND_NEUTRAL, "Lume %d" % light)
		assert_almost_eq(ExpeditionLight.desolation_multiplier(light, k), 1.0, 0.0001)
		assert_almost_eq(ExpeditionLight.ambush_multiplier(light, k), 1.0, 0.0001)
		assert_almost_eq(ExpeditionLight.enemy_damage_multiplier(light, k), 1.0, 0.0001)
		assert_almost_eq(ExpeditionLight.alms_multiplier(light, k), 1.0, 0.0001)


func test_low_band_from_0_to_24() -> void:
	for light: int in [0, 24]:
		assert_eq(ExpeditionLight.band(light, k), ExpeditionLight.BAND_LOW, "Lume %d" % light)
		assert_almost_eq(ExpeditionLight.desolation_multiplier(light, k), 1.3, 0.0001)
		assert_almost_eq(ExpeditionLight.enemy_damage_multiplier(light, k), 1.1, 0.0001)
		assert_almost_eq(ExpeditionLight.alms_multiplier(light, k), 1.5, 0.0001)
		assert_almost_eq(ExpeditionLight.ambush_multiplier(light, k), 1.0, 0.0001)


func test_outside_an_expedition_every_band_effect_is_neutral() -> void:
	assert_eq(ExpeditionLight.band(ExpeditionLight.NONE, k), ExpeditionLight.BAND_NEUTRAL)
	assert_almost_eq(ExpeditionLight.desolation_multiplier(ExpeditionLight.NONE, k), 1.0, 0.0001)
	assert_almost_eq(ExpeditionLight.enemy_damage_multiplier(ExpeditionLight.NONE, k), 1.0, 0.0001)


func test_state_survives_a_json_round_trip() -> void:
	var e := ExpeditionState.create(k, &"circle_02", 99, _party(), [&"bread", &"candle"] as Array[StringName])
	e.enter_node(&"l1_n0", k)
	e.enter_node(&"l1_n2", k)
	e.alms_unbanked = 140
	e.fallen_once.append(&"saint_b")
	var text: String = JSON.stringify(e.to_dict())
	var back := ExpeditionState.from_dict(JSON.parse_string(text))
	assert_eq(JSON.stringify(back.to_dict()), text)
	assert_eq(back.light, 90)
	assert_eq(back.provisions, [&"bread", &"candle"] as Array[StringName])
