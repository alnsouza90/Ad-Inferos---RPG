class_name BattleScreen
extends Control
## The battle screen of screens §3. It sends commands to BattleController,
## animates the returned events in order and redraws from the state; it never
## decides a rule (architecture §3.2).
## T65 (ADR-0013, D-367): the screen is drawn in pixel art on the inner
## 960 × 540 grid. The field (top 360) shows the scenery of the circle in
## layers with parallax and the filter of the circle, every combatant at the
## natural size of its frames with the feet on the ground line; the panel
## below (180) is the "chapel in the dark": the saint in an arch, lancet
## windows for the abilities, the rose window of the miracle, the candle
## rack of the Fervor, the provisions on their hooks and the tapped
## combatant in a broken frame. When the phone is wider (aspect = expand)
## the field grows sideways and the panel stays centred.

const STAGE_SIZE := Vector2(960, 540)
const FIELD_HEIGHT: float = 360.0
## Ground line of the field and height of a standing figure in pixel art
## (ADR-0013): the frames are shown at their natural size.
const GROUND_Y: float = 338.0
## The pixel figures are drawn at 0.6 of their PixelLab size (D-384): this
## is the height of a standing saint, and of painted frames shrunk to match.
const FIGURE_HEIGHT: float = 138.0
## Intents over the enemies, all on one row (field y).
const INTENT_ROW_Y: float = 150.0
const VIEW_WIDTH: float = 110.0
## Feet of the front saint and the front enemy, and the step between slots.
## Four enemies and four saints fit in the 960 of the stage with room
## between each figure and a wider gap between the two sides (D-384).
const SAINT_FRONT_X: float = 400.0
const ENEMY_FRONT_X: float = 560.0
const SLOT_STEP: float = 112.0
## Share of the two figures' widths kept apart when the attacker arrives.
const CONTACT_SHARE: float = 0.3
const BLOW_HOLD: float = 0.45
## The front layer of the scenery shows only in the corners of the battle,
## pushed down, so nothing covers the fighters (D-258).
const FRONT_DROP: float = 110.0
const FRONT_CORNER: float = 64.0
## Shake and push of the impact camera were measured on the old 1920 stage.
const CAMERA_REACH: float = 0.5
## The Lume (expedition light) on the left edge (D-257): a lantern that
## slides down an iron rod as the light fades.
const LUME_X: float = 26.0
const LUME_TOP: float = 70.0
const LUME_BOTTOM: float = 236.0
const LANTERN_SIZE := Vector2(31, 67)
## Top of the iron rod the lantern slides on (the drawn piece, D-385).
const ROD_TOP: float = 22.0
## The pieces of the panel (positions on the stage, from the approved
## preview v2) and the windows inside them, measured on the pieces.
const ARCH_POS := Vector2(8, 366)
const PORTRAIT_WINDOW := Rect2(22, 62, 60, 96)
## Corner of the portrait, left and above the head point of the idle frame.
const PORTRAIT_FROM_HEAD := Vector2(26, 22)
const LANCET_POS := Vector2(118, 380)
const LANCET_STEP: float = 68.0
const LANCET_TEXT := Rect2(7, 56, 51, 84)
const ROSE_POS := Vector2(400, 380)
const RACK_POS := Vector2(396, 478)
## Where the flame of each candle of the rack burns (pixels of the piece).
const CANDLE_FLAMES: Array[Vector2] = [Vector2(22, 2), Vector2(42, 11), Vector2(63, -1), Vector2(85, 9), Vector2(107, 3), Vector2(127, 6)]
const ACTION_POS := Vector2(566, 368)
const ACTION_SIZE := Vector2(126, 24)
## Two small actions share a row: Swap and Pass, Interceder and the gift.
const HALF_ACTION_SIZE := Vector2(64, 24)
const GALE_LABEL_WIDTH: float = 200.0
## Pause on the liver's smoke and on a boss's change of phase.
const BOSS_SCENE_SECONDS: float = 0.8
const HOOK_POS := Vector2(566, 446)
const HOOK_STEP: float = 28.0
const HOOK_TEXT := Rect2(4, 62, 26, 24)
const FRAME_POS := Vector2(712, 372)
const FRAME_WINDOW := Rect2(14, 14, 64, 90)
const SHEET_X: float = 812.0
const OVERLAY_WIDTH: float = 300.0
const OVERLAY_MARGIN: float = 400.0
const COLOR_BACKGROUND := Color("0D0C10")
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const COLOR_DAMAGE := Color("E0554A")
const COLOR_HEAL := Color("8FB573")
const COLOR_SPIRIT := Color("B79AD8")
const COLOR_CONDITION := Color("E4DDCF")
## Animation speed factors for 1×, 2× and instant (screens §3).
const SPEEDS: Array[float] = [1.0, 2.0, 0.0]
const SPEED_KEYS: Array[StringName] = [&"speed_normal", &"speed_fast", &"speed_instant"]
const SPEED_INSTANT: int = 2
const MOVE_TIME: float = 0.3
const SMALL_TIME: float = 0.2
const ABILITY_SLOTS: int = 4
## Desolation step of the dev buttons (a test tool, not a game number).
const DEV_DESOLATION_STEP: int = 25
const DEFAULT_ENCOUNTER: StringName = &"m0_easy_01"
## Frames of every character: the pixel art ones (T64) at
## <dir>/pixel/<def id>_frames.tres; a character that has none yet keeps its
## painted frames (<dir>/<def id>_frames.tres, T35), drawn smaller; without
## either it stays a rectangle with its name.
const ART_DIR: String = "res://scenes/battle/combatants"
const PIXEL_ART_DIR: String = "res://scenes/battle/combatants/pixel"
const BUST_PATH: String = "res://assets/pixel/characters/%s/%s_bust.png"
const PORTRAIT_PATH: String = "res://assets/characters/saints/%s/portrait/%s_portrait.png"
## The painted halo (the animation test screen still uses it) and the one
## of the pixel grid.
const HALO_SETTINGS_PATH: String = "res://scenes/battle/halo_settings.tres"
## Clip a saint may have for the preparation of its miracle (D-388).
const MIRACLE_WINDUP: StringName = &"miracle_windup"
const HALO_SETTINGS_PIXEL_PATH: String = "res://scenes/battle/halo_settings_pixel.tres"

## The arena (T17) sets these before adding the screen to the tree.
@export var encounter_id: StringName = DEFAULT_ENCOUNTER
@export var battle_seed: int = 1
## The arena shows "Voltar à arena" on the result and listens to this.
@export var show_back_button: bool = false
## Dev tools (D-117): on in debug builds and in exports with the
## "dev_tools" feature (the test builds of the M0).
var dev_tools: bool = OS.is_debug_build() or OS.has_feature("dev_tools")

signal back_requested

## Inside an expedition (T30): every command goes through `executor` (logged
## and saved by the expedition), "Jogar de novo" and the dev buttons are
## hidden (they would bypass the log) and the result offers "Continuar".
var in_expedition: bool = false
## Takes a BattleCommand and returns its CommandResult. Default: the
## controller itself (the arena).
var executor: Callable

var data: GameData
var texts: BattleTexts
var ctrl: BattleController
var selection: BattleSelection
var speed_index: int = 0
## Where the chosen speed is remembered (user://settings.json, screens §3).
## Null in tests, so they never depend on a file from an earlier run.
var settings: SettingsStore
## True while events are being animated: input waits.
var busy: bool = false
## The expedition's Lume on the lantern rod (-1: none, as in the arena).
var light: int = -1
var light_max: int = 100

