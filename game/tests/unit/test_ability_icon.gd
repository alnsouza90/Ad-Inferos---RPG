extends GutTest
## T44 (D-436 to D-438): each ability shows the mosaic of its main effect.

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _kind(id: StringName) -> StringName:
	return AbilityIcon.of(data.catalog.ability(id))


func test_the_three_saints_get_the_mosaic_of_their_main_effect() -> void:
	assert_eq(_kind(&"george_spear_thrust"), AbilityIcon.STRIKE)
	assert_eq(_kind(&"george_raised_shield"), AbilityIcon.WARD)
	assert_eq(_kind(&"george_formal_challenge"), AbilityIcon.STRENGTH, "o Duelo não tem mosaico; vale a Força que vem depois")
	assert_eq(_kind(&"benedict_cross_medal"), AbilityIcon.EXORCISM)
	assert_eq(_kind(&"benedict_ora_et_labora"), AbilityIcon.RELIEF)
	assert_eq(_kind(&"benedict_broken_cup"), AbilityIcon.STRIP)
	assert_eq(_kind(&"benedict_vade_retro"), AbilityIcon.EXORCISM)
	assert_eq(_kind(&"therese_petal"), AbilityIcon.HEAL)
	assert_eq(_kind(&"therese_trust"), AbilityIcon.RELIEF)
	assert_eq(_kind(&"therese_abandonment"), AbilityIcon.RAISE)


func test_every_ability_has_its_lancet_in_three_states() -> void:
	for id: StringName in data.catalog.abilities:
		var kind: StringName = _kind(id)
		for state: String in ["on", "chosen", "off"]:
			assert_not_null(AbilityIcon.lancet(kind, state), "%s: %s %s" % [id, kind, state])


func test_the_three_saints_have_the_rose_of_their_miracle() -> void:
	for id: StringName in [&"saint_george", &"saint_benedict", &"saint_therese"]:
		assert_not_null(AbilityIcon.rose(id, "on"), String(id))
		assert_not_null(AbilityIcon.rose(id, "off"), String(id))
