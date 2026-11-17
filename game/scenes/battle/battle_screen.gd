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
## The pixel figures are drawn at 0.72 of their PixelLab size (D-415, was
## 0.6 in D-384): this is the height of a standing saint, and of painted
## frames shrunk to match.
const FIGURE_HEIGHT: float = 166.0
## Intents over the enemies, all on one row (field y).
const INTENT_ROW_Y: float = 118.0
const VIEW_WIDTH: float = 110.0
## Feet of the front saint and the front enemy, and the step between slots.
## Three saints and four enemies fit in the 960 of the stage with room
## between each figure and a wider gap between the two sides (D-384, D-415).
const SAINT_FRONT_X: float = 374.0
const ENEMY_FRONT_X: float = 548.0
const SLOT_STEP: float = 118.0
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
## The lancet shows only its mosaic; the cost is a row of marks on the iron
## at its foot and the name and description go to a note in the corner of
## the field when it is touched (D-440).
const LANCET_PIPS_Y: float = 143.0
const NOTE_RECT := Rect2(50, 62, 300, 74)
const NOTE_BOSS_DROP: float = 42.0
const NAMEPLATE := Rect2(112, 361, 428, 17)
const ROSE_POS := Vector2(400, 372)
## The miracle's name and cost, to the right of the rose (D-436).
const MIRACLE_LABEL := Rect2(481, 384, 58, 90)
const RACK_POS := Vector2(386, 478)
## Where the flame of each candle of the rack burns (pixels of the piece).
const CANDLE_FLAMES: Array[Vector2] = [Vector2(22, 2), Vector2(42, 11), Vector2(63, -1), Vector2(85, 9), Vector2(107, 3), Vector2(127, 6)]
## The common actions and the alforje, as tiles with their icon (D-436).
const ACTION_POS := Vector2(542, 370)
const ACTION_TILE := Vector2(54, 48)
const ACTION_GAP: float = 2.0
## The alforje opened: its slots over the field, above the tiles (D-412).
const PACK_POS := Vector2(470, 236)
const PACK_SLOT := Vector2(48, 40)
const PACK_COLUMNS: int = 4
const GALE_LABEL_WIDTH: float = 200.0
## Pause on the liver's smoke and on a boss's change of phase.
const BOSS_SCENE_SECONDS: float = 0.8
const FRAME_POS := Vector2(712, 372)
const FRAME_WINDOW := Rect2(14, 14, 64, 90)
const SHEET_X: float = 812.0
const SHEET_ICON := Vector2(24, 24)
## The big bar of a boss under the top line (D-436): name, life, phase and
## the claws of the Domínio.
const BOSS_BAR := Rect2(240, 54, 480, 46)
## The claws at each end of the boss bar, and where its slot is (top, height),
## in pixels of ui_boss_bar.
const BOSS_BAR_END: float = 36.0
const BOSS_BAR_SLOT := Vector2(12.0, 8.0)
## Where the slot of the bar starts inside the claws.
const BOSS_BAR_FILL_INSET: float = 33.0
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
const SAINT_PORTRAIT_PATH: String = "res://assets/pixel/characters/%s/%s_portrait.png"
## The painted halo (the animation test screen still uses it) and the one
## of the pixel grid.
const HALO_SETTINGS_PATH: String = "res://scenes/battle/halo_settings.tres"
## Clip a saint may have for the preparation of its miracle (D-388).
const MIRACLE_WINDUP: StringName = &"miracle_windup"
## The miracle's stamp (D-424): the screen darkens and the saint's white
## stamp appears over it and fades, while the saint makes the gesture.
const STAMP_PATH: String = "res://assets/pixel/vfx/stamp_%s.png"
const STAMP_DARK := Color(0.02, 0.01, 0.03, 0.72)
const STAMP_IN: float = 0.15
const STAMP_HOLD: float = 0.55
const STAMP_OUT: float = 0.35
## The instant of the icon (Art Bible §4.3 item 4): in Consolation the field
## turns flat gold and the saint black ink; in the Dark Night, black with
## the saint outlined in bone; the name of the state above.
const INSTANT_IN: float = 0.12
const INSTANT_HOLD: float = 0.7
const INSTANT_OUT: float = 0.3
const INSTANT_LABEL := Rect2(0, 40, 960, 30)
## Drawn above the fighters while they last (z order inside the field).
const OVERLAY_Z: int = 3
## Saint Raphael at the victory with the liver (bosses.md §5.3, D-452,
## D-453): beside the defeated Asmodeus, Raphael flickers in flat gold and
## becomes himself (gold edge, halo); the story panel; then he flickers in
## gold again and is gone.
const RAPHAEL_PATH: String = "res://assets/pixel/characters/archangel_raphael/archangel_raphael.png"
const RAPHAEL_GOLD_PATH: String = "res://assets/pixel/characters/archangel_raphael/archangel_raphael_gold.png"
const RAPHAEL_PANEL_PATH: String = "res://assets/events/circle_02/scene_raphael_binds.png"
## Gap between Raphael's right edge and Asmodeus' feet, and where his halo
## stands on the drawing (measured on it).
const RAPHAEL_GAP: float = 70.0
const RAPHAEL_HALO_CENTER := Vector2(52, 4)
const RAPHAEL_HALO_SIZE: float = 40.0
const FLICKER_STEP: float = 0.08
const FLICKERS: int = 3
const BECOME: float = 0.35
const RAPHAEL_HOLD: float = 0.8
const PANEL_FADE: float = 0.4
const PANEL_HOLD: float = 3.5
const PANEL_CAPTION := Rect2(40, 492, 880, 30)
const RAPHAEL_FADE: float = 0.3
## The Vendaval's wind sweeps at about chest height over the saints.
const WIND_HEIGHT: float = 90.0
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
## The scenery of the corridor the battle broke out in (SceneryPlan.look);
## empty: the leg-1 set, or the boss arena.
var scenery_look: Dictionary = {}
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
var _sheet_icons: HBoxContainer
var _boss_bar: Control
var _note: Control
var _note_title: Label
var _note_text: Label
var _pack_capacity: int = 0
var _sheet_picture: TextureRect
## combatant id -> CombatantBadge (bars, mark, intent, conditions).
var _badges: Dictionary = {}
## combatant id -> CharacterFrames (null: a rectangle).
var _frames: Dictionary = {}
var _camera: ImpactCamera
var _dim: ColorRect
var _stamp_dark: ColorRect
## What of an ability stamp passes behind the fighters (the far half of
## Benedict's ring, D-453).
var _stamps_behind: Control
var _stamp: TextureRect
var _instant_bg: ColorRect
var _instant_label: Label
## Raphael's scene played (it plays once, at the end of the boss battle).
var _raphael_played: bool = false
var _raphael_nodes: Array[CanvasItem] = []
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
	# The sheet on the right is the enemy's (D-411): the saint is on the left.
	if not c.is_saint():
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
		var bound: bool = false
		for ev: BattleEvent in ctrl.history:
			if ev.type == BattleController.EV_BOSS_DEFEATED:
				bound = bool(ev.data["bound"])
				_result_label.text += "\n" + texts.t(&"boss_bound" if bound else &"boss_fled")
		if bound and not _raphael_played and _play_raphael():
			_refresh()
			return
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
			var stamp_time: float = 0.0
			if actor != null and actor_view != null and StringName(str(d["ability"])) == actor.miracle:
				actor_view.next_windup = MIRACLE_WINDUP
				stamp_time = _play_stamp(actor.def_id)
			var first_target: StringName = StringName(str(targets[0])) if not targets.is_empty() else &""
			var blow: float = _act(d["actor"], _style_of_ability(d["ability"]), first_target)
			if actor != null:
				_schedule_saint_stamp(actor, StringName(str(d["ability"])), first_target if first_target != &"" else actor.id, blow)
			return maxf(stamp_time, blow)
		&"enemy_action", &"party_turn_ended":
			_last_actor = &""
		&"enemy_action_started":
			# An action with its own clip plays it whole; its damage then
			# lands without a second lunge (D-428).
			var acting: CombatantView = view_of(StringName(str(d["enemy"])))
			var action_clip := StringName(str(d["action"]))
			if acting == null or acting.player() == null or not acting.player().frames.has_clip(action_clip):
				return 0.0
			_last_actor = StringName(str(d["enemy"]))
			var aimed: Array = d.get("targets", [])
			var aimed_view: CombatantView = view_of(StringName(str(aimed[0]))) if not aimed.is_empty() else null
			var where: Vector2 = aimed_view.chest_global() if aimed_view != null and aimed_view != acting else Vector2.INF
			return acting.play_own_clip(action_clip, where) * acting.impact_share()
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
			var ink: StringName = _ink_of(source, target_id, StringName(str(d.get("type", ""))))
			if lunge > 0.0:
				# The target reacts when the blow lands, after the wait.
				_pending_hit = {"target": target_id, "text": number, "ink": ink}
				return lunge
			view.float_text(number, COLOR_DAMAGE)
			_play_ink(ink, view)
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
			if view != null and (d["new"] == Desolation.CONSOLATION or d["new"] == Desolation.DARK_NIGHT):
				return maxf(_scaled(SMALL_TIME, factor), _play_instant(view, StringName(str(d["new"]))))
			return _scaled(SMALL_TIME, factor)
		&"fell", &"enemy_died":
			var view: CombatantView = view_of(d["target"])
			return view.play_fall() if view != null else 0.0
		&"interceded":
			# D-268: a thread of gold from the one who intercedes to the one he helps.
			var giver: CombatantView = view_of(StringName(str(d["actor"])))
			var helped: CombatantView = view_of(StringName(str(d["target"])))
			if giver != null and helped != null and factor > 0.0:
				var thread := GoldenThread.new()
				thread.z_index = OVERLAY_Z
				_field.add_child(thread)
				var to_field: Transform2D = _field.get_global_transform().affine_inverse()
				return thread.play(to_field * giver.halo_global(), to_field * helped.halo_global(), factor)
		&"gale_swapped":
			# D-402, D-455: the wind sweeps over the two saints it swaps.
			var slots: Array = d.get("slots", [])
			if slots.size() == 2:
				var mid: float = (_saint_x(int(slots[0])) + _saint_x(int(slots[1]))) * 0.5
				_play_ink_at(InkSplash.WIND, Vector2(mid, GROUND_Y - WIND_HEIGHT))
		&"moved", &"swapped", &"summoned":
			_sync_views(factor > 0.0)
			if ev.type == &"summoned":
				# D-455: the new enemy comes out of a pool of ink.
				_play_ink(InkSplash.POOL, view_of(StringName(str(d["enemy"]))))
			return _scaled(MOVE_TIME, factor)
	return 0.0