var _stage: Control
var _field: Control
var _lines: IntentLine
var _views: Dictionary = {}
var _round_label: Label
var _fervor_label: Label
var _fervor_flames: Control
var _field_clip: Control
var _scenery_back: ParallaxScenery
## The front layer, once in each bottom corner (clipped by its holder).
var _scenery_front: Array[ParallaxScenery] = []
var _front_corners: Array[Control] = []
var _miracle_label: Label
var _hooks: Control
var _speed_button: Button
var _pause_button: Button
var _hint: Label
var _info: Label
var _actor_label: Label
var _ability_buttons: Array[Button] = []
var _miracle_button: Button
var _swap_button: Button
var _pass_button: Button
var _intercede_button: Button
var _give_button: Button
var _stand_firm_button: Button
## The Vendaval of this round over the two marked saints (bosses.md §2.1).
var _gale_label: Label
var _provisions_button: Button
var _end_turn_button: Button
## Open while the player is choosing a provision (the flow of the old
## "Provisões" button). The hooks are always in view (Art Bible).
var _provision_menu: Control
var _confirm_overlay: Control
var _confirm_label: Label
var _pause_overlay: Control
var _retreat_button: Button
var _retreat_reason: Label
var _result_overlay: Control
var _result_label: Label
var _info_id: StringName = &""
var _last_actor: StringName = &""
var _ui_built: bool = false
var _dev_row: HBoxContainer
var _halo_settings: HaloSettings
var _portrait: TextureRect
var _portrait_frame: TextureRect
var _actor_detail: Label
var _stats: Label
var _sheet_title: Label
var _sheet_picture: TextureRect
## combatant id -> CombatantBadge (bars, mark, intent, conditions).
var _badges: Dictionary = {}
## combatant id -> CharacterFrames (null: a rectangle).
var _frames: Dictionary = {}
var _camera: ImpactCamera
var _dim: ColorRect
var _flash: ColorRect
var _lantern: Control
var _lume_label: Label
var _lume_holder: Control
var _fighters: Control
var _badges_layer: Control
## A blow whose target reacts once it lands: {"target", "text"}.
var _pending_hit: Dictionary = {}
## combatant id -> CombatantArt, for the saints that have art.
var _arts: Dictionary = {}


## Tests and the arena hand in the data and a fresh controller; otherwise
## _ready() loads res://data and starts the default encounter.
func setup(p_data: GameData, p_ctrl: BattleController) -> void:
	data = p_data
	texts = BattleTexts.new(p_data)
	_set_controller(p_ctrl)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if data == null:
		var loaded: GameData = GameData.load_all()
		setup(loaded, BattleController.new(loaded.battle(encounter_id, battle_seed)))
	_build_ui()
	_center_stage()
	_begin()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- player input (also called by the tests) ------------------------------------

func tap(combatant_id: StringName) -> void:
	var c: Combatant = ctrl.state.find(combatant_id)
	if c == null:
		return
	_info_id = combatant_id
	if busy or ctrl.phase != BattleController.Phase.PARTY_TURN:
		_refresh()
		return
	var answer: StringName = selection.tap_combatant(combatant_id)
	if answer == BattleSelection.CONFIRM:
		_execute(selection.take_pending())
		return
	if answer == BattleSelection.IGNORED and c.is_saint():
		selection.select_actor(combatant_id)
	_refresh()


func press_ability(index: int) -> void:
	var actor: Combatant = selection.actor()
	if not _accepting_input() or actor == null or index >= actor.equipped.size():
		return
	var id: StringName = actor.equipped[index]
	if selection.mode == BattleSelection.Mode.ABILITY and selection.ability_id == id and selection.pending != null:
		_execute(selection.take_pending())
		return
	selection.choose_ability(id)
	_refresh()


func press_miracle() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	if selection.mode == BattleSelection.Mode.MIRACLE and selection.pending != null:
		_execute(selection.take_pending())
		return
	selection.choose_miracle()
	_refresh()


func press_swap() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	if selection.mode == BattleSelection.Mode.SWAP:
		selection.clear_choice()
	else:
		selection.choose_swap()
	_refresh()


func press_pass() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	if selection.mode == BattleSelection.Mode.PASS and selection.pending != null:
		_execute(selection.take_pending())
		return
	selection.choose_pass()
	_refresh()


## Interceder (combat §4.1): tap an ally, then the button again to take
## something else (desolation or one of the ally's negative conditions);
## with only one thing to take, the button confirms, like an ability.
func press_intercede() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	if selection.mode == BattleSelection.Mode.INTERCEDE and selection.pending != null:
		if not selection.next_intercede_option():
			_execute(selection.take_pending())
			return
	elif selection.mode == BattleSelection.Mode.INTERCEDE:
		selection.clear_choice()
	else:
		selection.choose_intercede()
	_refresh()


func press_give_consolation() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	if selection.mode == BattleSelection.Mode.GIVE_CONSOLATION and selection.pending != null:
		_execute(selection.take_pending())
		return
	if selection.mode == BattleSelection.Mode.GIVE_CONSOLATION:
		selection.clear_choice()
	else:
		selection.choose_give_consolation()
	_refresh()


## Firmar o pé (bosses.md §2.2): first tap shows what it does, the second
## confirms, like Pass.
func press_stand_firm() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	if selection.mode == BattleSelection.Mode.STAND_FIRM and selection.pending != null:
		_execute(selection.take_pending())
		return
	selection.choose_stand_firm()
	_refresh()


func press_provisions() -> void:
	if not _accepting_input() or selection.actor() == null:
		return
	_provision_menu.visible = not _provision_menu.visible
	_refresh()


func press_provision(id: StringName) -> void:
	if not _accepting_input():
		return
	_provision_menu.visible = false
	if selection.mode == BattleSelection.Mode.PROVISION and selection.provision_id == id and selection.pending != null:
		_execute(selection.take_pending())
		return
	selection.choose_provision(id)
	_refresh()


## screens §3: asks first if a saint could still act.
func press_end_turn() -> void:
	if not _accepting_input():
		return
	if not selection.ready_saints().is_empty():
		_confirm_label.text = texts.t(&"confirm_end_turn")
		_confirm_overlay.visible = true
		return
	_end_turn()


func press_confirm() -> void:
	_confirm_overlay.visible = false
	_end_turn()


func press_cancel() -> void:
	_confirm_overlay.visible = false


func press_speed() -> void:
	speed_index = (speed_index + 1) % SPEEDS.size()
	if settings != null:
		settings.set_value("animation_speed", speed_index)
	for view: CombatantView in _views.values():
		view.speed = SPEEDS[speed_index]
	_refresh_top()


func press_pause() -> void:
	_retreat_button.disabled = ctrl.validate(BattleCommand.retreat()) != &""
	_retreat_reason.text = texts.reason(ctrl.validate(BattleCommand.retreat())) if _retreat_button.disabled else ""
	_pause_overlay.visible = true


func press_resume() -> void:
	_pause_overlay.visible = false


func press_retreat() -> void:
	_pause_overlay.visible = false
	if _accepting_input():
		_execute(BattleCommand.retreat())


## Same encounter again with the next seed (the arena of T17 will choose).
func press_play_again() -> void:
	battle_seed += 1
	_set_controller(BattleController.new(data.battle(encounter_id, battle_seed)))
	for view: CombatantView in _views.values():
		view.queue_free()
	_views.clear()
	_result_overlay.visible = false
	_begin()


func press_back() -> void:
	back_requested.emit()


## Dev tools (D-117): change the chosen saint's desolation, or give
## Consolation, and animate what the rules answer.
func press_dev_desolation(amount: int) -> void:
	var actor: Combatant = selection.actor()
	if not _accepting_input() or actor == null:
		return
	selection.clear_choice()
	_play(ctrl.dev_change_desolation(actor.id, amount))


func press_dev_consolation() -> void:
	var actor: Combatant = selection.actor()
	if not _accepting_input() or actor == null:
		return
	selection.clear_choice()
	_play(ctrl.dev_force_consolation(actor.id))


func dev_tools_shown() -> bool:
	return _dev_row != null and _dev_row.visible


func result_shown() -> bool:
	return _result_overlay.visible


func confirm_shown() -> bool:
	return _confirm_overlay.visible


func portrait_texture() -> Texture2D:
	return _portrait.texture if _portrait.visible else null


func view_of(combatant_id: StringName) -> CombatantView:
	return _views.get(combatant_id)


func hint_text() -> String:
	return _hint.text


# --- flow ------------------------------------------------------------------------

func _set_controller(p_ctrl: BattleController) -> void:
	ctrl = p_ctrl
	selection = BattleSelection.new(ctrl)
	_info_id = &""
	_last_actor = &""


func _begin() -> void:
	_sync_views(false)
	if ctrl.phase == BattleController.Phase.SETUP:
		_play(ctrl.start())
	else:
		_after_events()


func _accepting_input() -> bool:
	return not busy and ctrl.phase == BattleController.Phase.PARTY_TURN


## Sends a command as if it came from the touches (also used by tests that
## play a whole leg, T30).
func send(cmd: BattleCommand) -> void:
	if _accepting_input():
		_execute(cmd)


func _execute(cmd: BattleCommand) -> void:
	if cmd == null:
		return
	var result: CommandResult = _run(cmd)
	if not result.ok:
		_refresh()
		_hint.text = texts.reason(result.reason)
		return
	_play(result.events)


