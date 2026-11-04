extends GutTest
## T29: camp screen (screens §5, expedition §6) — portraits with hit points
## and desolation, one activity per saint, Rest / Continue / Planned retreat
## by touch (second tap confirms), the ambush result and the way back.

const MAX_STEPS: int = 3000

var data: GameData
var cat: ExpeditionCatalog
var sent: Array[ExpeditionCommand] = []


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func before_each() -> void:
	sent.clear()


## An expedition walked to its camp (first entrances, nodes finished by
## DevNodeResolver), or null if the party fell on the way.
func _at_camp(seed: int) -> ExpeditionController:
	var c := ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	for i: int in 12:
		if c.phase == ExpeditionController.Phase.AT_CAMP or c.is_over():
			break
		if c.phase == ExpeditionController.Phase.AT_FORK:
			assert_eq(c.execute(ExpeditionCommand.choose_path(c.entrances()[0].id)), &"")
		else:
			DevNodeResolver.resolve(c, c.execute)
	return c if c.phase == ExpeditionController.Phase.AT_CAMP else null


func _camp(seed_from: int = 1) -> ExpeditionController:
	for seed: int in range(seed_from, seed_from + 30):
		var c := _at_camp(seed)
		if c != null:
			return c
	fail_test("nenhuma semente chegou ao Pouso")
	return null


func _screen(c: ExpeditionController) -> CampScreen:
	var s := CampScreen.new()
	s.setup(data, c, func(cmd: ExpeditionCommand) -> StringName:
		sent.append(cmd)
		return c.execute(cmd))
	add_child_autofree(s)
	return s


func _plan_vigil(s: CampScreen) -> void:
	for id: StringName in s.ctrl.state.party:
		s.choose_activity(id, ExpeditionController.ACTIVITY_VIGIL)


# --- acceptance: rest and continue by touch -------------------------------------------

func test_rest_and_continue_by_touch() -> void:
	var c := _camp()
	var s := _screen(c)
	var bread: int = c.state.provisions.count(&"bread")
	s.choose_activity(&"saint_george", ExpeditionController.ACTIVITY_OWN)
	s.choose_activity(&"saint_benedict", ExpeditionController.ACTIVITY_PRAYER)
	s.choose_activity(&"saint_therese", ExpeditionController.ACTIVITY_SHARE)
	s.choose_target(&"saint_therese", &"saint_george")
	s.press_rest()
	assert_eq(sent.size(), 0, "o primeiro toque em Descansar só pede confirmação")
	assert_eq(s.info_text(), data.ui.text(&"camp_confirm_rest"))
	s.press_rest()
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].type, ExpeditionCommand.REST)
	assert_eq(sent[0].activities.size(), 3)
	assert_true(c.state.camp_rested)
	assert_eq(c.state.provisions.count(&"bread"), bread - 1, "custou 1 Pão")
	assert_true(s.result_shown())
	assert_true(s.result_text().contains(data.ui.text(&"camp_change_bread", {"delta": "−1"})), s.result_text())
	if c.phase == ExpeditionController.Phase.IN_BATTLE:
		pass_test("emboscada nesta semente; o caminho de volta tem teste próprio")
		return
	s.press_result_continue()
	assert_true(s.fixed_button(CampScreen.FIXED_REST).disabled, "só se descansa uma vez")
	var left: Array[bool] = [false]
	s.left_camp.connect(func() -> void: left[0] = true)
	s.press_continue()
	assert_false(left[0], "o primeiro toque em Seguir só pede confirmação")
	s.press_continue()
	assert_true(left[0])
	assert_eq(c.ended_reason, ExpeditionController.END_LEG_COMPLETE)


func test_rest_needs_an_activity_for_every_saint() -> void:
	var c := _camp()
	var s := _screen(c)
	s.choose_activity(&"saint_george", ExpeditionController.ACTIVITY_VIGIL)
	s.press_rest()
	s.press_rest()
	assert_eq(sent.size(), 0)
	assert_eq(s.info_text(), data.ui.text(&"camp_reason_bad_activity"))


func test_share_asks_for_another_saint() -> void:
	var c := _camp()
	var s := _screen(c)
	s.choose_activity(&"saint_therese", ExpeditionController.ACTIVITY_SHARE)
	assert_true(s.target_buttons_shown(&"saint_therese"))
	assert_eq(s.asking_target, &"saint_therese")
	s.choose_target(&"saint_therese", &"saint_benedict")
	assert_eq(s.asking_target, &"")
	assert_eq(s.activities()[s.activities().size() - 1]["target"], &"saint_benedict")
	s.choose_activity(&"saint_therese", ExpeditionController.ACTIVITY_VIGIL)
	assert_false(s.target_buttons_shown(&"saint_therese"), "Vigília não pede alvo")


func test_without_bread_rest_says_why() -> void:
	var c := _camp()
	while c.state.provisions.has(&"bread"):
		c.state.provisions.erase(&"bread")
	var s := _screen(c)
	_plan_vigil(s)
	s.press_rest()
	assert_eq(sent.size(), 0)
	assert_eq(s.info_text(), data.ui.text(&"camp_reason_no_bread"))


