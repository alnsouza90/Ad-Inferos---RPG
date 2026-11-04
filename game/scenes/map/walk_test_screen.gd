class_name WalkTestScreen
extends Control
## Test of the walk from the arena (dev builds only), while the flow screens
## do not exist (T30): a new leg of Circle 2 with the M1 kit, walked on the
## WalkScreen. A Temptation opens the EventScreen (T28) and the camp the
## CampScreen (T29); battles and relics show a placeholder that finishes
## them with DevNodeResolver; the end of the leg shows a short note.
## Everything goes through commands, like the real game.

## M1 data ids: the leg is played in Circle 2 with the arena groups and the
## fixed kit (expedition §13, D-123).
const CIRCLE: StringName = &"circle_02"
const KIT: StringName = &"m1_kit"
const PANEL_SIZE := Vector2(900, 420)
const BUTTON_SIZE := Vector2(560, 100)

signal back_requested

var data: GameData
var catalog: ExpeditionCatalog
var ctrl: ExpeditionController
var walk: WalkScreen
## The Temptation in progress (T28), or null.
var event_screen: EventScreen
## The camp of the leg (T29), kept while an ambush is fought, or null.
var camp_screen: CampScreen
var leg_seed: int = 1
var speed_index: int = 0
## True in the game: commands go through GameState, which saves after each
## one. Tests turn it off so they never touch the player's save slot.
var use_game_state: bool = true

var _overlay: Control
var _message: Label
var _action: Button


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_seed: int) -> void:
	data = p_data
	catalog = p_catalog
	leg_seed = p_seed


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ctrl = ExpeditionController.start_new(catalog, CIRCLE, leg_seed, GameData.M0_FORMATION, catalog.kit_provisions(KIT), EncounterDef.ARENA_CIRCLE)
	var state: Node = _game_state()
	if state != null:
		state.call("start_expedition", catalog, ctrl, leg_seed)
	walk = WalkScreen.new()
	walk.speed_index = speed_index
	walk.setup(data, ctrl, run_command)
	walk.node_entered.connect(_on_node_entered)
	add_child(walk)
	_build_overlay()


## Sends one command (through GameState when it is in use, so it is saved).
func run_command(cmd: ExpeditionCommand) -> StringName:
	var state: Node = _game_state()
	if state != null:
		return state.call("execute", cmd)
	return ctrl.execute(cmd)


## The placeholder's button: finish the node or battle, or go back.
func press_action() -> void:
	match ctrl.phase:
		ExpeditionController.Phase.ENDED:
			back_requested.emit()
		_:
			DevNodeResolver.resolve(ctrl, run_command)
			_show_state()


func overlay_shown() -> bool:
	return _overlay.visible


func message_text() -> String:
	return _message.text


func _on_node_entered(_node_id: StringName) -> void:
	_show_state()


func _on_event_finished() -> void:
	if event_screen != null:
		event_screen.queue_free()
		event_screen = null
	_show_state()


func _show_state() -> void:
	var t: UiTextDef = data.ui
	if ctrl.phase == ExpeditionController.Phase.IN_EVENT and event_screen == null:
		_overlay.visible = false
		event_screen = EventScreen.new()
		event_screen.setup(data, ctrl, run_command)
		event_screen.finished.connect(_on_event_finished)
		add_child(event_screen)
		return
	if ctrl.phase == ExpeditionController.Phase.AT_CAMP:
		_overlay.visible = false
		if camp_screen == null:
			camp_screen = CampScreen.new()
			camp_screen.setup(data, ctrl, run_command)
			camp_screen.battle_started.connect(_show_state)
			camp_screen.left_camp.connect(_show_state)
			add_child(camp_screen)
		camp_screen.visible = true
		camp_screen.refresh()
		return
	if camp_screen != null:
		camp_screen.visible = false
		if ctrl.is_over():
			camp_screen.queue_free()
			camp_screen = null
	if ctrl.phase == ExpeditionController.Phase.IN_BATTLE and ctrl.state.camp_reached:
		_message.text = t.text(&"walk_test_ambush")
		_action.text = t.text(&"walk_test_resolve")
		_overlay.visible = true
		return
	match ctrl.phase:
		ExpeditionController.Phase.AT_FORK:
			_overlay.visible = false
			walk.arrive()
			return
		ExpeditionController.Phase.ENDED:
			_message.text = t.text(&"walk_test_ended", {"reason": t.text(StringName("walk_end_%s" % ctrl.ended_reason)), "alms": ctrl.state.alms_banked})
			_action.text = t.text(&"back_to_arena")
		_:
			var n: MapNode = ctrl.current_node()
			_message.text = t.text(&"walk_test_node", {"type": t.text(n.type) if n != null else ""})
			_action.text = t.text(&"walk_test_resolve")
	_overlay.visible = true


func _game_state() -> Node:
	if not use_game_state or not is_inside_tree():
		return null
	return get_node_or_null("/root/GameState")


func _build_overlay() -> void:
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.visible = false
	add_child(_overlay)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.75)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.add_child(center)
	var box := VBoxContainer.new()
	box.custom_minimum_size = PANEL_SIZE
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 40)
	center.add_child(box)
	_message = Label.new()
	_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.custom_minimum_size = Vector2(PANEL_SIZE.x, 0)
	_message.add_theme_font_size_override("font_size", 34)
	box.add_child(_message)
	_action = Button.new()
	_action.custom_minimum_size = BUTTON_SIZE
	_action.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_action.add_theme_font_size_override("font_size", 32)
	_action.pressed.connect(press_action)
	box.add_child(_action)
