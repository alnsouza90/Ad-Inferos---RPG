class_name BattleScreen
extends Control
## The battle screen of screens §3. It sends commands to BattleController,
## animates the returned events in order and redraws from the state; it never
## decides a rule (architecture §3.2). Layout is built in code on a 1920×1080
## stage that stays centred when the phone is wider (aspect = expand).
## T36 (D-257, D-258): Darkest Dungeon mood. The field (top 720 px) shows the
## Circle 2 scenery with every combatant animated, feet on the ground line,
## bars at the feet and intents over the heads; the iron panel below holds
## the chosen saint (left) and the sheet of the tapped combatant (right).

const STAGE_SIZE := Vector2(1920, 1080)
const FIELD_HEIGHT: float = 720.0
## Ground line of the field and height of a standing figure (D-256).
const GROUND_Y: float = 655.0
const FIGURE_HEIGHT: float = 380.0
## Intents over the enemies, all on one row (field y).
const INTENT_ROW_Y: float = 150.0
const VIEW_WIDTH: float = 200.0
## Feet of the front saint and the front enemy, and the step between slots.
const SAINT_FRONT_X: float = 740.0
const ENEMY_FRONT_X: float = 1110.0
const SLOT_STEP: float = 210.0
## Share of the two figures' widths kept apart when the attacker arrives.
const CONTACT_SHARE: float = 0.55
const BLOW_HOLD: float = 0.45
## Scenery of the field (Circle 2, leg 1): layers scaled to the field.
const SCENERY_DIR: String = "res://assets/environments/circles/circle_02/t1"
const SCENERY_LAYERS: Array[String] = ["env_circle_02_t1_back.png", "env_circle_02_t1_mid.webp"]
const SCENERY_DETAIL: String = "env_circle_02_t1_front_detail.webp"
const SCENERY_SCALE: float = 0.8
const SCENERY_OFFSET := Vector2(-104, -110)
const VIGNETTE_ALPHA: float = 0.45
## The Lume (expedition light) on the left edge (D-257): a lantern that
## slides down an iron rod as the light fades.
const LUME_X: float = 70.0
const LUME_TOP: float = 70.0
const LUME_BOTTOM: float = 600.0
const LANTERN_HEIGHT: float = 120.0
const PIP_SIZE := Vector2(18, 18)
## The portrait frame on screen, and the window inside it where the portrait
## goes (shares of the frame measured on ui_portrait_frame.png, D-259): the
## iron never covers the face.
const PORTRAIT_FRAME := Rect2(44, 30, 168, 164)
const PORTRAIT_WINDOW := Rect2(0.18, 0.235, 0.645, 0.67)
const COLOR_BACKGROUND := Color(0.035, 0.035, 0.04)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const COLOR_DAMAGE := Color(1.0, 0.45, 0.4)
const COLOR_HEAL := Color(0.5, 1.0, 0.6)
const COLOR_SPIRIT := Color(0.8, 0.65, 1.0)
const COLOR_CONDITION := Color(1.0, 0.95, 0.75)
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
## Frames of every character live at <dir>/<def id>_frames.tres (T35); a
## combatant without them stays a rectangle with its name.
const ART_DIR: String = "res://scenes/battle/combatants"
const PORTRAIT_PATH: String = "res://assets/characters/saints/%s/portrait/%s_portrait.png"
const HALO_SETTINGS_PATH: String = "res://scenes/battle/halo_settings.tres"

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
var _fervor_pips: HBoxContainer
var _speed_button: Button
var _pause_button: Button
var _hint: Label
var _info: Label
var _actor_label: Label
var _ability_buttons: Array[Button] = []
var _miracle_button: Button
var _swap_button: Button
var _pass_button: Button
var _provisions_button: Button
var _end_turn_button: Button
var _provision_menu: VBoxContainer
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
var _lantern: TextureRect
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
			return _act(d["actor"], _style_of_ability(d["ability"]), StringName(str(targets[0])) if not targets.is_empty() else &"")
		&"enemy_action", &"party_turn_ended":
			_last_actor = &""
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
	_fervor_label.text = texts.t(&"fervor", {"amount": ctrl.fervor.amount, "max": cap})
	while _fervor_pips.get_child_count() < cap:
		var pip := ColorRect.new()
		pip.custom_minimum_size = PIP_SIZE
		pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_fervor_pips.add_child(pip)
	for i: int in _fervor_pips.get_child_count():
		var pip_rect: ColorRect = _fervor_pips.get_child(i)
		pip_rect.color = HudStyle.COLOR_FERVOR if i < ctrl.fervor.amount else HudStyle.COLOR_PIP_OFF
	_speed_button.text = texts.t(SPEED_KEYS[speed_index])
	_pause_button.text = texts.t(&"pause")
	_refresh_lume()


