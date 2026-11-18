extends GutTest
## T48: the Pantry, the Infirmary, the Garden, the relics and the Gate
## (village-economy §2, §3, §7, §12 and §13): buying without Alms (V09) and
## with the pack full (V10), the paid bed (V11), and one whole week planned
## and gone down.

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(alms: int = 1000) -> CampaignState:
	var c := Campaign.start(cat, 5)
	c.alms = alms
	return c


func test_buying_costs_its_price_and_fills_the_pack() -> void:
	var c := _new()
	assert_eq(Village.buy(c, cat, &"bread"), Village.OK)
	assert_eq(c.alms, 1000 - cat.economy.get_int(&"price_bread"))
	assert_eq(c.pantry_stock, [&"bread"] as Array[StringName])


func test_v09_buying_without_alms_is_refused() -> void:
	var c := _new(cat.economy.get_int(&"price_incense") - 1)
	assert_eq(Village.buy(c, cat, &"incense"), Village.NOT_ENOUGH_ALMS)
	assert_true(c.pantry_stock.is_empty())
	assert_eq(c.alms, cat.economy.get_int(&"price_incense") - 1, "nada muda")


func test_v10_the_ninth_provision_does_not_fit_the_pack() -> void:
	var c := _new(10000)
	var room: int = Village.pack_capacity(c, cat)
	assert_eq(room, cat.constants.get_int(&"pantry_slots_l1"))
	for i: int in room:
		assert_eq(Village.buy(c, cat, &"bread"), Village.OK)
	var before: int = c.alms
	assert_eq(Village.buy(c, cat, &"bread"), Village.PACK_FULL)
	assert_eq(c.alms, before)


func test_a_bigger_pantry_gives_a_bigger_pack() -> void:
	# D-474: the pack grows with the Pantry, not the Gate.
	var c := _new()
	c.facilities[Village.PANTRY] = 2
	assert_eq(Village.pack_capacity(c, cat), cat.constants.get_int(&"pantry_slots_l2"))


func test_giving_back_returns_its_price() -> void:
	var c := _new()
	Village.buy(c, cat, &"candle")
	assert_eq(Village.give_back(c, cat, &"candle"), Village.OK)
	assert_eq(c.alms, 1000)
	assert_eq(Village.give_back(c, cat, &"candle"), Village.NOT_IN_STOCK)


func test_v11_a_paid_bed_heals_a_major_injury_the_next_week() -> void:
	var c := _new()
	var george: CampaignSaint = c.saint(&"saint_george")
	assert_eq(Village.pay_bed(c, cat, &"saint_george"), Village.NOT_INJURED)
	george.status.injury = SaintStatus.INJURY_MAJOR
	george.injury_weeks_left = cat.economy.get_int(&"injury_major_weeks")
	assert_eq(Village.pay_bed(c, cat, &"saint_george"), Village.OK)
	assert_eq(c.alms, 1000 - cat.economy.get_int(&"infirmary_bed_cost"))
	Campaign.advance_week(c, cat)
	assert_eq(george.status.injury, SaintStatus.INJURY_NONE)


func test_the_infirmary_has_its_beds() -> void:
	var c := _new()
	for id: StringName in [&"saint_george", &"saint_benedict"]:
		c.saint(id).status.injury = SaintStatus.INJURY_MAJOR
	assert_eq(Village.pay_bed(c, cat, &"saint_george"), Village.OK)
	assert_eq(Village.beds(c, cat), cat.constants.get_int(&"infirmary_beds_l1"))
	assert_eq(Village.pay_bed(c, cat, &"saint_benedict"), Village.NO_BED_FREE)
	c.alms = 0
	c.infirmary_beds.clear()
	assert_eq(Village.pay_bed(c, cat, &"saint_benedict"), Village.NOT_ENOUGH_ALMS)


func test_the_garden_has_its_places_and_frees_them() -> void:
	var c := _new()
	assert_eq(Village.toggle_garden(c, cat, &"saint_therese"), Village.OK)
	assert_eq(Village.toggle_garden(c, cat, &"saint_george"), Village.NO_PLACE_FREE)
	assert_eq(Village.toggle_garden(c, cat, &"saint_therese"), Village.OK, "sai do Jardim")
	assert_true(c.garden_saints.is_empty())


