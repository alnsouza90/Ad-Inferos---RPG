extends GutTest
## T62: Interceder and the gift of Consolation on the battle screen
## (combat §4.1, D-268, D-285), and the clock of the battle-end desolation
## (desolation §8, D-269). The screen only asks the controller: options from
## validate(), numbers from preview().

const SEED: int = 3

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _screen() -> BattleScreen:
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	screen.setup(data, BattleController.new(data.battle(&"m0_easy_01", SEED)))
	add_child_autofree(screen)
	return screen


func _entry(screen: BattleScreen, id: StringName) -> PreviewEntry:
	for e: PreviewEntry in screen.selection.preview:
		if e.target_id == id:
			return e
	return null


func test_intercede_is_greyed_until_an_ally_has_something_to_take() -> void:
	var screen: BattleScreen = _screen()
	screen.tap(&"saint_george")
	assert_eq(screen.selection.intercede_reason(), CommandResult.NOTHING_TO_TAKE)
	assert_true(screen._intercede_button.disabled)
	screen.ctrl.state.find(&"saint_benedict").desolation = 40
	screen.tap(&"saint_george")
	assert_eq(screen.selection.intercede_reason(), &"")
	assert_false(screen._intercede_button.disabled)


func test_intercede_flow_previews_then_confirms() -> void:
	var screen: BattleScreen = _screen()
	var ben: Combatant = screen.ctrl.state.find(&"saint_benedict")
	ben.desolation = 40
	screen.tap(&"saint_george")
	screen.press_intercede()
	assert_eq(screen.selection.mode, BattleSelection.Mode.INTERCEDE)
	assert_true(screen.selection.targetable_ids().has(&"saint_benedict"))
	assert_false(screen.selection.targetable_ids().has(&"saint_george"), "não intercede por si")
	screen.tap(&"saint_benedict")
	assert_eq(_entry(screen, &"saint_benedict").desolation, -15, "prévia: o aliado perde 15")
	assert_eq(_entry(screen, &"saint_george").desolation, 15, "prévia: quem intercede recebe 15")
	assert_string_contains(screen.hint_text(), "15")
	screen.press_intercede()  # only one thing to take: the button confirms
	assert_eq(ben.desolation, 25)
	assert_eq(screen.ctrl.state.find(&"saint_george").desolation, 15)


func test_the_button_switches_between_desolation_and_a_condition() -> void:
	var screen: BattleScreen = _screen()
	var ben: Combatant = screen.ctrl.state.find(&"saint_benedict")
	ben.desolation = 40
	ben.conditions[&"bleed"] = 2
	screen.tap(&"saint_george")
	screen.press_intercede()
	screen.tap(&"saint_benedict")
	assert_eq(screen.selection.intercede_options, [&"", &"bleed"] as Array[StringName])
	screen.press_intercede()
	assert_eq(screen.selection.intercede_option(), &"bleed")
	assert_eq(_entry(screen, &"saint_george").applied.get(&"bleed", 0), 2, "prévia: as pilhas passam para Jorge")
	screen.tap(&"saint_benedict")  # confirm on the target
	assert_false(ben.has_condition(&"bleed"))
	assert_eq(screen.ctrl.state.find(&"saint_george").stacks(&"bleed"), 2)
	assert_eq(ben.desolation, 40)


func test_gift_of_consolation_needs_the_consolation_and_previews_30() -> void:
	var screen: BattleScreen = _screen()
	screen.ctrl.state.find(&"saint_therese").desolation = 70
	screen.tap(&"saint_george")
	assert_eq(screen.selection.give_consolation_reason(), CommandResult.NOT_IN_CONSOLATION)
	screen.ctrl.state.find(&"saint_george").spirit_state = Desolation.CONSOLATION
	screen.tap(&"saint_george")
	screen.press_give_consolation()
	screen.tap(&"saint_therese")
	assert_eq(_entry(screen, &"saint_therese").desolation, -30)
	screen.press_give_consolation()
	assert_eq(screen.ctrl.state.find(&"saint_therese").desolation, 40)
	assert_eq(screen.ctrl.state.find(&"saint_george").spirit_state, Desolation.NORMAL)


func test_the_round_shows_the_desolation_of_a_victory_now() -> void:
	var screen: BattleScreen = _screen()
	var expected: String = screen.texts.t(&"round_clock", {"round": 1, "amount": 23})
	assert_eq(screen._round_label.text, expected, "20 + 3 na 1ª rodada")