func _end_turn() -> void:
	if not _accepting_input():
		return
	selection.reset()
	_provision_menu.visible = false
	var result: CommandResult = _run(BattleCommand.end_party_turn())
	if result.ok:
		_play(result.events)
	else:
		_refresh()


func _run(cmd: BattleCommand) -> CommandResult:
	if executor.is_valid():
		return executor.call(cmd)
	return ctrl.execute(cmd)


## Animates the events in order, then redraws from the state. At instant
## speed nothing waits, so the whole call runs at once.
func _play(events: Array[BattleEvent]) -> void:
	busy = true
	_refresh_controls()
	for ev: BattleEvent in events:
		var wait: float = _animate(ev)
		if wait > 0.0 and is_inside_tree():
			await get_tree().create_timer(wait).timeout
		if not _pending_hit.is_empty():
			var hit: float = _react(_pending_hit)
			_pending_hit = {}
			if hit > 0.0 and is_inside_tree():
				await get_tree().create_timer(hit).timeout
	busy = false
	_after_events()


func _after_events() -> void:
	_sync_views(false)
	if ctrl.is_over():
		selection.reset()
		_result_label.text = texts.t(StringName("result_%s" % _result_key()))
		# bosses.md §5.3: Raphael binds Asmodeus (with the liver) or he flees.
		for ev: BattleEvent in ctrl.history:
			if ev.type == BattleController.EV_BOSS_DEFEATED:
				_result_label.text += "\n" + texts.t(&"boss_bound" if bool(ev.data["bound"]) else &"boss_fled")
		_result_overlay.visible = true
	else:
		var actor: Combatant = selection.actor()
		if actor == null or not actor.is_standing() or actor.has_acted:
			var ready_now: Array[Combatant] = selection.ready_saints()
			if ready_now.is_empty():
				selection.reset()
			else:
				selection.select_actor(ready_now[0].id)
	_refresh()


func _result_key() -> String:
	if ctrl.phase == BattleController.Phase.VICTORY:
		return "victory"
	if ctrl.phase == BattleController.Phase.DEFEAT:
		return "defeat"
	return "retreat"


## One event on screen; returns how long to wait before the next one.
func _animate(ev: BattleEvent) -> float:
	var d: Dictionary = ev.data
	var factor: float = SPEEDS[speed_index]
	match ev.type:
		&"round_started", &"fervor_gained", &"intents_chosen", &"intents_updated":
			_refresh_top()
		&"ability_used":
			_last_actor = d["actor"]
			var actor: Combatant = ctrl.state.find(d["actor"])
			if actor != null:
				_hint.text = "%s: %s" % [texts.name_of(actor), texts.ability_name(d["ability"])]
			var targets: Array = d.get("targets", [])
			var actor_view: CombatantView = view_of(d["actor"])
			if actor != null and actor_view != null and StringName(str(d["ability"])) == actor.miracle:
				actor_view.next_windup = MIRACLE_WINDUP
			return _act(d["actor"], _style_of_ability(d["ability"]), StringName(str(targets[0])) if not targets.is_empty() else &"")
		&"enemy_action", &"party_turn_ended":
			_last_actor = &""
		&"liver_smoke":
			_hint.text = texts.t(&"boss_liver_smoke")
			var smoke_view: CombatantView = view_of(StringName(str(d["boss"])))
			if smoke_view != null:
				smoke_view.float_text(texts.t(&"boss_liver_smoke_short"), COLOR_SPIRIT)
			return _scaled(BOSS_SCENE_SECONDS, factor)
		&"boss_phase_changed":
			var boss: Combatant = ctrl.state.boss()
			var boss_view: CombatantView = view_of(boss.id) if boss != null else null
			if boss_view != null:
				boss_view.float_text(texts.t(&"boss_phase_float", {"phase": d["phase"], "of": d["of"]}), COLOR_SPIRIT)
			_on_impact(boss_view.position if boss_view != null else Vector2.ZERO, 1.0, AnimationStyle.SPIRITUAL)
			return _scaled(BOSS_SCENE_SECONDS, factor)
		&"damage_dealt", &"bleed_tick", &"self_damaged":
			var lunge: float = 0.0
			var source: StringName = StringName(str(d.get("source", "")))
			var target_id: StringName = StringName(str(d["target"]))
			if source != &"" and source != _last_actor and source != target_id:
				_last_actor = source
				# An enemy's blow: a strike slides, any other damage is cast.
				var style: StringName = AnimationStyle.PHYSICAL if d.get("type", &"") == &"strike" else AnimationStyle.SPIRITUAL
				lunge = _act(source, style, target_id)
			var view: CombatantView = view_of(target_id)
			if view == null:
				return lunge
			_set_hp(target_id, int(d["hp"]))
			var number: String = texts.t(&"preview_damage", {"amount": d["amount"]})
			if lunge > 0.0:
				# The target reacts when the blow lands, after the wait.
				_pending_hit = {"target": target_id, "text": number}
				return lunge
			view.float_text(number, COLOR_DAMAGE)
			return view.play_hit()
		&"healed", &"revived":
			var view: CombatantView = view_of(d["target"])
			if view != null:
				_set_hp(d["target"], int(d["hp"]))
				view.float_text(texts.t(&"preview_heal", {"amount": d["amount"]}), COLOR_HEAL)
			return _scaled(SMALL_TIME, factor)
		&"condition_applied":
			var view: CombatantView = view_of(d["target"])
			if view != null:
				view.float_text(texts.t(&"preview_applied", {"stacks": d["stacks"], "name": texts.condition_name(d["condition"])}), COLOR_CONDITION)
			return _scaled(SMALL_TIME, factor)
		&"desolation_changed":
			var change: int = int(d["new"]) - int(d["old"])
			var view: CombatantView = view_of(d["target"])
			if view != null and change != 0:
				var key: StringName = &"preview_desolation_up" if change > 0 else &"preview_desolation_down"
				view.float_text(texts.t(key, {"amount": absi(change)}), COLOR_SPIRIT)
				view.set_desolation(int(d["new"]))
			return _scaled(SMALL_TIME, factor)
		&"state_changed":
			var view: CombatantView = view_of(d["target"])
			if view != null:
				view.set_spirit_state(StringName(str(d["new"])))
			if view != null and d["new"] != Desolation.NORMAL:
				view.float_text(texts.t(StringName("spirit_%s" % d["new"])), COLOR_SPIRIT)
			return _scaled(SMALL_TIME, factor)
		&"fell", &"enemy_died":
			var view: CombatantView = view_of(d["target"])
			return view.play_fall() if view != null else 0.0
		&"moved", &"swapped", &"summoned":
			_sync_views(factor > 0.0)
			return _scaled(MOVE_TIME, factor)
	return 0.0


func _react(hit: Dictionary) -> float:
	var view: CombatantView = view_of(hit["target"])
	if view == null:
		return 0.0
	view.float_text(hit["text"], COLOR_DAMAGE)
	return view.play_hit()


## Plays the action of `actor_id` on `target_id` in its style (D-233) and
## returns how long to wait before the blow lands (the rest of the move, the
## return home, runs on while the target reacts).
func _act(actor_id: StringName, style: StringName, target_id: StringName) -> float:
	var view: CombatantView = view_of(actor_id)
	if view == null:
		return 0.0
	var target: CombatantView = view_of(target_id)
	# The Shade of Desire never strikes in the flesh: every blow of hers
	# wraps the target in a dark light, like Vertigo's (D-386).
	if style == AnimationStyle.PHYSICAL and view.player() != null and view.player().frames.attack_style == &"outline":
		style = AnimationStyle.SPIRITUAL
	if target == null or target == view:
		if style == AnimationStyle.BLESSING:
			return view.play_blessing()
		return view.play_action()
	match style:
		AnimationStyle.SPIRITUAL:
			if view.player() != null:
				return view.play_spell(target.chest_global(), target) * view.impact_share()
		AnimationStyle.BLESSING:
			if view.player() != null:
				return view.play_blessing(target.feet_global()) * view.impact_share()
	return view.play_action(&"", _reach(view, target), target.chest_global()) * view.impact_share()


func _style_of_ability(ability_id: StringName) -> StringName:
	var def: AbilityDef = ctrl.state.catalog.ability(ability_id)
	if def == null:
		return AnimationStyle.PHYSICAL
	return AnimationStyle.of(def.effects, def.targeting)


## How far the attacker slides to stand before its target, in its own
## (unscaled) pixels.
func _reach(actor: CombatantView, target: CombatantView) -> float:
	var view_scale: float = actor.scale.x
	var gap: float = VIEW_WIDTH
	if actor.player() != null and target.player() != null:
		gap = (actor.player().figure_width() + target.player().figure_width()) * 0.5 * CONTACT_SHARE
	var distance: float = absf(_feet_x(target) - _feet_x(actor)) - gap * view_scale
	return maxf(0.0, distance / view_scale)


