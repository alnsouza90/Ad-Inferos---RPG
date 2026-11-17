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


## T16/T36: every saint animated with its frames, the halo drawn by the
## engine over the head following desolation (D-258), portraits in the panel.
func test_saints_are_animated_with_a_halo_that_follows_desolation() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	var view: CombatantView = screen.view_of(&"saint_george")
	assert_not_null(view.player(), "Jorge aparece animado pelos quadros")
	assert_not_null(view.halo(), "auréola desenhada pelo motor")
	assert_not_null(screen.view_of(&"saint_benedict").player(), "Bento também")
	assert_not_null(screen.portrait_texture(), "o retrato de Jorge aparece no painel")
	screen.tap(&"saint_benedict")
	assert_not_null(screen.portrait_texture(), "e o de Bento")
	screen.tap(&"saint_george")
	var full: float = view.halo().brightness()
	var calm: Color = screen.portrait_tint()
	screen.ctrl.state.find(&"saint_george").desolation = 99
	screen.tap(&"saint_george")
	assert_lt(view.halo().brightness(), full, "a auréola perde brilho com a desolação")
	assert_ne(screen.portrait_tint(), calm, "a moldura do retrato muda de cor com a desolação (D-258)")


## T36 (D-256, D-258): feet on the ground line, saints left and enemies
## right in slot order, figures of the agreed height, bars at the feet and
## intents on one row over the enemies.
func test_layout_puts_everyone_on_the_ground_in_slot_order() -> void:
	var screen: BattleScreen = _screen(&"m0_hard_02", SEED)
	var state: BattleState = screen.ctrl.state
	var last_x: float = INF
	for slot: int in range(1, state.party.size() + 1):
		var feet: Vector2 = screen.feet_of(state.party_at(slot).id)
		assert_almost_eq(feet.y, BattleScreen.GROUND_Y, 0.01, "santo %d no chão" % slot)
		assert_lt(feet.x, last_x, "posição %d mais longe do centro" % slot)
		last_x = feet.x
	var front_saint: float = screen.feet_of(state.party_at(1).id).x
	last_x = -INF
	for c: Combatant in state.enemies:
		var feet: Vector2 = screen.feet_of(c.id)
		assert_almost_eq(feet.y, BattleScreen.GROUND_Y, 0.01, "%s no chão" % c.id)
		assert_gt(feet.x, front_saint, "%s à direita dos santos" % c.id)
		assert_gt(feet.x, last_x, "%s em ordem de posição" % c.id)
		assert_lt(feet.x, BattleScreen.STAGE_SIZE.x, "%s dentro da tela" % c.id)
		last_x = feet.x
		var view: CombatantView = screen.view_of(c.id)
		assert_not_null(view.player(), "%s com a arte do Drive" % c.id)
		var height: float = view.player().display_height * view.scale.y
		assert_almost_eq(height, BattleScreen.figure_px_of(view.player().frames) * view.player().frames.display_scale, 0.5, "%s com a altura combinada" % c.id)
		var badge: CombatantBadge = screen.badge_of(c.id)
		assert_true(badge.intent_shown(), "%s mostra a intenção" % c.id)
		assert_not_null(badge.intent_texture(), "%s: intenção com ícone" % c.id)
	for c: Combatant in state.party + state.enemies:
		var feet: Vector2 = screen.view_of(c.id).feet_global() - screen.stage_position()
		assert_almost_eq(feet.y, BattleScreen.GROUND_Y, 0.5, "%s: os pés da figura pisam na linha do chão" % c.id)
		assert_almost_eq(feet.x, screen.feet_of(c.id).x, 0.5, "%s: barras sob os pés" % c.id)
	assert_gt(BattleScreen.GROUND_Y - BattleScreen.FIGURE_HEIGHT, 0.0, "a cabeça cabe no campo")
	assert_lt(BattleScreen.GROUND_Y, BattleScreen.FIELD_HEIGHT, "os pés ficam acima do painel")


