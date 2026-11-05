class_name BattleScreen
extends Control
## The battle screen of screens §3 with placeholder art (T15): rectangles and
## names instead of characters. It sends commands to BattleController, animates
## the returned events in order and redraws from the state; it never decides a
## rule (architecture §3.2). Layout is built in code on a 1920×1080 stage that
## stays centred when the phone is wider (aspect = expand).

const STAGE_SIZE := Vector2(1920, 1080)
const CENTER_X: float = 960.0
const CENTER_GAP: float = 60.0
const FIELD_Y: float = 200.0
const SAINT_WIDTH: float = 220.0
const SAINT_STEP: float = 260.0
const ENEMY_WIDTH: float = 190.0
const ENEMY_STEP: float = 210.0
const BUTTON_SIZE := Vector2(230, 120)
const PIP_SIZE := Vector2(26, 26)
const COLOR_BACKGROUND := Color(0.09, 0.07, 0.08)
const COLOR_PIP_ON := Color(1.0, 0.78, 0.3)
const COLOR_PIP_OFF := Color(0.3, 0.27, 0.25)
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
## Saint art lives at <dir>/<saint id>_art.tres; a saint without it stays a
## rectangle (T16 brings only São Jorge, D-203).
const ART_DIR: String = "res://scenes/battle/combatants"
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
			return _action_of(d["actor"])
		&"enemy_action", &"party_turn_ended":
			_last_actor = &""
		&"damage_dealt", &"bleed_tick", &"self_damaged":
			var lunge: float = 0.0
			var source: StringName = StringName(str(d.get("source", "")))
			if source != &"" and source != _last_actor:
				_last_actor = source
				lunge = _action_of(source)
			var view: CombatantView = view_of(d["target"])
			if view == null:
				return lunge
			view.set_hp(int(d["hp"]))
			view.float_text(texts.t(&"preview_damage", {"amount": d["amount"]}), COLOR_DAMAGE)
			return maxf(lunge, view.play_hit())
		&"healed", &"revived":
			var view: CombatantView = view_of(d["target"])
			if view != null:
				view.set_hp(int(d["hp"]))
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


func _action_of(combatant_id: StringName) -> float:
	var view: CombatantView = view_of(combatant_id)
	return view.play_action() if view != null else 0.0


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
		pip_rect.color = COLOR_PIP_ON if i < ctrl.fervor.amount else COLOR_PIP_OFF
	_speed_button.text = texts.t(SPEED_KEYS[speed_index])
	_pause_button.text = texts.t(&"pause")


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
		view.show_preview(previews.get(id, ""))
	var enemy_view: CombatantView = view_of(_info_id)
	var target_view: CombatantView = view_of(intent_target.id) if intent_target != null else null
	if enemy_view != null and target_view != null:
		_lines.show_line(enemy_view.center(), target_view.center())
	else:
		_lines.hide_line()


func _show(view: CombatantView, c: Combatant) -> void:
	var slot: int = ctrl.state.party_slot_of(c) if c.is_saint() else ctrl.state.enemy_slot_of(c)
	var intent_text: String = "" if c.is_saint() else texts.intent(ctrl.state.intent_of(c))
	var status_text: String = texts.status(c)
	if status_text.is_empty() and c.is_saint() and c.has_acted and c.is_standing():
		status_text = texts.t(&"acted")
	view.show_state(c, texts.name_of(c), texts.t(&"slot", {"slot": slot}), status_text, texts.hp(c), texts.desolation(c), texts.conditions_summary(c), intent_text)


func _refresh_controls() -> void:
	if not _ui_built:
		return
	var actor: Combatant = selection.actor()
	var open: bool = _accepting_input() and actor != null
	_actor_label.text = texts.name_of(actor) if actor != null else ""
	var art: CombatantArt = _arts.get(actor.id) if actor != null else null
	_portrait.texture = art.portrait if art != null else null
	_portrait.visible = _portrait.texture != null
	_actor_label.visible = not _portrait.visible
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
	_end_turn_button.text = texts.t(&"end_turn")
	_end_turn_button.disabled = not _accepting_input()
	_refresh_provision_menu(open)


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
		button.custom_minimum_size = Vector2(BUTTON_SIZE.x * 1.4, 70)
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