func _on_impact(at: Vector2, strength: float, kind: StringName, attacker: CombatantView = null) -> void:
	var factor: float = SPEEDS[speed_index]
	if factor <= 0.0 or _camera == null:
		return
	if kind == &"physical":
		var push: Vector2 = attacker.blow_push() if attacker != null else Vector2.ZERO
		var shake: float = attacker.blow_shake() if attacker != null else 1.0
		_camera.blow(at, factor, BLOW_HOLD / factor, push, shake)
	else:
		_camera.punch(at, factor, strength)


func _scaled(seconds: float, factor: float) -> float:
	return seconds / factor if factor > 0.0 else 0.0


# --- drawing ---------------------------------------------------------------------

func _refresh() -> void:
	if not _ui_built:
		return
	_refresh_top()
	_refresh_views()
	_refresh_controls()
	_refresh_hint()
	_refresh_info()


func _refresh_top() -> void:
	if not _ui_built:
		return
	var cap: int = ctrl.state.constants.get_int(&"fervor_cap")
	_round_label.text = texts.t(&"round", {"round": ctrl.state.round_number})
	if ctrl.state.encounter_type == &"common" and ctrl.state.constants.has_key(&"desolation_battle_end_per_round"):
		# The clock of D-269: what a victory now would cost, before multipliers.
		var at_end: int = ExpeditionController.battle_end_desolation(ctrl.state, ctrl.state.constants.get_int(&"desolation_battle_end_common"))
		_round_label.text = texts.t(&"round_clock", {"round": ctrl.state.round_number, "amount": at_end})
	_fervor_label.text = texts.t(&"fervor", {"amount": ctrl.fervor.amount, "max": cap})
	_fervor_flames.queue_redraw()
	_speed_button.text = texts.t(SPEED_KEYS[speed_index])
	_pause_button.text = texts.t(&"pause")
	_refresh_lume()


## The lantern slides down the rod as the Lume fades (D-257).
func _refresh_lume() -> void:
	_lume_holder.visible = light >= 0
	if light < 0:
		return
	var share: float = clampf(float(light) / maxf(float(light_max), 1.0), 0.0, 1.0)
	var y: float = roundf(LUME_BOTTOM - (LUME_BOTTOM - LUME_TOP) * share)
	_lantern.position = Vector2(LUME_X - LANTERN_SIZE.x * 0.5, y - LANTERN_SIZE.y * 0.5)
	_lume_label.text = data.ui.text(&"walk_light", {"value": light})


## The Vendaval mark over the two saints it would swap at the end of the
## round, or that a saint stood firm against it.
func _refresh_gale() -> void:
	var slots: Array[int] = ctrl.state.gale_slots
	_gale_label.visible = slots.size() == 2 and not ctrl.is_over()
	if not _gale_label.visible:
		return
	var key: StringName = &"gale_mark"
	if ctrl.state.gale_held:
		key = &"gale_held_firm"
	_gale_label.text = texts.t(key)
	var mid: float = (_saint_x(slots[0]) + _saint_x(slots[1])) * 0.5
	_gale_label.position = Vector2(roundf(mid - GALE_LABEL_WIDTH * 0.5), INTENT_ROW_Y)


## The Vendaval as the screen shows it (tests).
func gale_text() -> String:
	return _gale_label.text if _gale_label.visible else ""


func _refresh_views() -> void:
	_refresh_gale()
	var targetable: Array[StringName] = selection.targetable_ids()
	var pending: Array[StringName] = []
	if selection.pending != null:
		pending = selection.pending_ids()
	var previews: Dictionary = {}
	for entry: PreviewEntry in selection.preview:
		previews[entry.target_id] = texts.preview_line(entry)
	var intent_target: Combatant = _info_intent_target()
	for id: StringName in _views:
		var view: CombatantView = _views[id]
		var c: Combatant = ctrl.state.find(id)
		if c == null:
			continue
		_show(view, c)
		var mark: CombatantView.Mark = CombatantView.Mark.NONE
		if id == selection.actor_id:
			mark = CombatantView.Mark.SELECTED
		if targetable.has(id):
			mark = CombatantView.Mark.TARGETABLE
		if pending.has(id):
			mark = CombatantView.Mark.PENDING
		if intent_target != null and intent_target.id == id and mark == CombatantView.Mark.NONE:
			mark = CombatantView.Mark.INTENT_TARGET
		view.set_mark(mark)
		view.set_intent_target(intent_target != null and intent_target.id == id)
		view.show_preview(previews.get(id, ""))
		var badge: CombatantBadge = _badges.get(id)
		if badge != null:
			badge.set_mark(mark)
			badge.show_preview(previews.get(id, ""))
	# The intent's target is outlined in light red (D-259), no line.
	_lines.hide_line()


func _show(view: CombatantView, c: Combatant) -> void:
	var slot: int = ctrl.state.party_slot_of(c) if c.is_saint() else ctrl.state.enemy_slot_of(c)
	var intent_obj: Intent = null if c.is_saint() else ctrl.state.intent_of(c)
	var intent_text: String = texts.intent(intent_obj)
	var status_text: String = texts.status(c)
	if status_text.is_empty() and c.is_saint() and c.has_acted and c.is_standing():
		status_text = texts.t(&"acted")
	view.show_state(c, texts.name_of(c), texts.t(&"slot", {"slot": slot}), status_text, texts.hp(c), texts.desolation(c), texts.conditions_summary(c), intent_text)
	var badge: CombatantBadge = _badges.get(c.id)
	if badge == null:
		return
	badge.set_bars(c.is_saint(), c.hp, c.max_hp, c.desolation, ctrl.state.constants.get_int(&"desolation_max"), not c.is_standing())
	var value: String = ""
	if intent_obj != null and intent_obj.kind == Intent.KIND_ACTION and intent_obj.preview_value > 0:
		value = str(intent_obj.preview_value)
	badge.set_intent(HudStyle.intent_icon(intent_obj) if not ctrl.is_over() else null, value)
	if not c.is_saint():
		var more: Array[Intent] = ctrl.state.intents_of(c)
		var extra: Intent = more[1] if more.size() > 1 else null
		var extra_value: String = str(extra.preview_value) if extra != null and extra.kind == Intent.KIND_ACTION and extra.preview_value > 0 else ""
		badge.set_extra_intent(HudStyle.intent_icon(extra) if extra != null and not ctrl.is_over() else null, extra_value)
	var entries: Array[Dictionary] = []
	var ids: Array[StringName] = texts.sorted_conditions(c)
	for i: int in mini(ids.size(), BattleTexts.MAX_CONDITIONS_SHOWN):
		entries.append({"icon": HudStyle.condition_icon(ids[i]), "text": texts.condition_label(c, ids[i])})
	var more: String = ""
	if ids.size() > BattleTexts.MAX_CONDITIONS_SHOWN:
		more = texts.t(&"conditions_more", {"count": ids.size() - BattleTexts.MAX_CONDITIONS_SHOWN})
	badge.set_conditions(entries, more)


func _set_hp(combatant_id: StringName, hp: int) -> void:
	var view: CombatantView = view_of(combatant_id)
	if view != null:
		view.set_hp(hp)
	var c: Combatant = ctrl.state.find(combatant_id)
	var badge: CombatantBadge = _badges.get(combatant_id)
	if badge != null and c != null:
		badge.set_hp_share(float(hp) / maxf(float(c.max_hp), 1.0))