## Alan's review (D-259), revised by D-376: the saints, women included,
## stand at the same height for now; each halo on its
## saint's head point, a light red outline (no line) on the intent's target,
## and the portrait inside the window of its frame.
func test_review_heights_halos_outline_and_portrait() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	var george: CombatantView = screen.view_of(&"saint_george")
	var therese: CombatantView = screen.view_of(&"saint_therese")
	assert_eq(therese.player().pixel_scale(), george.player().pixel_scale(), "Teresinha na mesma escala de Jorge por enquanto (D-376)")
	for id: StringName in [&"saint_george", &"saint_benedict", &"saint_therese"]:
		var view: CombatantView = screen.view_of(id)
		var frames: CharacterFrames = view.player().frames
		var idle: FrameClip = frames.clip(&"idle")
		var head: Vector2 = view.player().position + view.player().feet + (frames.halo_center - idle.anchor) * view.player().pixel_scale()
		var halo_centre: Vector2 = view.halo().position + view.halo().size * 0.5
		assert_almost_eq(halo_centre.x, head.x, 0.5, "%s: auréola no ponto da cabeça" % id)
		assert_almost_eq(halo_centre.y, head.y, view.halo().size.y * 0.05, "%s: auréola na altura da cabeça" % id)
		assert_almost_eq(view.halo().size.x, frames.halo_diameter * view.player().pixel_scale(), 0.5, "%s: tamanho da auréola" % id)
	var enemy: Combatant = screen.ctrl.state.enemy_at(1)
	var intent: Intent = screen.ctrl.state.intent_of(enemy)
	screen.tap(enemy.id)
	if intent != null and intent.kind == Intent.KIND_ACTION and intent.target_slot > 0:
		var target: Combatant = screen.ctrl.state.party_at(intent.target_slot)
		assert_true(screen.view_of(target.id).is_intent_target(), "o alvo da intenção ganha contorno vermelho")
		assert_gt(screen.view_of(target.id).player().outline_strength, 0.0)
	for c: Combatant in screen.ctrl.state.party:
		if intent == null or intent.target_slot != screen.ctrl.state.party_slot_of(c):
			assert_false(screen.view_of(c.id).is_intent_target(), "%s sem contorno" % c.id)
	var window := Rect2(screen._portrait_frame.position + BattleScreen.PORTRAIT_WINDOW.position, BattleScreen.PORTRAIT_WINDOW.size)
	assert_eq(Rect2(screen._portrait.position, screen._portrait.size), window, "o retrato fica na janela do arco")
	assert_true(Rect2(screen._portrait_frame.position, screen._portrait_frame.size).encloses(window), "a janela fica dentro do arco")


## T36: tapping an enemy opens its sheet on the right (DD), and the Lume
## lantern slides down the rod as the light fades (D-257).
func test_enemy_sheet_and_lume_lantern() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	assert_false(screen.lume_shown(), "na arena não há Lume")
	var enemy: Combatant = screen.ctrl.state.enemy_at(1)
	screen.tap(enemy.id)
	assert_eq(screen.sheet_title(), screen.texts.name_of(enemy), "a ficha mostra o inimigo tocado")
	var lit := BattleScreen.new()
	lit.speed_index = BattleScreen.SPEED_INSTANT
	lit.light = 100
	lit.setup(data, BattleController.new(data.battle(&"m0_easy_01", SEED)))
	add_child_autofree(lit)
	assert_true(lit.lume_shown())
	var full_y: float = lit.lantern_y()
	lit.light = 20
	lit.press_speed()
	assert_gt(lit.lantern_y(), full_y, "com menos Lume a lamparina desce")


## T17 (D-117): dev buttons drive desolation through the rules and the
## halo follows.
func test_dev_buttons_change_desolation_and_give_consolation() -> void:
	var screen: BattleScreen = _screen(&"m0_easy_01", SEED)
	assert_true(screen.dev_tools_shown(), "botões de teste na versão de desenvolvimento")
	var george: Combatant = screen.ctrl.state.find(&"saint_george")
	var view: CombatantView = screen.view_of(&"saint_george")
	var full: float = view.halo().brightness()
	# Gains pass through the desolation multipliers (Benedict's Clausura may
	# lower them): from 70, one press lands in the fading band, below 100.
	george.desolation = 70
	screen.press_dev_desolation(BattleScreen.DEV_DESOLATION_STEP)
	assert_between(george.desolation, 76, 99)
	assert_eq(george.spirit_state, Desolation.NORMAL)
	assert_lt(view.halo().brightness(), full, "a auréola perde brilho")
	var before: int = george.desolation
	screen.press_dev_desolation(-BattleScreen.DEV_DESOLATION_STEP)
	assert_eq(george.desolation, before - BattleScreen.DEV_DESOLATION_STEP, "reduções não passam por multiplicador")
	screen.press_dev_consolation()
	assert_eq(george.spirit_state, Desolation.CONSOLATION)
	assert_true(view.halo().rays_shown(), "raios da Consolação")
	assert_eq(screen.ctrl.command_log, [] as Array[Dictionary], "botões de teste não entram no log")


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
		"back_to_arena", "arena_title", "arena_choose", "arena_encounter", "arena_seed", "arena_seed_minus",
		"arena_seed_plus", "arena_start", "pool_easy", "pool_hard", "dev_title", "dev_desolation_up",
		"dev_desolation_down", "dev_consolation",
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


