extends GutTest
## T02: importer validations (data-schemas §2). Uses in-memory fixtures only.


func _import(tables: Dictionary) -> BalanceImporter:
	var importer := BalanceImporter.new()
	importer.import_tables(tables)
	return importer


func _assert_error(tables: Dictionary, code: String) -> void:
	var importer := _import(tables)
	var found: bool = importer.errors.any(func(e: String) -> bool: return e.contains("[%s]" % code))
	assert_true(found, "Esperava erro [%s]; erros: %s" % [code, importer.errors])


# --- accepted data ----------------------------------------------------------

func test_valid_fixture_imports_without_errors() -> void:
	var importer := _import(BalanceFixture.valid_tables())
	assert_eq(importer.errors, [] as Array[String])
	assert_eq(importer.saints.size(), 1)
	assert_eq(importer.abilities.size(), 7)


func test_saint_fields_are_parsed() -> void:
	var s: SaintDef = _import(BalanceFixture.valid_tables()).saints["saint_t"]
	assert_eq(s.max_hp, 32)
	assert_eq(s.preferred_slots, [1, 2] as Array[int])
	assert_eq(s.roles, [&"fighter", &"protector"] as Array[StringName])
	assert_eq(s.trait_def.id, &"trait_t")
	assert_eq(s.trait_def.params, {"mult": 2.0})
	assert_eq(s.camp_skill.id, &"camp_t")
	assert_true(s.m0)


func test_ability_effects_are_attached_in_order() -> void:
	var a: AbilityDef = _import(BalanceFixture.valid_tables()).abilities["t_bash"]
	assert_eq(a.effects.size(), 2)
	assert_eq(a.effects[0].type, &"damage")
	assert_eq(a.effects[1].condition_id, &"stun")


func test_chosen_enemy_slots_parses_count() -> void:
	var a: AbilityDef = _import(BalanceFixture.valid_tables()).abilities["t_miracle"]
	assert_eq(a.targeting, &"chosen_enemy_slots")
	assert_eq(a.target_count, 2)


func test_effect_params_are_numbers() -> void:
	var a: AbilityDef = _import(BalanceFixture.valid_tables()).abilities["t_charge"]
	assert_eq(a.effects[0].params, {"elite": 2.0, "boss": 2.0})


func test_const_param_takes_value_from_constants() -> void:
	var p: ProvisionDef = _import(BalanceFixture.valid_tables()).provisions["bread"]
	assert_eq(p.effects[0].amount, 5.0)


func test_constants_numbers_and_lists() -> void:
	var c: ConstantsDef = _import(BalanceFixture.valid_tables()).constants
	assert_eq(c.get_int(&"fervor_cap"), 6)
	assert_eq(c.get_list(&"xp_thresholds"), [0.0, 40.0, 100.0] as Array[float])


func test_enemy_actions_sorted_by_priority_with_conditions() -> void:
	var e: EnemyDef = _import(BalanceFixture.valid_tables()).enemies["enemy_e"]
	assert_eq(e.actions[0].id, &"e_brood")
	assert_eq(e.actions[0].conditions, [{"name": "every_n_rounds", "param": 2}, {"name": "free_enemy_slot", "param": null}] as Array[Dictionary])
	assert_eq(e.immune, [&"stun"] as Array[StringName])


func test_arena_encounter_circle() -> void:
	var enc: EncounterDef = _import(BalanceFixture.valid_tables()).encounters["enc_1"]
	assert_eq(enc.circle, EncounterDef.ARENA_CIRCLE)
	assert_eq(enc.slots, [&"enemy_e", &"enemy_e"] as Array[StringName])


func test_comment_rows_are_ignored() -> void:
	var tables := BalanceFixture.appended("saints", "# santo futuro,,,,,,,,,,,,,,,,,")
	assert_eq(_import(tables).errors, [] as Array[String])


# --- rejected data (aceite da T02) -------------------------------------------