func _refresh_controls() -> void:
	if not _ui_built:
		return
	var actor: Combatant = selection.actor()
	var open: bool = _accepting_input() and actor != null
	_actor_label.text = texts.name_of(actor) if actor != null else ""
	_portrait.texture = _portrait_of(actor)
	_portrait.visible = _portrait.texture != null
	_portrait_frame.visible = actor != null
	if actor != null:
		_portrait_frame.self_modulate = PixelStyle.frame_tint(actor.spirit_state, actor.desolation, ctrl.state.constants.get_int(&"desolation_max"))
		var slot: int = ctrl.state.party_slot_of(actor)
		var status_text: String = texts.status(actor)
		_actor_detail.text = texts.t(&"slot", {"slot": slot}) + (" · " + status_text if not status_text.is_empty() else "")
		_stats.text = "%s · %s" % [texts.hp(actor), texts.desolation(actor)]
	else:
		_actor_detail.text = ""
		_stats.text = ""
	for i: int in ABILITY_SLOTS:
		var button: Button = _ability_buttons[i]
		if not open or i >= actor.equipped.size():
			_set_button(button, "", &"", true, false)
			continue
		var id: StringName = actor.equipped[i]
		var chosen: bool = selection.mode == BattleSelection.Mode.ABILITY and selection.ability_id == id
		_set_button(button, _ability_label(actor, id), selection.ability_reason(id, false), false, chosen)
	if open:
		_set_button(_miracle_button, _ability_label(actor, actor.miracle, true), selection.ability_reason(actor.miracle, true), false, selection.mode == BattleSelection.Mode.MIRACLE)
		_set_button(_swap_button, texts.t(&"swap"), selection.swap_reason(), false, selection.mode == BattleSelection.Mode.SWAP)
		_set_button(_pass_button, texts.t(&"pass"), selection.pass_reason(), false, selection.mode == BattleSelection.Mode.PASS)
		_set_button(_intercede_button, texts.t(&"intercede"), selection.intercede_reason(), false, selection.mode == BattleSelection.Mode.INTERCEDE)
		_set_button(_give_button, texts.t(&"give_consolation"), selection.give_consolation_reason(), false, selection.mode == BattleSelection.Mode.GIVE_CONSOLATION)
		_set_button(_stand_firm_button, texts.t(&"stand_firm"), selection.stand_firm_reason(), false, selection.mode == BattleSelection.Mode.STAND_FIRM)
		_set_button(_provisions_button, texts.t(&"provisions"), _provisions_reason(), false, selection.mode == BattleSelection.Mode.PROVISION)
	else:
		_set_button(_miracle_button, texts.t(&"miracle"), &"", true, false)
		_set_button(_swap_button, texts.t(&"swap"), &"", true, false)
		_set_button(_pass_button, texts.t(&"pass"), &"", true, false)
		_set_button(_intercede_button, texts.t(&"intercede"), &"", true, false)
		_set_button(_give_button, texts.t(&"give_consolation"), &"", true, false)
		_set_button(_stand_firm_button, texts.t(&"stand_firm"), &"", true, false)
		_set_button(_provisions_button, texts.t(&"provisions"), &"", true, false)
	# Without a Vendaval in this battle the button is only noise.
	_stand_firm_button.visible = ctrl.state.hazard == &"gale"
	_miracle_label.text = _miracle_button.text
	_miracle_label.add_theme_color_override("font_color", PixelStyle.COLOR_LEAD_LIGHT if _miracle_button.disabled else PixelStyle.COLOR_GOLD)
	_end_turn_button.text = texts.t(&"end_turn")
	_end_turn_button.disabled = not _accepting_input()
	_refresh_provision_menu(open)


## The head of the saint, cut from its idle frame around the head point
## (as in the approved preview); a saint without frames keeps the painted
## portrait.
func _portrait_of(actor: Combatant) -> Texture2D:
	if actor == null:
		return null
	var bust: Texture2D = _bust_of(actor)
	if bust != null:
		return bust
	var head: Texture2D = _head_picture(actor.id, PORTRAIT_WINDOW.size)
	if head != null:
		return head
	var path: String = PORTRAIT_PATH % [actor.def_id, actor.def_id]
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


func _ability_label(actor: Combatant, id: StringName, is_miracle: bool = false) -> String:
	var def: AbilityDef = ctrl.state.catalog.ability(id)
	if def == null:
		return ""
	var label: String = def.name_pt
	if is_miracle:
		label = "%s: %s" % [texts.t(&"miracle"), label]
	var cost: int = ctrl.effective_cost(actor, def)
	if cost > 0:
		label += "\n" + texts.t(&"cost_badge", {"cost": cost})
	return label


## Empty label hides the button text; a reason greys it out and is shown
## under the name (screens §3).
func _set_button(button: Button, label: String, reason: StringName, off: bool, chosen: bool) -> void:
	var text: String = label
	if reason != &"" and not label.is_empty():
		text += "\n(" + texts.reason(reason) + ")"
	button.text = text
	button.disabled = off or reason != &""
	if button is PieceButton:
		(button as PieceButton).chosen = chosen
	else:
		button.modulate = COLOR_CHOSEN if chosen else Color.WHITE


func _provisions_reason() -> StringName:
	if ctrl.state.provisions.is_empty():
		return CommandResult.NO_PROVISION
	var reason: StringName = CommandResult.NO_PROVISION
	for id: StringName in _unique_provisions():
		reason = selection.provision_reason(id)
		if reason == &"":
			return &""
	return reason


func _unique_provisions() -> Array[StringName]:
	var ids: Array[StringName] = []
	for id: StringName in ctrl.state.provisions:
		if not ids.has(id):
			ids.append(id)
	return ids


## One hook with its bag per kind of provision the company carries, with
## the amount (Art Bible: the provisions are always in view).
func _refresh_provision_menu(open: bool) -> void:
	for child: Node in _hooks.get_children():
		_hooks.remove_child(child)
		child.queue_free()
	if not open:
		_provision_menu.visible = false
	var ids: Array[StringName] = _unique_provisions()
	for i: int in ids.size():
		var id: StringName = ids[i]
		var hook := PieceButton.new()
		hook.setup(PixelStyle.piece("ui_hook_bag"), null, null, HOOK_TEXT)
		hook.show_plate = false
		hook.position = Vector2(i * HOOK_STEP, 0)
		hook.set_meta(&"provision", id)
		hook.text = str(ctrl.state.provisions.count(id))
		hook.disabled = not open or selection.provision_reason(id) != &""
		hook.chosen = open and selection.mode == BattleSelection.Mode.PROVISION and selection.provision_id == id
		hook.modulate = Color(0.5, 0.5, 0.55) if hook.disabled else Color.WHITE
		hook.pressed.connect(press_provision.bind(id))
		_hooks.add_child(hook)


## How many hooks hang in the panel (tests).
func provision_hook_count() -> int:
	return _hooks.get_child_count()


func _refresh_hint() -> void:
	if busy:
		return
	var key: StringName = &"hint_enemy_turn"
	var args: Dictionary = {}
	if ctrl.is_over():
		key = StringName("result_%s" % _result_key())
	elif ctrl.phase == BattleController.Phase.PARTY_TURN:
		if selection.actor() == null:
			key = &"hint_select_saint"
		elif selection.mode == BattleSelection.Mode.NONE:
			key = &"hint_choose_action"
			args = {"saint": texts.name_of(selection.actor())}
		elif selection.pending != null:
			key = &"hint_confirm"
		else:
			key = &"hint_choose_target"
	_hint.text = texts.t(key, args)
	if selection.mode == BattleSelection.Mode.ABILITY and not ctrl.is_over():
		var def: AbilityDef = ctrl.state.catalog.ability(selection.ability_id)
		if def != null and not def.desc_pt.is_empty():
			_hint.text = def.desc_pt + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.PROVISION and not ctrl.is_over():
		_hint.text = texts.provision_name(selection.provision_id) + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.INTERCEDE and not ctrl.is_over():
		_hint.text = _intercede_hint() + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.GIVE_CONSOLATION and not ctrl.is_over():
		_hint.text = texts.t(&"give_consolation_desc") + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.STAND_FIRM and not ctrl.is_over():
		_hint.text = texts.t(&"stand_firm_desc", {"fervor": ctrl.state.constants.get_int(&"firmness_fervor")}) + "\n" + _hint.text


## What the pending Interceder takes, or what the action does.
func _intercede_hint() -> String:
	if selection.pending == null:
		return texts.t(&"intercede_desc")
	var ally: Combatant = ctrl.state.party_at(selection.picked[0])
	var option: StringName = selection.intercede_option()
	var key: StringName = &"intercede_take_desolation" if option == &"" else &"intercede_take_condition"
	var amount: int = mini(ctrl.state.constants.get_int(&"intercede_amount"), ally.desolation)
	var text: String = texts.t(key, {"amount": amount, "saint": texts.name_of(ally), "condition": texts.condition_name(option)})
	if selection.intercede_options.size() > 1:
		text += " " + texts.t(&"intercede_more")
	return text


