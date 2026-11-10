extends GutTest
## D-233: the animation of an action comes from its data: a blow (strike)
## slides to the target, a spiritual action is cast from afar, a support
## action with no damage is a blessing.

var catalog: BattleCatalog


func before_all() -> void:
	catalog = RealData.catalog()


func _style(ability_id: StringName) -> StringName:
	var a: AbilityDef = catalog.ability(ability_id)
	return AnimationStyle.of(a.effects, a.targeting)


func test_a_spear_thrust_is_physical() -> void:
	assert_eq(_style(&"george_spear_thrust"), AnimationStyle.PHYSICAL)


func test_an_exorcism_is_spiritual() -> void:
	assert_eq(_style(&"benedict_cross_medal"), AnimationStyle.SPIRITUAL)
	assert_eq(_style(&"therese_ardent_prayer"), AnimationStyle.SPIRITUAL)


func test_healing_an_ally_is_a_blessing() -> void:
	assert_eq(_style(&"therese_petal"), AnimationStyle.BLESSING)
	assert_eq(_style(&"therese_shower_of_roses"), AnimationStyle.BLESSING)


func test_every_saint_ability_gets_a_style() -> void:
	for id: StringName in catalog.abilities.keys():
		assert_true([AnimationStyle.PHYSICAL, AnimationStyle.SPIRITUAL, AnimationStyle.BLESSING].has(_style(id)), String(id))
