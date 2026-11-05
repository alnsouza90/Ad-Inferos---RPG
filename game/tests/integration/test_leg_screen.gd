extends GutTest
## T30: the whole leg (screens §2, M1 flow) — title, preparation, walk,
## battles inside the expedition, Temptation, relic, camp and summary, all
## by the screens' touch functions; closing and reopening on each kind of
## screen lands on the same point (save-load §4).

const MAX_STEPS: int = 4000
const CAMPAIGN_SEED: int = 5

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _new_ctrl(seed: int) -> ExpeditionController:
	var map_seed: int = ExpeditionController.map_seed_for(seed, TitleScreen.CIRCLE, TitleScreen.EXPEDITION_NUMBER)
	return ExpeditionController.start_new(cat, TitleScreen.CIRCLE, map_seed, GameData.M0_FORMATION, cat.kit_provisions(TitleScreen.KIT), EncounterDef.ARENA_CIRCLE)


func _leg(ctrl: ExpeditionController) -> LegScreen:
	var leg := LegScreen.new()
	leg.use_game_state = false
	leg.speed_index = BattleScreen.SPEED_INSTANT
	leg.setup(data, cat, ctrl)
	add_child_autofree(leg)
	return leg


## One touch on whatever screen is shown. Returns false at the summary.
func _touch(leg: LegScreen) -> bool:
	match leg.screen_kind():
		&"walk":
			var walk: WalkScreen = leg.current
			var ids: Array[StringName] = walk.entrance_ids()
			var pick: StringName = ids[ids.size() - 1]
			walk.tap_entrance(pick)
			walk.tap_entrance(pick)
		&"battle":
			_battle_touch(leg.current as BattleScreen, leg.ctrl)
		&"event":
			_event_touch(leg.current as EventScreen)
		&"relic":
			var carrier: StringName = &""
			for id: StringName in leg.ctrl.state.party:
				if leg.ctrl.has_free_slot(id):
					carrier = id
					break
			leg.press_relic(carrier)
			leg.press_relic(carrier)
		&"node":
			leg.press_node_continue()
		&"camp":
			_camp_touch(leg.current as CampScreen)
		&"summary":
			return false
	return true


func _battle_touch(battle: BattleScreen, ctrl: ExpeditionController) -> void:
	if battle.result_shown():
		battle.press_back()
		return
	var cmd: BattleCommand = DevNodeResolver.battle_command(ctrl.battle)
	if cmd.type == BattleCommand.END_PARTY_TURN:
		battle.press_end_turn()
		if battle.confirm_shown():
			battle.press_confirm()
	else:
		battle.send(cmd)


func _event_touch(screen: EventScreen) -> void:
	if screen.result_shown():
		screen.press_next()
	elif not screen.options_shown():
		screen.press_next()
	else:
		for id: StringName in screen.option_ids():
			if not screen.option_disabled(id):
				screen.tap_option(id)
				screen.tap_option(id)
				return


func _camp_touch(camp: CampScreen) -> void:
	if camp.result_shown():
		camp.press_result_continue()
	elif not camp.ctrl.state.camp_rested and camp.ctrl.state.provisions.has(&"bread"):
		for id: StringName in camp.ctrl.state.party:
			camp.choose_activity(id, ExpeditionController.ACTIVITY_VIGIL)
		camp.press_rest()
		camp.press_rest()
	else:
		camp.press_continue()
		camp.press_continue()


func _play_to_summary(leg: LegScreen) -> Array[StringName]:
	var seen: Array[StringName] = []
	for i: int in MAX_STEPS:
		var kind: StringName = leg.screen_kind()
		if not seen.has(kind):
			seen.append(kind)
		if not _touch(leg):
			break
	return seen


## The save of `ctrl` written and read back as text, then a new screen on it.
func _reopen(ctrl: ExpeditionController) -> LegScreen:
	var saved: Dictionary = JSON.parse_string(JSON.stringify(ExpeditionSave.build(ctrl, CAMPAIGN_SEED)))
	var restored: ExpeditionController = ExpeditionSave.restore(cat, saved)
	assert_not_null(restored, "o save volta a ser lido")
	return _leg(restored)


# --- acceptance: a whole leg only by touches -------------------------------------------

