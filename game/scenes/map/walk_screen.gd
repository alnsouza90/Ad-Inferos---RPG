class_name WalkScreen
extends Control
## The walk of the expedition (screens §4, expedition §2.3): the party walks
## a corridor from left to right and, at its end, the entrances of the next
## layer appear. One tap shows what is known of an entrance, a second tap
## sends ChoosePath. Provisions can be used at the fork; the mini-map shows
## the whole leg. The screen only sends ExpeditionCommand through `run` and
## redraws from the state: it never decides a rule (architecture §3.2).
## Provisional art (M1): the Circle 2 leg 1 scenery and rectangles, George
## with his existing art.

const STAGE_SIZE := Vector2(1920, 1080)
const BACK_PATH: String = "res://assets/environments/circles/circle_02/t1/env_circle_02_t1_back.png"
const FRONT_PATH: String = "res://assets/environments/circles/circle_02/t1/env_circle_02_t1_front.png"
const ART_DIR: String = "res://scenes/battle/combatants"
## Parallax of the provisional scenery while the party walks (asset-pipeline
## §4: _back about 20%, _front about 130% of the walk).
const BACK_PARALLAX: float = 0.2
const FRONT_PARALLAX: float = 1.3
## The party walks this far across the stage in each corridor.
const WALK_DISTANCE: float = 520.0
const WALK_TIME: float = 1.6
const WALK_BOB: float = 10.0
const PARTY_END_X: float = 900.0
const FEET_Y: float = 900.0
const FIGURE_HEIGHT: float = 420.0
const FIGURE_WIDTH: float = 170.0
const FIGURE_STEP: float = 200.0
const ENTRANCE_SIZE := Vector2(480, 130)
const ENTRANCE_X: float = 1340.0
const ENTRANCE_Y: float = 250.0
const BUTTON_SIZE := Vector2(300, 100)
const COLOR_BACKGROUND := Color(0.09, 0.07, 0.08)
const COLOR_SAINT := Color(0.42, 0.36, 0.3)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const COLOR_STRAIGHT := Color(0.36, 0.3, 0.18, 0.92)
const COLOR_DETOUR := Color(0.2, 0.17, 0.2, 0.92)
const COLOR_LIGHT_ON := Color(1.0, 0.8, 0.35)
const COLOR_LIGHT_OFF := Color(0.25, 0.22, 0.2)
const COLOR_DIM := Color(0, 0, 0, 0.7)
const LIGHT_BAR_SIZE := Vector2(300, 26)

## Emitted when a ChoosePath was accepted: the party left the corridor.
signal node_entered(node_id: StringName)

var data: GameData
var texts: WalkTexts
var ctrl: ExpeditionController
## Takes an ExpeditionCommand and returns the refusal reason (&"" when
## accepted). The game passes GameState.execute (saves after each command);
## tests and the default use the controller directly.
var run: Callable
## Animation speed index of BattleScreen.SPEEDS (1×, 2×, instant).
var speed_index: int = 0
## True while the party walks: the entrances wait.
var busy: bool = false
var selected_entrance: StringName = &""
## Provision waiting for a target saint (Holy Water).
var pending_provision: StringName = &""

var _stage: Control
var _back: TextureRect
var _front: TextureRect
var _party: Control
var _entrance_box: VBoxContainer
var _entrance_buttons: Dictionary = {}
var _info: Label
var _light_fill: ColorRect
var _light_label: Label
var _alms_label: Label
var _provisions_button: Button
var _provisions_overlay: Control
var _provisions_list: VBoxContainer
var _minimap_overlay: Control
var _minimap: MiniMapView
var _tween: Tween
var _straight: StringName = &""


func setup(p_data: GameData, p_ctrl: ExpeditionController, p_run: Callable = Callable()) -> void:
	data = p_data
	texts = WalkTexts.new(p_data)
	ctrl = p_ctrl
	run = p_run if p_run.is_valid() else func(cmd: ExpeditionCommand) -> StringName: return ctrl.execute(cmd)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()
	arrive()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- player input (also called by the tests) ------------------------------------

## The party walks the corridor up to the next fork (expedition §2.3 item 1).
## Called when the screen opens and each time the party comes back from a node.
func arrive() -> void:
	selected_entrance = &""
	pending_provision = &""
	_provisions_overlay.visible = false
	_minimap_overlay.visible = false
	_build_party()
	_build_entrances()
	_refresh()
	if _tween != null:
		_tween.kill()
	var factor: float = BattleScreen.SPEEDS[speed_index]
	if factor <= 0.0:
		_place_walk(1.0)
		busy = false
		_refresh()
		return
	busy = true
	_place_walk(0.0)
	_refresh()
	_tween = create_tween()
	_tween.tween_method(_place_walk, 0.0, 1.0, WALK_TIME / factor)
	_tween.tween_callback(_walk_finished)


