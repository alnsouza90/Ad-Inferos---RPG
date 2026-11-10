class_name LegScreen
extends Control
## One expedition leg from the gate to the end (screens §2, M1 flow): shows
## the screen the expedition's phase asks for (walk, battle, Temptation,
## relic, camp) and the summary at the end. Every command goes through
## `run_command`: in the game, GameState (saved after each one); in tests,
## the controller. Opened on a new leg or on a loaded save, it lands on the
## same screen (save-load §4).

const STAGE_SIZE := Vector2(1920, 1080)
const BUTTON_SIZE := Vector2(760, 96)
const COLOR_BACKGROUND := Color(0.06, 0.05, 0.06)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)

## The summary's "Voltar ao título".
signal title_requested

var data: GameData
var catalog: ExpeditionCatalog
var ctrl: ExpeditionController
## Battle animation speed (BattleScreen.SPEEDS index); also the walk's.
var speed_index: int = 0
## True in the game: commands go through GameState, which saves after each
## one. Tests turn it off so they never touch the player's save slot.
var use_game_state: bool = true
## The screen shown now (WalkScreen, BattleScreen, EventScreen, CampScreen
## or one of the panels below).
var current: Control
## Relic waiting for a carrier: the saint (or &"pack") tapped once.
var relic_choice: StringName = &""

var _panel_label: Label


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_ctrl: ExpeditionController) -> void:
	data = p_data
	catalog = p_catalog
	ctrl = p_ctrl


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	show_phase()


## Sends one command; through GameState when it is in use, so it is saved.
func run_command(cmd: ExpeditionCommand) -> StringName:
	var state: Node = _game_state()
	if state != null:
		return state.call("execute", cmd)
	return ctrl.execute(cmd)


## A battle command through the expedition (logged and saved); the battle
## screen animates the events of its answer.
func run_battle(cmd: BattleCommand) -> CommandResult:
	var reason: StringName = run_command(ExpeditionCommand.battle(cmd))
	if reason != &"" and (ctrl.last_battle_result == null or ctrl.last_battle_result.ok):
		return CommandResult.rejected(reason)
	return ctrl.last_battle_result


## Opens the screen of the current phase (called after every screen ends).
func show_phase() -> void:
	match ctrl.phase:
		ExpeditionController.Phase.AT_FORK:
			_show_walk()
		ExpeditionController.Phase.IN_BATTLE:
			_show_battle()
		ExpeditionController.Phase.IN_EVENT:
			_show_event()
		ExpeditionController.Phase.IN_RELIC:
			_show_relic()
		ExpeditionController.Phase.IN_NODE:
			_show_empty_node()
		ExpeditionController.Phase.AT_CAMP:
			_show_camp()
		ExpeditionController.Phase.ENDED:
			_show_summary()


## What kind of screen is shown, for the tests ("walk", "battle"...).
func screen_kind() -> StringName:
	if current is WalkScreen:
		return &"walk"
	if current is BattleScreen:
		return &"battle"
	if current is EventScreen:
		return &"event"
	if current is CampScreen:
		return &"camp"
	return StringName(str(current.get_meta(&"kind", ""))) if current != null else &""


func panel_text() -> String:
	return _panel_label.text if _panel_label != null and is_instance_valid(_panel_label) else ""


# --- relic, empty node and summary (small panels) ------------------------------------

## D-146: the saint who carries the relic (or &"" for the pack); second tap confirms.
func press_relic(saint_id: StringName) -> void:
	if ctrl.phase != ExpeditionController.Phase.IN_RELIC:
		return
	var key: StringName = saint_id if saint_id != &"" else &"pack"
	if relic_choice != key:
		relic_choice = key
		_panel_label.text = _relic_text() + "\n\n" + data.ui.text(&"relic_confirm")
		_mark_choice(key)
		return
	relic_choice = &""
	if run_command(ExpeditionCommand.place_relic(saint_id)) == &"":
		show_phase()


func press_node_continue() -> void:
	if run_command(ExpeditionCommand.complete_node()) == &"":
		show_phase()


func press_title() -> void:
	title_requested.emit()


# --- screens ------------------------------------------------------------------------

func _replace(screen: Control) -> void:
	if current != null and is_instance_valid(current):
		current.queue_free()
	current = screen
	_panel_label = null
	add_child(screen)


func _show_walk() -> void:
	var walk := WalkScreen.new()
	walk.speed_index = speed_index
	walk.setup(data, ctrl, run_command)
	walk.node_entered.connect(func(_id: StringName) -> void: show_phase())
	_replace(walk)


func _show_battle() -> void:
	var battle := BattleScreen.new()
	battle.in_expedition = true
	battle.speed_index = speed_index
	battle.setup(data, ctrl.battle)
	battle.light = ctrl.state.light
	battle.light_max = ctrl.catalog.constants.get_int(&"light_start")
	battle.executor = run_battle
	battle.back_requested.connect(show_phase)
	_replace(battle)