## D-424: darkness and the white stamp of `saint_def_id`; returns how long
## it lasts (0 at the instant speed or without a stamp).
func _play_stamp(saint_def_id: StringName) -> float:
	var factor: float = SPEEDS[speed_index]
	var path: String = STAMP_PATH % saint_def_id
	if factor <= 0.0 or not ResourceLoader.exists(path) or not is_inside_tree():
		return 0.0
	var tex: Texture2D = load(path)
	_stamp.texture = tex
	_stamp.size = tex.get_size()
	_stamp.position = ((Vector2(STAGE_SIZE.x, FIELD_HEIGHT) - _stamp.size) * 0.5).round()
	_stamp_dark.visible = true
	_stamp.visible = true
	_stamp_dark.modulate.a = 0.0
	_stamp.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(_stamp_dark, "modulate:a", 1.0, STAMP_IN / factor)
	tween.parallel().tween_property(_stamp, "modulate:a", 1.0, STAMP_IN / factor)
	tween.tween_interval(STAMP_HOLD / factor)
	tween.tween_property(_stamp_dark, "modulate:a", 0.0, STAMP_OUT / factor)
	tween.parallel().tween_property(_stamp, "modulate:a", 0.0, STAMP_OUT / factor)
	tween.tween_callback(func() -> void:
		_stamp_dark.visible = false
		_stamp.visible = false)
	return (STAMP_IN + STAMP_HOLD + STAMP_OUT) / factor


