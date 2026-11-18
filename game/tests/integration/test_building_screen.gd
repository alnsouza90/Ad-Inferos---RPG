extends GutTest
## T49, D-500, D-501, D-503: inside each building open in the M2, the guardian,
## his line and help, the board of places and the saints stacked at the right;
## a place and a saint tapped, in either order, go through the campaign rules.

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _screen(building: StringName, c: CampaignState = null) -> BuildingScreen:
	if c == null:
		c = Campaign.start(cat, 1)
		c.alms = 500
	var b := BuildingScreen.new()
	b.setup(data, cat, c, building)
	add_child_autofree(b)
	return b


func test_every_open_building_has_its_interior_guardian_and_texts() -> void:
	for id: StringName in [&"gate", &"pantry", &"infirmary", &"garden", &"retreat_house"]:
		assert_true(ResourceLoader.exists(BuildingScreen.INTERIOR_PATH % id), "interior %s" % id)
		assert_true(ResourceLoader.exists(BuildingScreen.PORTRAIT_PATH % BuildingScreen.GUARDIANS[id]), "guardião %s" % id)
		for key: String in ["guardian_%s", "guardian_line_%s", "guardian_help_%s", "building_%s"]:
			assert_true(data.ui.has_text(StringName(key % id)), key % id)


func test_the_pantry_buys_and_gives_back() -> void:
	var b := _screen(&"pantry")
	assert_eq(b.buy(&"bread"), &"")
	assert_eq(b.campaign.pantry_stock, [&"bread"] as Array[StringName])
	assert_eq(b.give_back(&"bread"), &"")
	assert_eq(b.campaign.alms, 500)


func test_a_refusal_is_shown_with_its_reason() -> void:
	var c := Campaign.start(cat, 1)
	c.alms = 0
	var b := _screen(&"pantry", c)
	assert_eq(b.buy(&"incense"), Village.NOT_ENOUGH_ALMS)
	assert_eq(b.warning_shown(), data.ui.text(&"reason_not_enough_alms"))


func test_the_infirmary_pays_a_bed() -> void:
	var c := Campaign.start(cat, 1)
	c.alms = 500
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MAJOR
	var b := _screen(&"infirmary", c)
	assert_eq(b.pay_bed(&"saint_george"), &"")
	assert_true(c.infirmary_beds.has(&"saint_george"))


func test_the_garden_takes_a_saint_to_rest() -> void:
	var b := _screen(&"garden")
	assert_eq(b.toggle_garden(&"saint_therese"), &"")
	assert_true(b.campaign.garden_saints.has(&"saint_therese"))


func test_the_retreat_house_improves_an_ability() -> void:
	var c := Campaign.start(cat, 1)
	c.saint(&"saint_george").status.xp = 40
	Campaign.settle_level(c.saint(&"saint_george"), cat)
	var b := _screen(&"retreat_house", c)
	b.choose_saint(&"saint_george")
	assert_eq(b.upgrade(&"george_spear_thrust"), &"")
	assert_true(c.saint(&"saint_george").status.upgrades.has(&"george_spear_thrust"))


func test_the_gate_suggests_the_company_and_departs() -> void:
	var b := _screen(&"gate")
	assert_eq(b.party_ids(), RealData.m0_party_ids(), "a sugestão de Planejar a semana")
	watch_signals(b)
	assert_eq(b.depart(), &"")
	assert_signal_emitted(b, "departed")


func test_the_gate_refuses_an_incomplete_company() -> void:
	var b := _screen(&"gate")
	b.toggle_party(&"saint_george")
	assert_eq(b.party.find(&""), RealData.m0_party_ids().find(&"saint_george"), "a vaga dele fica livre")
	watch_signals(b)
	assert_eq(b.depart(), Campaign.WRONG_PARTY)
	assert_signal_not_emitted(b, "departed")


