extends GutTest
## T50, D-464, D-477: the saint's sheet (model B). The life page shows the
## feast and the life; the sheet page the stained glass of the abilities with
## the rule of the chosen one, position and target, attributes, the camp
## activity and the relics. Two touches on a stained glass take it into
## battle or leave it in the village.

const CARD_SAINTS: Array[StringName] = [&"saint_george", &"saint_benedict", &"saint_therese", &"saint_anthony_abbot"]

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _card(saint_id: StringName, equipped: Array[StringName] = [], relics: Array = [], level: int = 1) -> SaintCard:
	var card := SaintCard.new()
	card.setup(data, saint_id, equipped, relics, level)
	add_child_autofree(card)
	return card


func test_the_card_of_george_shows_his_life_and_sheet() -> void:
	var card := _card(&"saint_george")
	var george: SaintDef = data.saints[&"saint_george"]
	assert_eq(card.name_shown(), george.name_pt)
	assert_eq(card.epithet_shown(), data.ui.text(&"saint_epithet_saint_george"))
	assert_eq(card.feast_shown(), data.ui.text(&"saint_card_feast", {"date": data.ui.text(&"saint_feast_saint_george")}))
	assert_eq(card.bio_shown(), data.ui.text(&"saint_bio_saint_george"))
	assert_string_contains(card.stats_shown(), str(george.max_hp))
	assert_string_contains(card.trait_shown(), george.trait_def.name_pt)
	assert_string_contains(card.trait_shown(), george.trait_def.desc_pt)
	assert_eq(card.camp_shown(), george.camp_skill.name_pt)
	assert_not_null(card.portrait_texture(), "o mesmo retrato da luta (D-442)")


func test_every_saint_has_its_life_feast_and_roles() -> void:
	for saint_id: StringName in CARD_SAINTS:
		for key: String in ["saint_bio_%s", "saint_feast_%s", "saint_roles_%s"]:
			assert_true(data.ui.has_text(StringName(key % saint_id)), key % saint_id)


func test_the_card_names_no_source() -> void:
	# The origin of each fact stays in the Martyrology (D-465).
	var card := _card(&"saint_george")
	for shown: String in [card.bio_shown(), card.trait_shown(), card.detail_shown()]:
		assert_false(shown.contains("Legenda Áurea"))
		assert_false(shown.contains("Diálogos"))


func test_the_faces_are_cut_in_the_proportion_of_the_window() -> void:
	# D-467: each face is framed so that all show the same size.
	var window: Vector2 = BattleScreen.PORTRAIT_WINDOW.size
	for saint_id: StringName in SaintCard.FACE_REGIONS:
		var region: Rect2 = SaintCard.FACE_REGIONS[saint_id]
		assert_almost_eq(region.size.x / region.size.y, window.x / window.y, 0.01, String(saint_id))


func test_every_life_fits_the_screen() -> void:
	for saint_id: StringName in CARD_SAINTS:
		var card := _card(saint_id)
		await wait_process_frames(3)
		assert_lte(card.column_bottom(), SaintCard.PLATE_RECT.end.y - 6.0, String(saint_id))


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
	var pair: String = data.ui.text(&"rule_pair", {"a": 1, "b": 2})
	assert_string_contains(rule, data.ui.text(&"rule_target_enemy", {"where": data.ui.text(&"rule_where_many", {"list": pair})}))
	assert_string_contains(rule, data.ui.text(&"rule_from_many", {"list": pair}))


func test_a_first_touch_shows_the_stained_glass_with_its_rule_and_slots() -> void:
	var card := _card(&"saint_george")
	var javelin: AbilityDef = data.catalog.abilities[&"george_javelin"]
	card.tap_ability(javelin.id)
	assert_eq(card.lancet_state(javelin.id), "chosen")
	assert_string_contains(card.detail_shown(), AbilityRule.line(javelin, data.ui, data.catalog))
	assert_string_contains(card.detail_shown(), javelin.desc_pt)
	assert_eq(card.lit_positions(), javelin.use_slots)
	assert_eq(card.lit_targets(), javelin.target_slots)
	assert_false(card.equipped.has(javelin.id), "o primeiro toque só mostra")


func test_a_second_touch_leaves_it_in_the_village_and_takes_another() -> void:
	var card := _card(&"saint_george")
	watch_signals(card)
	var bash: StringName = &"george_shield_bash"
	card.tap_ability(bash)
	card.tap_ability(bash)
	assert_false(card.equipped.has(bash))
	assert_signal_emitted(card, "loadout_changed")
	card.tap_ability(&"george_javelin")
	card.tap_ability(&"george_javelin")
	assert_true(card.equipped.has(&"george_javelin"))
	assert_eq(card.equipped.size(), data.catalog.constants.get_int(&"equipped_abilities"))


func test_a_fifth_ability_is_refused_with_its_reason() -> void:
	var card := _card(&"saint_george")
	card.tap_ability(&"george_javelin")
	card.tap_ability(&"george_javelin")
	assert_false(card.equipped.has(&"george_javelin"))
	assert_eq(card.warning_shown(), data.ui.text(&"reason_loadout_full", {"count": data.catalog.constants.get_int(&"equipped_abilities")}))


func test_the_card_does_not_close_without_a_whole_loadout() -> void:
	var card := _card(&"saint_george")
	watch_signals(card)
	card.tap_ability(&"george_shield_bash")
	card.tap_ability(&"george_shield_bash")
	card.press_close()
	assert_signal_not_emitted(card, "closed")
	assert_ne(card.warning_shown(), "")
	# Still the chosen one: one more touch takes it back.
	card.tap_ability(&"george_shield_bash")
	card.press_close()
	assert_signal_emitted(card, "closed")


func test_the_miracle_shows_but_is_never_left_behind() -> void:
	var card := _card(&"saint_george")
	var george: SaintDef = data.saints[&"saint_george"]
	card.tap_ability(george.miracle)
	card.tap_ability(george.miracle)
	assert_string_contains(card.detail_shown(), data.catalog.abilities[george.miracle].name_pt)
	assert_eq(card.equipped, george.default_equipped)


func test_the_second_relic_slot_is_closed_until_its_level() -> void:
	# D-477: the second slot shows, closed, until the level of the GDD.
	var open_level: int = data.catalog.constants.get_int(&"relic_second_slot_level")
	var locked: String = data.ui.text(&"saint_card_relic_locked", {"level": open_level})
	var card := _card(&"saint_george")
	assert_eq(card.relics_shown(), [data.ui.text(&"saint_card_relic_none"), locked] as Array[String])
	var veteran := _card(&"saint_george", [], [], open_level)
	assert_eq(veteran.relics_shown()[1], data.ui.text(&"saint_card_relic_none"))


func test_a_carried_relic_shows_its_name() -> void:
	var relic: RelicDef = RealData.expedition_catalog().relic(&"relic_wooden_crucifix")
	var card := _card(&"saint_george", [], [relic])
	assert_eq(card.relics_shown()[0], relic.name_pt)


func test_the_card_opens_on_the_life_and_turns_to_the_sheet() -> void:
	var card := _card(&"saint_george")
	assert_eq(card.page_index, SaintCard.PAGE_LIFE)
	card.show_page(SaintCard.PAGE_SHEET)
	assert_eq(card.page_index, SaintCard.PAGE_SHEET)