## The instant of the icon when `view`'s saint enters `state`.
func _play_instant(view: CombatantView, state: StringName) -> float:
	var factor: float = SPEEDS[speed_index]
	if factor <= 0.0 or not is_inside_tree():
		return 0.0
	var gold: bool = state == Desolation.CONSOLATION
	_instant_bg.color = PixelStyle.COLOR_GOLD if gold else PixelStyle.COLOR_PITCH
	_instant_label.text = texts.t(StringName("spirit_%s" % state))
	_instant_label.add_theme_color_override("font_color", PixelStyle.COLOR_PITCH if gold else PixelStyle.COLOR_BONE)
	_instant_label.add_theme_color_override("font_outline_color", PixelStyle.COLOR_GOLD if gold else PixelStyle.COLOR_PITCH)
	for item: CanvasItem in [_instant_bg, _instant_label]:
		item.visible = true
		item.modulate.a = 0.0
	var figure: FramePlayer = view.player()
	var kept: Dictionary = {}
	view.z_index = OVERLAY_Z + 1
	if figure != null:
		kept = {"strength": figure.outline_strength, "color": figure.outline_color, "width": figure.outline_width, "pulse": figure.outline_pulse, "tint": figure.self_modulate}
		# Only the figure's own drawing turns to ink; its outline (a child)
		# keeps the bone of the Dark Night.
		figure.self_modulate = Color.BLACK
		if not gold:
			figure.outline_color = PixelStyle.COLOR_BONE
			figure.outline_width = 1.0
			figure.outline_pulse = false
			figure.outline_strength = 1.0
	var tween := create_tween()
	tween.tween_property(_instant_bg, "modulate:a", 1.0, INSTANT_IN / factor)
	tween.parallel().tween_property(_instant_label, "modulate:a", 1.0, INSTANT_IN / factor)
	tween.tween_interval(INSTANT_HOLD / factor)
	tween.tween_property(_instant_bg, "modulate:a", 0.0, INSTANT_OUT / factor)
	tween.parallel().tween_property(_instant_label, "modulate:a", 0.0, INSTANT_OUT / factor)
	tween.tween_callback(func() -> void:
		_instant_bg.visible = false
		_instant_label.visible = false
		view.z_index = 0
		if figure != null:
			figure.self_modulate = kept["tint"]
			figure.outline_strength = float(kept["strength"])
			figure.outline_color = kept["color"]
			figure.outline_width = float(kept["width"])
			figure.outline_pulse = bool(kept["pulse"]))
	return (INSTANT_IN + INSTANT_HOLD + INSTANT_OUT) / factor


## D-452: the stamp of a saint's ability lands on its target with the blow.
func _schedule_saint_stamp(actor: Combatant, ability_id: StringName, target_id: StringName, delay: float) -> void:
	var factor: float = SPEEDS[speed_index]
	var stamp_shape: StringName = SaintStamp.shape_for(actor.def_id, AbilityIcon.of(ctrl.state.catalog.ability(ability_id)))
	var target: CombatantView = view_of(target_id)
	if factor <= 0.0 or stamp_shape == &"" or target == null or SaintStamp.texture_of(stamp_shape) == null or not is_inside_tree():
		return
	var place := func() -> void:
		if not is_instance_valid(target):
			return
		var stamp := SaintStamp.new()
		stamp.z_index = OVERLAY_Z
		_field.add_child(stamp)
		var to_field: Transform2D = _field.get_global_transform().affine_inverse()
		stamp.play(stamp_shape, to_field * target.chest_global(), to_field * target.feet_global(), factor, _stamps_behind)
	if delay > 0.0:
		get_tree().create_timer(delay).timeout.connect(place)
	else:
		place.call()


## The ability stamps playing now (tests).
func saint_stamps_shown() -> Array[StringName]:
	var shown: Array[StringName] = []
	for child: Node in _field.get_children():
		if child is SaintStamp:
			shown.append((child as SaintStamp).shape)
	return shown