## T44 part 2 (D-424, Art Bible §4.3): the miracle's white stamp, the instant
## of the icon and the halo of each state, in the battle.
func test_the_miracle_shows_the_white_stamp_of_its_saint() -> void:
	var screen := _screen(&"m0_easy_01", 1)
	screen.speed_index = 0
	for id: StringName in [&"saint_george", &"saint_benedict", &"saint_therese"]:
		assert_true(ResourceLoader.exists(BattleScreen.STAMP_PATH % id), String(id))
	assert_gt(screen._play_stamp(&"saint_george"), 0.0)
	assert_true(screen.stamp_shown())
	await wait_seconds((BattleScreen.STAMP_IN + BattleScreen.STAMP_HOLD + BattleScreen.STAMP_OUT) + 0.2)
	assert_false(screen.stamp_shown(), "a estampa some")


func test_consolation_has_its_instant_of_the_icon_and_the_clearing() -> void:
	var screen := _screen(&"m0_easy_01", 1)
	screen.speed_index = 0
	screen.tap(&"saint_george")
	screen.press_dev_consolation()
	await wait_until(func() -> bool: return screen.instant_shown(), 3.0)
	assert_true(screen.instant_shown(), "o campo vira ouro por um instante")
	await wait_seconds(BattleScreen.INSTANT_IN + BattleScreen.INSTANT_HOLD + BattleScreen.INSTANT_OUT + 1.5)
	assert_false(screen.instant_shown())
	var view: CombatantView = screen.view_of(&"saint_george")
	assert_eq(view.halo().kind(), HaloLook.DISK)
	assert_true(view.clearing_shown(), "clareira de luz no chão")
	assert_ne(view.player().self_modulate, Color.BLACK, "o santo volta à cor depois do instante")


## T44 part 3 (D-452): each saint's ability stamp lands on its target.
func test_each_saint_has_the_stamp_of_its_abilities() -> void:
	assert_eq(SaintStamp.shape_for(&"saint_george", AbilityIcon.WARD), SaintStamp.SHIELD)
	assert_eq(SaintStamp.shape_for(&"saint_benedict", AbilityIcon.EXORCISM), SaintStamp.CROSS)
	assert_eq(SaintStamp.shape_for(&"saint_benedict", AbilityIcon.RELIEF), SaintStamp.RING)
	assert_eq(SaintStamp.shape_for(&"saint_therese", AbilityIcon.HEAL), SaintStamp.PETALS)
	assert_eq(SaintStamp.shape_for(&"saint_george", AbilityIcon.STRIKE), &"", "o golpe de lança não tem estampa")
	for shape: StringName in [SaintStamp.SHIELD, SaintStamp.CROSS, SaintStamp.RING]:
		assert_not_null(SaintStamp.texture_of(shape), String(shape))


func test_george_shield_drops_on_the_one_he_protects() -> void:
	var screen := _screen(&"m0_easy_01", 1)
	screen.speed_index = 0
	var george: Combatant = screen.ctrl.state.find(&"saint_george")
	screen._schedule_saint_stamp(george, &"george_raised_shield", &"saint_therese", 0.0)
	assert_eq(screen.saint_stamps_shown(), [SaintStamp.SHIELD] as Array[StringName])
	await wait_seconds(SaintStamp.ARRIVE + SaintStamp.HOLD + SaintStamp.LEAVE + 0.3)
	assert_eq(screen.saint_stamps_shown(), [] as Array[StringName], "a estampa some")


## bosses.md §5.3 (D-452): with the liver, Raphael appears in gold beside
## Asmodeus, becomes himself, the story panel shows, Asmodeus goes; then
## the result.
func test_raphael_binds_asmodeus_before_the_result() -> void:
	var screen := _screen(&"c02_boss_asmodeus", 3)
	screen.speed_index = 1
	assert_true(screen._play_raphael())
	assert_true(screen.raphael_shown())
	assert_true(screen.busy, "a cena segura os toques")
	await wait_until(func() -> bool: return screen.result_shown(), 6.0)
	assert_true(screen.result_shown())
	assert_false(screen.raphael_shown())
	assert_false(screen.busy)
	var asmodeus: CombatantView = null
	for c: Combatant in screen.ctrl.state.enemies:
		if c.category == &"boss":
			asmodeus = screen.view_of(c.id)
	assert_almost_eq(asmodeus.modulate.a, 0.0, 0.01, "Asmodeu pisca em ouro e some")