## The lantern slides down the rod as the Lume fades (D-257).
func _refresh_lume() -> void:
	_lume_holder.visible = light >= 0
	if light < 0:
		return
	var share: float = clampf(float(light) / maxf(float(light_max), 1.0), 0.0, 1.0)
	var y: float = LUME_BOTTOM - (LUME_BOTTOM - LUME_TOP) * share
	_lantern.position = Vector2(LUME_X - _lantern.size.x * 0.5, y - LANTERN_HEIGHT * 0.5)
	_lume_label.text = data.ui.text(&"walk_light", {"value": light})


func _refresh_views() -> void:
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
		_portrait_frame.self_modulate = HudStyle.frame_tint(actor.spirit_state, actor.desolation, ctrl.state.constants.get_int(&"desolation_max"))
		var slot: int = ctrl.state.party_slot_of(actor)
		var status_text: String = texts.status(actor)
		_actor_detail.text = texts.t(&"slot", {"slot": slot}) + (" · " + status_text if not status_text.is_empty() else "")
		_stats.text = "%s\n%s" % [texts.hp(actor), texts.desolation(actor)]
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
		_set_button(_provisions_button, texts.t(&"provisions"), _provisions_reason(), false, selection.mode == BattleSelection.Mode.PROVISION)
	else:
		_set_button(_miracle_button, texts.t(&"miracle"), &"", true, false)
		_set_button(_swap_button, texts.t(&"swap"), &"", true, false)
		_set_button(_pass_button, texts.t(&"pass"), &"", true, false)
		_set_button(_provisions_button, texts.t(&"provisions"), &"", true, false)
	_miracle_button.add_theme_color_override("font_color", HudStyle.COLOR_GOLD)
	_end_turn_button.text = texts.t(&"end_turn")
	_end_turn_button.disabled = not _accepting_input()
	_refresh_provision_menu(open)


func _portrait_of(actor: Combatant) -> Texture2D:
	if actor == null:
		return null
	var art: CombatantArt = _arts.get(actor.id)
	if art != null and art.portrait != null:
		return art.portrait
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


func _refresh_provision_menu(open: bool) -> void:
	for child: Node in _provision_menu.get_children():
		child.queue_free()
	if not open:
		_provision_menu.visible = false
		return
	for id: StringName in _unique_provisions():
		var button := Button.new()
		button.custom_minimum_size = Vector2(320, 70)
		var count: int = ctrl.state.provisions.count(id)
		_set_button(button, "%s (%d)" % [texts.provision_name(id), count], selection.provision_reason(id), false, selection.provision_id == id)
		button.pressed.connect(press_provision.bind(id))
		_provision_menu.add_child(button)


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


## The sheet on the right (DD): the tapped combatant, or the chosen saint.
func _refresh_info() -> void:
	var c: Combatant = ctrl.state.find(_info_id) if _info_id != &"" else selection.actor()
	if c == null:
		_info.text = ""
		_sheet_title.text = ""
		_sheet_picture.texture = null
		return
	_sheet_title.text = texts.name_of(c)
	_sheet_picture.texture = _idle_picture(c.id)
	var lines: Array[String] = []
	var first: String = texts.hp(c)
	var status_text: String = texts.status(c)
	if not status_text.is_empty():
		first = status_text + " · " + first
	if c.is_saint():
		first += " · " + texts.desolation(c)
	lines.append(first)
	if not c.is_saint():
		var intent_text: String = texts.intent(ctrl.state.intent_of(c))
		if not intent_text.is_empty():
			lines.append(texts.t(&"intent_details", {"intent": intent_text}))
	lines.append(texts.conditions_details(c))
	_info.text = "\n".join(lines)


## First frame of the idle clip, for the sheet.
func _idle_picture(combatant_id: StringName) -> Texture2D:
	var frames: CharacterFrames = _frames.get(combatant_id)
	var idle: FrameClip = frames.clip(&"idle") if frames != null else null
	if idle == null:
		return null
	var atlas := AtlasTexture.new()
	atlas.atlas = FramePlayer.sheet(idle.sheet_path)
	atlas.region = idle.region(0)
	return atlas if atlas.atlas != null else null


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
	for id: StringName in _views.keys():
		if not present.has(id):
			(_views[id] as CombatantView).queue_free()
			(_badges[id] as CombatantBadge).queue_free()
			_views.erase(id)
			_badges.erase(id)
			_frames.erase(id)