func tap_entrance(node_id: StringName) -> void:
	if busy or not _entrance_buttons.has(node_id) or ctrl.phase != ExpeditionController.Phase.AT_FORK:
		return
	_provisions_overlay.visible = false
	if selected_entrance == node_id:
		_choose(node_id)
		return
	selected_entrance = node_id
	_refresh()


func press_minimap() -> void:
	if _minimap_overlay.visible:
		close_minimap()
		return
	_minimap_overlay.visible = true
	_minimap.rebuild()


func close_minimap() -> void:
	_minimap_overlay.visible = false


func press_provisions() -> void:
	if busy or ctrl.phase != ExpeditionController.Phase.AT_FORK:
		return
	pending_provision = &""
	_provisions_overlay.visible = not _provisions_overlay.visible
	_refresh()


## Uses a provision; one that needs a saint (Holy Water) asks for him first.
func press_provision(id: StringName) -> void:
	if busy:
		return
	var def: ProvisionDef = data.catalog.provision(id)
	if def != null and FieldProvisions.needs_target(def) and ctrl.field_provision_problem(id) == FieldProvisions.REJECT_NEEDS_TARGET:
		pending_provision = id
		_refresh()
		return
	_use(id, &"")


func press_provision_target(saint_id: StringName) -> void:
	if pending_provision == &"":
		return
	var id: StringName = pending_provision
	pending_provision = &""
	_use(id, saint_id)


# --- queries for the tests ---------------------------------------------------------

func entrance_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for n: MapNode in ctrl.entrances():
		ids.append(n.id)
	return ids


func entrance_text(node_id: StringName) -> String:
	var button: Button = _entrance_buttons.get(node_id)
	return button.text if button != null else ""


func straight_entrance() -> StringName:
	return _straight


func info_text() -> String:
	return _info.text


func light_text() -> String:
	return _light_label.text


func alms_text() -> String:
	return _alms_label.text


func minimap_open() -> bool:
	return _minimap_overlay.visible


func minimap() -> MiniMapView:
	return _minimap


func provisions_open() -> bool:
	return _provisions_overlay.visible


## Text of the provision's button in the open list ("" when not listed).
func provision_text(id: StringName) -> String:
	for child: Node in _provisions_list.get_children():
		if child is Button and (child as Button).get_meta(&"provision", &"") == id:
			return (child as Button).text
	return ""


func provision_disabled(id: StringName) -> bool:
	for child: Node in _provisions_list.get_children():
		if child is Button and (child as Button).get_meta(&"provision", &"") == id:
			return (child as Button).disabled
	return true


func stage_position() -> Vector2:
	return _stage.position if _stage != null else Vector2.ZERO


func party_figure_count() -> int:
	return _party.get_child_count() if _party != null else 0


# --- flow ------------------------------------------------------------------------

func _choose(node_id: StringName) -> void:
	var reason: StringName = run.call(ExpeditionCommand.choose_path(node_id))
	if reason != &"":
		_info.text = texts.reason(reason)
		return
	selected_entrance = &""
	_refresh()
	node_entered.emit(node_id)


func _use(id: StringName, target: StringName) -> void:
	var reason: StringName = run.call(ExpeditionCommand.use_provision(id, target))
	_provisions_overlay.visible = false
	_build_entrances()
	_refresh()
	if reason != &"":
		_info.text = texts.reason(reason)
	else:
		_info.text = texts.t(&"walk_provision_used", {"provision": texts.provision_name(id)})


func _walk_finished() -> void:
	busy = false
	_refresh()


## Progress of the walk, 0 at the start of the corridor and 1 at the fork.
func _place_walk(progress: float) -> void:
	var walked: float = WALK_DISTANCE * progress
	_party.position = Vector2(walked - WALK_DISTANCE, sin(progress * PI * 6.0) * WALK_BOB * (1.0 - progress))
	_back.position.x = -walked * BACK_PARALLAX
	_front.position.x = -walked * FRONT_PARALLAX


# --- drawing -----------------------------------------------------------------------

func _refresh() -> void:
	if _stage == null:
		return
	var at_fork: bool = ctrl.phase == ExpeditionController.Phase.AT_FORK
	_entrance_box.visible = at_fork and not busy
	for id: StringName in _entrance_buttons:
		(_entrance_buttons[id] as Button).modulate = COLOR_CHOSEN if id == selected_entrance else Color.WHITE
	if selected_entrance != &"":
		_info.text = _entrance_info(ctrl.map.find(selected_entrance))
	elif at_fork and not busy:
		_info.text = texts.t(&"walk_hint_choose")
	elif busy:
		_info.text = ""
	_light_fill.size.x = LIGHT_BAR_SIZE.x * clampf(ctrl.state.light / float(ExpeditionLight.LIGHT_MAX), 0.0, 1.0)
	_light_label.text = texts.light(ctrl)
	_alms_label.text = texts.alms(ctrl)
	_provisions_button.text = texts.t(&"walk_provisions", {"count": ctrl.state.provisions.size()})
	_provisions_button.disabled = busy or not at_fork
	_fill_provisions()