func test_a_whole_leg_is_played_only_by_touches() -> void:
	for seed: int in [1, 2, 3]:
		var ctrl := _new_ctrl(seed)
		var leg := _leg(ctrl)
		var seen: Array[StringName] = _play_to_summary(leg)
		assert_eq(leg.screen_kind(), &"summary", "semente %d terminou no resumo (%s)" % [seed, seen])
		assert_true(ctrl.is_over())
		assert_true(seen.has(&"walk") and seen.has(&"battle"), "semente %d: %s" % [seed, seen])
		var again := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
		assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(ctrl.snapshot()), "tudo passou por comandos registrados")
		leg.queue_free()


func test_battles_inside_the_leg_are_logged_by_the_expedition() -> void:
	var ctrl := _new_ctrl(1)
	var leg := _leg(ctrl)
	for i: int in 20:
		if leg.screen_kind() == &"battle":
			break
		_touch(leg)
	assert_eq(leg.screen_kind(), &"battle")
	var battle: BattleScreen = leg.current
	assert_false(battle.dev_tools_shown(), "sem botões de teste dentro da expedição")
	var before: int = ctrl.command_log.size()
	_battle_touch(battle, ctrl)
	assert_eq(ctrl.command_log.size(), before + 1, "a ação do combate entrou no log da expedição")
	assert_eq(ctrl.command_log[before]["type"], String(ExpeditionCommand.BATTLE))


# --- acceptance: close and reopen on each kind of screen ---------------------------------

func test_reopening_on_each_kind_of_screen_lands_on_the_same_point() -> void:
	var checked: Array[StringName] = []
	for seed: int in range(1, 12):
		var ctrl := _new_ctrl(seed)
		var leg := _leg(ctrl)
		var acted_in_battle := false
		for i: int in MAX_STEPS:
			var kind: StringName = leg.screen_kind()
			var mid_turn: bool = kind == &"battle" and acted_in_battle and not (leg.current as BattleScreen).result_shown()
			var key: StringName = &"battle_mid_turn" if mid_turn else kind
			if not checked.has(key) and not (kind == &"battle" and (leg.current as BattleScreen).result_shown()):
				var again := _reopen(ctrl)
				assert_eq(again.screen_kind(), kind, "volta à mesma tela: %s" % key)
				assert_eq(JSON.stringify(again.ctrl.snapshot()), JSON.stringify(ctrl.snapshot()), "mesmo estado: %s" % key)
				if kind == &"battle":
					assert_eq(again.ctrl.battle.command_log, ctrl.battle.command_log, "mesmo ponto do turno")
				checked.append(key)
				again.queue_free()
			if kind == &"battle":
				acted_in_battle = ctrl.battle != null and not ctrl.battle.command_log.is_empty() and ctrl.battle.command_log[ctrl.battle.command_log.size() - 1]["type"] != "EndPartyTurn"
			if not _touch(leg):
				break
		leg.queue_free()
	for kind: StringName in [&"walk", &"battle", &"battle_mid_turn", &"event", &"camp", &"summary"]:
		assert_true(checked.has(kind), "testado reabrir em %s (%s)" % [kind, checked])


# --- relic panel ----------------------------------------------------------------

func test_relic_carrier_is_chosen_with_a_second_tap() -> void:
	for seed: int in range(1, 60):
		var ctrl := _new_ctrl(seed)
		var leg := _leg(ctrl)
		for i: int in 200:
			if leg.screen_kind() == &"relic" or ctrl.is_over():
				break
			if leg.screen_kind() == &"walk":
				var walk: WalkScreen = leg.current
				var pick: StringName = walk.entrance_ids()[0]
				for id: StringName in walk.entrance_ids():
					if ctrl.map.find(id).type == MapNode.TYPE_RELIC:
						pick = id
				walk.tap_entrance(pick)
				walk.tap_entrance(pick)
			else:
				_touch(leg)
		if leg.screen_kind() != &"relic":
			leg.queue_free()
			continue
		var relic: RelicDef = cat.relic(ctrl.state.pending_relic)
		assert_true(leg.panel_text().contains(relic.name_pt), leg.panel_text())
		var log_size: int = ctrl.command_log.size()
		leg.press_relic(&"saint_george")
		assert_eq(ctrl.command_log.size(), log_size, "o primeiro toque só escolhe")
		assert_true(leg.panel_text().contains(data.ui.text(&"relic_confirm")))
		leg.press_relic(&"saint_george")
		assert_eq(ctrl.command_log.size(), log_size + 1)
		assert_true((ctrl.saints[&"saint_george"] as SaintStatus).relics.has(relic.id), "Jorge carrega a relíquia (D-146)")
		assert_ne(leg.screen_kind(), &"relic")
		return
	fail_test("nenhum nó de relíquia em 60 sementes")


