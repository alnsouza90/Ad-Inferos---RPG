class_name MiniMapView
extends Control
## The whole leg at a glance (screens §4, expedition §2.3 item 7): layers
## from left to right between the gate and the camp, the type of every node
## in text, the links, the path already walked and where the party is.
## Consultation only (D-128): nothing here sends a command.

## Darkest Dungeon look (T36, D-258): each node a square iron room with the
## icon of its type and its name under it; the links are corridors of small
## squares, lit where the party walked; the room where it stands glows.
## Sizes on the 960 × 540 grid (T65, ADR-0013).
const ROOM_SIZE := Vector2(48, 48)
const COLOR_DARK_ROOM := Color(0.55, 0.55, 0.6)
const LABEL_SIZE := Vector2(110, 30)
const ICON_SIZE: float = 32.0
const STEP_SIZE: float = 6.0
const STEPS_PER_LINK: int = 4
const COLOR_STEP := Color("33313A")
const COLOR_ROOM_EDGE := Color("55525D")
const COLOR_VISITED := Color("8A8791")
const COLOR_CURRENT := Color("D9A520")
const ICONS: Dictionary = {
	MapNode.TYPE_BATTLE: "icon_node_combat",
	MapNode.TYPE_ELITE: "icon_node_elite",
	MapNode.TYPE_TEMPTATION: "icon_node_temptation",
	MapNode.TYPE_SOUL: "icon_node_soul",
	MapNode.TYPE_RELIC: "icon_node_relic",
}
const GATE_ICON: String = "icon_node_gate"
const CAMP_ICON: String = "icon_node_camp"

var ctrl: ExpeditionController
var texts: WalkTexts
## node id -> centre of its box, in this control's coordinates.
var centres: Dictionary = {}
var _gate_centre := Vector2.ZERO
var _camp_centre := Vector2.ZERO
## Where the company stands now (the lantern hangs there).
var _current_centre := Vector2.INF
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
	_current_centre = Vector2.INF
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
	# A medallion of forged iron with the node's icon (D-441): lit where the
	# company has been, dark ahead.
	var room := TextureRect.new()
	room.texture = PixelStyle.piece("ui_medallion")
	room.size = ROOM_SIZE
	room.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	room.position = (centre - ROOM_SIZE * 0.5).round()
	room.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var dark: bool = edge == COLOR_ROOM_EDGE
	room.modulate = COLOR_DARK_ROOM if dark else Color.WHITE
	add_child(room)
	var icon := TextureRect.new()
	icon.texture = HudStyle.icon(icon_name)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.size = Vector2(ICON_SIZE, ICON_SIZE)
	icon.position = ((ROOM_SIZE - icon.size) * 0.5).round()
	room.add_child(icon)
	if edge == COLOR_CURRENT:
		_current_centre = centre
	var label := Label.new()
	label.text = text
	label.size = LABEL_SIZE
	label.position = centre + Vector2(-LABEL_SIZE.x * 0.5, ROOM_SIZE.y * 0.5 + 2.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_constant_override("line_spacing", 0)
	label.add_theme_color_override("font_color", PixelStyle.COLOR_BONE if edge != COLOR_ROOM_EDGE else PixelStyle.COLOR_GREY)
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
	if _current_centre != Vector2.INF:
		draw_arc(_current_centre, ROOM_SIZE.x * 0.5 - 2.0, 0.0, TAU, 32, PixelStyle.COLOR_AMBER, 2.0)
		var lantern: Texture2D = PixelStyle.piece("ui_lantern_on")
		if lantern != null:
			draw_texture(lantern, (_current_centre + Vector2(ROOM_SIZE.x * 0.4, -lantern.get_height() - 4.0)).round())


func _corridor(from: Vector2, to: Vector2, walked_pairs: Dictionary) -> void:
	var lit: bool = walked_pairs.has([from, to])
	var dir: Vector2 = (to - from).normalized()
	var start: Vector2 = from + dir * ROOM_SIZE.x * 0.6
	var finish: Vector2 = to - dir * ROOM_SIZE.x * 0.6
	for k: int in STEPS_PER_LINK:
		var at: Vector2 = start.lerp(finish, (k + 0.5) / STEPS_PER_LINK)
		# Chiselled pebbles (D-441): lit amber like the lantern's light where
		# the company walked.
		var rect := Rect2(at - Vector2.ONE * STEP_SIZE * 0.5, Vector2.ONE * STEP_SIZE)
		draw_rect(Rect2(rect.position.round() - Vector2.ONE, rect.size + Vector2(2, 2)), PixelStyle.COLOR_PITCH)
		rect.position = rect.position.round()
		draw_rect(rect, PixelStyle.COLOR_AMBER if lit else COLOR_STEP)
