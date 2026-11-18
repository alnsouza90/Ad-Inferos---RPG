extends GutTest
## T47: experience, levels and the Retreat House (village-economy §9,
## expedition §8): one case per level, the general "+" rule at its edges
## (half up, at least +1, negative desolation, hp_fraction, a condition's
## stack) and the exceptions of the `upgrade` field.

var cat: ExpeditionCatalog
var data: GameData
var constants: ConstantsDef


func before_all() -> void:
	cat = RealData.expedition_catalog()
	data = RealData.game_data()
	constants = cat.constants


func _thresholds() -> Array[float]:
	return constants.get_list(&"xp_thresholds")


func _saint_at(xp: int, id: StringName = &"saint_george") -> CampaignSaint:
	var s := CampaignSaint.from_def(cat.saint(id))
	s.status.xp = xp
	Campaign.settle_level(s, cat)
	return s


func _ability(id: StringName) -> AbilityDef:
	return cat.battle_catalog.abilities[id]


func test_each_level_by_its_experience_with_its_gains() -> void:
	var george: SaintDef = cat.saint(&"saint_george")
	var thresholds: Array[float] = _thresholds()
	for level: int in range(1, thresholds.size() + 1):
		var at: int = int(thresholds[level - 1])
		var s := _saint_at(at)
		assert_eq(s.level, level, "experiência %d" % at)
		assert_eq(s.status.max_hp, george.max_hp + george.hp_per_level * (level - 1))
		assert_eq(s.status.level_faith, george.faith_per_level * (level - 1))
		if at > 0:
			assert_eq(_saint_at(at - 1).level, level - 1, "um ponto antes")


func test_a_level_up_adds_its_faith_and_vigor_in_battle() -> void:
	var s := _saint_at(int(_thresholds()[1]))
	var body := Combatant.from_saint(cat.saint(&"saint_george"))
	var base_faith: int = body.faith
	s.status.apply_to(body)
	assert_eq(body.faith, base_faith + cat.saint(&"saint_george").faith_per_level)
	assert_eq(body.max_hp, s.status.max_hp)


func test_upgrades_come_from_levels_two_three_and_four() -> void:
	var levels: Array[float] = constants.get_list(&"upgrade_levels")
	assert_eq(Campaign.upgrades_left(_saint_at(0), cat), 0)
	for i: int in levels.size():
		var s := _saint_at(int(_thresholds()[int(levels[i]) - 1]))
		assert_eq(Campaign.upgrades_left(s, cat), i + 1, "nível %d" % s.level)


func test_level_five_improves_the_miracle_without_spending_an_upgrade() -> void:
	var top: int = constants.get_int(&"miracle_upgrade_level")
	var s := _saint_at(int(_thresholds()[top - 1]))
	assert_true(s.status.upgrades.has(cat.saint(&"saint_george").miracle))
	assert_eq(Campaign.upgrades_left(s, cat), constants.get_list(&"upgrade_levels").size())


func test_the_retreat_house_applies_an_upgrade_once() -> void:
	var c := Campaign.start(cat, 1)
	var george: CampaignSaint = c.saint(&"saint_george")
	assert_eq(Campaign.apply_upgrade(c, cat, &"saint_george", &"george_spear_thrust"), Campaign.NO_UPGRADE_LEFT)
	george.status.xp = int(_thresholds()[1])
	Campaign.settle_level(george, cat)
	assert_eq(Campaign.apply_upgrade(c, cat, &"saint_george", &"therese_petal"), Campaign.NOT_AN_ABILITY)
	assert_eq(Campaign.apply_upgrade(c, cat, &"saint_george", &"george_spear_thrust"), Campaign.OK)
	assert_eq(Campaign.apply_upgrade(c, cat, &"saint_george", &"george_spear_thrust"), Campaign.ALREADY_UPGRADED)
	assert_eq(Campaign.apply_upgrade(c, cat, &"saint_george", &"george_javelin"), Campaign.NO_UPGRADE_LEFT)
	c.facilities.erase(Campaign.RETREAT_HOUSE)
	assert_eq(Campaign.apply_upgrade(c, cat, &"saint_george", &"george_javelin"), Campaign.NO_RETREAT_HOUSE)


func test_the_general_rule_rounds_half_up() -> void:
	# 7 × 30% = 2.1 → +2; 5 × 30% = 1.5 → +2 (half up).
	var spear := AbilityUpgrade.upgraded(_ability(&"george_spear_thrust"), constants)
	assert_eq(spear.effects[0].amount, _ability(&"george_spear_thrust").effects[0].amount + Damage.round_half_up(_ability(&"george_spear_thrust").effects[0].amount * constants.get_float(&"upgrade_gain")))
	var javelin := AbilityUpgrade.upgraded(_ability(&"george_javelin"), constants)
	assert_eq(javelin.effects[0].amount, 7.0, "5 + 2 (1,5 arredonda para cima)")
	assert_eq(javelin.cost, _ability(&"george_javelin").cost, "o custo nunca muda")
	assert_eq(javelin.name_pt, _ability(&"george_javelin").name_pt + AbilityUpgrade.NAME_MARK)
	assert_eq(_ability(&"george_javelin").effects[0].amount, 5.0, "a definição não muda")