## Raphael's scene; false when it cannot play (instant speed, no art), and
## the result shows at once.
func _play_raphael() -> bool:
	var factor: float = SPEEDS[speed_index]
	var boss_view: CombatantView = null
	for c: Combatant in ctrl.state.enemies:
		if c.category == &"boss":
			boss_view = view_of(c.id)
	if factor <= 0.0 or boss_view == null or not is_inside_tree() or not ResourceLoader.exists(RAPHAEL_PATH):
		return false
	_raphael_played = true
	busy = true
	var to_field: Transform2D = _field.get_global_transform().affine_inverse()
	var boss_feet: Vector2 = to_field * boss_view.feet_global()
	var figure_tex: Texture2D = load(RAPHAEL_PATH)
	var right: float = boss_feet.x - RAPHAEL_GAP
	var at := Vector2(roundf(right - figure_tex.get_width()), GROUND_Y - figure_tex.get_height())
	var halo := TextureRect.new()
	halo.texture = _halo_settings.disk if _halo_settings != null else null
	halo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	halo.size = Vector2.ONE * RAPHAEL_HALO_SIZE
	halo.position = (at + RAPHAEL_HALO_CENTER - halo.size * 0.5).round()
	var figure := TextureRect.new()
	figure.texture = figure_tex
	figure.position = at
	var gold := TextureRect.new()
	gold.texture = load(RAPHAEL_GOLD_PATH)
	gold.position = at
	_raphael_nodes.clear()
	for item: Control in [halo, figure, gold]:
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.z_index = OVERLAY_Z
		item.modulate.a = 0.0
		_field.add_child(item)
		_raphael_nodes.append(item)
	var panel := TextureRect.new()
	panel.texture = load(RAPHAEL_PANEL_PATH) if ResourceLoader.exists(RAPHAEL_PANEL_PATH) else null
	panel.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	panel.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	panel.size = STAGE_SIZE
	var caption := Label.new()
	caption.text = texts.t(&"boss_bound")
	caption.position = PANEL_CAPTION.position
	caption.size = PANEL_CAPTION.size
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	PixelStyle.title(caption, PixelStyle.COLOR_BONE, PixelStyle.BIG_TITLE_SIZE)
	for item: Control in [panel, caption]:
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.z_index = OVERLAY_Z + 10
		item.modulate.a = 0.0
		_stage.add_child(item)
		_raphael_nodes.append(item)
	var tween := create_tween()
	# Raphael appears in flat gold, flickering, beside the defeated Asmodeus.
	_flicker(tween, gold, factor)
	# The gold becomes the archangel as Alan drew him, with his halo.
	tween.tween_property(figure, "modulate:a", 1.0, BECOME / factor)
	tween.parallel().tween_property(halo, "modulate:a", 1.0, BECOME / factor)
	tween.parallel().tween_property(gold, "modulate:a", 0.0, BECOME / factor)
	tween.tween_interval(RAPHAEL_HOLD / factor)
	# The story panel: Raphael binds Asmodeus (Tobit 8:3).
	tween.tween_property(panel, "modulate:a", 1.0, PANEL_FADE / factor)
	tween.parallel().tween_property(caption, "modulate:a", 1.0, PANEL_FADE / factor)
	tween.tween_interval(PANEL_HOLD / factor)
	tween.tween_property(panel, "modulate:a", 0.0, PANEL_FADE / factor)
	tween.parallel().tween_property(caption, "modulate:a", 0.0, PANEL_FADE / factor)
	# Back on the field he turns to gold again, flickers and is gone.
	tween.tween_property(gold, "modulate:a", 1.0, BECOME / factor)
	tween.parallel().tween_property(figure, "modulate:a", 0.0, BECOME / factor)
	tween.parallel().tween_property(halo, "modulate:a", 0.0, BECOME / factor)
	_flicker(tween, gold, factor)
	tween.tween_property(gold, "modulate:a", 0.0, RAPHAEL_FADE / factor)
	tween.tween_callback(func() -> void:
		for item: CanvasItem in _raphael_nodes:
			if is_instance_valid(item):
				item.queue_free()
		_raphael_nodes.clear()
		busy = false
		_result_overlay.visible = true
		_refresh())
	return true


## The gold flickers: on, dim, on... and stays on.
func _flicker(tween: Tween, item: CanvasItem, factor: float) -> void:
	for i: int in FLICKERS:
		tween.tween_property(item, "modulate:a", 1.0, FLICKER_STEP / factor)
		tween.tween_property(item, "modulate:a", 0.2, FLICKER_STEP / factor)
	tween.tween_property(item, "modulate:a", 1.0, FLICKER_STEP / factor)


## True while Raphael's scene plays (tests).
func raphael_shown() -> bool:
	return not _raphael_nodes.is_empty()


## True while the miracle's stamp or the instant of the icon is on screen.
func stamp_shown() -> bool:
	return _stamp != null and _stamp.visible


func instant_shown() -> bool:
	return _instant_bg != null and _instant_bg.visible


func _react(hit: Dictionary) -> float:
	var view: CombatantView = view_of(hit["target"])
	if view == null:
		return 0.0
	view.float_text(hit["text"], COLOR_DAMAGE)
	_play_ink(StringName(str(hit.get("ink", ""))), view)
	return view.play_hit()


## The enemy's ink on a saint it hits (D-454, D-455): a blow in the flesh
## leaves the slash; any other harm rises from the ground as a stain.
func _ink_of(source: StringName, target_id: StringName, damage_type: StringName) -> StringName:
	var attacker: Combatant = ctrl.state.find(source)
	var target: Combatant = ctrl.state.find(target_id)
	if attacker == null or target == null or attacker.is_saint() or not target.is_saint():
		return &""
	return InkSplash.SLASH if damage_type == &"strike" else InkSplash.STAIN


func _play_ink(ink: StringName, view: CombatantView) -> void:
	if view == null:
		return
	var spot: Vector2 = view.feet_global() if InkSplash.GROUNDED.has(ink) else view.chest_global()
	_play_ink_at(ink, _field.get_global_transform().affine_inverse() * spot)


## `ink` at `at` in the field's coordinates.
func _play_ink_at(ink: StringName, at: Vector2) -> void:
	var factor: float = SPEEDS[speed_index]
	if ink == &"" or factor <= 0.0 or InkSplash.texture_of(ink) == null:
		return
	var splash := InkSplash.new()
	# Over the fighters, under their bars and intents.
	_field.add_child(splash)
	_field.move_child(splash, _badges_layer.get_index())
	splash.play(ink, at, factor)


## The golden threads playing now (tests).
func threads_shown() -> int:
	var count: int = 0
	for child: Node in _field.get_children():
		if child is GoldenThread:
			count += 1
	return count


## The ink splashes playing now (tests).
func inks_shown() -> Array[StringName]:
	var shown: Array[StringName] = []
	for child: Node in _field.get_children():
		if child is InkSplash:
			shown.append((child as InkSplash).kind)
	return shown


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
	_boss_bar.visible = ctrl.state.boss() != null
	_boss_bar.queue_redraw()
	_speed_button.text = texts.t(SPEED_KEYS[speed_index])
	_pause_button.text = texts.t(&"pause")
	_refresh_lume()