func _ensure_view(c: Combatant) -> CombatantView:
	if _views.has(c.id):
		return _views[c.id]
	if _halo_settings == null:
		_halo_settings = load(HALO_SETTINGS_PATH)
	var view := CombatantView.new()
	var frames: CharacterFrames = _frames_for(c)
	_frames[c.id] = frames
	view.setup(c.id, c.is_saint(), VIEW_WIDTH, null, _halo_settings if c.is_saint() else null, frames)
	view.set_info_visible(false)
	view.speed = SPEEDS[speed_index]
	view.scale = Vector2.ONE * view_scale()
	view.tapped.connect(tap)
	view.impact.connect(_on_impact.bind(view))
	_fighters.add_child(view)
	_views[c.id] = view
	var badge := CombatantBadge.new()
	var display: float = frames.display_scale if frames != null else 1.0
	badge.set_head_height(FIGURE_HEIGHT * display, GROUND_Y - INTENT_ROW_Y)
	_badges_layer.add_child(badge)
	_badges[c.id] = badge
	_show(view, c)
	return view


func _frames_for(c: Combatant) -> CharacterFrames:
	var path: String = "%s/%s_frames.tres" % [ART_DIR, c.def_id]
	return load(path) as CharacterFrames if ResourceLoader.exists(path) else null


## Scale of a combatant view: its figure (CombatantView.FIGURE_SIZE) becomes
## FIGURE_HEIGHT tall on the field.
static func view_scale() -> float:
	return FIGURE_HEIGHT / CombatantView.FIGURE_SIZE.y


## Where the feet of `view` stand on the field (x).
func _feet_x(view: CombatantView) -> float:
	return view.position.x + VIEW_WIDTH * 0.5 * view.scale.x


func _place(view: CombatantView, x: float, animated: bool) -> void:
	var feet_local := Vector2(VIEW_WIDTH * 0.5, CombatantView.INTENT_HEIGHT + CombatantView.BODY_HEIGHT)
	var target := Vector2(x, GROUND_Y) - feet_local * view.scale.x
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
	return _lantern.position.y + LANTERN_HEIGHT * 0.5


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


func _build_ui() -> void:
	theme = HudStyle.theme(26)
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
	_result_label.add_theme_font_size_override("font_size", 64)
	var again: Button = _overlay_button(_result_overlay, texts.t(&"play_again"), press_play_again)
	again.visible = not in_expedition
	var back: Button = _overlay_button(_result_overlay, texts.t(&"result_continue" if in_expedition else &"back_to_arena"), press_back)
	back.visible = show_back_button or in_expedition
	_ui_built = true


## The field: scenery, darkening, fighters, bars and marks, the intent line
## and the small front detail, clipped to the top of the stage. The impact
## camera zooms all of it.
func _build_field() -> void:
	var clip := Control.new()
	clip.size = Vector2(STAGE_SIZE.x, FIELD_HEIGHT)
	clip.clip_contents = true
	clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(clip)
	_field = Control.new()
	_field.size = clip.size
	_field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip.add_child(_field)
	for file: String in SCENERY_LAYERS:
		var layer := _scenery(file)
		if layer != null:
			layer.size *= SCENERY_SCALE
			layer.position = SCENERY_OFFSET
			_field.add_child(layer)
	var vignette := ColorRect.new()
	vignette.color = Color(0.02, 0.015, 0.02, VIGNETTE_ALPHA)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vignette.size = clip.size
	_field.add_child(vignette)
	_dim = ColorRect.new()
	_dim.color = Color(0.02, 0.01, 0.02, 0.0)
	_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dim.position = Vector2(-400, -400)
	_dim.size = clip.size + Vector2(800, 800)
	_field.add_child(_dim)
	_badges_layer = Control.new()
	_badges_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_badges_layer)
	_fighters = Control.new()
	_fighters.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fighters.size = clip.size
	_field.add_child(_fighters)
	# Intents, conditions and previews float over the fighters.
	_field.move_child(_badges_layer, _fighters.get_index() + 1)
	_lines = IntentLine.new()
	_lines.size = clip.size
	# Covers the whole field: it must never swallow the taps on the views.
	_lines.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field.add_child(_lines)
	var detail := _scenery(SCENERY_DETAIL)
	if detail != null:
		detail.size = clip.size
		_field.add_child(detail)
	_flash = ColorRect.new()
	_flash.color = Color(1, 1, 1, 0)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_flash.size = clip.size
	clip.add_child(_flash)
	_camera = ImpactCamera.new(_field, _flash, _dim)
	_build_lume(clip)