func test_the_gate_swaps_a_place_and_a_saint_of_the_reserve() -> void:
	var c := Campaign.start(cat, 1)
	c.unlocked_saints.append(&"saint_anthony_abbot")
	c.saints[&"saint_anthony_abbot"] = CampaignSaint.from_def(cat.saint(&"saint_anthony_abbot"))
	var b := _screen(&"gate", c)
	var out: StringName = b.party[1]
	b.tap_slot(1)
	assert_eq(b.selected_slot, 1, "a vaga acende")
	assert_eq(b.tap_saint(&"saint_anthony_abbot"), &"")
	assert_eq(b.party[1], &"saint_anthony_abbot")
	assert_false(b.party.has(out), "quem saiu volta para a reserva")
	assert_eq(b.selected_slot, -1)


func test_the_gate_swaps_two_places_of_the_company() -> void:
	var b := _screen(&"gate")
	var first: StringName = b.party[0]
	var third: StringName = b.party[2]
	b.tap_slot(0)
	b.tap_saint(third)
	assert_eq(b.party[0], third)
	assert_eq(b.party[2], first, "a ordem troca")


func test_the_gate_refuses_a_saint_who_cannot_go_down_with_its_reason() -> void:
	var c := Campaign.start(cat, 1)
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MAJOR
	var b := _screen(&"gate", c)
	b.toggle_party(&"saint_george")
	b.tap_slot(0)
	assert_eq(b.tap_saint(&"saint_george"), Campaign.INJURED)
	assert_eq(b.warning_shown(), data.ui.text(&"reason_saint_injured"))
	assert_false(b.party.has(&"saint_george"))


func test_the_gate_tells_why_a_saint_has_not_arrived() -> void:
	var b := _screen(&"gate")
	assert_eq(b.lock_reason(&"saint_anthony_abbot"), data.ui.text(&"lock_circle", {"circle": "2"}))
	assert_eq(b.lock_reason(&"saint_nicholas"), data.ui.text(&"lock_week", {"week": "3"}))


func test_the_gate_announces_who_arrived() -> void:
	var c := Campaign.start(cat, 1)
	c.unlocked_saints.append(&"saint_anthony_abbot")
	c.saints[&"saint_anthony_abbot"] = CampaignSaint.from_def(cat.saint(&"saint_anthony_abbot"))
	c.pending_arrivals.append(&"saint_anthony_abbot")
	var b := _screen(&"gate", c)
	await wait_process_frames(1)
	assert_eq(b.warning_shown(), data.ui.text(&"gate_arrival", {"name": cat.saint(&"saint_anthony_abbot").name_pt}))
	assert_true(c.pending_arrivals.is_empty(), "anunciado uma vez só")


func test_the_infirmary_takes_a_saint_then_a_free_bed() -> void:
	var c := Campaign.start(cat, 1)
	c.alms = 500
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MAJOR
	var b := _screen(&"infirmary", c)
	b.tap_saint(&"saint_george")
	assert_eq(b.selected_saint, &"saint_george", "o retrato acende")
	assert_eq(b.tap_slot(0), &"")
	assert_true(c.infirmary_beds.has(&"saint_george"))


func test_the_garden_takes_a_free_place_then_a_saint_and_gives_it_back() -> void:
	var b := _screen(&"garden")
	b.tap_slot(0)
	assert_eq(b.tap_saint(&"saint_therese"), &"")
	assert_true(b.campaign.garden_saints.has(&"saint_therese"))
	b.tap_slot(0)
	assert_false(b.campaign.garden_saints.has(&"saint_therese"), "tocar nele de novo o tira")


func test_every_saint_has_a_short_name_and_every_unlock_a_reason() -> void:
	for id: StringName in cat.saints:
		assert_true(data.ui.has_text(StringName("saint_short_%s" % id)), "nome curto %s" % id)
		var unlock: String = cat.saint(id).unlock
		if unlock != Campaign.UNLOCK_START:
			assert_true(data.ui.has_text(StringName("lock_%s" % unlock.split(":")[0])), "motivo %s" % id)
