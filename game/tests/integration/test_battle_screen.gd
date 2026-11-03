extends GutTest
## T15 acceptance: a whole battle played only through the screen's touch
## handlers, at instant speed, with the real M0 kits (built from the CSVs).
## The taps must produce exactly the commands the fixed policy sends straight
## to the controller.

const SEED: int = 4242
const MAX_ROUNDS: int = 40
const MAX_STEPS: int = 2000

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _screen(encounter_id: StringName, seed: int) -> BattleScreen:
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	screen.setup(data, BattleController.new(data.battle(encounter_id, seed)))
	add_child_autofree(screen)
	return screen


func _target_id(screen: BattleScreen, slot: int) -> StringName:
	var c: Combatant = screen.ctrl.state.party_at(slot) if screen.selection.side == BattleSelection.SIDE_PARTY else screen.ctrl.state.enemy_at(slot)
	return c.id if c != null else &""


## Plays `cmd` the way a player would: tap the saint, tap the action, tap
## each target, then tap again to confirm.
func _drive(screen: BattleScreen, cmd: BattleCommand) -> void:
	if cmd.type == BattleCommand.END_PARTY_TURN:
		screen.press_end_turn()
		if screen.confirm_shown():
			screen.press_confirm()
		return
	screen.tap(cmd.actor_id)
	if cmd.type == BattleCommand.PASS:
		screen.press_pass()
		screen.press_pass()
		return
	var actor: Combatant = screen.ctrl.state.find(cmd.actor_id)
	var press: Callable = screen.press_miracle
	if cmd.type == BattleCommand.USE_ABILITY:
		press = screen.press_ability.bind(actor.equipped.find(cmd.ability_id))
	press.call()
	for slot: int in cmd.target_slots:
		screen.tap(_target_id(screen, slot))
	if cmd.target_slots.is_empty():
		press.call()
	else:
		screen.tap(_target_id(screen, cmd.target_slots[0]))


func test_a_whole_battle_is_played_by_taps_and_matches_the_direct_commands() -> void:
	for encounter_id: String in RealData.m0_encounter_ids():
		var screen: BattleScreen = _screen(StringName(encounter_id), SEED)
		var steps := 0
		while not screen.ctrl.is_over() and screen.ctrl.state.round_number <= MAX_ROUNDS and steps < MAX_STEPS:
			steps += 1
			var before: int = screen.ctrl.command_log.size()
			var cmd: BattleCommand = FirstValidPolicy.choose(screen.ctrl)
			_drive(screen, cmd)
			if screen.ctrl.command_log.size() != before + 1:
				fail_test("%s: os toques não enviaram %s" % [encounter_id, cmd.to_dict()])
				return
		assert_true(screen.ctrl.is_over(), "%s terminou" % encounter_id)
		assert_true(screen.result_shown(), "%s mostra o resultado" % encounter_id)
		assert_eq(screen.ctrl.errors, [] as Array[String])
		var direct := BattleController.new(data.battle(StringName(encounter_id), SEED))
		direct.start()
		FirstValidPolicy.play(direct, MAX_ROUNDS)
		assert_eq(JSON.stringify(screen.ctrl.command_log), JSON.stringify(direct.command_log), "%s: mesmos comandos pelo toque e direto" % encounter_id)


func test_screen_shows_round_fervor_intents_and_hp() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	assert_eq(screen.ctrl.phase, BattleController.Phase.PARTY_TURN)
	assert_eq(screen.selection.actor_id, &"saint_george", "o primeiro santo pronto já vem escolhido")
	for c: Combatant in screen.ctrl.state.party + screen.ctrl.state.enemies:
		assert_not_null(screen.view_of(c.id), "%s tem uma CombatantView" % c.id)
	var enemy: Combatant = screen.ctrl.state.enemy_at(1)
	var intent_text: String = screen.texts.intent(screen.ctrl.state.intent_of(enemy))
	assert_false(intent_text.is_empty(), "a intenção do inimigo aparece")
	assert_false(intent_text.contains("["), "sem texto faltando: %s" % intent_text)
	assert_eq(screen.hint_text(), data.ui.text(&"hint_choose_action", {"saint": "São Jorge"}))


func test_tapping_a_saint_view_selects_it() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	screen.view_of(&"saint_therese")._gui_input(click)
	assert_eq(screen.selection.actor_id, &"saint_therese")


func test_end_turn_asks_first_while_a_saint_can_act() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	screen.press_end_turn()
	assert_true(screen.confirm_shown())
	screen.press_cancel()
	assert_eq(screen.ctrl.state.round_number, 1, "cancelar não encerra o turno")
	screen.press_end_turn()
	screen.press_confirm()
	assert_true(screen.ctrl.is_over() or screen.ctrl.state.round_number == 2)


func test_play_again_starts_a_fresh_battle() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	screen.press_retreat()
	assert_true(screen.result_shown())
	screen.press_play_again()
	assert_false(screen.result_shown())
	assert_eq(screen.ctrl.phase, BattleController.Phase.PARTY_TURN)
	assert_eq(screen.battle_seed, 2)


## Every key the screen asks for exists in docs/balance/ui_text.csv.
func test_every_screen_text_exists_in_the_data() -> void:
	var keys: Array[String] = [
		"round", "fervor", "pause", "resume", "retreat", "speed_normal", "speed_fast", "speed_instant",
		"miracle", "swap", "pass", "provisions", "end_turn", "cost_badge", "confirm", "cancel",
		"confirm_end_turn", "hint_select_saint", "hint_choose_action", "hint_choose_target", "hint_confirm",
		"hint_enemy_turn", "hp", "desolation", "acted", "slot", "conditions_more", "condition_stacks",
		"no_conditions", "state_fallen", "state_out", "state_remains", "state_dead", "intent_stunned",
		"intent_wait", "intent_value", "intent_slot", "intent_details", "preview_damage", "preview_heal",
		"preview_desolation_up", "preview_desolation_down", "preview_applied", "preview_removed",
		"polarity_negative", "polarity_positive", "preview_moved", "preview_falls", "preview_cancelled",
		"result_victory", "result_defeat", "result_retreat", "play_again", "reason_no_slot",
	]
	for icon: String in BalanceImporter.INTENT_ICONS:
		keys.append("intent_%s" % icon)
	for spirit: StringName in [Desolation.CONSOLATION, Desolation.DARK_NIGHT]:
		keys.append("spirit_%s" % spirit)
	var codes: Dictionary = (CommandResult.new().get_script() as Script).get_script_constant_map()
	for code: Variant in codes.values():
		keys.append("reason_%s" % code)
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)