## The sheet on the right (DD): the tapped combatant, or the chosen saint.
func _refresh_info() -> void:
	var c: Combatant = ctrl.state.find(_info_id) if _info_id != &"" else selection.actor()
	if c == null:
		_info.text = ""
		_sheet_title.text = ""
		_sheet_picture.texture = null
		return
	_sheet_title.text = texts.name_of(c)
	var bust: Texture2D = _bust_of(c)
	_sheet_picture.texture = bust if bust != null else _head_picture(c.id, FRAME_WINDOW.size)
	var lines: Array[String] = []
	var first: String = texts.hp(c)
	var status_text: String = texts.status(c)
	if not status_text.is_empty():
		first = status_text + " · " + first
	if c.is_saint():
		first += " · " + texts.desolation(c)
	lines.append(first)
	if not c.is_saint():
		var parts: Array[String] = []
		for intent: Intent in ctrl.state.intents_of(c):
			parts.append(texts.intent(intent))
		var intent_text: String = " · ".join(parts)
		if not intent_text.is_empty():
			lines.append(texts.t(&"intent_details", {"intent": intent_text}))
		if c.category == &"boss":
			# bosses.md §5: the phase and the claws of the Domínio, visible.
			lines.append(texts.t(&"boss_status", {"phase": ctrl.state.boss_phase, "of": ctrl.state.boss_phase_count(), "claws": ctrl.state.dominion_claws.size()}))
	lines.append(texts.conditions_details(c))
	_info.text = "\n".join(lines)


## Head and shoulders at full size, cut by the pixel art tool before the
## figures are shrunk (D-384); null for a character without pixel art.
func _bust_of(c: Combatant) -> Texture2D:
	var path: String = BUST_PATH % [c.def_id, c.def_id]
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## The top of the idle figure of a combatant, `window` pixels on the pixel
## grid: around the head point when the frames have one (saints), else the
## top of the figure. Null without frames.
func _head_picture(combatant_id: StringName, window: Vector2) -> Texture2D:
	var frames: CharacterFrames = _frames.get(combatant_id)
	var idle: FrameClip = frames.clip(&"idle") if frames != null else null
	if idle == null:
		return null
	var sheet: Texture2D = FramePlayer.sheet(idle.sheet_path)
	if sheet == null:
		return null
	# Painted frames are bigger than the grid: the window takes the same
	# share of the figure.
	var k: float = frames.figure_height / FIGURE_HEIGHT
	var corner := Vector2(idle.anchor.x - window.x * 0.5 * k, idle.anchor.y - frames.figure_height)
	if frames.halo_diameter > 0.0:
		corner = frames.halo_center - PORTRAIT_FROM_HEAD * k
	var cell: Rect2 = idle.region(0)
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(cell.position + corner.floor(), (window * k).floor()).intersection(cell)
	return atlas


func _info_intent_target() -> Combatant:
	var c: Combatant = ctrl.state.find(_info_id) if _info_id != &"" else null
	if c == null or c.is_saint() or ctrl.is_over():
		return null
	var intent: Intent = ctrl.state.intent_of(c)
	if intent == null or intent.kind != Intent.KIND_ACTION or intent.target_slot <= 0:
		return null
	return ctrl.state.party_at(intent.target_slot)


## Creates views for new combatants, removes the ones that left and moves
## every view to its slot.
func _sync_views(animated: bool) -> void:
	if not _ui_built:
		return
	var present: Dictionary = {}
	for c: Combatant in ctrl.state.party:
		present[c.id] = true
		_place(_ensure_view(c), _saint_x(ctrl.state.party_slot_of(c)), animated)
	for c: Combatant in ctrl.state.enemies:
		present[c.id] = true
		_place(_ensure_view(c), _enemy_x(ctrl.state.enemy_slot_of(c), c.size), animated)
	_stack_by_slot()
	for id: StringName in _views.keys():
		if not present.has(id):
			(_views[id] as CombatantView).queue_free()
			(_badges[id] as CombatantBadge).queue_free()
			_views.erase(id)
			_badges.erase(id)
			_frames.erase(id)


## The figures overlap on the narrow grid: whoever stands closer to the
## centre of the field is drawn in front (the front slots of each side).
func _stack_by_slot() -> void:
	var order: Array[Combatant] = []
	for slot: int in range(ctrl.state.party.size(), 0, -1):
		var saint: Combatant = ctrl.state.party_at(slot)
		if saint != null:
			order.append(saint)
	for slot: int in range(ctrl.state.enemies.size() + 4, 0, -1):
		var enemy: Combatant = ctrl.state.enemy_at(slot)
		if enemy != null and not order.has(enemy):
			order.append(enemy)
	for c: Combatant in order:
		var view: CombatantView = _views.get(c.id)
		if view != null:
			_fighters.move_child(view, _fighters.get_child_count() - 1)


func _ensure_view(c: Combatant) -> CombatantView:
	if _views.has(c.id):
		return _views[c.id]
	if _halo_settings == null:
		_halo_settings = load(HALO_SETTINGS_PIXEL_PATH)
	var view := CombatantView.new()
	var frames: CharacterFrames = _frames_for(c)
	_frames[c.id] = frames
	view.figure_px = figure_px_of(frames)
	view.float_font_size = PixelStyle.TEXT_SIZE * 2
	view.float_outline = 4
	view.float_rise = 36.0
	view.setup(c.id, c.is_saint(), VIEW_WIDTH, null, _halo_settings if c.is_saint() else null, frames)
	view.set_info_visible(false)
	view.speed = SPEEDS[speed_index]
	if view.player() != null:
		# The fight in poses (T60, D-359): every character, saint or enemy,
		# shows the safe last frame of each action and a slow idle.
		view.player().pose_mode = true
		view.player().outline_width = 1.0
		CircleLook.light_figure(view.player(), c.is_saint())
		# Painted frames (not pixel art yet) are shrunk with the smooth filter.
		if not is_pixel_art(frames):
			view.player().texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	view.tapped.connect(tap)
	view.impact.connect(_on_impact.bind(view))
	_fighters.add_child(view)
	_views[c.id] = view
	var badge := CombatantBadge.new()
	var display: float = frames.display_scale if frames != null else 1.0
	badge.set_head_height(figure_px_of(frames) * display, GROUND_Y - INTENT_ROW_Y)
	_badges_layer.add_child(badge)
	_badges[c.id] = badge
	_show(view, c)
	return view


func _frames_for(c: Combatant) -> CharacterFrames:
	for dir: String in [PIXEL_ART_DIR, ART_DIR]:
		var path: String = "%s/%s_frames.tres" % [dir, c.def_id]
		if ResourceLoader.exists(path):
			return load(path) as CharacterFrames
	return null


## Height of a standing figure on screen: pixel art at its natural size
## (one pixel of the drawing is one pixel of the screen, ADR-0013); painted
## frames are shrunk to FIGURE_HEIGHT.
static func figure_px_of(frames: CharacterFrames) -> float:
	return frames.figure_height if is_pixel_art(frames) else FIGURE_HEIGHT


## True for frames that came from the pixel art tool (T64).
static func is_pixel_art(frames: CharacterFrames) -> bool:
	return frames != null and frames.resource_path.begins_with(PIXEL_ART_DIR)


## The views are not scaled on the pixel grid: one pixel of a frame is one
## pixel of the screen (ADR-0013).
static func view_scale() -> float:
	return 1.0


## Where the feet of `view` stand on the field (x).
func _feet_x(view: CombatantView) -> float:
	return view.position.x + VIEW_WIDTH * 0.5 * view.scale.x


func _place(view: CombatantView, x: float, animated: bool) -> void:
	var feet_local := Vector2(VIEW_WIDTH * 0.5, CombatantView.INTENT_HEIGHT + CombatantView.BODY_HEIGHT)
	var target := (Vector2(x, GROUND_Y) - feet_local * view.scale.x).round()
	var badge: CombatantBadge = _badges.get(view.combatant_id)
	if animated and view.is_inside_tree() and view.position != Vector2.ZERO:
		var t: float = MOVE_TIME / SPEEDS[speed_index]
		view.create_tween().tween_property(view, "position", target, t)
		if badge != null:
			badge.create_tween().tween_property(badge, "position", Vector2(x, GROUND_Y), t)
	else:
		view.position = target
		if badge != null:
			badge.position = Vector2(x, GROUND_Y)


## Feet of the saint in `slot` (1 next to the centre).
func _saint_x(slot: int) -> float:
	return SAINT_FRONT_X - (slot - 1) * SLOT_STEP


## Feet of an enemy whose front slot is `anchor_slot`; a big one stands
## between the slots it takes.
func _enemy_x(anchor_slot: int, slots: int = 1) -> float:
	return ENEMY_FRONT_X + (anchor_slot - 1 + (maxi(slots, 1) - 1) * 0.5) * SLOT_STEP


