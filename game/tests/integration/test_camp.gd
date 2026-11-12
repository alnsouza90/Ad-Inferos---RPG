extends GutTest
## T24: the camp (expedition §6 and §12: E05, E06, E07; D-143, D-144), with
## the real M0 saints: George (Guard), Benedict (Lectio Divina) and Therese
## (Little Sacrifices).

const G: StringName = &"saint_george"
const B: StringName = &"saint_benedict"
const T: StringName = &"saint_therese"

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


## A controller standing at the camp of its leg (built directly, so each
## test controls the party without playing the whole leg).
func _at_camp(catalog: ExpeditionCatalog = null, provisions: Array[StringName] = []) -> ExpeditionController:
	if catalog == null:
		catalog = cat
	if provisions.is_empty():
		provisions = catalog.kit_provisions(&"m1_kit")
	var ctrl := ExpeditionController.start_new(catalog, &"circle_02", 1, RealData.m0_party_ids(), provisions, EncounterDef.ARENA_CIRCLE)
	ctrl.state.current_node = ctrl.map.node(4, 0).id
	ctrl.state.light = 80
	ctrl._arrive_at_camp()
	return ctrl


static func _acts(g: String, b: String, t: String, target_g: StringName = &"", target_b: StringName = &"", target_t: StringName = &"") -> Array[Dictionary]:
	var list: Array[Dictionary] = [
		{"saint": G, "activity": StringName(g), "target": target_g},
		{"saint": B, "activity": StringName(b), "target": target_b},
		{"saint": T, "activity": StringName(t), "target": target_t},
	]
	return list


## Catalog whose constants make the ambush certain (the shared one is untouched).
func _certain_ambush() -> ExpeditionCatalog:
	var c := RealData.expedition_catalog()
	var k := ConstantsDef.new()
	k.values = cat.constants.values.duplicate(true)
	# High Light halves the chance at camp; 10 keeps the ambush certain.
	k.values["ambush_chance"] = 10.0
	c.constants = k
	return c


func test_arriving_consecrates_the_camp_and_banks_the_alms() -> void:
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 1, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	ctrl.state.alms_unbanked = 140
	ctrl.state.current_node = ctrl.map.node(4, 0).id
	ctrl._arrive_at_camp()
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_CAMP)
	assert_true(ctrl.state.camp_reached)
	assert_eq(ctrl.state.alms_banked, 140)
	assert_eq(ctrl.state.alms_unbanked, 0)


func test_E05_resting_without_bread_is_unavailable() -> void:
	var no_bread: Array[StringName] = [&"candle", &"incense"]
	var ctrl := _at_camp(null, no_bread)
	var acts := _acts("vigil", "vigil", "vigil")
	assert_eq(ctrl.rest_problem(acts), ExpeditionController.REJECT_NO_BREAD)
	assert_eq(ctrl.execute(ExpeditionCommand.rest(acts)), ExpeditionController.REJECT_NO_BREAD)


func test_rest_spends_one_bread_and_only_once() -> void:
	var ctrl := _at_camp()
	var acts := _acts("vigil", "vigil", "vigil")
	assert_eq(ctrl.execute(ExpeditionCommand.rest(acts)), &"")
	assert_eq(ctrl.state.provisions.count(&"bread"), 1)
	assert_eq(ctrl.execute(ExpeditionCommand.rest(acts)), ExpeditionController.REJECT_ALREADY_RESTED)


func test_vigil_lowers_the_saints_own_desolation_by_20() -> void:
	var ctrl := _at_camp()
	for id: StringName in ctrl.saints:
		ctrl.saints[id].desolation = 50
	ctrl.execute(ExpeditionCommand.rest(_acts("vigil", "prayer", "prayer")))
	assert_eq(ctrl.saints[G].desolation, 30)
	assert_eq(ctrl.saints[B].desolation, 50)


func test_share_heals_30_percent_of_another_saint() -> void:
	var ctrl := _at_camp()
	var george: SaintStatus = ctrl.saints[G]
	george.hp = 1
	ctrl.execute(ExpeditionCommand.rest(_acts("vigil", "share", "vigil", &"", G)))
	assert_eq(george.hp, 1 + Damage.round_half_up(george.max_hp * 0.3))


func test_D144_share_cannot_target_the_saint_himself() -> void:
	var ctrl := _at_camp()
	assert_eq(ctrl.rest_problem(_acts("vigil", "share", "vigil", &"", B)), ExpeditionController.REJECT_BAD_ACTIVITY)


func test_every_saint_needs_exactly_one_activity() -> void:
	var ctrl := _at_camp()
	var two: Array[Dictionary] = [{"saint": G, "activity": &"vigil", "target": &""}, {"saint": B, "activity": &"vigil", "target": &""}]
	assert_eq(ctrl.rest_problem(two), ExpeditionController.REJECT_BAD_ACTIVITY)


func test_E06_two_prayers_give_2_fervor_and_three_still_give_2() -> void:
	var ctrl := _at_camp()
	ctrl.execute(ExpeditionCommand.rest(_acts("prayer", "prayer", "vigil")))
	assert_eq(ctrl.state.next_battle_fervor, 2)
	var ctrl3 := _at_camp()
	ctrl3.execute(ExpeditionCommand.rest(_acts("prayer", "prayer", "prayer")))
	assert_eq(ctrl3.state.next_battle_fervor, 2)