# --- summary --------------------------------------------------------------------

func test_summary_shows_alms_saints_and_virtues() -> void:
	var ctrl := _new_ctrl(1)
	var leg := _leg(ctrl)
	_play_to_summary(leg)
	var text: String = leg.panel_text()
	assert_true(text.contains(data.ui.text(StringName("walk_end_%s" % ctrl.ended_reason))), text)
	assert_true(text.contains(data.ui.text(&"summary_alms", {"banked": ctrl.state.alms_banked, "unbanked": ctrl.state.alms_unbanked})), text)
	for id: StringName in ctrl.state.party:
		assert_true(text.contains((data.saints[id] as SaintDef).name_pt), text)
	assert_true(text.contains("Fé %d" % ctrl.virtues.get_value(Virtues.FAITH)), text)
	var asked: Array[bool] = [false]
	leg.title_requested.connect(func() -> void: asked[0] = true)
	leg.press_title()
	assert_true(asked[0])


# --- title and preparation ---------------------------------------------------------

func _title() -> TitleScreen:
	var title := TitleScreen.new()
	title.use_game_state = false
	title.fixed_seed = CAMPAIGN_SEED
	title.speed_override = BattleScreen.SPEED_INSTANT
	title.setup(data, cat)
	add_child_autofree(title)
	return title


func test_new_leg_goes_through_preparation_to_the_walk() -> void:
	var title := _title()
	assert_true(title.menu_shown())
	title.press_new_leg()
	assert_false(title.menu_shown())
	assert_eq(StringName(str(title.screen.get_meta(&"kind", ""))), &"preparation")
	title.press_depart()
	assert_not_null(title.leg)
	assert_eq(title.leg.screen_kind(), &"walk")
	var expected: int = ExpeditionController.map_seed_for(CAMPAIGN_SEED, TitleScreen.CIRCLE, TitleScreen.EXPEDITION_NUMBER)
	assert_eq(title.leg.ctrl.state.map_seed, expected)
	assert_eq(title.leg.ctrl.state.provisions, cat.kit_provisions(TitleScreen.KIT), "parte com o kit (D-123)")
	title.leg.press_title()
	assert_true(title.menu_shown(), "o resumo volta ao título")


func test_continue_is_off_without_a_save() -> void:
	var title := _title()
	assert_false(title.has_save())
	assert_true(title._continue.disabled)


func test_arena_opens_from_the_title_only_in_dev_builds() -> void:
	var title := _title()
	title.dev_tools = false
	title.press_arena()
	assert_true(title.menu_shown())
	title.dev_tools = true
	title.press_arena()
	assert_true(title.screen is ArenaScreen)
	(title.screen as ArenaScreen).press_title()
	assert_true(title.menu_shown())


func test_map_seed_depends_on_campaign_and_expedition() -> void:
	var a: int = ExpeditionController.map_seed_for(1, &"circle_02", 1)
	assert_eq(a, ExpeditionController.map_seed_for(1, &"circle_02", 1))
	assert_ne(a, ExpeditionController.map_seed_for(1, &"circle_02", 2))
	assert_ne(a, ExpeditionController.map_seed_for(2, &"circle_02", 1))


func test_every_flow_text_exists_in_the_data() -> void:
	var keys: Array[String] = [
		"back_to_title", "result_continue", "title_name", "title_subtitle", "title_continue", "title_new_leg",
		"title_arena", "title_confirm_new", "title_no_save", "title_save_corrupt", "title_save_future",
		"title_save_from_backup", "prep_title", "prep_party", "prep_kit", "prep_depart", "prep_back",
		"relic_found", "relic_give", "relic_pack", "relic_no_slot", "relic_confirm", "node_empty",
		"node_continue", "summary_title", "summary_alms", "summary_saint", "summary_virtues", "summary_relics",
	]
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)