func test_unknown_ability_id_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("saints", "t_strike|t_bash|t_guard|t_pray|t_charge|t_rally,", "t_strike|t_bash|t_guard|t_pray|t_charge|t_nope,"), "unknown_id")


func test_duplicate_id_is_rejected() -> void:
	_assert_error(BalanceFixture.appended("conditions", "stun,token,negative,1,none,none,none,on_action_attempt,false,stun_cancel,res://x.png,1,Outro,Outro."), "duplicate_id")


func test_saint_without_any_slot_free_basic_is_rejected() -> void:
	# The fixture has two free any-slot basics (t_strike, t_guard): one alone still satisfies the rule.
	var one_left := BalanceFixture.replaced("abilities", "t_strike,saint_t,Golpe,basic,0,1|2|3", "t_strike,saint_t,Golpe,basic,0,1|2")
	assert_eq(_import(one_left).errors, [] as Array[String])
	var none_left: Dictionary = one_left.duplicate()
	none_left["abilities"] = String(none_left["abilities"]).replace("t_guard,saint_t,Guarda,basic,0,1|2|3", "t_guard,saint_t,Guarda,basic,0,1|2")
	_assert_error(none_left, "missing_any_slot_basic")


# --- other rules of data-schemas §2 -----------------------------------------

func test_unknown_condition_in_effect_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("effects", "t_bash,2,apply_condition,,,stun", "t_bash,2,apply_condition,,,dazed"), "unknown_id")


func test_unknown_enemy_in_encounter_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("encounters", "enc_1,m0,easy,enemy_e,enemy_e", "enc_1,m0,easy,enemy_e,enemy_ghost"), "unknown_id")


func test_number_out_of_range_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("saints", "32,2,4,1,4,1", "32,5,4,1,4,1"), "out_of_range")


func test_miracle_cost_below_three_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("abilities", "t_miracle,saint_t,Milagre,miracle,3", "t_miracle,saint_t,Milagre,miracle,2"), "bad_cost")


func test_miracle_cost_above_four_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("abilities", "t_miracle,saint_t,Milagre,miracle,3", "t_miracle,saint_t,Milagre,miracle,5"), "bad_cost")


func test_basic_cost_above_one_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("abilities", "t_bash,saint_t,Pancada,basic,1", "t_bash,saint_t,Pancada,basic,2"), "bad_cost")


func test_fervor_cost_other_than_two_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("abilities", "t_rally,saint_t,Reunir,fervor,2", "t_rally,saint_t,Reunir,fervor,1"), "bad_cost")


func test_default_equipped_without_free_ability_is_rejected() -> void:
	var tables := BalanceFixture.replaced("abilities", "t_strike,saint_t,Golpe,basic,0", "t_strike,saint_t,Golpe,basic,1")
	tables["abilities"] = String(tables["abilities"]).replace("t_guard,saint_t,Guarda,basic,0", "t_guard,saint_t,Guarda,basic,1")
	tables["abilities"] = String(tables["abilities"]).replace("t_pray,saint_t,Prece,basic,0,2|3", "t_pray,saint_t,Prece,basic,0,1|2|3")
	_assert_error(tables, "missing_free_equipped")


func test_saint_without_damaging_basic_is_rejected() -> void:
	var tables := BalanceFixture.replaced("effects", "t_strike,1,damage,7,strike,,,,,,,,,", "t_strike,1,heal,7,,,,,,,,,,")
	tables["effects"] = String(tables["effects"]).replace("t_bash,1,damage,4,strike,,,,,,,,,", "t_bash,1,heal,4,,,,,,,,,,")
	_assert_error(tables, "missing_damage_basic")


func test_wrong_kit_size_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("saints", "t_strike|t_bash|t_guard|t_pray|t_charge|t_rally,", "t_strike|t_bash|t_guard|t_pray|t_charge,"), "kit_size")


func test_ability_without_effects_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("effects", "t_pray,1,desolation,-10,,,,,,,,,,\n", ""), "missing_effects")