func test_prayer_fervor_enters_the_next_battle_in_round_1() -> void:
	var ctrl := _at_camp()
	ctrl.execute(ExpeditionCommand.rest(_acts("prayer", "vigil", "vigil")))
	ctrl._start_battle(&"m0_hard_01", &"test_battle")
	assert_eq(ctrl.battle.fervor.amount, cat.constants.get_int(&"fervor_per_round") + 1)
	assert_eq(ctrl.state.next_battle_fervor, 0, "o bônus vale para um combate só")


func test_benedict_lectio_lowers_the_whole_party_by_15() -> void:
	var ctrl := _at_camp()
	for id: StringName in ctrl.saints:
		ctrl.saints[id].desolation = 40
	ctrl.execute(ExpeditionCommand.rest(_acts("prayer", "own", "prayer")))
	for id: StringName in ctrl.saints:
		assert_eq(ctrl.saints[id].desolation, 25, String(id))


func test_therese_little_sacrifices_heal_15_percent_of_the_party() -> void:
	var ctrl := _at_camp()
	for id: StringName in ctrl.saints:
		ctrl.saints[id].hp = 1
	ctrl.execute(ExpeditionCommand.rest(_acts("prayer", "prayer", "own")))
	for id: StringName in ctrl.saints:
		var s: SaintStatus = ctrl.saints[id]
		assert_eq(s.hp, 1 + Damage.round_half_up(s.max_hp * 0.15), String(id))


func test_george_guard_halves_the_ambush_chance() -> void:
	var ctrl := _at_camp()
	ctrl.state.light = 80
	assert_almost_eq(ctrl.ambush_chance(), 0.25 * 0.5, 0.0001, "Lume alto: × 0,5")
	assert_almost_eq(ctrl.ambush_chance(0.5), 0.25 * 0.5 * 0.5, 0.0001, "com a Guarda de Jorge")
	ctrl.state.light = 50
	assert_almost_eq(ctrl.ambush_chance(), 0.25, 0.0001)


func test_E07_ambush_with_incense_is_cancelled_and_incense_spent() -> void:
	var ctrl := _at_camp(_certain_ambush())
	assert_eq(ctrl.state.provisions.count(&"incense"), 1)
	ctrl.execute(ExpeditionCommand.rest(_acts("vigil", "vigil", "vigil")))
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_CAMP)
	assert_eq(ctrl.state.provisions.count(&"incense"), 0)


func test_D143_ambush_is_a_hard_battle_that_gets_the_prayer_fervor() -> void:
	var kit: Array[StringName] = [&"bread", &"candle"]
	var ctrl := _at_camp(_certain_ambush(), kit)
	ctrl.execute(ExpeditionCommand.rest(_acts("prayer", "prayer", "vigil")))
	assert_eq(ctrl.phase, ExpeditionController.Phase.IN_BATTLE)
	assert_eq(ctrl.battle.fervor.amount, cat.constants.get_int(&"fervor_per_round") + 2)
	var steps: int = 0
	while ctrl.phase == ExpeditionController.Phase.IN_BATTLE and steps < 500:
		assert_eq(ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle))), &"")
		steps += 1
	if ctrl.last_battle.phase == BattleController.Phase.VICTORY:
		assert_eq(ctrl.phase, ExpeditionController.Phase.AT_CAMP)
		assert_eq(ctrl.state.alms_unbanked, 0, "Esmolas da emboscada garantidas no Pouso")


func test_leaving_the_camp_ends_the_m1_leg_and_keeps_the_alms() -> void:
	var ctrl := _at_camp()
	ctrl.state.alms_banked = 210
	assert_eq(ctrl.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_RETREAT)), &"")
	assert_eq(ctrl.ended_reason, ExpeditionController.END_PLANNED_RETREAT)
	assert_eq(ctrl.state.alms_banked, 210)
	var other := _at_camp()
	other.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))
	assert_eq(other.ended_reason, ExpeditionController.END_LEG_COMPLETE)


func test_a_whole_leg_with_rest_replays_exactly() -> void:
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 3, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	var steps: int = 0
	while not ctrl.is_over() and steps < 3000:
		steps += 1
		match ctrl.phase:
			ExpeditionController.Phase.AT_FORK:
				ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
			ExpeditionController.Phase.PENDING:
				ctrl.execute(ExpeditionCommand.engage_node())
			ExpeditionController.Phase.IN_NODE:
				ctrl.execute(ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_EVENT:
				ctrl.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
			ExpeditionController.Phase.IN_RELIC:
				ctrl.execute(ExpeditionCommand.place_relic(&"saint_george"))
			ExpeditionController.Phase.IN_BATTLE:
				ctrl.execute(ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
			ExpeditionController.Phase.AT_CAMP:
				if not ctrl.state.camp_rested and ctrl.state.provisions.has(&"bread"):
					ctrl.execute(ExpeditionCommand.rest(_acts("own", "own", "own")))
				else:
					ctrl.execute(ExpeditionCommand.leave_camp(ExpeditionCommand.MODE_CONTINUE))
	assert_true(ctrl.is_over())
	var again := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
	assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(ctrl.snapshot()))