func test_a_relic_goes_on_a_saint_and_comes_back() -> void:
	var c := _new()
	c.relic_stock.append(&"relic_wooden_crucifix")
	c.relic_stock.append(&"relic_tau_cross")
	var george: CampaignSaint = c.saint(&"saint_george")
	assert_eq(Village.equip_relic(c, cat, &"saint_george", &"relic_wooden_crucifix"), Village.OK)
	assert_eq(george.status.faith_bonus, 1)
	assert_eq(Village.equip_relic(c, cat, &"saint_george", &"relic_tau_cross"), Village.NO_RELIC_SPACE, "um espaço até o nível 4")
	assert_eq(Village.unequip_relic(c, cat, &"saint_george", &"relic_wooden_crucifix"), Village.OK)
	assert_eq(george.status.faith_bonus, 0)
	assert_eq(Village.equip_relic(c, cat, &"saint_george", &"relic_tau_cross"), Village.OK)
	var def: SaintDef = cat.saint(&"saint_george")
	assert_eq(george.status.max_hp, Damage.round_half_up(def.max_hp * 1.05))
	assert_true(c.relic_stock.has(&"relic_wooden_crucifix"))


func test_the_suggestions_send_the_wounded_to_bed_and_the_desolate_to_the_garden() -> void:
	var c := _new()
	c.saint(&"saint_george").status.injury = SaintStatus.INJURY_MAJOR
	c.saint(&"saint_benedict").status.desolation = cat.constants.get_int(&"faith_check_threshold")
	var s: Dictionary = Village.suggestions(c, cat)
	assert_eq(s["bed"], [&"saint_george"] as Array[StringName])
	assert_eq(s["garden"], [&"saint_benedict"] as Array[StringName])
	assert_eq(s["party"], [&"saint_therese"] as Array[StringName])


func test_the_gate_refuses_a_saint_without_a_whole_loadout() -> void:
	var c := _new()
	c.saint(&"saint_george").equipped.pop_back()
	var why: Array[StringName] = []
	assert_null(Village.depart(c, cat, RealData.m0_party_ids(), &"circle_02", 3, 2, 0, why))
	assert_eq(why, [Village.LOADOUT] as Array[StringName])


func test_a_whole_week_planned_and_gone_down() -> void:
	var c := _new()
	c.relic_stock.append(&"relic_wooden_crucifix")
	for p: StringName in [&"bread", &"candle", &"holy_water"]:
		assert_eq(Village.buy(c, cat, p), Village.OK)
	assert_eq(Village.equip_relic(c, cat, &"saint_benedict", &"relic_wooden_crucifix"), Village.OK)
	var party: Array[StringName] = Village.suggestions(c, cat)["party"]
	var why: Array[StringName] = []
	var ctrl := Village.depart(c, cat, party, &"circle_02", 3, 2, 0, why)
	assert_not_null(ctrl, str(why))
	assert_eq(ctrl.state.provisions, [&"bread", &"candle", &"holy_water"] as Array[StringName], "o alforje comprado desce")
	assert_true(c.pantry_stock.is_empty())
	assert_eq((ctrl.saints[&"saint_benedict"] as SaintStatus).relics, [&"relic_wooden_crucifix"] as Array[StringName])
	assert_eq(ctrl.state.party, party, "na ordem escolhida")
	Campaign.finish_expedition(c, cat, ctrl)
	assert_eq(c.week, 2)


func test_a_bigger_pantry_does_not_reveal_more_of_the_way() -> void:
	# D-469: the reveal is always that of level 1.
	var c := _new()
	c.facilities[Village.PANTRY] = 3
	var ctrl := Village.depart(c, cat, RealData.m0_party_ids(), &"circle_02", 3, 2)
	for n: MapNode in ctrl.map.all_nodes():
		assert_eq(ctrl.content_visible(n), LegMap.content_visible(n.layer, 0, 1), String(n.id))