func test_the_general_rule_gives_at_least_one() -> void:
	var tiny := AbilityDef.new()
	var e := EffectDef.new()
	e.type = &"damage"
	e.amount = 1.0
	tiny.effects = [e] as Array[EffectDef]
	assert_eq(AbilityUpgrade.upgraded(tiny, constants).effects[0].amount, 2.0)


func test_negative_desolation_counts_by_its_size() -> void:
	# Ora et Labora: −10 → −13.
	var ora := AbilityUpgrade.upgraded(_ability(&"benedict_ora_et_labora"), constants)
	assert_eq(ora.effects[0].amount, -13.0)


func test_hp_fraction_gains_a_tenth() -> void:
	var raise := AbilityUpgrade.upgraded(_ability(&"therese_abandonment"), constants)
	assert_almost_eq(float(raise.effects[0].params["hp_fraction"]), 0.4, 0.001)


func test_without_a_number_the_first_condition_gains_a_stack() -> void:
	var shield := AbilityUpgrade.upgraded(_ability(&"george_raised_shield"), constants)
	assert_eq(shield.effects[0].stacks, _ability(&"george_raised_shield").effects[0].stacks + 1)


func test_the_upgrade_field_holds_the_exceptions() -> void:
	var odd: AbilityDef = _ability(&"george_shield_bash").duplicate(false)
	odd.upgrade = "e1.amount+4;e2.stacks+1"
	var plus := AbilityUpgrade.upgraded(odd, constants)
	assert_eq(plus.effects[0].amount, _ability(&"george_shield_bash").effects[0].amount + 4.0)
	assert_eq(plus.effects[1].stacks, _ability(&"george_shield_bash").effects[1].stacks + 1)


func test_an_improved_ability_acts_as_its_plus_version_in_battle() -> void:
	var state: BattleState = data.battle(data.arena_encounter_ids()[0], 5)
	var george: Combatant = state.party[0]
	george.upgraded = [&"george_spear_thrust"] as Array[StringName]
	var ctrl := BattleController.new(state)
	var used: AbilityDef = ctrl._ability_for(BattleCommand.use_ability(george.id, &"george_spear_thrust"), george)
	assert_eq(used.name_pt, _ability(&"george_spear_thrust").name_pt + AbilityUpgrade.NAME_MARK)
	assert_gt(used.effects[0].amount, _ability(&"george_spear_thrust").effects[0].amount)


func test_the_reserve_gets_half_of_the_expedition() -> void:
	var c := Campaign.start(cat, 1)
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 3, [&"saint_george", &"saint_benedict", &"saint_therese"] as Array[StringName], cat.kit_provisions(&"m1_kit"), 2)
	# Antão in the company but left home this time.
	c.unlocked_saints.append(&"saint_anthony_abbot")
	c.saints[&"saint_anthony_abbot"] = CampaignSaint.from_def(cat.saint(&"saint_anthony_abbot"))
	Campaign.board(c, cat, ctrl)
	for id: StringName in ctrl.saints:
		(ctrl.saints[id] as SaintStatus).xp += 40
	Campaign.finish_expedition(c, cat, ctrl)
	assert_eq(c.saint(&"saint_george").status.xp, 40)
	assert_eq(c.saint(&"saint_anthony_abbot").status.xp, Damage.round_half_up(40 * constants.get_float(&"xp_reserve_share")))
	assert_eq(c.saint(&"saint_george").level, 2, "o nível sobe na volta")


func test_the_level_reaches_the_expedition_and_opens_the_second_relic_space() -> void:
	var c := Campaign.start(cat, 1)
	var george: CampaignSaint = c.saint(&"saint_george")
	george.status.xp = int(_thresholds()[constants.get_int(&"relic_second_slot_level") - 1])
	Campaign.settle_level(george, cat)
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), 2)
	Campaign.board(c, cat, ctrl)
	assert_eq(ctrl.relic_slots(&"saint_george"), constants.get_int(&"relic_slots_max"))
	assert_eq(ctrl.relic_slots(&"saint_benedict"), constants.get_int(&"relic_slots_start"))


func test_the_chosen_abilities_reach_the_battle() -> void:
	var c := Campaign.start(cat, 1)
	var george: CampaignSaint = c.saint(&"saint_george")
	george.equipped = AbilityLoadout.toggle(cat.saint(&"saint_george"), george.equipped, &"george_shield_bash", constants)
	george.equipped = AbilityLoadout.toggle(cat.saint(&"saint_george"), george.equipped, &"george_javelin", constants)
	var body := Combatant.from_saint(cat.saint(&"saint_george"))
	(Campaign.departing(c, cat, [&"saint_george"] as Array[StringName])[&"saint_george"] as SaintStatus).apply_to(body)
	assert_true(body.equipped.has(&"george_javelin"))
	assert_false(body.equipped.has(&"george_shield_bash"))
