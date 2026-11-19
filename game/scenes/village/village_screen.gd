class_name VillageScreen
extends Control
## The village (T49, D-492, D-495): Alan's village at 960 x 540 under a sky
## that moves slowly sideways. Touching a building lights its outline (Alan's
## own line); an open building is chosen, a closed one only says it is
## closed. In Advent and Lent the sky turns greyer and the light misty
## (LiturgicalCalendar). The top band and the note follow the rest of the
## game. Pure presentation: it reads the campaign and says which building
## was chosen.

## Emitted when an open building is touched (its id, as in VillageLayout).
signal building_chosen(building: StringName)

const STAGE_SIZE := VillageLayout.PICTURE_SIZE
const WEATHER_SHADER_PATH: String = "res://shaders/village_weather.gdshader"
## Outside Advent and Lent the sky is an amber sunset drawn by the engine
## (D-496); in them, Alan's clouds turned grey.
const SUNSET_SHADER_PATH: String = "res://shaders/village_sunset.gdshader"
## The clouds' drift, in picture pixels per second.
const SKY_SPEED: float = 6.0
## Advent and Lent: how grey the sky and the village get, and the mist over
## the village (a veil of light grey from the top, thinning to the ground).
const GREY_SKY: float = 0.85
const GREY_VILLAGE: float = 0.45
const MIST_COLOR := Color(0.62, 0.62, 0.66, 0.28)
## The thin iron band at the top, as in battle and on the walk.
const BAND_HEIGHT: float = 16.0
const WEEK_POS := Vector2(14, 18)
const TITLE_SIZE: int = PixelStyle.TITLE_SIZE * 2
const TEXT_SIZE: int = PixelStyle.TEXT_SIZE * 2
## The note of the touched building, in the sky corner.
const NOTE_RECT := Rect2(586, 24, 360, 68)
## The Ave Maria, when the statue is touched (D-497): an iron plate under
## the sky, so the statue stays in sight, the prayer typed one letter at a
## time.
const PRAYER_RECT := Rect2(276, 22, 664, 140)
const PRAYER_CHARS_PER_SECOND: float = 22.0

var data: GameData
var campaign: CampaignState
var economy: ConstantsDef
var selected: StringName = &""

var _stage: Control
var _sky: TextureRect
var _sky_width: float = 0.0
var _sunset: ColorRect
var _picture: TextureRect
var _outlines: Dictionary = {}
var _week: Label
var _note: NinePatchRect
var _note_title: Label
var _note_text: Label
var _prayer: NinePatchRect
var _prayer_text: Label
var _prayer_chars: float = 0.0


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


func _process(delta: float) -> void:
	drift_sky(delta)
	type_prayer(delta)


## Types the prayer, letter by letter, while it is open.
func type_prayer(delta: float) -> void:
	if _prayer == null or not _prayer.visible or _prayer_text.visible_ratio >= 1.0:
		return
	_prayer_chars += PRAYER_CHARS_PER_SECOND * delta
	_prayer_text.visible_characters = int(_prayer_chars)
	if _prayer_text.visible_characters >= _prayer_text.get_total_character_count():
		_prayer_text.visible_characters = -1


func prayer_shown() -> String:
	if _prayer == null or not _prayer.visible:
		return ""
	if _prayer_text.visible_characters < 0:
		return _prayer_text.text
	return _prayer_text.text.left(_prayer_text.visible_characters)


## Moves the clouds; they wrap, so the sky never ends.
func drift_sky(delta: float) -> void:
	if _sky == null or _sky_width <= 0.0:
		return
	_sky.position.x = -fposmod(-_sky.position.x + SKY_SPEED * delta, _sky_width)


## A building can be touched when its facility is open in the campaign.
func is_open(building: StringName) -> bool:
	return campaign.facilities.has(building)


## Advent and Lent: grey sky and misty light.
func is_grey() -> bool:
	return LiturgicalCalendar.is_night(campaign.week, economy)


## Touch at `point` in picture pixels: lights that building's outline; an
## open building is chosen, a closed one only says it is closed.
func tap_at(point: Vector2) -> void:
	var building: StringName = VillageLayout.building_at(point)
	if _prayer.visible:
		_prayer.visible = false
		if building == VillageLayout.STATUE:
			return
	if building == &"":
		return
	if building == VillageLayout.STATUE:
		_open_prayer()
		return
	selected = building
	for id: StringName in _outlines:
		(_outlines[id] as CanvasItem).visible = id == building
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


