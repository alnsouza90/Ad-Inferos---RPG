class_name MiniMapView
extends Control
## The whole leg at a glance (screens §4, expedition §2.3 item 7): layers
## from left to right between the gate and the camp, the type of every node
## in text, the links, the path already walked and where the party is.
## Consultation only (D-128): nothing here sends a command.

const NODE_SIZE := Vector2(210, 84)
const COLOR_LINK := Color(0.55, 0.5, 0.45)
const COLOR_WALKED := Color(1.0, 0.85, 0.45)
const COLOR_NODE := Color(0.18, 0.15, 0.16)
const COLOR_VISITED := Color(0.35, 0.29, 0.2)
const COLOR_CURRENT := Color(0.62, 0.48, 0.18)
const LINK_WIDTH: float = 4.0
const WALKED_WIDTH: float = 8.0

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
	_add_box(_gate_centre, texts.t(&"minimap_gate"), _gate_color())
	_add_box(_camp_centre, texts.t(&"minimap_camp"), COLOR_CURRENT if ctrl.phase == ExpeditionController.Phase.AT_CAMP else COLOR_NODE)
	for layer: int in range(1, ctrl.map.layer_count() + 1):
		var nodes: Array[MapNode] = ctrl.map.layer_nodes(layer)
		var step_y: float = size.y / nodes.size()
		for n: MapNode in nodes:
			var centre := Vector2(step_x * (layer + 0.5), step_y * (n.index + 0.5))
			centres[n.id] = centre
			_labels[n.id] = _add_box(centre, texts.minimap_node(ctrl, n), _node_color(n))
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
	return COLOR_NODE


func _add_box(centre: Vector2, text: String, color: Color) -> Label:
	var box := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(10)
	box.add_theme_stylebox_override("panel", style)
	box.size = NODE_SIZE
	box.position = centre - NODE_SIZE * 0.5
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(box)
	var label := Label.new()
	label.text = text
	label.size = NODE_SIZE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 24)
	box.add_child(label)
	return label


func _draw() -> void:
	if ctrl == null or centres.is_empty():
		return
	for n: MapNode in ctrl.map.layer_nodes(1):
		draw_line(_gate_centre, centres[n.id], COLOR_LINK, LINK_WIDTH)
	for n: MapNode in ctrl.map.all_nodes():
		for next: MapNode in ctrl.map.entrances_from(n):
			draw_line(centres[n.id], centres[next.id], COLOR_LINK, LINK_WIDTH)
		if n.layer == ctrl.map.layer_count():
			draw_line(centres[n.id], _camp_centre, COLOR_LINK, LINK_WIDTH)
	var walked: Array[Vector2] = [_gate_centre]
	for id: StringName in ctrl.state.visited:
		walked.append(centres[id])
	if ctrl.state.current_node != &"":
		walked.append(centres[ctrl.state.current_node])
	if ctrl.phase == ExpeditionController.Phase.AT_CAMP or ctrl.state.camp_reached:
		walked.append(_camp_centre)
	for i: int in range(1, walked.size()):
		draw_line(walked[i - 1], walked[i], COLOR_WALKED, WALKED_WIDTH)
