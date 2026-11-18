extends GutTest
## GDD §3, combat.md §2, D-477: a saint takes [equipped_abilities] of the
## abilities it knows into battle, at least one costing nothing.

var data: GameData
var george: SaintDef
var constants: ConstantsDef


func before_all() -> void:
	data = RealData.game_data()
	george = data.saints[&"saint_george"]
	constants = data.catalog.constants


func test_the_default_loadout_goes_into_battle() -> void:
	assert_eq(AbilityLoadout.refusal(george, george.default_equipped, data.catalog.abilities, constants), AbilityLoadout.OK)


func test_one_too_few_is_incomplete() -> void:
	var fewer: Array[StringName] = george.default_equipped.duplicate()
	fewer.pop_back()
	assert_eq(AbilityLoadout.refusal(george, fewer, data.catalog.abilities, constants), AbilityLoadout.INCOMPLETE)


func test_no_free_ability_is_refused() -> void:
	# No saint of the M2 knows four costly abilities, so a made-up one does.
	var costly: Array[StringName] = []
	for id: StringName in data.catalog.abilities:
		var ability: AbilityDef = data.catalog.abilities[id]
		if ability.cost > 0 and ability.kind != &"miracle" and costly.size() < constants.get_int(&"equipped_abilities"):
			costly.append(id)
	var made_up := SaintDef.new()
	made_up.abilities = costly
	assert_eq(AbilityLoadout.refusal(made_up, costly, data.catalog.abilities, constants), AbilityLoadout.NEEDS_FREE)


func test_a_fifth_is_refused_and_toggle_keeps_the_list_order() -> void:
	var extra: StringName = &""
	for id: StringName in george.abilities:
		if not george.default_equipped.has(id):
			extra = id
	assert_eq(AbilityLoadout.add_refusal(george, george.default_equipped, extra, constants), AbilityLoadout.FULL)
	assert_eq(AbilityLoadout.toggle(george, george.default_equipped, extra, constants), george.default_equipped)
	var without: Array[StringName] = AbilityLoadout.toggle(george, george.default_equipped, george.default_equipped[0], constants)
	var back: Array[StringName] = AbilityLoadout.toggle(george, without, george.default_equipped[0], constants)
	assert_eq(back, george.default_equipped, "volta na ordem da lista do santo")


func test_an_ability_of_another_saint_is_unknown() -> void:
	assert_eq(AbilityLoadout.add_refusal(george, [] as Array[StringName], &"therese_petal", constants), AbilityLoadout.UNKNOWN)