func _show_event() -> void:
	var screen := EventScreen.new()
	screen.setup(data, ctrl, run_command)
	screen.finished.connect(show_phase)
	_replace(screen)


func _show_camp() -> void:
	var camp := CampScreen.new()
	camp.setup(data, ctrl, run_command)
	camp.battle_started.connect(show_phase)
	camp.left_camp.connect(show_phase)
	_replace(camp)


func _show_relic() -> void:
	relic_choice = &""
	var box: VBoxContainer = _panel(&"relic", _relic_text())
	for saint_id: StringName in ctrl.state.party:
		var free: bool = ctrl.has_free_slot(saint_id)
		var key: StringName = &"relic_give" if free else &"relic_no_slot"
		var button := _button(data.ui.text(key, {"saint": _saint_name(saint_id)}))
		button.disabled = not free
		button.set_meta(&"choice", saint_id)
		button.pressed.connect(press_relic.bind(saint_id))
		box.add_child(button)
	var pack := _button(data.ui.text(&"relic_pack"))
	pack.set_meta(&"choice", &"pack")
	pack.pressed.connect(press_relic.bind(&""))
	box.add_child(pack)


func _show_empty_node() -> void:
	var box: VBoxContainer = _panel(&"node", data.ui.text(&"node_empty"))
	var button := _button(data.ui.text(&"node_continue"))
	button.pressed.connect(press_node_continue)
	box.add_child(button)


## End of the leg (T30): reason, Alms, each saint, the Pilgrim's virtues.
func _show_summary() -> void:
	var t: UiTextDef = data.ui
	var lines: Array[String] = [
		t.text(&"summary_title", {"reason": t.text(StringName("walk_end_%s" % ctrl.ended_reason))}),
		"",
		t.text(&"summary_alms", {"banked": ctrl.state.alms_banked, "unbanked": ctrl.state.alms_unbanked}),
	]
	for saint_id: StringName in ctrl.state.party:
		var status: SaintStatus = ctrl.saints[saint_id]
		var line: String = t.text(&"summary_saint", {"saint": _saint_name(saint_id), "hp": status.hp, "max": status.max_hp, "desolation": status.desolation})
		if status.spirit_state != Desolation.NORMAL:
			line += " · " + t.text(StringName("spirit_%s" % status.spirit_state))
		if status.injury != SaintStatus.INJURY_NONE:
			line += " · " + t.text(StringName("camp_injury_%s" % status.injury))
		lines.append(line)
	var relic_names: Array[String] = []
	for saint_id: StringName in ctrl.state.party:
		for r: StringName in (ctrl.saints[saint_id] as SaintStatus).relics:
			relic_names.append(_relic_name(r))
	for r: StringName in ctrl.state.relic_pack:
		relic_names.append(_relic_name(r))
	if not relic_names.is_empty():
		lines.append(t.text(&"summary_relics", {"relics": ", ".join(relic_names)}))
	lines.append(t.text(&"summary_virtues", {
		"faith": ctrl.virtues.get_value(Virtues.FAITH),
		"hope": ctrl.virtues.get_value(Virtues.HOPE),
		"charity": ctrl.virtues.get_value(Virtues.CHARITY),
	}))
	var box: VBoxContainer = _panel(&"summary", "\n".join(lines))
	var button := _button(t.text(&"back_to_title"))
	button.pressed.connect(press_title)
	box.add_child(button)


func _relic_text() -> String:
	var def: RelicDef = catalog.relic(ctrl.state.pending_relic)
	var text: String = data.ui.text(&"relic_found", {"relic": _relic_name(ctrl.state.pending_relic)})
	if def != null and def.desc_pt != "":
		text += "\n" + def.desc_pt
	return text


func _mark_choice(key: StringName) -> void:
	if current == null:
		return
	for child: Node in current.find_children("*", "Button", true, false):
		var b := child as Button
		b.modulate = COLOR_CHOSEN if b.get_meta(&"choice", &"") == key else Color.WHITE


## A centred panel with a text and room for buttons.
func _panel(kind: StringName, text: String) -> VBoxContainer:
	var root := CenterContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.set_meta(&"kind", kind)
	_replace(root)
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(1100, 0)
	box.add_theme_constant_override("separation", 24)
	root.add_child(box)
	_panel_label = Label.new()
	_panel_label.text = text
	_panel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_panel_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_panel_label.add_theme_font_size_override("font_size", 32)
	box.add_child(_panel_label)
	return box


func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = BUTTON_SIZE
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.add_theme_font_size_override("font_size", 30)
	return button


func _saint_name(id: StringName) -> String:
	var def: SaintDef = data.saints.get(id)
	return def.name_pt if def != null else String(id)


func _relic_name(id: StringName) -> String:
	var def: RelicDef = catalog.relic(id)
	return def.name_pt if def != null else String(id)


func _game_state() -> Node:
	if not use_game_state or not is_inside_tree():
		return null
	return get_node_or_null("/root/GameState")