func _scenery(file: String) -> TextureRect:
	var path: String = "%s/%s" % [SCENERY_DIR, file]
	if not ResourceLoader.exists(path):
		return null
	var layer := TextureRect.new()
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.texture = load(path) as Texture2D
	layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	layer.stretch_mode = TextureRect.STRETCH_SCALE
	layer.size = layer.texture.get_size()
	return layer


func _build_lume(holder: Control) -> void:
	_lume_holder = Control.new()
	_lume_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lume_holder.visible = false
	holder.add_child(_lume_holder)
	var rod := TextureRect.new()
	rod.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rod.texture = HudStyle.hud_texture("ui_lume_scale")
	rod.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rod.stretch_mode = TextureRect.STRETCH_SCALE
	var rod_height: float = LUME_BOTTOM - LUME_TOP + 60.0
	var rod_width: float = rod_height * 50.0 / 1024.0
	rod.size = Vector2(rod_width, rod_height)
	rod.position = Vector2(LUME_X - rod_width * 0.5, LUME_TOP - 30.0)
	_lume_holder.add_child(rod)
	_lantern = TextureRect.new()
	_lantern.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lantern.texture = HudStyle.hud_texture("ui_lume_lantern")
	_lantern.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_lantern.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_lantern.size = Vector2(LANTERN_HEIGHT * 156.0 / 256.0, LANTERN_HEIGHT)
	_lume_holder.add_child(_lantern)
	_lume_label = Label.new()
	_lume_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lume_label.position = Vector2(LUME_X - 70.0, LUME_BOTTOM + 40.0)
	_lume_label.size = Vector2(140, 40)
	_lume_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lume_label.add_theme_font_size_override("font_size", 30)
	_lume_holder.add_child(_lume_label)


func _build_top_bar() -> void:
	_round_label = _label(Vector2(0, 14), Vector2(STAGE_SIZE.x, 50), 40)
	_pause_button = _button(Vector2(1560, 16), Vector2(150, 60), press_pause)
	_speed_button = _button(Vector2(1720, 16), Vector2(180, 60), press_speed)
	_build_dev_row()


## The iron panel under the field: banners at the sides, the chosen saint on
## the left, the sheet of the tapped combatant on the right.
func _build_bottom() -> void:
	var strip := ColorRect.new()
	strip.color = Color(0.06, 0.06, 0.065)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	strip.position = Vector2(0, FIELD_HEIGHT)
	strip.size = Vector2(STAGE_SIZE.x, STAGE_SIZE.y - FIELD_HEIGHT)
	_stage.add_child(strip)
	var edge := ColorRect.new()
	edge.color = HudStyle.COLOR_PANEL_EDGE
	edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	edge.position = Vector2(0, FIELD_HEIGHT)
	edge.size = Vector2(STAGE_SIZE.x, 6)
	_stage.add_child(edge)
	for x: float in [6.0, STAGE_SIZE.x - 136.0]:
		var banner := TextureRect.new()
		banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
		banner.texture = HudStyle.hud_texture("ui_banner_keys")
		banner.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		banner.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		banner.position = Vector2(x, FIELD_HEIGHT + 6)
		banner.size = Vector2(130, STAGE_SIZE.y - FIELD_HEIGHT - 10)
		_stage.add_child(banner)
	_build_hero_panel(Rect2(140, FIELD_HEIGHT + 10, 920, 344))
	_build_sheet_panel(Rect2(1066, FIELD_HEIGHT + 10, 714, 344))