## Where the feet of a combatant stand on the field (tests, T36).
func feet_of(combatant_id: StringName) -> Vector2:
	var badge: CombatantBadge = _badges.get(combatant_id)
	return badge.position if badge != null else Vector2.INF


func badge_of(combatant_id: StringName) -> CombatantBadge:
	return _badges.get(combatant_id)


func lume_shown() -> bool:
	return _lume_holder != null and _lume_holder.visible


func lantern_y() -> float:
	return _lantern.position.y + LANTERN_SIZE.y * 0.5


func portrait_tint() -> Color:
	return _portrait_frame.self_modulate


func sheet_title() -> String:
	return _sheet_title.text


# --- building --------------------------------------------------------------------

## The area this screen fills. A screen created in code (the battle inside
## the arena) only gets its size after layout, so the viewport is the
## fallback; never centre on a zero size (the T17 phone bug).
func screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


func stage_position() -> Vector2:
	return _stage.position if _stage != null else Vector2.ZERO


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((screen_size() - STAGE_SIZE) * 0.5).floor()
		_layout_field()


## How far the field goes beyond each side of the stage on a wide phone.
func field_margin() -> float:
	return maxf(_stage.position.x, 0.0) if _stage != null else 0.0


## The field takes the whole width of the screen: the scenery repeats to the
## sides, the fighters stay on the stage in the middle.
func _layout_field() -> void:
	if _field_clip == null:
		return
	var margin: float = field_margin()
	var wide := Vector2(STAGE_SIZE.x + margin * 2.0, FIELD_HEIGHT)
	_field_clip.position = Vector2(-margin, 0)
	_field_clip.size = wide
	_field.position = Vector2(margin, 0)
	_camera.rehome(_field.position)
	_scenery_back.position = Vector2(-margin, 0)
	_scenery_back.size = wide
	var corner := Vector2(margin + FRONT_CORNER, FIELD_HEIGHT)
	_front_corners[0].position = Vector2(-margin, 0)
	_front_corners[1].position = Vector2(STAGE_SIZE.x - FRONT_CORNER, 0)
	for i: int in _front_corners.size():
		_front_corners[i].size = corner
		# Each copy is laid over the whole field; its holder shows one corner.
		_scenery_front[i].position = Vector2(-margin, 0) - _front_corners[i].position
		_scenery_front[i].size = wide
	_dim.position = Vector2(-margin - 200.0, -200.0)
	_dim.size = wide + Vector2(400, 400)
	_flash.size = wide
	_lume_holder.position = Vector2(margin, 0)


## The far layers of the scenery follow the camera of a blow less than the
## fighters do: the depth shows (parallax).
func _process(_delta: float) -> void:
	if _scenery_back == null:
		return
	var pushed: float = _field.position.x - field_margin()
	_scenery_back.set_shift(pushed)
	for front: ParallaxScenery in _scenery_front:
		front.set_shift(pushed)


func scenery_layer_count() -> int:
	return _scenery_back.layer_count() + _scenery_front[0].layer_count()


func scenery_material() -> Material:
	return _scenery_back.material


func _build_ui() -> void:
	theme = PixelStyle.theme()
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_build_field()
	_build_bottom()
	_build_top_bar()
	_confirm_overlay = _overlay()
	_confirm_label = _overlay_label(_confirm_overlay)
	_overlay_button(_confirm_overlay, texts.t(&"confirm"), press_confirm)
	_overlay_button(_confirm_overlay, texts.t(&"cancel"), press_cancel)
	_pause_overlay = _overlay()
	var pause_title: Label = _overlay_label(_pause_overlay)
	pause_title.text = texts.t(&"pause")
	_overlay_button(_pause_overlay, texts.t(&"resume"), press_resume)
	_retreat_button = _overlay_button(_pause_overlay, texts.t(&"retreat"), press_retreat)
	_retreat_reason = _overlay_label(_pause_overlay)
	_result_overlay = _overlay()
	_result_label = _overlay_label(_result_overlay)
	PixelStyle.title(_result_label, PixelStyle.COLOR_BONE, PixelStyle.BIG_TITLE_SIZE)
	var again: Button = _overlay_button(_result_overlay, texts.t(&"play_again"), press_play_again)
	again.visible = not in_expedition
	var back: Button = _overlay_button(_result_overlay, texts.t(&"result_continue" if in_expedition else &"back_to_arena"), press_back)
	back.visible = show_back_button or in_expedition
	_ui_built = true


## The field: scenery behind (sky and middle), darkening, fighters, bars and
## marks, the scenery in front, clipped to the top of the screen. The impact
## camera moves all of it.
func _build_field() -> void:
	_field_clip = Control.new()
	_field_clip.size = Vector2(STAGE_SIZE.x, FIELD_HEIGHT)
	_field_clip.clip_contents = true
	_field_clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_field_clip)
	_field = Control.new()
	_field.size = _field_clip.size
	_field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field_clip.add_child(_field)
	var set_id: StringName = CircleLook.SET_BOSS if ctrl.state.encounter_type == &"boss" else CircleLook.SET_LEG_1
	_scenery_back = ParallaxScenery.new()
	_scenery_back.setup(CircleLook.back_layers(set_id), CircleLook.filter_material())
	_field.add_child(_scenery_back)
	_dim = ColorRect.new()
	_dim.color = Color(0.02, 0.01, 0.02, 0.0)
	_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_dim)
	_fighters = Control.new()
	_fighters.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fighters.size = _field.size
	_field.add_child(_fighters)
	# Bars, intents, conditions and previews float over the fighters.
	_badges_layer = Control.new()
	_badges_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_badges_layer)
	_gale_label = Label.new()
	_gale_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_gale_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_gale_label.size = Vector2(GALE_LABEL_WIDTH, 14)
	_gale_label.add_theme_color_override("font_color", PixelStyle.COLOR_VIOLET)
	_gale_label.visible = false
	_badges_layer.add_child(_gale_label)
	_lines = IntentLine.new()
	_lines.size = _field.size
	# Covers the whole field: it must never swallow the taps on the views.
	_lines.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_lines)
	for i: int in 2:
		var holder := Control.new()
		holder.clip_contents = true
		holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_field.add_child(holder)
		var front := ParallaxScenery.new()
		front.setup(CircleLook.front_layers(set_id), CircleLook.filter_material())
		front.drop = FRONT_DROP
		holder.add_child(front)
		_front_corners.append(holder)
		_scenery_front.append(front)
	_flash = ColorRect.new()
	_flash.color = Color(1, 1, 1, 0)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field_clip.add_child(_flash)
	_camera = ImpactCamera.new(_field, _flash, _dim)
	_camera.reach = CAMERA_REACH
	_build_lume(_field_clip)
	_layout_field()


## The Lume (D-257): the drawn iron rod with its notches and the lit
## lantern that slides down it as the light fades (pieces of D-385).
func _build_lume(holder: Control) -> void:
	_lume_holder = Control.new()
	_lume_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lume_holder.visible = false
	holder.add_child(_lume_holder)
	var rod := TextureRect.new()
	rod.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rod.texture = PixelStyle.piece("ui_lume_rod")
	if rod.texture != null:
		rod.position = Vector2(roundf(LUME_X - rod.texture.get_width() * 0.5), ROD_TOP)
	_lume_holder.add_child(rod)
	var lantern := TextureRect.new()
	lantern.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lantern.texture = PixelStyle.piece("ui_lantern_on")
	lantern.size = LANTERN_SIZE
	_lantern = lantern
	_lume_holder.add_child(_lantern)
	_lume_label = Label.new()
	_lume_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lume_label.position = Vector2(LUME_X - 22.0, LUME_BOTTOM + LANTERN_SIZE.y * 0.5 + 2.0)
	_lume_label.size = Vector2(44, 12)
	_lume_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lume_label.add_theme_color_override("font_color", PixelStyle.COLOR_AMBER)
	_lume_holder.add_child(_lume_label)


## A small flame in whole pixels, as in the approved preview: a diamond of
## amber with a gold heart. `at` is its base; `size_px` the side of a block.
func _draw_flame(on: Control, at: Vector2, size_px: int = 1) -> void:
	var widths: Array[int] = [1, 3, 5, 3, 1]
	for row: int in widths.size():
		var w: float = widths[row] * size_px
		var y: float = at.y - (widths.size() - row) * size_px
		on.draw_rect(Rect2(floorf(at.x - w * 0.5), y, w, size_px), PixelStyle.COLOR_AMBER)
	on.draw_rect(Rect2(floorf(at.x - size_px * 0.5), at.y - 3.0 * size_px, size_px, size_px), PixelStyle.COLOR_GOLD)