func _entrance_info(n: MapNode) -> String:
	var lines: Array[String] = [texts.type_name(n) + " · " + texts.path_name(CorridorLook.path_kind(n.id, _straight))]
	var known: String = texts.content(ctrl, n)
	if known != "":
		lines.append(known)
	lines.append(texts.t(&"walk_hint_confirm"))
	return "\n".join(lines)


func _build_entrances() -> void:
	for child: Node in _entrance_box.get_children():
		child.queue_free()
	_entrance_buttons.clear()
	var entrances: Array[MapNode] = ctrl.entrances()
	_straight = CorridorLook.straight_entrance(ctrl.map, ctrl.current_node(), entrances)
	for n: MapNode in entrances:
		var kind: StringName = CorridorLook.path_kind(n.id, _straight)
		var button := _button(texts.type_name(n) + "\n" + texts.path_name(kind), ENTRANCE_SIZE)
		var style := StyleBoxFlat.new()
		style.bg_color = COLOR_STRAIGHT if kind == CorridorLook.STRAIGHT else COLOR_DETOUR
		style.set_corner_radius_all(12)
		button.add_theme_stylebox_override("normal", style)
		button.pressed.connect(tap_entrance.bind(n.id))
		_entrance_box.add_child(button)
		_entrance_buttons[n.id] = button


## The party in formation, the vanguard (first) on the right, walking right.
func _build_party() -> void:
	for child: Node in _party.get_children():
		child.queue_free()
	var count: int = ctrl.state.party.size()
	for i: int in count:
		var saint_id: StringName = ctrl.state.party[i]
		var x: float = PARTY_END_X - i * FIGURE_STEP
		var art: CombatantArt = _art_for(saint_id)
		var figure: Control
		if art != null:
			var picture := TextureRect.new()
			picture.texture = art.body_normal
			picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			var tall: float = FIGURE_HEIGHT * 1.3
			picture.size = Vector2(tall * 2.0 / 3.0, tall)
			picture.position = Vector2(x - picture.size.x * 0.5, FEET_Y - tall)
			figure = picture
		else:
			var block := ColorRect.new()
			block.color = COLOR_SAINT
			block.size = Vector2(FIGURE_WIDTH, FIGURE_HEIGHT)
			block.position = Vector2(x - FIGURE_WIDTH * 0.5, FEET_Y - FIGURE_HEIGHT)
			var name_label := _label(texts.saint_name(saint_id), 26)
			name_label.size = Vector2(FIGURE_WIDTH, 60)
			name_label.position = Vector2(0, FIGURE_HEIGHT * 0.4)
			name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			block.add_child(name_label)
			figure = block
		figure.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_party.add_child(figure)


func _art_for(saint_id: StringName) -> CombatantArt:
	var path: String = ART_DIR.path_join("%s_art.tres" % saint_id)
	if not ResourceLoader.exists(path):
		return null
	return load(path) as CombatantArt


func _fill_provisions() -> void:
	for child: Node in _provisions_list.get_children():
		_provisions_list.remove_child(child)
		child.queue_free()
	if pending_provision != &"":
		_provisions_list.add_child(_label(texts.t(&"walk_choose_saint", {"provision": texts.provision_name(pending_provision)}), 30))
		for saint_id: StringName in ctrl.state.party:
			var target := _button(texts.saint_name(saint_id), Vector2(620, 90))
			target.pressed.connect(press_provision_target.bind(saint_id))
			_provisions_list.add_child(target)
		return
	var counts: Dictionary = {}
	var order: Array[StringName] = []
	for id: StringName in ctrl.state.provisions:
		if not counts.has(id):
			order.append(id)
		counts[id] = int(counts.get(id, 0)) + 1
	if order.is_empty():
		_provisions_list.add_child(_label(texts.t(&"walk_no_provisions"), 30))
	for id: StringName in order:
		var problem: StringName = ctrl.field_provision_problem(id, ctrl.state.party[0] if not ctrl.state.party.is_empty() else &"")
		var line: String = texts.t(&"walk_provision_line", {"provision": texts.provision_name(id), "count": counts[id]})
		if problem != &"":
			line += " · " + texts.reason(problem)
		var button := _button(line, Vector2(620, 90))
		button.set_meta(&"provision", id)
		button.disabled = problem != &""
		button.pressed.connect(press_provision.bind(id))
		_provisions_list.add_child(button)


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


