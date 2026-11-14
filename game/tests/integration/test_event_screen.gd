extends GutTest
## T28: event screen (screens §6, narrative-system §3 and §4.1) — the
## Temptation of the M1 played by touch in every option: pages, who speaks,
## options with requirement and chance written, origin label, result.

const MAX_LAYERS: int = 10
const EVENT_ID: StringName = &"c02_temptation_wind_shelter"

var data: GameData
var cat: ExpeditionCatalog
var sent: Array[ExpeditionCommand] = []


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func before_each() -> void:
	sent.clear()


## An expedition walked (preferring Temptation entrances) until its event opens.
func _at_temptation(seed: int) -> ExpeditionController:
	var c := ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
	for i: int in MAX_LAYERS:
		if c.phase == ExpeditionController.Phase.IN_EVENT:
			return c
		if c.phase != ExpeditionController.Phase.AT_FORK:
			DevNodeResolver.resolve(c, c.execute)
			continue
		var pick: MapNode = c.entrances()[0]
		for n: MapNode in c.entrances():
			if n.type == MapNode.TYPE_TEMPTATION:
				pick = n
		assert_eq(c.execute(ExpeditionCommand.choose_path(pick.id)), &"")
		if c.phase == ExpeditionController.Phase.PENDING and pick.type == MapNode.TYPE_TEMPTATION:
			assert_eq(c.execute(ExpeditionCommand.engage_node()), &"")
	return c if c.phase == ExpeditionController.Phase.IN_EVENT else null


func _screen(c: ExpeditionController) -> EventScreen:
	var s := EventScreen.new()
	s.setup(data, c, func(cmd: ExpeditionCommand) -> StringName:
		sent.append(cmd)
		return c.execute(cmd))
	add_child_autofree(s)
	return s


func _first_event(seed_from: int = 1) -> ExpeditionController:
	for seed: int in range(seed_from, seed_from + 20):
		var c := _at_temptation(seed)
		if c != null:
			return c
	fail_test("nenhuma semente chegou à Tentação")
	return null


func _to_options(s: EventScreen) -> void:
	while not s.options_shown():
		s.press_next()


# --- acceptance: the M1 Temptation by touch, every option -----------------------------

func test_every_option_of_the_temptation_is_played_by_touch() -> void:
	var event: EventDef = cat.events[EVENT_ID]
	for option: Dictionary in event.options:
		var id := StringName(str(option.get("id", "")))
		sent.clear()
		var c := _first_event()
		assert_eq(c.event.id, EVENT_ID)
		# Faith 3 for the prayer option (N01 is checked below).
		c.virtues.values[Virtues.FAITH] = 3
		var s := _screen(c)
		_to_options(s)
		assert_false(s.option_disabled(id), "opção %s disponível" % id)
		s.tap_option(id)
		assert_eq(sent.size(), 0, "o primeiro toque não envia comando")
		s.tap_option(id)
		assert_eq(sent.size(), 1, "o segundo toque envia ChooseOption")
		assert_eq(sent[0].type, ExpeditionCommand.CHOOSE_OPTION)
		assert_eq(sent[0].node_id, id)
		assert_true(s.result_shown())
		var expected: Array[String] = []
		for key: String in ["result_pt", "success_pt", "failure_pt"]:
			if str(option.get(key, "")) != "":
				expected.append(str(option[key]))
		var found := false
		for text: String in expected:
			found = found or s.result_shown() and s.text_shown().contains(text)
		assert_true(found, "texto do resultado de %s: %s" % [id, s.text_shown()])
		var done: Array[bool] = [false]
		s.finished.connect(func() -> void: done[0] = true)
		s.press_next()
		assert_true(done[0], "Seguir fecha o evento")
		assert_ne(c.phase, ExpeditionController.Phase.IN_EVENT)


# --- pages and speakers ---------------------------------------------------------

func test_pages_advance_one_tap_at_a_time_with_who_speaks() -> void:
	var c := _first_event()
	var s := _screen(c)
	var event: EventDef = c.event
	assert_eq(s.page_count(), event.pages.size())
	for i: int in event.pages.size():
		var page: Dictionary = event.pages[i]
		assert_eq(s.text_shown(), str(page["text_pt"]))
		var speaker := StringName(str(page["speaker"]))
		if speaker == EventTexts.NARRATOR:
			assert_eq(s.speaker_shown(), "", "o narrador não tem nome (D-151)")
		else:
			assert_eq(s.speaker_shown(), data.ui.text(StringName("speaker_%s" % speaker)))
		assert_eq(s.options_shown(), i == event.pages.size() - 1, "opções só na última página")
		s.press_next()


