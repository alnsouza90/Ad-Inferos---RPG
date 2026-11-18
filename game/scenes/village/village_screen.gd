class_name VillageScreen
extends Control
## The village (T49, D-492): Alan's picture at 960 x 540, with the engine on
## top. Touching an open building chooses it; the closed ones are darkened;
## the night of the liturgical calendar (Advent and Lent) pulls the picture
## to grey-violet and leaves the lights lit. Pure presentation: it reads the
## campaign and says which building was chosen.

## Emitted when an open building is touched (its id, as in VillageLayout).
signal building_chosen(building: StringName)

const STAGE_SIZE := VillageLayout.PICTURE_SIZE
const SHADER_PATH: String = "res://shaders/village_hub.gdshader"
## Darkness over a closed building (Bíblia de Arte §10A: a silhouette).
const CLOSED_COLOR := Color(0.05, 0.03, 0.08, 0.62)
const SELECTED_COLOR := PixelStyle.COLOR_BONE
const SELECTED_WIDTH: float = 2.0
const BAND_HEIGHT: float = 28.0
const BAND_SIZE: int = PixelStyle.TEXT_SIZE * 2

var data: GameData
var campaign: CampaignState
var economy: ConstantsDef
var selected: StringName = &""

var _stage: Control
var _picture: TextureRect
var _closed: Dictionary = {}
var _outline: Line2D
var _week: Label
var _name: Label


func setup(p_data: GameData, p_campaign: CampaignState, p_economy: ConstantsDef) -> void:
	data = p_data
	campaign = p_campaign
	economy = p_economy


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


## A building can be touched when its facility is open in the campaign.
func is_open(building: StringName) -> bool:
	return campaign.facilities.has(building)


func is_night() -> bool:
	return LiturgicalCalendar.is_night(campaign.week, economy)


## Touch at `point` in picture pixels: chooses the open building there; a
## closed one only shows its name and that it is closed.
func tap_at(point: Vector2) -> void:
	var building: StringName = VillageLayout.building_at(point)
	if building == &"":
		return
	selected = building
	_outline.points = VillageLayout.outline(building)
	_outline.add_point(VillageLayout.outline(building)[0])
	_outline.visible = true
	var name_text: String = data.ui.text(StringName("building_%s" % building))
	if is_open(building):
		_name.text = name_text
		building_chosen.emit(building)
	else:
		_name.text = "%s · %s" % [name_text, data.ui.text(&"building_closed")]


func name_shown() -> String:
	return _name.text


func week_shown() -> String:
	return _week.text


func closed_shown() -> Array[StringName]:
	var ids: Array[StringName] = []
	for id: StringName in _closed:
		ids.append(id)
	return ids


func night_amount() -> float:
	return float((_picture.material as ShaderMaterial).get_shader_parameter(&"night"))


func _gui_input(event: InputEvent) -> void:
	var touch: bool = event is InputEventScreenTouch and (event as InputEventScreenTouch).pressed
	var click: bool = event is InputEventMouseButton and (event as InputEventMouseButton).pressed
	if touch or click:
		tap_at((event as InputEvent).position - _stage.position)


func _build() -> void:
	theme = PixelStyle.theme()
	clip_contents = true
	var background := ColorRect.new()
	background.color = PixelStyle.COLOR_PITCH
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_picture = TextureRect.new()
	_picture.texture = load(VillageLayout.PICTURE_PATH) as Texture2D
	_picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_picture.size = STAGE_SIZE
	_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = load(SHADER_PATH) as Shader
	material.set_shader_parameter(&"lights", load(VillageLayout.LIGHTS_PATH) as Texture2D)
	material.set_shader_parameter(&"night", 1.0 if is_night() else 0.0)
	_picture.material = material
	_stage.add_child(_picture)
	for id: StringName in VillageLayout.OUTLINES:
		if is_open(id):
			continue
		var shade := Polygon2D.new()
		shade.polygon = VillageLayout.outline(id)
		shade.color = CLOSED_COLOR
		_stage.add_child(shade)
		_closed[id] = shade
	_outline = Line2D.new()
	_outline.width = SELECTED_WIDTH
	_outline.default_color = SELECTED_COLOR
	_outline.visible = false
	_stage.add_child(_outline)
	_build_bands()


func _build_bands() -> void:
	_stage.add_child(PixelStyle.plate(Rect2(0, 0, STAGE_SIZE.x, BAND_HEIGHT)))
	_week = _label(data.ui.text(&"village_week", {
		"week": campaign.week,
		"season": data.ui.text(StringName("season_%s" % LiturgicalCalendar.season(campaign.week, economy))),
	}))
	_week.position = Vector2(12, 2)
	_stage.add_child(_week)
	_stage.add_child(PixelStyle.plate(Rect2(0, STAGE_SIZE.y - BAND_HEIGHT, STAGE_SIZE.x, BAND_HEIGHT)))
	_name = _label("")
	_name.position = Vector2(12, STAGE_SIZE.y - BAND_HEIGHT + 2)
	_stage.add_child(_name)


func _label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", BAND_SIZE)
	label.add_theme_color_override("font_color", PixelStyle.COLOR_BONE)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE
