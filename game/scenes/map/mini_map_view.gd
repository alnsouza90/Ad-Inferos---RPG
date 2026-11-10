class_name MiniMapView
extends Control
## The whole leg at a glance (screens §4, expedition §2.3 item 7): layers
## from left to right between the gate and the camp, the type of every node
## in text, the links, the path already walked and where the party is.
## Consultation only (D-128): nothing here sends a command.

## Darkest Dungeon look (T36, D-258): each node a square iron room with the
## icon of its type and its name under it; the links are corridors of small
## squares, lit where the party walked; the room where it stands glows.
const ROOM_SIZE := Vector2(104, 104)
const LABEL_SIZE := Vector2(220, 60)
const ICON_SIZE: float = 76.0
const STEP_SIZE: float = 20.0
const STEPS_PER_LINK: int = 4
const COLOR_STEP := Color(0.25, 0.25, 0.26)
const COLOR_STEP_WALKED := Color(0.62, 0.61, 0.58)
const COLOR_ROOM := Color(0.09, 0.09, 0.095)
const COLOR_ROOM_EDGE := Color(0.33, 0.33, 0.34)
const COLOR_VISITED := Color(0.62, 0.61, 0.58)
const COLOR_CURRENT := Color(0.98, 0.86, 0.6)
const ICONS: Dictionary = {
	MapNode.TYPE_BATTLE: "icon_node_combat",
	MapNode.TYPE_ELITE: "icon_node_elite",
	MapNode.TYPE_TEMPTATION: "icon_node_temptation",
	MapNode.TYPE_SOUL: "icon_node_soul",
	MapNode.TYPE_RELIC: "icon_node_relic",
}
const GATE_ICON: String = "icon_node_camp"
const CAMP_ICON: String = "icon_node_camp"

var ctrl: ExpeditionController
var texts: WalkTexts
## node id -> centre of its box, in this control's coordinates.
var centres: Dictionary = {}
var _gate_centre := Vector2.ZERO
var _camp_centre := Vector2.ZERO
## node id -> Label (tests read the text shown for each node).
var _labels: Dictionary = {}


func setup(p_ctrl: ExpeditionController, p_texts: WalkTexts) -> void:
	ctrl = p_ctrl
	texts = p_texts


## Rebuilds the boxes from the current state (called each time it opens).
func rebuild() -> void:
	for child: Node in get_children():
		child.queue_free()
	centres.clear()
	_labels.clear()
	var columns: int = ctrl.map.layer_count() + 2
	var step_x: float = size.x / columns
	_gate_centre = Vector2(step_x * 0.5, size.y * 0.5)
	_camp_centre = Vector2(step_x * (columns - 0.5), size.y * 0.5)
	_add_box(_gate_centre, texts.t(&"minimap_gate"), _gate_color(), GATE_ICON)
	_add_box(_camp_centre, texts.t(&"minimap_camp"), COLOR_CURRENT if ctrl.phase == ExpeditionController.Phase.AT_CAMP else COLOR_ROOM_EDGE, CAMP_ICON)
	for layer: int in range(1, ctrl.map.layer_count() + 1):
		var nodes: Array[MapNode] = ctrl.map.layer_nodes(layer)
		var step_y: float = size.y / nodes.size()
		for n: MapNode in nodes:
			var centre := Vector2(step_x * (layer + 0.5), step_y * (n.index + 0.5))
			centres[n.id] = centre
			_labels[n.id] = _add_box(centre, texts.minimap_node(ctrl, n), _node_color(n), ICONS.get(n.type, ""))
	queue_redraw()


func label_of(node_id: StringName) -> String:
	var label: Label = _labels.get(node_id)
	return label.text if label != null else ""


func _gate_color() -> Color:
	return COLOR_CURRENT if ctrl.state.current_node == &"" else COLOR_VISITED


func _node_color(n: MapNode) -> Color:
	if n.id == ctrl.state.current_node:
		return COLOR_CURRENT
	if ctrl.state.visited.has(n.id):
		return COLOR_VISITED
	return COLOR_ROOM_EDGE


func _add_box(centre: Vector2, text: String, edge: Color, icon_name: String) -> Label:
	var room := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_ROOM
	style.border_color = edge
	style.set_border_width_all(6 if edge == COLOR_CURRENT else 4)
	style.shadow_color = Color(edge, 0.55) if edge == COLOR_CURRENT else Color(0, 0, 0, 0.6)
	style.shadow_size = 16 if edge == COLOR_CURRENT else 4
	room.add_theme_stylebox_override("panel", style)
	room.size = ROOM_SIZE
	room.position = centre - ROOM_SIZE * 0.5
	room.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(room)
	var icon := TextureRect.new()
	icon.texture = HudStyle.icon(icon_name)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.size = Vector2(ICON_SIZE, ICON_SIZE)
	icon.position = (ROOM_SIZE - icon.size) * 0.5
	room.add_child(icon)
	var label := Label.new()
	label.text = text
	label.size = LABEL_SIZE
	label.position = centre + Vector2(-LABEL_SIZE.x * 0.5, ROOM_SIZE.y * 0.5 + 2.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", HudStyle.COLOR_TEXT if edge != COLOR_ROOM_EDGE else HudStyle.COLOR_TEXT_DIM)
	add_child(label)
	return label


## Corridors of small squares between the rooms (DD); lit where walked.
func _draw() -> void:
	if ctrl == null or centres.is_empty():
		return
	var walked_pairs: Dictionary = {}
	var walked: Array[Vector2] = [_gate_centre]
	for id: StringName in ctrl.state.visited:
		walked.append(centres[id])
	if ctrl.state.current_node != &"" and not ctrl.state.visited.has(ctrl.state.current_node):
		walked.append(centres[ctrl.state.current_node])
	if ctrl.phase == ExpeditionController.Phase.AT_CAMP or ctrl.state.camp_reached:
		walked.append(_camp_centre)
	for i: int in range(1, walked.size()):
		walked_pairs[[walked[i - 1], walked[i]]] = true
	for n: MapNode in ctrl.map.layer_nodes(1):
		_corridor(_gate_centre, centres[n.id], walked_pairs)
	for n: MapNode in ctrl.map.all_nodes():
		for next: MapNode in ctrl.map.entrances_from(n):
			_corridor(centres[n.id], centres[next.id], walked_pairs)
		if n.layer == ctrl.map.layer_count():
			_corridor(centres[n.id], _camp_centre, walked_pairs)


func _corridor(from: Vector2, to: Vector2, walked_pairs: Dictionary) -> void:
	var lit: bool = walked_pairs.has([from, to])
	var dir: Vector2 = (to - from).normalized()
	var start: Vector2 = from + dir * ROOM_SIZE.x * 0.6
	var finish: Vector2 = to - dir * ROOM_SIZE.x * 0.6
	for k: int in STEPS_PER_LINK:
		var at: Vector2 = start.lerp(finish, (k + 0.5) / STEPS_PER_LINK)
		var rect := Rect2(at - Vector2.ONE * STEP_SIZE * 0.5, Vector2.ONE * STEP_SIZE)
		draw_rect(rect.grow(2.0), Color(0, 0, 0, 0.9))
		draw_rect(rect, COLOR_STEP_WALKED if lit else COLOR_STEP)