func _refresh_info() -> void:
	var c: Combatant = ctrl.state.find(_info_id) if _info_id != &"" else selection.actor()
	if c == null:
		_info.text = ""
		return
	var lines: Array[String] = [texts.name_of(c)]
	var status_text: String = texts.status(c)
	if not status_text.is_empty():
		lines[0] += " · " + status_text
	lines[0] += " · " + texts.hp(c)
	if c.is_saint():
		lines[0] += " · " + texts.desolation(c)
	else:
		var intent_text: String = texts.intent(ctrl.state.intent_of(c))
		if not intent_text.is_empty():
			lines.append(texts.t(&"intent_details", {"intent": intent_text}))
	lines.append(texts.conditions_details(c))
	_info.text = "\n".join(lines)


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
		_place(_ensure_view(c, SAINT_WIDTH), _saint_x(ctrl.state.party_slot_of(c)), animated)
	for c: Combatant in ctrl.state.enemies:
		present[c.id] = true
		var width: float = c.size * ENEMY_STEP - (ENEMY_STEP - ENEMY_WIDTH)
		_place(_ensure_view(c, width), _enemy_x(ctrl.state.enemy_slot_of(c)), animated)
	for id: StringName in _views.keys():
		if not present.has(id):
			(_views[id] as CombatantView).queue_free()
			_views.erase(id)


func _ensure_view(c: Combatant, width: float) -> CombatantView:
	if _views.has(c.id):
		return _views[c.id]
	var view := CombatantView.new()
	var art: CombatantArt = _art_for(c)
	if art != null:
		_arts[c.id] = art
	view.setup(c.id, c.is_saint(), width, art, _halo_settings if art != null else null)
	view.speed = SPEEDS[speed_index]
	view.tapped.connect(tap)
	_field.add_child(view)
	_views[c.id] = view
	_show(view, c)
	return view


func _art_for(c: Combatant) -> CombatantArt:
	if not c.is_saint():
		return null
	var path: String = "%s/%s_art.tres" % [ART_DIR, c.def_id]
	if not ResourceLoader.exists(path):
		return null
	if _halo_settings == null:
		_halo_settings = load(HALO_SETTINGS_PATH)
	return load(path) as CombatantArt


func _place(view: CombatantView, x: float, animated: bool) -> void:
	var target := Vector2(x, FIELD_Y)
	if animated and view.is_inside_tree() and view.position != Vector2.ZERO:
		view.create_tween().tween_property(view, "position", target, MOVE_TIME / SPEEDS[speed_index])
	else:
		view.position = target


func _saint_x(slot: int) -> float:
	return CENTER_X - CENTER_GAP - (slot - 0.5) * SAINT_STEP - SAINT_WIDTH * 0.5


func _enemy_x(anchor_slot: int) -> float:
	return CENTER_X + CENTER_GAP + (anchor_slot - 1) * ENEMY_STEP


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
	var ui_theme := Theme.new()
	ui_theme.default_font_size = 26
	theme = ui_theme
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_build_top_bar()
	_field = Control.new()
	_field.size = STAGE_SIZE
	_field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_field)
	_lines = IntentLine.new()
	_lines.size = STAGE_SIZE
	# Covers the whole stage: it must never swallow the taps on the views.
	_lines.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_lines)
	_hint = _label(Vector2(0, 112), Vector2(STAGE_SIZE.x, 40), 28)
	_info = _label(Vector2(80, 670), Vector2(STAGE_SIZE.x - 160, 130), 22)
	_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_build_action_bar()
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
	_result_label.add_theme_font_size_override("font_size", 56)
	var again: Button = _overlay_button(_result_overlay, texts.t(&"play_again"), press_play_again)
	again.visible = not in_expedition
	var back: Button = _overlay_button(_result_overlay, texts.t(&"result_continue" if in_expedition else &"back_to_arena"), press_back)
	back.visible = show_back_button or in_expedition
	_ui_built = true


