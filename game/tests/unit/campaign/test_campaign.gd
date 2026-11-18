extends GutTest
## T46: the campaign between expeditions (village-economy §1, §8, §10, §12
## and §13; save-load §3.3).

const SEED: int = 7

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new() -> CampaignState:
	return Campaign.start(cat, SEED)


func _expedition(c: CampaignState, map_seed: int = 3) -> ExpeditionController:
	var party: Array[StringName] = RealData.m0_party_ids()
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", map_seed, party, cat.kit_provisions(&"m1_kit"), 2)
	Campaign.board(c, cat, ctrl)
	return ctrl


func test_a_new_campaign_starts_at_week_one_with_the_three_saints() -> void:
	var c := _new()
	assert_eq(c.week, 1)
	assert_eq(c.unlocked_saints, RealData.m0_party_ids())
	assert_false(c.unlocked_saints.has(&"saint_anthony_abbot"))
	for f: StringName in Campaign.M2_FACILITIES:
		assert_eq(int(c.facilities[f]), 1, String(f))
	assert_eq(c.saint(&"saint_george").equipped, (cat.saint(&"saint_george")).default_equipped)


func test_v01_a_second_retreat_in_a_row_is_refused() -> void:
	var c := _new()
	assert_eq(Campaign.retreat(c, cat), Campaign.OK)
	assert_eq(c.week, 2)
	assert_eq(Campaign.retreat(c, cat), Campaign.RETREAT_USED)
	assert_eq(c.week, 2, "nada muda")


func test_an_expedition_turns_the_week_and_frees_the_retreat() -> void:
	var c := _new()
	Campaign.retreat(c, cat)
	var ctrl := _expedition(c)
	Campaign.finish_expedition(c, cat, ctrl)
	assert_eq(c.week, 3)
	assert_false(c.retreat_used)
	assert_eq(Campaign.retreat(c, cat), Campaign.OK)


func test_v05_a_major_injury_with_a_bed_heals_the_next_week() -> void:
	var c := _new()
	var george: CampaignSaint = c.saint(&"saint_george")
	george.status.injury = SaintStatus.INJURY_MAJOR
	george.injury_weeks_left = cat.economy.get_int(&"injury_major_weeks")
	c.infirmary_beds.append(&"saint_george")
	Campaign.advance_week(c, cat)
	assert_eq(george.status.injury, SaintStatus.INJURY_NONE)


func test_a_major_injury_without_a_bed_takes_its_weeks() -> void:
	var c := _new()
	var george: CampaignSaint = c.saint(&"saint_george")
	george.status.injury = SaintStatus.INJURY_MAJOR
	george.injury_weeks_left = cat.economy.get_int(&"injury_major_weeks")
	for i: int in cat.economy.get_int(&"injury_major_weeks") - 1:
		Campaign.advance_week(c, cat)
		assert_eq(george.status.injury, SaintStatus.INJURY_MAJOR, "semana %d" % (i + 1))
	Campaign.advance_week(c, cat)
	assert_eq(george.status.injury, SaintStatus.INJURY_NONE)


func test_an_injury_from_the_expedition_starts_counting() -> void:
	var c := _new()
	var ctrl := _expedition(c)
	(ctrl.saints[&"saint_george"] as SaintStatus).add_injury(SaintStatus.INJURY_MAJOR)
	Campaign.finish_expedition(c, cat, ctrl)
	var george: CampaignSaint = c.saint(&"saint_george")
	assert_eq(george.status.injury, SaintStatus.INJURY_MAJOR)
	# The week already turned once on the way home.
	assert_eq(george.injury_weeks_left, cat.economy.get_int(&"injury_major_weeks") - 1)


func test_a_second_minor_injury_before_healing_becomes_major() -> void:
	# D-481.
	assert_eq(Campaign.combined_injury(SaintStatus.INJURY_NONE, SaintStatus.INJURY_MINOR), SaintStatus.INJURY_MINOR)
	assert_eq(Campaign.combined_injury(SaintStatus.INJURY_MINOR, SaintStatus.INJURY_MINOR), SaintStatus.INJURY_MAJOR)
	assert_eq(Campaign.combined_injury(SaintStatus.INJURY_MINOR, SaintStatus.INJURY_NONE), SaintStatus.INJURY_MINOR)
	assert_eq(Campaign.combined_injury(SaintStatus.INJURY_NONE, SaintStatus.INJURY_MAJOR), SaintStatus.INJURY_MAJOR)
	var c := _new()
	var therese: CampaignSaint = c.saint(&"saint_therese")
	therese.status.injury = SaintStatus.INJURY_MINOR
	therese.injury_weeks_left = 5
	var ctrl := _expedition(c)
	assert_eq((ctrl.saints[&"saint_therese"] as SaintStatus).injury, SaintStatus.INJURY_NONE, "o ferimento fica na campanha")
	(ctrl.saints[&"saint_therese"] as SaintStatus).add_injury(SaintStatus.INJURY_MINOR)
	Campaign.finish_expedition(c, cat, ctrl)
	assert_eq(therese.status.injury, SaintStatus.INJURY_MAJOR)