func _build_top_bar() -> void:
	_round_label = _label(Vector2(180, 4), Vector2(600, 14))
	PixelStyle.title(_round_label)
	_hint = _label(Vector2(230, 20), Vector2(500, 36))
	_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_pause_button = _button(Vector2(778, 4), Vector2(52, 26), press_pause)
	_speed_button = _button(Vector2(834, 4), Vector2(122, 26), press_speed)
	_build_dev_row()


## The panel under the field, the "chapel in the dark" (Art Bible, D-368):
## the chosen saint and its actions on the left, the tapped combatant in a
## broken frame on the right.
func _build_bottom() -> void:
	_stage.add_child(PixelStyle.plate(Rect2(-OVERLAY_MARGIN, FIELD_HEIGHT, STAGE_SIZE.x + OVERLAY_MARGIN * 2.0, STAGE_SIZE.y - FIELD_HEIGHT + 1.0)))
	_build_hero_panel()
	_build_sheet_panel()


func _build_hero_panel() -> void:
	_portrait_frame = _piece("ui_portrait_arch", ARCH_POS)
	_portrait = TextureRect.new()
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_portrait.position = ARCH_POS + PORTRAIT_WINDOW.position
	_portrait.size = PORTRAIT_WINDOW.size
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_portrait.visible = false
	_stage.add_child(_portrait)
	_actor_label = _label(Vector2(118, 362), Vector2(150, 16))
	_actor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	PixelStyle.title(_actor_label)
	_actor_detail = _label(Vector2(250, 365), Vector2(120, 12))
	_actor_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_actor_detail.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	_stats = _label(Vector2(372, 365), Vector2(190, 12))
	_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_stats.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	for i: int in ABILITY_SLOTS:
		var lancet := PieceButton.new()
		lancet.setup(PixelStyle.piece("ui_lancet_on"), PixelStyle.piece("ui_lancet_chosen"), PixelStyle.piece("ui_lancet_off"), LANCET_TEXT)
		lancet.position = LANCET_POS + Vector2(i * LANCET_STEP, 0)
		lancet.pressed.connect(press_ability.bind(i))
		_stage.add_child(lancet)
		_ability_buttons.append(lancet)
	var rose := PieceButton.new()
	rose.setup(PixelStyle.piece("ui_rose_on"), PixelStyle.piece("ui_rose_on"), PixelStyle.piece("ui_rose_off"), Rect2())
	rose.position = ROSE_POS
	rose.pressed.connect(press_miracle)
	_stage.add_child(rose)
	_miracle_button = rose
	_miracle_label = _label(ROSE_POS + Vector2(82, 2), Vector2(80, 76))
	_miracle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_miracle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_piece("ui_candle_rack", RACK_POS)
	_fervor_flames = Control.new()
	_fervor_flames.position = RACK_POS
	_fervor_flames.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fervor_flames.draw.connect(_draw_fervor)
	_stage.add_child(_fervor_flames)
	_fervor_label = _label(Vector2(480, 462), Vector2(82, 12))
	_fervor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_fervor_label.add_theme_color_override("font_color", PixelStyle.COLOR_AMBER)
	var half_step := Vector2(HALF_ACTION_SIZE.x + 2.0, 0)
	var row_step := Vector2(0, ACTION_SIZE.y + 2.0)
	_swap_button = _button(ACTION_POS, HALF_ACTION_SIZE, press_swap)
	_pass_button = _button(ACTION_POS + half_step, HALF_ACTION_SIZE, press_pass)
	_intercede_button = _button(ACTION_POS + row_step, HALF_ACTION_SIZE, press_intercede)
	_give_button = _button(ACTION_POS + row_step + half_step, HALF_ACTION_SIZE, press_give_consolation)
	# The provisions hang on their hooks, always in view: the old button
	# only keeps its place in the flow (press_provisions) and names the row.
	_provisions_button = _button(ACTION_POS + row_step * 2.0, HALF_ACTION_SIZE, press_provisions)
	_stand_firm_button = _button(ACTION_POS + row_step * 2.0 + half_step, HALF_ACTION_SIZE, press_stand_firm)
	_provisions_button.flat = true
	_provisions_button.focus_mode = Control.FOCUS_NONE
	_hooks = Control.new()
	_hooks.position = HOOK_POS
	_hooks.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_hooks)
	_provision_menu = Control.new()
	_provision_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_provision_menu.visible = false
	_stage.add_child(_provision_menu)


## One flame over each candle of the rack, as many as the Fervor.
func _draw_fervor() -> void:
	if ctrl == null:
		return
	for i: int in mini(ctrl.fervor.amount, CANDLE_FLAMES.size()):
		_draw_flame(_fervor_flames, CANDLE_FLAMES[i])


## Flames lit on the candle rack (tests).
func fervor_flames() -> int:
	return mini(ctrl.fervor.amount, CANDLE_FLAMES.size())


## DD's sheet: the tapped enemy (or saint) in the broken frame, with its
## life, intent and conditions; "Encerrar turno" in its corner.
func _build_sheet_panel() -> void:
	_piece("ui_broken_frame", FRAME_POS)
	_sheet_picture = TextureRect.new()
	_sheet_picture.position = FRAME_POS + FRAME_WINDOW.position
	_sheet_picture.size = FRAME_WINDOW.size
	_sheet_picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_sheet_picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_sheet_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_sheet_picture)
	_sheet_title = _label(Vector2(SHEET_X, 368), Vector2(144, 16))
	_sheet_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	PixelStyle.title(_sheet_title)
	_info = _label(Vector2(SHEET_X, 386), Vector2(144, 112))
	_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.clip_text = true
	_info.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	_end_turn_button = _button(Vector2(SHEET_X, 502), Vector2(142, 32), press_end_turn)


## Test buttons (D-117), small, in the top left corner.
func _build_dev_row() -> void:
	_dev_row = HBoxContainer.new()
	_dev_row.position = Vector2(44, 4)
	_dev_row.add_theme_constant_override("separation", 2)
	_dev_row.visible = dev_tools and not in_expedition
	_stage.add_child(_dev_row)
	var specs: Array = [
		[texts.t(&"dev_desolation_up", {"amount": DEV_DESOLATION_STEP}), press_dev_desolation.bind(DEV_DESOLATION_STEP)],
		[texts.t(&"dev_desolation_down", {"amount": DEV_DESOLATION_STEP}), press_dev_desolation.bind(-DEV_DESOLATION_STEP)],
		[texts.t(&"dev_consolation"), press_dev_consolation],
	]
	for spec: Array in specs:
		var button := Button.new()
		button.text = spec[0]
		button.custom_minimum_size = Vector2(0, 16)
		button.pressed.connect(spec[1])
		_dev_row.add_child(button)


## One piece of the cathedral interface at its natural size.
func _piece(file_name: String, pos: Vector2) -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = PixelStyle.piece(file_name)
	rect.position = pos
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(rect)
	return rect


func _label(pos: Vector2, label_size: Vector2) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = label_size
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_stage.add_child(label)
	return label


func _button(pos: Vector2, button_size: Vector2, action: Callable) -> Button:
	var button := Button.new()
	button.position = pos
	button.size = button_size
	button.clip_text = true
	button.pressed.connect(action)
	_stage.add_child(button)
	return button


func _overlay() -> Control:
	var shade := ColorRect.new()
	shade.color = Color(PixelStyle.COLOR_PITCH, 0.8)
	# Wider than the stage: it also covers the sides of a wide phone.
	shade.position = Vector2(-OVERLAY_MARGIN, 0)
	shade.size = STAGE_SIZE + Vector2(OVERLAY_MARGIN * 2.0, 0)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	shade.visible = false
	var box := VBoxContainer.new()
	box.name = "Box"
	box.position = Vector2(OVERLAY_MARGIN + (STAGE_SIZE.x - OVERLAY_WIDTH) * 0.5, 150)
	box.custom_minimum_size = Vector2(OVERLAY_WIDTH, 0)
	box.add_theme_constant_override("separation", 10)
	shade.add_child(box)
	_stage.add_child(shade)
	return shade


func _overlay_label(overlay: Control) -> Label:
	var label := Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(OVERLAY_WIDTH, 0)
	PixelStyle.title(label)
	overlay.get_node("Box").add_child(label)
	return label


func _overlay_button(overlay: Control, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(OVERLAY_WIDTH, 36)
	button.pressed.connect(action)
	overlay.get_node("Box").add_child(button)
	return button