func test_unknown_effect_param_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("effects", "elite=2.0;boss=2.0", "elite=2.0;giant=3"), "unknown_param")


func test_bad_enum_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("enemies", "corporeal,brute", "ghostly,brute"), "bad_enum")


func test_missing_column_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("provisions", "id,name_pt,price", "id,name_pt,cost"), "missing_column")


func test_missing_table_is_rejected() -> void:
	var tables := BalanceFixture.valid_tables()
	tables.erase("traits")
	_assert_error(tables, "missing_table")


func test_effect_owner_that_does_not_exist_is_rejected() -> void:
	_assert_error(BalanceFixture.appended("effects", "nobody,1,damage,3,strike,,,,,,,,,"), "unknown_id")


func test_unknown_summon_is_rejected() -> void:
	_assert_error(BalanceFixture.replaced("effects", "e_brood,1,summon,,,,,,,,enemy_e", "e_brood,1,summon,,,,,,,,enemy_ghost"), "unknown_id")


func test_ability_not_in_owner_kit_is_rejected() -> void:
	_assert_error(BalanceFixture.appended("abilities", "t_extra,saint_t,Extra,basic,0,1,enemy,1,,,game_fiction,,Extra."), "orphan")


# --- interface texts (T15) --------------------------------------------------

func test_ui_text_is_parsed_and_formatted() -> void:
	var ui: UiTextDef = _import(BalanceFixture.valid_tables()).ui_text
	assert_eq(ui.text(&"end_turn"), "Encerrar turno")
	assert_eq(ui.text(&"round", {"round": 3}), "Rodada 3")
	assert_eq(ui.text(&"nope"), "[nope]", "texto ausente aparece entre colchetes")


func test_ui_text_with_duplicate_id_is_rejected() -> void:
	_assert_error(BalanceFixture.appended("ui_text", "end_turn,Outra vez"), "duplicate_id")


func test_ui_text_without_text_is_rejected() -> void:
	_assert_error(BalanceFixture.appended("ui_text", "empty_one,"), "missing_value")


# --- map templates (T20) ------------------------------------------------------

func test_map_template_is_parsed_into_layers() -> void:
	var d: MapTemplateDef = _import(BalanceFixture.valid_tables()).map_templates["t_leg"]
	assert_eq(d.leg, 1)
	assert_eq(d.layers.size(), 4)
	assert_eq(StringName((d.layers[1][0] as Dictionary)["role"]), &"temptation")


func test_map_template_breaking_the_path_rules_is_rejected() -> void:
	var tables := BalanceFixture.replaced("map_templates", "t_leg,1,2,0,temptation,node_temptation,0", "t_leg,1,2,0,battle,node_battle,0")
	_assert_error(tables, "invalid_template")


func test_map_template_link_outside_the_next_layer_is_rejected() -> void:
	var tables := BalanceFixture.replaced("map_templates", "t_leg,1,3,0,variable,node_relic,0", "t_leg,1,3,0,variable,node_relic,2")
	_assert_error(tables, "invalid_template")


func test_map_template_unknown_node_type_is_rejected() -> void:
	var tables := BalanceFixture.replaced("map_templates", "t_leg,1,1,0,battle,node_battle,0", "t_leg,1,1,0,battle,node_dragon,0")
	_assert_error(tables, "bad_enum")


func test_map_template_with_a_gap_in_the_layer_is_rejected() -> void:
	var tables := BalanceFixture.appended("map_templates", "t_leg,1,2,2,temptation,node_temptation,0")
	_assert_error(tables, "slot_gap")


func test_const_keeps_the_sign_written_in_the_csv() -> void:
	var tables := BalanceFixture.replaced("effects", "t_pray,1,desolation,-10,,,,,,,,,,", "t_pray,1,desolation,-10,,,,,,,,,,const=bread_heal")
	var a: AbilityDef = _import(tables).abilities["t_pray"]
	assert_eq(a.effects[0].amount, -5.0, "constante 5 com sinal negativo da planilha")
