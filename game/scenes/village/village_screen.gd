class_name VillageScreen
extends Control
## The village (T49, D-492, D-494): Alan's picture at 960 x 540, by day, or
## his night picture in Advent and Lent. Touching an open building chooses
## it; a closed one only says it is closed when touched. The top band and
## the note follow the rest of the game: the iron band, Jacquard 12 for the
## title, the riveted iron plate for the note. Pure presentation: it reads
## the campaign and says which building was chosen.

## Emitted when an open building is touched (its id, as in VillageLayout).
signal building_chosen(building: StringName)

const STAGE_SIZE := VillageLayout.PICTURE_SIZE
## The thin iron band at the top, as in battle and on the walk.
const BAND_HEIGHT: float = 16.0
const WEEK_POS := Vector2(14, 18)
## Texts at twice the pixel size, as in the event, story and saint screens.
const TITLE_SIZE: int = PixelStyle.TITLE_SIZE * 2
const TEXT_SIZE: int = PixelStyle.TEXT_SIZE * 2
## The note of the touched building, as the battle's note, in the sky
## corner, so it never covers a building.
const NOTE_RECT := Rect2(586, 24, 360, 68)
## The outline of the touched building: a thin line in bone (selection is
## bone, never gold, Bíblia de Arte §9).
const SELECTED_WIDTH: float = 1.0

var data: GameData
var campaign: CampaignState
var economy: ConstantsDef
var selected: StringName = &""

var _stage: Control
var _picture: TextureRect
var _outline: Line2D
var _week: Label
var _note: NinePatchRect
var _note_title: Label
var _note_text: Label


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
	var outline: PackedVector2Array = VillageLayout.outline(building)
	outline.append(outline[0])
	_outline.points = outline
	_outline.visible = true
	_note.visible = true
	_note_title.text = data.ui.text(StringName("building_%s" % building))
	if is_open(building):
		_note_text.text = ""
		building_chosen.emit(building)
	else:
		_note_text.text = data.ui.text(&"building_closed")


func name_shown() -> String:
	return ("%s %s" % [_note_title.text, _note_text.text]).strip_edges()


func week_shown() -> String:
	return _week.text


func picture_texture() -> Texture2D:
	return _picture.texture


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
	_picture.texture = load(VillageLayout.NIGHT_PATH if is_night() else VillageLayout.PICTURE_PATH) as Texture2D
	_picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_picture.size = STAGE_SIZE
	_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_picture)
	_outline = Line2D.new()
	_outline.width = SELECTED_WIDTH
	_outline.default_color = PixelStyle.COLOR_BONE
	_outline.antialiased = false
	_outline.visible = false
	_stage.add_child(_outline)
	_build_top_band()
	_build_note()


func _build_top_band() -> void:
	var band := TextureRect.new()
	band.texture = PixelStyle.piece("ui_top_band")
	band.stretch_mode = TextureRect.STRETCH_TILE
	band.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	band.size = Vector2(STAGE_SIZE.x, BAND_HEIGHT)
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(band)
	_week = Label.new()
	_week.text = data.ui.text(&"village_week", {
		"week": campaign.week,
		"season": data.ui.text(StringName("season_%s" % LiturgicalCalendar.season(campaign.week, economy))),
	})
	_week.position = WEEK_POS
	_week.mouse_filter = Control.MOUSE_FILTER_IGNORE
	PixelStyle.title(_week, PixelStyle.COLOR_BONE, TITLE_SIZE)
	_stage.add_child(_week)


func _build_note() -> void:
	_note = PixelStyle.iron_plate(NOTE_RECT)
	_note.visible = false
	_stage.add_child(_note)
	_note_title = Label.new()
	_note_title.position = Vector2(14, 6)
	_note_title.size = Vector2(NOTE_RECT.size.x - 28.0, 26)
	_note_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	PixelStyle.title(_note_title, PixelStyle.COLOR_AMBER, TITLE_SIZE)
	_note.add_child(_note_title)
	_note_text = Label.new()
	_note_text.position = Vector2(14, 34)
	_note_text.size = Vector2(NOTE_RECT.size.x - 28.0, NOTE_RECT.size.y - 40.0)
	_note_text.add_theme_font_size_override("font_size", TEXT_SIZE)
	_note_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_note.add_child(_note_text)


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE
