extends GutTest
## T50, D-464: the saint's card shows the portrait, the name, the feast, the
## life and the sheet of play, every text from the data, and no source.

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _card(saint_id: StringName) -> SaintCard:
	var card := SaintCard.new()
	card.setup(data, saint_id)
	add_child_autofree(card)
	return card


func test_the_card_of_george_shows_his_whole_sheet() -> void:
	var card := _card(&"saint_george")
	var george: SaintDef = data.saints[&"saint_george"]
	assert_eq(card.name_shown(), george.name_pt)
	assert_eq(card.feast_shown(), data.ui.text(&"saint_card_feast", {"date": data.ui.text(&"saint_feast_saint_george")}))
	assert_eq(card.bio_shown(), data.ui.text(&"saint_bio_saint_george"))
	assert_string_contains(card.stats_shown(), str(george.max_hp))
	assert_string_contains(card.trait_shown(), george.trait_def.name_pt)
	assert_string_contains(card.trait_shown(), george.trait_def.desc_pt)
	assert_eq(card.abilities_shown().size(), george.abilities.size())
	for i: int in george.abilities.size():
		var ability: AbilityDef = data.catalog.abilities[george.abilities[i]]
		assert_string_contains(card.abilities_shown()[i], ability.name_pt)
		assert_string_contains(card.abilities_shown()[i], ability.desc_pt)
	assert_string_contains(card.miracle_shown(), data.catalog.abilities[george.miracle].name_pt)
	assert_not_null(card.portrait_texture(), "o mesmo retrato da luta (D-442)")


func test_every_saint_has_its_life_and_feast() -> void:
	for saint_id: StringName in [&"saint_george", &"saint_benedict", &"saint_therese", &"saint_anthony_abbot"]:
		assert_true(data.ui.has_text(StringName("saint_bio_%s" % saint_id)), String(saint_id))
		assert_true(data.ui.has_text(StringName("saint_feast_%s" % saint_id)), String(saint_id))


func test_the_card_names_no_source() -> void:
	# The origin of each fact stays in the Martyrology (D-465).
	var card := _card(&"saint_george")
	for shown: String in [card.bio_shown(), card.trait_shown(), card.miracle_shown()]:
		assert_false(shown.contains("Legenda Áurea"))
		assert_false(shown.contains("Diálogos"))


func test_the_faces_are_cut_in_the_proportion_of_the_window() -> void:
	# D-467: each face is framed so that all show the same size.
	var window: Vector2 = BattleScreen.PORTRAIT_WINDOW.size
	for saint_id: StringName in SaintCard.FACE_REGIONS:
		var region: Rect2 = SaintCard.FACE_REGIONS[saint_id]
		assert_almost_eq(region.size.x / region.size.y, window.x / window.y, 0.01, String(saint_id))


func test_closing_the_card() -> void:
	var card := _card(&"saint_george")
	watch_signals(card)
	card.press_close()
	assert_signal_emitted(card, "closed")


func test_every_card_fits_the_screen() -> void:
	for saint_id: StringName in [&"saint_george", &"saint_benedict", &"saint_therese", &"saint_anthony_abbot"]:
		var card := _card(saint_id)
		await wait_process_frames(3)
		assert_lte(card.column_bottom(), SaintCard.PLATE_RECT.end.y - 6.0, String(saint_id))


const CARD_SAINTS: Array[StringName] = [&"saint_george", &"saint_benedict", &"saint_therese", &"saint_anthony_abbot"]


func test_every_ability_has_a_whole_rule_line_from_its_data() -> void:
	# D-475: the numbers of the card are the battle's own, and no key is missing.
	for saint_id: StringName in CARD_SAINTS:
		var saint: SaintDef = data.saints[saint_id]
		for ability_id: StringName in saint.abilities + [saint.miracle]:
			var ability: AbilityDef = data.catalog.abilities[ability_id]
			var rule: String = AbilityRule.line(ability, data.ui, data.catalog)
			assert_false(rule.contains("["), "%s: %s" % [ability_id, rule])
			for effect: EffectDef in ability.effects:
				if effect.type == &"damage" or effect.type == &"heal" or effect.type == &"desolation":
					assert_string_contains(rule, str(roundi(absf(effect.amount))), String(ability_id))
				if effect.type == &"apply_condition":
					assert_string_contains(rule, (data.catalog.conditions[effect.condition_id] as ConditionDef).name_pt, String(ability_id))


func test_the_rule_says_whom_and_from_where() -> void:
	var spear: AbilityDef = data.catalog.abilities[&"george_spear_thrust"]
	var rule: String = AbilityRule.line(spear, data.ui, data.catalog)
	assert_string_contains(rule, data.ui.text(&"rule_target_enemy", {"where": data.ui.text(&"rule_where_many", {"list": data.ui.text(&"rule_pair", {"a": 1, "b": 2})})}))
	assert_string_contains(rule, data.ui.text(&"rule_from_many", {"list": data.ui.text(&"rule_pair", {"a": 1, "b": 2})}))


func test_the_abilities_show_rule_and_story() -> void:
	var card := _card(&"saint_anthony_abbot")
	var cross: AbilityDef = data.catalog.abilities[&"antony_sign_of_cross"]
	assert_string_contains(card.abilities_shown()[0], AbilityRule.line(cross, data.ui, data.catalog))
	assert_string_contains(card.abilities_shown()[0], cross.desc_pt)


func test_the_card_opens_on_the_life_and_turns_to_the_abilities() -> void:
	var card := _card(&"saint_george")
	assert_eq(card.page_index, 0)
	card.show_page(1)
	assert_eq(card.page_index, 1)