func _draw_boss_bar() -> void:
	var boss: Combatant = ctrl.state.boss() if ctrl != null else null
	if boss == null:
		return
	var w: float = BOSS_BAR.size.x
	var font: Font = PixelStyle.title_font()
	var name_text: String = texts.name_of(boss)
	# The name on a small dark plate centred over the bar; the phase and the
	# claws on the same line, at the ends (D-442).
	var name_w: float = font.get_string_size(name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, PixelStyle.TITLE_SIZE).x + 16.0
	var plate := Rect2(roundf((w - name_w) * 0.5), 0, roundf(name_w), 14)
	_boss_bar.draw_rect(plate, PixelStyle.COLOR_PITCH)
	_boss_bar.draw_rect(plate, PixelStyle.COLOR_LEAD_LIGHT, false)
	_boss_bar.draw_string(font, Vector2(plate.position.x, 11), name_text, HORIZONTAL_ALIGNMENT_CENTER, plate.size.x, PixelStyle.TITLE_SIZE, PixelStyle.COLOR_BONE)
	var phase: String = texts.t(&"boss_phase_float", {"phase": ctrl.state.boss_phase, "of": ctrl.state.boss_phase_count()})
	_boss_bar.draw_string(PixelStyle.text_font(), Vector2(BOSS_BAR_END, 11), phase, HORIZONTAL_ALIGNMENT_LEFT, -1, PixelStyle.TEXT_SIZE, PixelStyle.COLOR_GOLD)
	# The iron bar with claws at the ends (D-441): ends kept, middle stretched.
	var frame: Texture2D = PixelStyle.piece("ui_boss_bar")
	var top: float = 12.0
	if frame != null:
		var end_w: float = BOSS_BAR_END
		var fh: float = frame.get_height()
		_boss_bar.draw_texture_rect_region(frame, Rect2(0, top, end_w, fh), Rect2(0, 0, end_w, fh))
		_boss_bar.draw_texture_rect_region(frame, Rect2(end_w, top, w - end_w * 2.0, fh), Rect2(end_w, 0, frame.get_width() - end_w * 2.0, fh))
		_boss_bar.draw_texture_rect_region(frame, Rect2(w - end_w, top, end_w, fh), Rect2(frame.get_width() - end_w, 0, end_w, fh))
	var share: float = clampf(float(boss.hp) / maxf(float(boss.max_hp), 1.0), 0.0, 1.0)
	var bar := Rect2(BOSS_BAR_FILL_INSET, top + BOSS_BAR_SLOT.x, w - BOSS_BAR_FILL_INSET * 2.0, BOSS_BAR_SLOT.y)
	_boss_bar.draw_rect(Rect2(bar.position, Vector2(roundf(bar.size.x * share), bar.size.y)), PixelStyle.COLOR_BLOOD)
	# The claws of the Domínio still holding (bosses.md §5), at the right.
	var grip: Texture2D = PixelStyle.piece("ui_claw_grip")
	if grip != null:
		for i: int in ctrl.state.dominion_claws.size():
			_boss_bar.draw_texture_rect(grip, Rect2(w - BOSS_BAR_END - 14 - i * 14, -3, 13, 16), false)


## Whether the big boss bar is shown (tests).
func boss_bar_shown() -> bool:
	return _boss_bar != null and _boss_bar.visible


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
			_dress_lancet(button as PieceButton, &"")
			_set_button(button, "", &"", true, false)
			continue
		var id: StringName = actor.equipped[i]
		var chosen: bool = selection.mode == BattleSelection.Mode.ABILITY and selection.ability_id == id
		_dress_lancet(button as PieceButton, AbilityIcon.of(ctrl.state.catalog.ability(id)))
		(button as PieceButton).pips = ctrl.effective_cost(actor, ctrl.state.catalog.ability(id))
		(button as PieceButton).pips_y = LANCET_PIPS_Y
		_set_button(button, _ability_label(actor, id), selection.ability_reason(id, false), false, chosen)
	_dress_rose(actor)
	if open:
		_set_button(_miracle_button, _ability_label(actor, actor.miracle, true), selection.ability_reason(actor.miracle, true), false, selection.mode == BattleSelection.Mode.MIRACLE)
		_set_button(_swap_button, texts.t(&"swap"), selection.swap_reason(), false, selection.mode == BattleSelection.Mode.SWAP)
		_set_button(_pass_button, texts.t(&"pass"), selection.pass_reason(), false, selection.mode == BattleSelection.Mode.PASS)
		_set_button(_intercede_button, texts.t(&"intercede"), selection.intercede_reason(), false, selection.mode == BattleSelection.Mode.INTERCEDE)
		_set_button(_give_button, texts.t(&"give_consolation"), selection.give_consolation_reason(), false, selection.mode == BattleSelection.Mode.GIVE_CONSOLATION)
		_set_button(_stand_firm_button, texts.t(&"stand_firm"), selection.stand_firm_reason(), false, selection.mode == BattleSelection.Mode.STAND_FIRM)
		_set_button(_provisions_button, texts.t(&"pack_count", {"count": ctrl.state.provisions.size()}), _provisions_reason(), false, selection.mode == BattleSelection.Mode.PROVISION or _provision_menu.visible)
	else:
		_set_button(_miracle_button, texts.t(&"miracle"), &"", true, false)
		_set_button(_swap_button, texts.t(&"swap"), &"", true, false)
		_set_button(_pass_button, texts.t(&"pass"), &"", true, false)
		_set_button(_intercede_button, texts.t(&"intercede"), &"", true, false)
		_set_button(_give_button, texts.t(&"give_consolation"), &"", true, false)
		_set_button(_stand_firm_button, texts.t(&"stand_firm"), &"", true, false)
		_set_button(_provisions_button, texts.t(&"pack_count", {"count": ctrl.state.provisions.size()}), &"", true, false)
	# Without a Vendaval in this battle the button is only noise.
	_stand_firm_button.visible = ctrl.state.hazard == &"gale"
	_miracle_label.text = _miracle_button.text
	_miracle_label.add_theme_color_override("font_color", PixelStyle.COLOR_LEAD_LIGHT if _miracle_button.disabled else PixelStyle.COLOR_GOLD)
	_end_turn_button.text = texts.t(&"end_turn")
	_end_turn_button.disabled = not _accepting_input()
	_refresh_provision_menu(open)