func _build() -> void:
	# The interface of the battle (T36, D-258): Pirata One, iron buttons.
	theme = HudStyle.theme(30)
	clip_contents = true
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_back = _layer(BACK_PATH)
	_stage.add_child(_back)
	_party = Control.new()
	_party.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_party)
	_front = _layer(FRONT_PATH)
	_stage.add_child(_front)
	_build_top_bar()
	_entrance_box = VBoxContainer.new()
	_entrance_box.position = Vector2(ENTRANCE_X, ENTRANCE_Y)
	_entrance_box.add_theme_constant_override("separation", 26)
	_stage.add_child(_entrance_box)
	_info = _label("", 28)
	_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.position = Vector2(1180, 790)
	_info.size = Vector2(680, 220)
	_stage.add_child(_info)
	_provisions_button = _button("", BUTTON_SIZE)
	_provisions_button.position = Vector2(70, STAGE_SIZE.y - BUTTON_SIZE.y - 70)
	_provisions_button.pressed.connect(press_provisions)
	_stage.add_child(_provisions_button)
	_build_provisions_overlay()
	_build_minimap_overlay()


func _layer(path: String) -> TextureRect:
	var layer := TextureRect.new()
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists(path):
		layer.texture = load(path) as Texture2D
	layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	layer.stretch_mode = TextureRect.STRETCH_SCALE
	layer.size = Vector2(STAGE_SIZE.y * 2560.0 / 1080.0, STAGE_SIZE.y)
	return layer


func _build_top_bar() -> void:
	var bar := ColorRect.new()
	bar.color = Color(0, 0, 0, 0.55)
	bar.size = Vector2(STAGE_SIZE.x, 120)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(bar)
	_light_label = _label("", 30)
	_light_label.position = Vector2(80, 14)
	_light_label.size = Vector2(LIGHT_BAR_SIZE.x, 50)
	_stage.add_child(_light_label)
	var light_back := ColorRect.new()
	light_back.color = COLOR_LIGHT_OFF
	light_back.position = Vector2(80, 70)
	light_back.size = LIGHT_BAR_SIZE
	light_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(light_back)
	_light_fill = ColorRect.new()
	_light_fill.color = COLOR_LIGHT_ON
	_light_fill.size = LIGHT_BAR_SIZE
	_light_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	light_back.add_child(_light_fill)
	_alms_label = _label("", 30)
	_alms_label.position = Vector2(460, 30)
	_alms_label.size = Vector2(960, 60)
	_stage.add_child(_alms_label)
	var minimap_button := _button(texts.t(&"walk_minimap"), BUTTON_SIZE)
	minimap_button.position = Vector2(STAGE_SIZE.x - BUTTON_SIZE.x - 70, 10)
	minimap_button.pressed.connect(press_minimap)
	_stage.add_child(minimap_button)


func _build_provisions_overlay() -> void:
	_provisions_overlay = Control.new()
	_provisions_overlay.size = STAGE_SIZE
	_provisions_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_provisions_overlay.visible = false
	_stage.add_child(_provisions_overlay)
	var panel := ColorRect.new()
	panel.color = COLOR_DIM
	panel.position = Vector2(50, 300)
	panel.size = Vector2(680, 560)
	_provisions_overlay.add_child(panel)
	_provisions_list = VBoxContainer.new()
	_provisions_list.position = Vector2(80, 330)
	_provisions_list.add_theme_constant_override("separation", 14)
	_provisions_overlay.add_child(_provisions_list)


func _build_minimap_overlay() -> void:
	_minimap_overlay = Control.new()
	_minimap_overlay.size = STAGE_SIZE
	_minimap_overlay.visible = false
	_stage.add_child(_minimap_overlay)
	# A tap anywhere outside the map closes it (screens §4).
	var dim := Button.new()
	dim.flat = true
	dim.size = STAGE_SIZE
	var dim_style := StyleBoxFlat.new()
	dim_style.bg_color = COLOR_DIM
	for state_name: String in ["normal", "hover", "pressed", "focus"]:
		dim.add_theme_stylebox_override(state_name, dim_style)
	dim.pressed.connect(close_minimap)
	_minimap_overlay.add_child(dim)
	_minimap_overlay.add_child(HudStyle.iron_panel(Rect2(70, 130, 1780, 840)))
	_minimap = MiniMapView.new()
	_minimap.position = Vector2(110, 170)
	_minimap.size = Vector2(1700, 760)
	_minimap.mouse_filter = Control.MOUSE_FILTER_STOP
	_minimap.setup(ctrl, texts)
	_minimap_overlay.add_child(_minimap)
	var close_button := _button(texts.t(&"walk_minimap_close"), BUTTON_SIZE)
	close_button.position = Vector2(STAGE_SIZE.x - BUTTON_SIZE.x - 70, 10)
	close_button.pressed.connect(close_minimap)
	_minimap_overlay.add_child(close_button)


func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	return button