func outline_shown() -> StringName:
	for id: StringName in _outlines:
		if (_outlines[id] as CanvasItem).visible:
			return id
	return &""


func sky_x() -> float:
	return _sky.position.x


func grey_amount() -> float:
	return float((_sky.material as ShaderMaterial).get_shader_parameter(&"grey")) if _sky.visible else 0.0


func sunset_shown() -> bool:
	return _sunset.visible


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
	_stage.clip_contents = true
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	var grey: bool = is_grey()
	var sky_texture: Texture2D = load(VillageLayout.SKY_PATH) as Texture2D
	_sky_width = sky_texture.get_size().x
	_sky = TextureRect.new()
	_sky.texture = sky_texture
	_sky.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_sky.stretch_mode = TextureRect.STRETCH_TILE
	_sky.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_sky.size = Vector2(STAGE_SIZE.x + _sky_width, sky_texture.get_size().y)
	_sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_sky.material = _weather(GREY_SKY)
	_sky.visible = grey
	_stage.add_child(_sky)
	_sunset = ColorRect.new()
	_sunset.size = STAGE_SIZE
	_sunset.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sunset := ShaderMaterial.new()
	sunset.shader = load(SUNSET_SHADER_PATH) as Shader
	sunset.set_shader_parameter(&"drift", SKY_SPEED)
	_sunset.material = sunset
	_sunset.visible = not grey
	_stage.add_child(_sunset)
	_picture = TextureRect.new()
	_picture.texture = load(VillageLayout.PICTURE_PATH) as Texture2D
	_picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_picture.size = STAGE_SIZE
	_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_picture.material = _weather(GREY_VILLAGE if grey else 0.0)
	_stage.add_child(_picture)
	if grey:
		_stage.add_child(_mist())
	for id: StringName in VillageLayout.AREAS:
		var outline := TextureRect.new()
		outline.texture = load(VillageLayout.OUTLINE_PATH % id) as Texture2D
		outline.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		outline.size = STAGE_SIZE
		outline.visible = false
		outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_stage.add_child(outline)
		_outlines[id] = outline
	_build_top_band()
	_build_note()
	_build_prayer()


func _build_prayer() -> void:
	_prayer = PixelStyle.iron_plate(PRAYER_RECT)
	_prayer.visible = false
	_stage.add_child(_prayer)
	var title := Label.new()
	title.text = data.ui.text(&"statue_title")
	title.position = Vector2(18, 8)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	PixelStyle.title(title, PixelStyle.COLOR_AMBER, TITLE_SIZE)
	_prayer.add_child(title)
	# A Label wraps only inside a container (as in the saint's card).
	var column := VBoxContainer.new()
	column.position = Vector2(18, 38)
	column.size = Vector2(PRAYER_RECT.size.x - 36.0, 0)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_prayer.add_child(column)
	_prayer_text = Label.new()
	_prayer_text.text = data.ui.text(&"statue_prayer")
	_prayer_text.custom_minimum_size.x = PRAYER_RECT.size.x - 36.0
	_prayer_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_prayer_text.add_theme_font_size_override("font_size", TEXT_SIZE)
	_prayer_text.add_theme_color_override("font_color", PixelStyle.COLOR_BONE)
	_prayer_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(_prayer_text)


func _open_prayer() -> void:
	for id: StringName in _outlines:
		(_outlines[id] as CanvasItem).visible = false
	_note.visible = false
	_prayer_chars = 0.0
	_prayer_text.visible_characters = 0
	_prayer.visible = true


func _weather(amount: float) -> ShaderMaterial:
	var material := ShaderMaterial.new()
	material.shader = load(WEATHER_SHADER_PATH) as Shader
	material.set_shader_parameter(&"grey", amount)
	return material


## A veil of mist, thicker at the top, over the village in Advent and Lent.
func _mist() -> TextureRect:
	var gradient := Gradient.new()
	gradient.set_color(0, MIST_COLOR)
	gradient.set_color(1, Color(MIST_COLOR, MIST_COLOR.a * 0.35))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill_from = Vector2(0, 0)
	texture.fill_to = Vector2(0, 1)
	var mist := TextureRect.new()
	mist.texture = texture
	mist.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mist.size = STAGE_SIZE
	mist.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return mist


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