func test_the_tempter_is_the_voice_in_the_storm() -> void:
	var c := _first_event()
	var s := _screen(c)
	s.press_next()
	assert_eq(s.speaker_shown(), "A voz na tempestade", "D-152")


func test_origin_label_and_illustration() -> void:
	var c := _first_event()
	var s := _screen(c)
	assert_eq(s.origin_shown(), data.ui.text(&"origin_game_fiction"))
	assert_not_null(s.background_texture(), "ilustração do evento ao fundo")
	assert_gt(s.size.x, 0.0)
	assert_eq(s.stage_position(), ((s.size - EventScreen.STAGE_SIZE) * 0.5).floor())


# --- options: requirement and chance written on the button ---------------------------

func test_n01_unmet_requirement_is_disabled_and_written() -> void:
	var c := _first_event()
	c.virtues.values[Virtues.FAITH] = 2
	var s := _screen(c)
	_to_options(s)
	assert_true(s.option_disabled(&"pray_for_pilgrim"))
	assert_true(s.option_text(&"pray_for_pilgrim").contains("Exige Fé 3"), s.option_text(&"pray_for_pilgrim"))
	s.tap_option(&"pray_for_pilgrim")
	s.tap_option(&"pray_for_pilgrim")
	assert_eq(sent.size(), 0, "opção bloqueada não envia comando")
	assert_eq(s.hint_shown(), data.ui.text(&"event_option_blocked"))


func test_n03_chance_is_written_with_what_helps() -> void:
	var c := _first_event()
	var s := _screen(c)
	_to_options(s)
	var text: String = s.option_text(&"enter_tent")
	var pct: int = roundi(c.option_chance(&"enter_tent") * 100.0)
	assert_eq(pct, 90, "50% + Bento 20% + Água Benta 20%")
	assert_true(text.contains("Chance 90%"), text)
	assert_true(text.contains("São Bento na equipe"), text)
	assert_true(text.contains("gasta Água Benta"), text)


func test_safe_option_has_no_chance_written() -> void:
	var c := _first_event()
	var s := _screen(c)
	_to_options(s)
	assert_false(s.option_text(&"follow_tracks").contains("Chance"), s.option_text(&"follow_tracks"))


func test_result_lists_what_changed() -> void:
	var c := _first_event()
	var s := _screen(c)
	_to_options(s)
	var light_before: int = c.state.light
	s.tap_option(&"follow_tracks")
	s.tap_option(&"follow_tracks")
	assert_eq(c.state.light, light_before - 5)
	assert_true(s.text_shown().contains(data.ui.text(&"event_change_light", {"delta": "−5"})), s.text_shown())


func test_signed_numbers_use_a_minus_sign() -> void:
	assert_eq(EventTexts.signed(5), "+5")
	assert_eq(EventTexts.signed(-15), "−15")


func test_every_event_text_exists_in_the_data() -> void:
	var keys: Array[String] = [
		"speaker_demon_tempter", "event_next", "event_continue", "event_hint_choose", "event_hint_confirm",
		"event_option_blocked", "event_chance", "event_chance_with", "event_requires_virtue",
		"event_requires_saint", "event_requires_provision", "event_requires_alms", "event_requires_flag",
		"event_helps_saint", "event_helps_provision", "event_helps_provision_spent", "event_helps_relic",
		"event_change_light", "event_change_virtue", "event_change_desolation", "event_change_alms",
		"event_change_provision", "event_change_battle",
	]
	for origin: String in ["scripture", "catechism", "tradition", "hagiography", "legend", "apocrypha", "dante", "demonology", "game_fiction"]:
		keys.append("origin_%s" % origin)
	for id: StringName in Virtues.ALL:
		keys.append(String(id))
	for code: StringName in [ExpeditionController.REJECT_WRONG_PHASE, ExpeditionController.REJECT_UNKNOWN_OPTION, ExpeditionController.REJECT_REQUIREMENT]:
		keys.append("event_reason_%s" % code)
	for event: EventDef in cat.events.values():
		for page: Dictionary in event.pages:
			var speaker := StringName(str(page["speaker"]))
			if speaker != EventTexts.NARRATOR:
				keys.append("speaker_%s" % speaker)
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)