func _build_hero_panel(rect: Rect2) -> void:
	_stage.add_child(HudStyle.iron_panel(rect))
	var x0: float = rect.position.x
	var y0: float = rect.position.y
	_portrait = TextureRect.new()
	var frame_rect := Rect2(PORTRAIT_FRAME.position + Vector2(x0, y0), PORTRAIT_FRAME.size)
	_portrait.position = frame_rect.position + PORTRAIT_WINDOW.position * frame_rect.size
	_portrait.size = PORTRAIT_WINDOW.size * frame_rect.size
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_portrait.visible = false
	_stage.add_child(_portrait)
	_portrait_frame = TextureRect.new()
	# Expand before the texture: otherwise the frame keeps the texture's size.
	_portrait_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait_frame.stretch_mode = TextureRect.STRETCH_SCALE
	_portrait_frame.texture = HudStyle.hud_texture("ui_portrait_frame")
	_portrait_frame.position = frame_rect.position
	_portrait_frame.size = frame_rect.size
	_portrait_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_portrait_frame)
	_actor_label = _label(Vector2(x0 + 240, y0 + 18), Vector2(420, 50), 42)
	_actor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_actor_detail = _label(Vector2(x0 + 240, y0 + 64), Vector2(420, 30), 24)
	_actor_detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_actor_detail.add_theme_color_override("font_color", HudStyle.COLOR_TEXT_DIM)
	_stats = _label(Vector2(x0 + 34, y0 + 196), Vector2(190, 64), 24)
	_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_fervor_label = _label(Vector2(x0 + 34, y0 + 256), Vector2(190, 30), 24)
	_fervor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_fervor_label.add_theme_color_override("font_color", HudStyle.COLOR_FERVOR)
	_fervor_pips = HBoxContainer.new()
	_fervor_pips.position = Vector2(x0 + 36, y0 + 290)
	_fervor_pips.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fervor_pips.add_theme_constant_override("separation", 7)
	_stage.add_child(_fervor_pips)
	var bx: float = x0 + 240
	var size_ability := Vector2(156, 96)
	for i: int in ABILITY_SLOTS:
		_ability_buttons.append(_button(Vector2(bx + i * (size_ability.x + 8), y0 + 100), size_ability, press_ability.bind(i)))
	var row: float = y0 + 204
	_miracle_button = _button(Vector2(bx, row), Vector2(248, 72), press_miracle)
	_miracle_button.add_theme_font_size_override("font_size", 20)
	_swap_button = _button(Vector2(bx + 256, row), Vector2(110, 72), press_swap)
	_pass_button = _button(Vector2(bx + 374, row), Vector2(110, 72), press_pass)
	_provisions_button = _button(Vector2(bx + 492, row), Vector2(166, 72), press_provisions)
	_provisions_button.add_theme_font_size_override("font_size", 19)
	_hint = _label(Vector2(bx, y0 + 280), Vector2(652, 56), 22)
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_hint.add_theme_color_override("font_color", HudStyle.COLOR_TEXT_DIM)
	_provision_menu = VBoxContainer.new()
	_provision_menu.position = Vector2(bx + 330, FIELD_HEIGHT - 300)
	_provision_menu.visible = false
	_stage.add_child(_provision_menu)


## DD's sheet: the tapped enemy (or saint), with its figure, life, intent
## and conditions; "Encerrar turno" in its corner.
func _build_sheet_panel(rect: Rect2) -> void:
	_stage.add_child(HudStyle.iron_panel(rect))
	var x0: float = rect.position.x
	var y0: float = rect.position.y
	_sheet_picture = TextureRect.new()
	_sheet_picture.position = Vector2(x0 + 30, y0 + 30)
	_sheet_picture.size = Vector2(170, 280)
	_sheet_picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_sheet_picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_sheet_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_sheet_picture)
	_sheet_title = _label(Vector2(x0 + 220, y0 + 18), Vector2(470, 50), 40)
	_sheet_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_info = _label(Vector2(x0 + 220, y0 + 72), Vector2(466, 180), 23)
	_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_end_turn_button = _button(Vector2(x0 + rect.size.x - 290, y0 + rect.size.y - 92), Vector2(260, 68), press_end_turn)


## Test buttons (D-117), small, under the top bar.
func _build_dev_row() -> void:
	_dev_row = HBoxContainer.new()
	_dev_row.position = Vector2(170, 84)
	_dev_row.add_theme_constant_override("separation", 8)
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
		button.custom_minimum_size = Vector2(230, 52)
		button.add_theme_font_size_override("font_size", 20)
		button.pressed.connect(spec[1])
		_dev_row.add_child(button)


func _label(pos: Vector2, label_size: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = label_size
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	_stage.add_child(label)
	return label


func _button(pos: Vector2, button_size: Vector2, action: Callable) -> Button:
	var button := Button.new()
	button.position = pos
	button.size = button_size
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 22)
	button.pressed.connect(action)
	_stage.add_child(button)
	return button


func _overlay() -> Control:
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.75)
	shade.size = STAGE_SIZE
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	shade.visible = false
	var box := VBoxContainer.new()
	box.name = "Box"
	box.position = Vector2(STAGE_SIZE.x * 0.5 - 300, 340)
	box.custom_minimum_size = Vector2(600, 0)
	box.add_theme_constant_override("separation", 24)
	shade.add_child(box)
	_stage.add_child(shade)
	return shade


func _overlay_label(overlay: Control) -> Label:
	var label := Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(600, 0)
	label.add_theme_font_size_override("font_size", 34)
	overlay.get_node("Box").add_child(label)
	return label


func _overlay_button(overlay: Control, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(600, 90)
	button.add_theme_font_size_override("font_size", 32)
	button.pressed.connect(action)
	overlay.get_node("Box").add_child(button)
	return button