func _build_top_bar() -> void:
	_pause_button = _button(Vector2(80, 24), Vector2(180, 70), press_pause)
	_round_label = _label(Vector2(320, 34), Vector2(300, 50), 32)
	_fervor_label = _label(Vector2(660, 34), Vector2(280, 50), 30)
	_fervor_pips = HBoxContainer.new()
	_fervor_pips.position = Vector2(950, 46)
	_fervor_pips.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fervor_pips.add_theme_constant_override("separation", 10)
	_stage.add_child(_fervor_pips)
	_speed_button = _button(Vector2(1480, 24), Vector2(360, 70), press_speed)


func _build_action_bar() -> void:
	var row_1: float = 812.0
	var row_2: float = 952.0
	_actor_label = _label(Vector2(80, row_1), Vector2(200, BUTTON_SIZE.y), 26)
	_actor_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_actor_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# The portrait of the chosen saint takes the label's place when it exists.
	_portrait = TextureRect.new()
	_portrait.position = Vector2(86, 800)
	_portrait.size = Vector2(108, 144)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_portrait.visible = false
	_stage.add_child(_portrait)
	for i: int in ABILITY_SLOTS:
		_ability_buttons.append(_button(Vector2(300 + i * (BUTTON_SIZE.x + 16), row_1), BUTTON_SIZE, press_ability.bind(i)))
	_miracle_button = _button(Vector2(1300, row_1), Vector2(300, BUTTON_SIZE.y), press_miracle)
	_swap_button = _button(Vector2(1616, row_1), Vector2(224, BUTTON_SIZE.y), press_swap)
	_provisions_button = _button(Vector2(80, row_2), Vector2(200, 100), press_provisions)
	_pass_button = _button(Vector2(300, row_2), Vector2(BUTTON_SIZE.x, 100), press_pass)
	_end_turn_button = _button(Vector2(1540, row_2), Vector2(300, 100), press_end_turn)
	_build_dev_row(row_2)
	_provision_menu = VBoxContainer.new()
	_provision_menu.position = Vector2(80, 560)
	_provision_menu.visible = false
	_stage.add_child(_provision_menu)


## Row of test buttons between "Passar" and "Encerrar turno" (D-117).
func _build_dev_row(row_y: float) -> void:
	_dev_row = HBoxContainer.new()
	_dev_row.position = Vector2(560, row_y)
	_dev_row.add_theme_constant_override("separation", 12)
	_dev_row.visible = dev_tools and not in_expedition
	_stage.add_child(_dev_row)
	var title := Label.new()
	title.text = texts.t(&"dev_title")
	title.custom_minimum_size = Vector2(90, 100)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_dev_row.add_child(title)
	var specs: Array = [
		[texts.t(&"dev_desolation_up", {"amount": DEV_DESOLATION_STEP}), press_dev_desolation.bind(DEV_DESOLATION_STEP)],
		[texts.t(&"dev_desolation_down", {"amount": DEV_DESOLATION_STEP}), press_dev_desolation.bind(-DEV_DESOLATION_STEP)],
		[texts.t(&"dev_consolation"), press_dev_consolation],
	]
	for spec: Array in specs:
		var button := Button.new()
		button.text = spec[0]
		button.custom_minimum_size = Vector2(270, 100)
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
	button.pressed.connect(action)
	_stage.add_child(button)
	return button


func _overlay() -> Control:
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.7)
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
	overlay.get_node("Box").add_child(label)
	return label


func _overlay_button(overlay: Control, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(600, 90)
	button.pressed.connect(action)
	overlay.get_node("Box").add_child(button)
	return button