## The one portrait of a saint, everywhere (D-442); null without one.
static func saint_portrait(def_id: StringName) -> Texture2D:
	var path: String = SAINT_PORTRAIT_PATH % [def_id, def_id]
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## The head of the saint, cut from its idle frame around the head point
## (as in the approved preview); a saint without frames keeps the painted
## portrait.
func _portrait_of(actor: Combatant) -> Texture2D:
	if actor == null:
		return null
	# The saint's portrait in pixel art (D-431), the same one the camp and the
	# walk show in the arch (D-442).
	var drawn: Texture2D = saint_portrait(actor.def_id)
	if drawn != null:
		return drawn
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


## The mosaic of the ability's kind in the lancet (D-436); the plain glass
## for an empty slot.
func _dress_lancet(button: PieceButton, kind: StringName) -> void:
	if kind == &"":
		button.setup(PixelStyle.piece("ui_lancet_on"), PixelStyle.piece("ui_lancet_chosen"), PixelStyle.piece("ui_lancet_off"), Rect2())
		button.pips = 0
		button.set_meta(&"kind", &"")
		return
	button.setup(AbilityIcon.lancet(kind, "on"), AbilityIcon.lancet(kind, "chosen"), AbilityIcon.lancet(kind, "off"), Rect2())
	button.set_meta(&"kind", kind)


## The medallion of the chosen saint's miracle in the rose (D-438); the
## plain rose for a saint without one.
func _dress_rose(actor: Combatant) -> void:
	var rose: PieceButton = _miracle_button as PieceButton
	var on: Texture2D = AbilityIcon.rose(actor.def_id, "on") if actor != null else null
	if on == null:
		rose.setup(PixelStyle.piece("ui_rose_on"), PixelStyle.piece("ui_rose_on"), PixelStyle.piece("ui_rose_off"), Rect2())
		return
	rose.setup(on, on, AbilityIcon.rose(actor.def_id, "off"), Rect2())


## The mosaic shown in a lancet (tests): its kind, or &"" for plain glass.
func lancet_kind(index: int) -> StringName:
	return StringName(str(_ability_buttons[index].get_meta(&"kind", &"")))


## Empty label hides the button text; a reason greys it out and is shown
## under the name (screens §3); the small tiles show it in the hint.
func _set_button(button: Button, label: String, reason: StringName, off: bool, chosen: bool) -> void:
	var text: String = label
	if reason != &"" and not label.is_empty() and button.icon == null:
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


## The alforje opened (D-412): one slot per unit it holds, full or empty;
## a full slot shows the provision and is touched to use it.
func _refresh_provision_menu(open: bool) -> void:
	for child: Node in _provision_menu.get_children():
		_provision_menu.remove_child(child)
		child.queue_free()
	if not open:
		_provision_menu.visible = false
	if not _provision_menu.visible:
		return
	var slots: int = maxi(pack_capacity(), ctrl.state.provisions.size())
	var rows: int = int(ceil(float(slots) / PACK_COLUMNS))
	var plate_size := Vector2(PACK_COLUMNS * (PACK_SLOT.x + 4.0) + 8.0, rows * (PACK_SLOT.y + 4.0) + 24.0)
	_provision_menu.add_child(PixelStyle.plate(Rect2(Vector2.ZERO, plate_size), PixelStyle.COLOR_IRON, PixelStyle.COLOR_GOLD))
	var title := Label.new()
	title.text = texts.t(&"pack_title", {"count": ctrl.state.provisions.size(), "of": slots})
	title.position = Vector2(8, 3)
	PixelStyle.title(title)
	_provision_menu.add_child(title)
	for i: int in slots:
		var id: StringName = ctrl.state.provisions[i] if i < ctrl.state.provisions.size() else &""
		var slot := Button.new()
		slot.position = Vector2(8 + (i % PACK_COLUMNS) * (PACK_SLOT.x + 4.0), 20 + (i / PACK_COLUMNS) * (PACK_SLOT.y + 4.0))
		slot.size = PACK_SLOT
		slot.focus_mode = Control.FOCUS_NONE
		if id == &"":
			slot.disabled = true
			slot.text = texts.t(&"pack_empty")
		else:
			slot.icon = HudStyle.icon("icon_item_%s" % id)
			slot.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			slot.set_meta(&"provision", id)
			slot.tooltip_text = texts.provision_name(id)
			slot.disabled = selection.provision_reason(id) != &""
			slot.modulate = COLOR_CHOSEN if selection.mode == BattleSelection.Mode.PROVISION and selection.provision_id == id else Color.WHITE
			slot.pressed.connect(press_provision.bind(id))
		_provision_menu.add_child(slot)


## Slots of the alforje: given by the expedition (the Gate's level), else
## the first level's (the arena).
func pack_capacity() -> int:
	if _pack_capacity > 0:
		return _pack_capacity
	return FieldProvisions.capacity(1, ctrl.state.constants)


func set_pack_capacity(slots: int) -> void:
	_pack_capacity = slots


## How many kinds of provision the opened alforje shows (tests).
func provision_hook_count() -> int:
	var kinds: Array[StringName] = []
	for child: Node in _provision_menu.get_children():
		var id: StringName = StringName(str(child.get_meta(&"provision", &""))) if child.has_meta(&"provision") else &""
		if id != &"" and not kinds.has(id):
			kinds.append(id)
	return kinds.size()


## Whether the alforje is open (tests).
func pack_open() -> bool:
	return _provision_menu.visible


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
	_refresh_note()
	if selection.mode == BattleSelection.Mode.PROVISION and not ctrl.is_over():
		_hint.text = texts.provision_name(selection.provision_id) + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.INTERCEDE and not ctrl.is_over():
		_hint.text = _intercede_hint() + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.GIVE_CONSOLATION and not ctrl.is_over():
		_hint.text = texts.t(&"give_consolation_desc") + "\n" + _hint.text
	if selection.mode == BattleSelection.Mode.STAND_FIRM and not ctrl.is_over():
		_hint.text = texts.t(&"stand_firm_desc", {"fervor": ctrl.state.constants.get_int(&"firmness_fervor")}) + "\n" + _hint.text


## The note in the corner (D-440): the touched ability's or miracle's name,
## cost and description, so the lancet keeps its glass clear.
func _refresh_note() -> void:
	var def: AbilityDef = null
	if not ctrl.is_over() and selection.actor() != null:
		if selection.mode == BattleSelection.Mode.ABILITY:
			def = ctrl.state.catalog.ability(selection.ability_id)
		elif selection.mode == BattleSelection.Mode.MIRACLE:
			def = ctrl.state.catalog.ability(selection.actor().miracle)
	_note.visible = def != null
	if def == null:
		return
	# Under the boss's bar when there is one.
	_note.position.y = NOTE_RECT.position.y + (NOTE_BOSS_DROP if boss_bar_shown() else 0.0)
	var title: String = def.name_pt
	var cost: int = ctrl.effective_cost(selection.actor(), def)
	if cost > 0:
		title += " · " + texts.t(&"cost_badge", {"cost": cost})
	_note_title.text = title
	_note_text.text = def.desc_pt


## The note's words (tests): name and cost, then the description.
func note_text() -> String:
	return "%s\n%s" % [_note_title.text, _note_text.text] if _note.visible else ""


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
## The enemy on the right-hand sheet (D-411): the one last tapped, or the
## first one standing; never a saint, who is shown in the arch on the left.
func info_enemy() -> Combatant:
	var tapped: Combatant = ctrl.state.find(_info_id) if _info_id != &"" else null
	if tapped != null and not tapped.is_saint() and tapped.state != Combatant.State.DEAD:
		return tapped
	for e: Combatant in ctrl.state.enemies:
		if e.is_alive_enemy():
			return e
	return null


func _refresh_info() -> void:
	var c: Combatant = info_enemy()
	if c == null:
		_refresh_sheet_icons(null)
		_info.text = ""
		_sheet_title.text = ""
		_sheet_picture.texture = null
		return
	_sheet_title.text = texts.name_of(c)
	_refresh_sheet_icons(c)
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


## The intents (in their oculus colours) and the conditions of the sheet's
## combatant as icons, in that order (D-436).
func _refresh_sheet_icons(c: Combatant) -> void:
	for child: Node in _sheet_icons.get_children():
		_sheet_icons.remove_child(child)
		child.queue_free()
	if c == null:
		return
	var icons: Array[Texture2D] = []
	if not c.is_saint() and not ctrl.is_over():
		for intent: Intent in ctrl.state.intents_of(c):
			var tex: Texture2D = HudStyle.intent_icon(intent)
			if tex != null:
				icons.append(tex)
	for id: StringName in texts.sorted_conditions(c):
		var tex: Texture2D = HudStyle.condition_icon(id)
		if tex != null:
			icons.append(tex)
	for tex: Texture2D in icons:
		var rect := TextureRect.new()
		rect.texture = tex
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		rect.custom_minimum_size = SHEET_ICON
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_sheet_icons.add_child(rect)


## Icons on the sheet (tests).
func sheet_icon_count() -> int:
	return _sheet_icons.get_child_count()


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


## The darkness and the stamp of the miracle, and the instant of the icon,
## over the whole field and above the fighters (hidden until used).
func _build_overlays() -> void:
	var cover := Rect2(-OVERLAY_MARGIN, -OVERLAY_MARGIN, STAGE_SIZE.x + OVERLAY_MARGIN * 2.0, FIELD_HEIGHT + OVERLAY_MARGIN * 2.0)
	_stamp_dark = ColorRect.new()
	_stamp_dark.color = STAMP_DARK
	_instant_bg = ColorRect.new()
	for rect: ColorRect in [_stamp_dark, _instant_bg]:
		rect.position = cover.position
		rect.size = cover.size
	_stamp = TextureRect.new()
	_instant_label = Label.new()
	_instant_label.position = INSTANT_LABEL.position
	_instant_label.size = INSTANT_LABEL.size
	PixelStyle.title(_instant_label, PixelStyle.COLOR_BONE, PixelStyle.BIG_TITLE_SIZE)
	_instant_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	for item: Control in [_stamp_dark, _stamp, _instant_bg, _instant_label]:
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.visible = false
		item.z_index = OVERLAY_Z
		_field.add_child(item)
	_instant_label.z_index = OVERLAY_Z + 2
	_stamp.z_index = OVERLAY_Z + 2


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
	var backs: Array[Dictionary] = CircleLook.back_layers(set_id)
	var fronts: Array[Dictionary] = CircleLook.front_layers(set_id)
	if not scenery_look.is_empty():
		# The battle stays in the place of the corridor (D-359, D-446).
		backs = SceneryPlan.back_layers(scenery_look)
		fronts = SceneryPlan.front_layers(scenery_look)
	_scenery_back = ParallaxScenery.new()
	_scenery_back.setup(backs, CircleLook.filter_material())
	_field.add_child(_scenery_back)
	_dim = ColorRect.new()
	_dim.color = Color(0.02, 0.01, 0.02, 0.0)
	_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_dim)
	_stamps_behind = Control.new()
	_stamps_behind.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_stamps_behind)
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
		front.setup(fronts, CircleLook.filter_material())
		front.drop = FRONT_DROP
		holder.add_child(front)
		_front_corners.append(holder)
		_scenery_front.append(front)
	_build_overlays()
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
	var band := TextureRect.new()
	band.texture = PixelStyle.piece("ui_top_band")
	band.stretch_mode = TextureRect.STRETCH_TILE
	band.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	band.position = Vector2(-OVERLAY_MARGIN, 0)
	band.size = Vector2(STAGE_SIZE.x + OVERLAY_MARGIN * 2.0, 16)
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(band)
	_round_label = _label(Vector2(180, 18), Vector2(600, 14))
	PixelStyle.title(_round_label)
	_hint = _label(Vector2(230, 32), Vector2(500, 24))
	_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_note = PixelStyle.iron_plate(NOTE_RECT)
	_note.visible = false
	_stage.add_child(_note)
	_note_title = Label.new()
	_note_title.position = Vector2(10, 6)
	_note_title.size = Vector2(NOTE_RECT.size.x - 20.0, 14)
	PixelStyle.title(_note_title)
	_note.add_child(_note_title)
	_note_text = Label.new()
	_note_text.position = Vector2(10, 22)
	_note_text.size = Vector2(NOTE_RECT.size.x - 20.0, NOTE_RECT.size.y - 28.0)
	_note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_note.add_child(_note_text)
	_boss_bar = Control.new()
	_boss_bar.position = BOSS_BAR.position
	_boss_bar.size = BOSS_BAR.size
	_boss_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_boss_bar.draw.connect(_draw_boss_bar)
	_stage.add_child(_boss_bar)
	_pause_button = _button(Vector2(778, 18), Vector2(52, 26), press_pause)
	_speed_button = _button(Vector2(834, 18), Vector2(122, 26), press_speed)
	_build_dev_row()


## The panel under the field, the "chapel in the dark" (Art Bible, D-368):
## the chosen saint and its actions on the left, the tapped combatant in a
## broken frame on the right.
func _build_bottom() -> void:
	_stage.add_child(PixelStyle.stone_panel(Rect2(-OVERLAY_MARGIN, FIELD_HEIGHT, STAGE_SIZE.x + OVERLAY_MARGIN * 2.0, STAGE_SIZE.y - FIELD_HEIGHT + 1.0)))
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
	# A dark nameplate on the iron band of the stone (D-442): the saint's
	# name, slot, life and desolation read on it, not over the bars.
	_stage.add_child(PixelStyle.plate(Rect2(NAMEPLATE.position, NAMEPLATE.size), PixelStyle.COLOR_PITCH, PixelStyle.COLOR_LEAD_LIGHT))
	_actor_label = _label(Vector2(118, 362), Vector2(150, 16))
	_actor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	PixelStyle.title(_actor_label)
	_actor_detail = _label(Vector2(250, 365), Vector2(56, 12))
	_actor_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_actor_detail.add_theme_color_override("font_color", PixelStyle.COLOR_GREY)
	# Life and desolation next to the slot, over the top of the rose (the
	# tiles of the actions took the right side, D-436).
	_stats = _label(Vector2(306, 365), Vector2(234, 12))
	_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
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
	_miracle_label = _label(MIRACLE_LABEL.position, MIRACLE_LABEL.size)
	_miracle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_miracle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_piece("ui_candle_rack", RACK_POS)
	_fervor_flames = Control.new()
	_fervor_flames.position = RACK_POS
	_fervor_flames.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fervor_flames.draw.connect(_draw_fervor)
	_stage.add_child(_fervor_flames)
	_fervor_label = _label(Vector2(456, 462), Vector2(82, 12))
	_fervor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_fervor_label.add_theme_color_override("font_color", PixelStyle.COLOR_AMBER)
	_swap_button = _tile(0, "icon_action_swap", press_swap)
	_pass_button = _tile(1, "icon_action_pass", press_pass)
	_intercede_button = _tile(2, "icon_action_intercede", press_intercede)
	_give_button = _tile(3, "icon_action_consolation", press_give_consolation)
	_stand_firm_button = _tile(4, "icon_action_firmness", press_stand_firm)
	# The alforje (D-298, D-412): a tile that opens its slots.
	_provisions_button = _tile(5, "icon_item_alms", press_provisions)
	_provisions_button.icon = PixelStyle.piece("ui_hook_bag")
	_provisions_button.expand_icon = true
	_provision_menu = Control.new()
	_provision_menu.position = PACK_POS
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
	_stage.add_child(PixelStyle.iron_plate(Rect2(SHEET_X - 8.0, 364, STAGE_SIZE.x - SHEET_X + 2.0, 134)))
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
	# The intents and conditions of the sheet as icons (D-436); the words
	# stay below for the details.
	_sheet_icons = HBoxContainer.new()
	_sheet_icons.position = Vector2(SHEET_X, 385)
	_sheet_icons.add_theme_constant_override("separation", 2)
	_sheet_icons.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_sheet_icons)
	_info = _label(Vector2(SHEET_X, 420), Vector2(144, 80))
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


## A tile of the action grid: the icon over the name (D-436).
func _tile(index: int, icon_name: String, action: Callable) -> Button:
	var col: int = index % 3
	var row: int = index / 3
	var pos: Vector2 = ACTION_POS + Vector2(col * (ACTION_TILE.x + ACTION_GAP), row * (ACTION_TILE.y + ACTION_GAP))
	var frame := _piece("ui_tile_frame", pos - Vector2(2, 2))
	frame.size = ACTION_TILE + Vector2(4, 4)
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	var button: Button = _button(pos, ACTION_TILE, action)
	# The iron frame is the button's edge; the button itself is only its icon
	# and name (D-441).
	for state: StringName in [&"normal", &"hover", &"pressed", &"disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	button.icon = HudStyle.icon(icon_name)
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	button.expand_icon = false
	button.add_theme_constant_override("icon_max_width", 32)
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.focus_mode = Control.FOCUS_NONE
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