func test_planned_retreat_by_touch() -> void:
	var c := _camp()
	var s := _screen(c)
	s.press_retreat()
	s.press_retreat()
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].mode, ExpeditionCommand.MODE_RETREAT)
	assert_eq(c.ended_reason, ExpeditionController.END_PLANNED_RETREAT)


# --- acceptance: the ambush leads to battle and back ----------------------------------

func test_ambush_leads_to_battle_and_back_to_the_camp() -> void:
	for seed: int in range(1, 80):
		var c := _at_camp(seed)
		if c == null:
			continue
		# Without Incense the ambush is not cancelled (E07).
		while c.state.provisions.has(&"incense"):
			c.state.provisions.erase(&"incense")
		if not c.state.provisions.has(&"bread"):
			continue
		var s := _screen(c)
		_plan_vigil(s)
		s.press_rest()
		s.press_rest()
		if c.phase != ExpeditionController.Phase.IN_BATTLE:
			s.queue_free()
			continue
		assert_true(s.result_text().contains(data.ui.text(&"camp_ambush_battle")), s.result_text())
		var started: Array[bool] = [false]
		s.battle_started.connect(func() -> void: started[0] = true)
		s.press_result_continue()
		assert_true(started[0], "Continuar leva ao combate da emboscada")
		DevNodeResolver.resolve(c, c.execute)
		if c.is_over():
			pass_test("a equipe caiu na emboscada (semente %d)" % seed)
			return
		assert_eq(c.phase, ExpeditionController.Phase.AT_CAMP, "de volta ao Pouso")
		s.refresh()
		assert_true(s.fixed_button(CampScreen.FIXED_REST).disabled)
		s.press_continue()
		s.press_continue()
		assert_true(c.is_over())
		return
	fail_test("nenhuma emboscada em 80 sementes")


func test_ambush_cancelled_by_incense_is_written() -> void:
	for seed: int in range(1, 80):
		var c := _at_camp(seed)
		if c == null or not c.state.provisions.has(&"incense") or not c.state.provisions.has(&"bread"):
			continue
		var s := _screen(c)
		_plan_vigil(s)
		s.press_rest()
		s.press_rest()
		if s.result_text().contains(data.ui.text(&"camp_ambush_cancelled")):
			assert_false(c.state.provisions.has(&"incense"), "o Incenso foi gasto (E07)")
			assert_eq(c.phase, ExpeditionController.Phase.AT_CAMP)
			return
		s.queue_free()
	fail_test("nenhuma emboscada anulada em 80 sementes")


# --- cards and texts --------------------------------------------------------------

func test_cards_show_portrait_hit_points_and_desolation() -> void:
	var c := _camp()
	var s := _screen(c)
	for id: StringName in c.state.party:
		var status: SaintStatus = c.saints[id]
		assert_not_null(s.portrait_of(id), "retrato de %s" % id)
		assert_true(s.card_text(id).contains(data.ui.text(&"hp", {"hp": status.hp, "max": status.max_hp})), s.card_text(id))
		assert_true(s.card_text(id).contains(data.ui.text(&"desolation", {"value": status.desolation})), s.card_text(id))
		assert_not_null(s.activity_button(id, ExpeditionController.ACTIVITY_OWN), "atividade própria de %s" % id)
	assert_eq(s.activity_button(&"saint_george", ExpeditionController.ACTIVITY_OWN).text, "Guarda")
	assert_true(s.fixed_button(CampScreen.FIXED_REST).text.contains("1 Pão"), "Descansar mostra o custo")
	assert_eq(s.stage_position(), ((s.size - CampScreen.STAGE_SIZE) * 0.5).floor())


func test_every_camp_text_exists_in_the_data() -> void:
	var keys: Array[String] = [
		"camp_bread", "camp_rest", "camp_rest_cost", "camp_continue", "camp_retreat", "camp_vigil_desc",
		"camp_share_desc", "camp_prayer_desc", "camp_choose_target", "camp_injury_minor", "camp_injury_major",
		"camp_confirm_rest", "camp_confirm_continue", "camp_confirm_retreat", "camp_change_hp",
		"camp_change_desolation", "camp_change_injury_healed", "camp_change_bread", "camp_bread_kept",
		"camp_change_fervor", "camp_ambush_none", "camp_ambush_cancelled", "camp_ambush_battle", "walk_test_ambush",
	]
	for activity: StringName in [ExpeditionController.ACTIVITY_VIGIL, ExpeditionController.ACTIVITY_SHARE, ExpeditionController.ACTIVITY_PRAYER]:
		keys.append("camp_%s" % activity)
	for code: StringName in [ExpeditionController.REJECT_NO_BREAD, ExpeditionController.REJECT_ALREADY_RESTED, ExpeditionController.REJECT_BAD_ACTIVITY, ExpeditionController.REJECT_WRONG_PHASE, ExpeditionController.REJECT_UNKNOWN_COMMAND]:
		keys.append("camp_reason_%s" % code)
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)