func test_a_saint_with_a_major_injury_cannot_go_down() -> void:
	# D-481: it demands the Infirmary or the weeks.
	var c := _new()
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MAJOR
	assert_eq(Campaign.party_refusal(c, cat, RealData.m0_party_ids()), Campaign.INJURED)
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MINOR
	assert_eq(Campaign.party_refusal(c, cat, RealData.m0_party_ids()), Campaign.OK, "o leve desce")


func test_a_minor_injury_takes_vigor_and_faith() -> void:
	# §8, D-481: −10% of both, no draw.
	var c := _new()
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MINOR
	var body := Combatant.from_saint(cat.saint(&"saint_george"))
	var whole_hp: int = body.max_hp
	var whole_faith: int = body.faith
	(Campaign.departing(c, cat, [&"saint_george"] as Array[StringName])[&"saint_george"] as SaintStatus).apply_to(body)
	var cut: float = 1.0 - cat.economy.get_float(&"injury_minor_penalty")
	assert_eq(body.max_hp, Damage.round_half_up(whole_hp * cut))
	assert_eq(body.faith, Damage.round_half_up(whole_faith * cut))


func test_the_expedition_carries_the_campaign_saints_and_replays_the_same() -> void:
	var c := _new()
	c.saint(&"saint_george").status.desolation = 40
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MINOR
	var ctrl := _expedition(c)
	assert_eq((ctrl.saints[&"saint_george"] as SaintStatus).desolation, 40)
	var again := ExpeditionController.from_snapshot(cat, ctrl.initial_snapshot())
	assert_eq((again.saints[&"saint_george"] as SaintStatus).hp_penalty, cat.economy.get_float(&"injury_minor_penalty"))


func test_the_alms_and_relics_of_the_expedition_come_home() -> void:
	var c := _new()
	var ctrl := _expedition(c)
	ctrl.state.alms_banked = 120
	ctrl.state.alms_unbanked = 30
	ctrl.state.relic_pack.append(&"relic_tau_cross")
	Campaign.finish_expedition(c, cat, ctrl)
	assert_eq(c.alms, 150)
	assert_eq(c.relic_stock, [&"relic_tau_cross"] as Array[StringName])


func test_v13_completing_circle_two_brings_anthony_to_be_announced() -> void:
	var c := _new()
	var ctrl := _expedition(c)
	ctrl.flags.append(&"circle_02_completed")
	Campaign.finish_expedition(c, cat, ctrl)
	assert_true(c.unlocked_saints.has(&"saint_anthony_abbot"))
	assert_eq(c.pending_arrivals, [&"saint_anthony_abbot"] as Array[StringName])
	assert_eq(Campaign.announce_arrivals(c), [&"saint_anthony_abbot"] as Array[StringName])
	assert_true(c.pending_arrivals.is_empty())
	# A second completion does not bring him again.
	var ctrl2 := _expedition(c)
	Campaign.finish_expedition(c, cat, ctrl2)
	assert_true(c.pending_arrivals.is_empty())


func test_v15_the_garden_eases_desolation_and_keeps_the_saint_home() -> void:
	var c := _new()
	c.saint(&"saint_therese").status.desolation = 80
	c.garden_saints.append(&"saint_therese")
	assert_eq(Campaign.party_refusal(c, cat, RealData.m0_party_ids()), Campaign.RESTING)
	Campaign.advance_week(c, cat)
	assert_eq(c.saint(&"saint_therese").status.desolation, 80 - cat.constants.get_int(&"garden_desolation_per_week"))
	assert_true(c.garden_saints.is_empty(), "a designação vale uma semana")


func test_the_party_must_be_three_saints_of_the_company() -> void:
	var c := _new()
	assert_eq(Campaign.party_refusal(c, cat, RealData.m0_party_ids()), Campaign.OK)
	assert_eq(Campaign.party_refusal(c, cat, [&"saint_george", &"saint_benedict", &"saint_anthony_abbot"] as Array[StringName]), Campaign.NOT_UNLOCKED)
	assert_eq(Campaign.party_refusal(c, cat, [&"saint_george", &"saint_george", &"saint_therese"] as Array[StringName]), Campaign.WRONG_PARTY)
	assert_eq(Campaign.party_refusal(c, cat, [&"saint_george"] as Array[StringName]), Campaign.WRONG_PARTY)


func test_everyone_is_back_to_full_health_when_the_week_turns() -> void:
	var c := _new()
	c.saint(&"saint_george").status.hp = 3
	Campaign.advance_week(c, cat)
	assert_eq(c.saint(&"saint_george").status.hp, c.saint(&"saint_george").status.max_hp)


func test_the_campaign_survives_a_save() -> void:
	var c := _new()
	Campaign.retreat(c, cat)
	c.alms = 77
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MINOR
	c.saint(&"saint_george").injury_weeks_left = 1
	var text: String = JSON.stringify(c.to_dict())
	var back := CampaignState.from_dict(JSON.parse_string(text))
	assert_eq(JSON.stringify(back.to_dict()), text)
