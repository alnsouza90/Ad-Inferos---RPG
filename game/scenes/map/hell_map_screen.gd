class_name HellMapScreen
extends Control
## The Map of Hell (T49, D-208, D-276, D-505 to D-512), opened from the Gate:
## Alan's eleven bands stacked and scrolled, the medallion of each place over
## its mark (dark until the boss falls, padlocked while closed), the sides
## darker band after band as the funnel narrows, the lantern on its chain
## from the Gate of Hell down to the company's band, the pale light one band
## ahead, and the trail of each open circle: its gate, its camps (grey until
## consecrated, amber after) and its boss. Tapping a lit point and "Partir
## daqui" chooses where the expedition starts. Rules come from HellMap.

## The company leaves for `place`, from its gate (camp 0) or a camp.
signal start_chosen(place: StringName, camp: int)
signal back_pressed

const STAGE_SIZE := Vector2(960, 540)
const BAND_SIZE := Vector2(960, 240)
const BAND_PATH: String = "res://assets/pixel/environments/map/map_band_%02d.png"
const MEDALLION_PATH: String = "res://assets/pixel/ui/map/map_medallion_%02d.png"
const POINT_PATH: String = "res://assets/pixel/ui/map/map_point_%s.png"
const CHAIN_PATH: String = "res://assets/pixel/ui/map/map_chain.png"
const TOP_HEIGHT: float = 40.0
const MEDALLION_SIZE: float = 96.0
## The centre of the round mark in each band, which the medallion covers.
const MEDALLION_CENTRES: Array[Vector2] = [
	Vector2(85, 92), Vector2(166, 108), Vector2(149, 101), Vector2(260, 102), Vector2(166, 120),
	Vector2(254, 91), Vector2(178, 94), Vector2(50, 122), Vector2(77, 94), Vector2(50, 106), Vector2(74, 67),
]
## The trail in a band: the gate of the circle, the camps, then the boss.
## Placed on the stairs Alan's band draws for Circle 2; a plain line for the
## bands not drawn yet.
const TRAILS: Dictionary = {
	&"circle_02": [Vector2(150, 100), Vector2(292, 182), Vector2(700, 205), Vector2(560, 150)],
}
const DEFAULT_TRAIL: Array[Vector2] = [Vector2(360, 190), Vector2(500, 200), Vector2(640, 190), Vector2(500, 120)]
const POINT_SIZE: float = 32.0
const DOT_GAP: float = 9.0
const DOT_SIZE: float = 2.0
## The lantern's chain hangs from the Gate of Hell, at the right.
const CHAIN_X: float = 830.0
const CHAIN_TOP: float = 214.0
const LANTERN_DROP: float = 120.0
## The funnel: the dark of each side grows band after band.
const FUNNEL_START: float = 20.0
const FUNNEL_STEP: float = 22.0
const LOCKED_SHADE := Color(0, 0, 0, 0.55)
const MEDALLION_DARK := Color(0.4, 0.38, 0.42)
const CAMP_GREY := Color(0.55, 0.55, 0.58)
const CAMP_AMBER := Color(1.25, 0.95, 0.6)
const PALE_LIGHT := Color(0.85, 0.9, 1.0, 0.55)
const PALE_LIGHT_SIZE: float = 120.0
const PLATE_RECT := Rect2(250, 452, 460, 80)
const TITLE_SIZE: int = PixelStyle.TITLE_SIZE * 2
const TEXT_SIZE: int = PixelStyle.TEXT_SIZE * 2

var data: GameData
var catalog: ExpeditionCatalog
var campaign: CampaignState
## The point tapped: place and camp (-1 when none).
var chosen_place: StringName = &""
var chosen_camp: int = -1

var _stage: Control
var _scroll: ScrollContainer
var _map: Control
var _plate: NinePatchRect
var _plate_text: Label
var _plate_button: Button


func setup(p_data: GameData, p_catalog: ExpeditionCatalog, p_campaign: CampaignState) -> void:
	data = p_data
	catalog = p_catalog
	campaign = p_campaign


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()
	scroll_to_band(HellMap.lantern_band(campaign, catalog))


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- taps ----------------------------------------------------------------------

## A point of a trail tapped: a start point opens the plate with "Partir
## daqui"; a camp not consecrated or the boss only says what it is.
func tap_point(place: StringName, camp: int) -> void:
	var starts: Array[int] = HellMap.start_points(campaign, catalog, place)
	chosen_place = place if starts.has(camp) else &""
	chosen_camp = camp if starts.has(camp) else -1
	_plate.visible = true
	_plate_text.text = point_text(place, camp)
	_plate_button.visible = chosen_camp >= 0


## A medallion tapped: its name, or why it is closed.
func tap_medallion(place: StringName) -> void:
	chosen_place = &""
	chosen_camp = -1
	_plate.visible = true
	var name_text: String = data.ui.text(StringName("map_place_%s" % place))
	if HellMap.state(campaign, catalog, place) == HellMap.LOCKED:
		_plate_text.text = "%s\n%s" % [name_text, data.ui.text(&"map_locked")]
	else:
		_plate_text.text = "%s\n%s" % [name_text, data.ui.text(&"map_choose")]
	_plate_button.visible = false


func depart_here() -> void:
	if chosen_camp >= 0:
		start_chosen.emit(chosen_place, chosen_camp)


func press_back() -> void:
	back_pressed.emit()


func plate_shown() -> String:
	return _plate_text.text if _plate.visible else ""


## What a point is: the gate, a camp (consecrated or not), or the boss.
func point_text(place: StringName, camp: int) -> String:
	var name_text: String = data.ui.text(StringName("map_place_%s" % place))
	if camp == 0:
		return "%s\n%s" % [name_text, data.ui.text(&"map_start_gate")]
	if camp > HellMap.camps().size():
		return "%s\n%s" % [name_text, data.ui.text(&"map_boss")]
	if HellMap.start_points(campaign, catalog, place).has(camp):
		return "%s\n%s" % [name_text, data.ui.text(&"map_start_camp", {"camp": camp})]
	return "%s\n%s" % [name_text, data.ui.text(&"map_camp_not_consecrated", {"camp": camp})]


## Scrolls so that `band` is in the middle of the screen.
func scroll_to_band(band: int) -> void:
	var visible_height: float = STAGE_SIZE.y - TOP_HEIGHT
	var target: float = band * BAND_SIZE.y + BAND_SIZE.y * 0.5 - visible_height * 0.5
	_scroll.scroll_vertical = int(clampf(target, 0.0, HellMap.PLACES.size() * BAND_SIZE.y - visible_height))


# --- building --------------------------------------------------------------------

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
	_scroll = ScrollContainer.new()
	_scroll.position = Vector2(0, TOP_HEIGHT)
	_scroll.size = Vector2(STAGE_SIZE.x, STAGE_SIZE.y - TOP_HEIGHT)
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	_stage.add_child(_scroll)
	_map = Control.new()
	_map.custom_minimum_size = Vector2(BAND_SIZE.x, BAND_SIZE.y * HellMap.PLACES.size())
	_map.mouse_filter = Control.MOUSE_FILTER_PASS
	_scroll.add_child(_map)
	for i: int in HellMap.PLACES.size():
		_build_band(i)
	_build_lantern()
	for i: int in HellMap.PLACES.size():
		_build_medallion(i)
		if HellMap.state(campaign, catalog, HellMap.PLACES[i]) != HellMap.LOCKED:
			_build_trail(i)
	_build_top()
	_build_plate()


func _build_band(i: int) -> void:
	var y: float = i * BAND_SIZE.y
	var band := _picture(load(BAND_PATH % i) as Texture2D, Rect2(Vector2(0, y), BAND_SIZE))
	_map.add_child(band)
	# The funnel narrows: each side a little darker, band after band.
	var side: float = FUNNEL_START + FUNNEL_STEP * i
	for left: bool in [true, false]:
		var shade := TextureRect.new()
		shade.texture = _side_shade(left)
		shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		shade.position = Vector2(0.0 if left else BAND_SIZE.x - side, y)
		shade.size = Vector2(side, BAND_SIZE.y)
		shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_map.add_child(shade)
	if HellMap.state(campaign, catalog, HellMap.PLACES[i]) == HellMap.LOCKED:
		var veil := ColorRect.new()
		veil.color = LOCKED_SHADE
		veil.position = Vector2(0, y)
		veil.size = BAND_SIZE
		veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_map.add_child(veil)


func _build_medallion(i: int) -> void:
	var place: StringName = HellMap.PLACES[i]
	var state: StringName = HellMap.state(campaign, catalog, place)
	var centre: Vector2 = MEDALLION_CENTRES[i] + Vector2(0, i * BAND_SIZE.y)
	var rect := Rect2(centre - Vector2.ONE * MEDALLION_SIZE * 0.5, Vector2.ONE * MEDALLION_SIZE)
	var button := TextureButton.new()
	button.texture_normal = load(MEDALLION_PATH % i) as Texture2D
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	button.position = rect.position
	button.size = rect.size
	button.focus_mode = Control.FOCUS_NONE
	# The medallion is the prize: dark until the boss of the place falls.
	if state != HellMap.COMPLETED:
		button.modulate = MEDALLION_DARK
	button.pressed.connect(func() -> void: tap_medallion(place))
	_map.add_child(button)
	if state == HellMap.LOCKED:
		_map.add_child(SaintMini.padlock(centre))
	var label := Label.new()
	label.text = data.ui.text(StringName("map_place_%s" % place))
	PixelStyle.title(label, PixelStyle.COLOR_BONE if state != HellMap.LOCKED else PixelStyle.COLOR_GREY, TITLE_SIZE)
	label.position = Vector2(rect.end.x + 6, centre.y - 14)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map.add_child(label)


func _build_trail(i: int) -> void:
	var place: StringName = HellMap.PLACES[i]
	var offset := Vector2(0, i * BAND_SIZE.y)
	var trail: Array = TRAILS.get(place, DEFAULT_TRAIL)
	var dots := TrailDots.new()
	dots.points = []
	for p: Vector2 in trail:
		dots.points.append(p + offset)
	dots.gap = DOT_GAP
	dots.dot = DOT_SIZE
	dots.color = PixelStyle.COLOR_AMBER
	dots.size = _map.custom_minimum_size
	dots.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map.add_child(dots)
	var starts: Array[int] = HellMap.start_points(campaign, catalog, place)
	var camps: Array[int] = HellMap.camps()
	for k: int in trail.size():
		var kind: String = "gate" if k == 0 else ("boss" if k > camps.size() else "camp")
		var point := TextureButton.new()
		point.texture_normal = load(POINT_PATH % kind) as Texture2D
		point.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		point.position = (trail[k] + offset - Vector2.ONE * POINT_SIZE * 0.5).round()
		point.focus_mode = Control.FOCUS_NONE
		if kind == "camp":
			point.modulate = CAMP_AMBER if starts.has(k) else CAMP_GREY
		var camp: int = k
		point.pressed.connect(func() -> void: tap_point(place, camp))
		_map.add_child(point)


## The lantern on its chain, from the Gate of Hell to the company's band,
## and the pale light one band ahead (D-276).
func _build_lantern() -> void:
	var band: int = HellMap.lantern_band(campaign, catalog)
	var bottom: float = band * BAND_SIZE.y + LANTERN_DROP
	var chain_texture: Texture2D = load(CHAIN_PATH) as Texture2D
	var chain := TextureRect.new()
	chain.texture = chain_texture
	chain.stretch_mode = TextureRect.STRETCH_TILE
	chain.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	chain.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	chain.position = Vector2(CHAIN_X - chain_texture.get_width() * 0.5, CHAIN_TOP)
	chain.size = Vector2(chain_texture.get_width(), bottom - CHAIN_TOP)
	chain.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map.add_child(chain)
	var lantern_texture: Texture2D = PixelStyle.piece("ui_lantern_on")
	_map.add_child(_picture(lantern_texture, Rect2(Vector2(CHAIN_X - lantern_texture.get_width() * 0.5, bottom).round(), lantern_texture.get_size())))
	var pale: int = HellMap.pale_light_band(campaign, catalog)
	if pale == band:
		return
	var light := TextureRect.new()
	light.texture = _glow()
	light.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	light.size = Vector2.ONE * PALE_LIGHT_SIZE
	light.position = Vector2(CHAIN_X, pale * BAND_SIZE.y + LANTERN_DROP) - light.size * 0.5
	light.modulate = PALE_LIGHT
	light.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map.add_child(light)
	if is_inside_tree():
		var tween := light.create_tween().set_loops()
		tween.tween_property(light, "modulate:a", PALE_LIGHT.a * 0.5, 1.6)
		tween.tween_property(light, "modulate:a", PALE_LIGHT.a, 1.6)


func _build_top() -> void:
	var bar := ColorRect.new()
	bar.color = PixelStyle.COLOR_PITCH
	bar.size = Vector2(STAGE_SIZE.x, TOP_HEIGHT)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(bar)
	var band := TextureRect.new()
	band.texture = PixelStyle.piece("ui_top_band")
	band.stretch_mode = TextureRect.STRETCH_TILE
	band.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	band.position = Vector2(0, TOP_HEIGHT - 8)
	band.size = Vector2(STAGE_SIZE.x, 16)
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(band)
	var title := Label.new()
	title.text = data.ui.text(&"map_title")
	PixelStyle.title(title, PixelStyle.COLOR_BONE, TITLE_SIZE)
	title.position = Vector2(14, 2)
	_stage.add_child(title)
	var back := Button.new()
	back.text = data.ui.text(&"map_back")
	back.add_theme_font_size_override("font_size", TEXT_SIZE)
	back.position = Vector2(STAGE_SIZE.x - 184, 2)
	back.size = Vector2(176, 30)
	back.pressed.connect(press_back)
	_stage.add_child(back)


func _build_plate() -> void:
	_plate = PixelStyle.iron_plate(PLATE_RECT)
	_plate.visible = false
	_stage.add_child(_plate)
	_plate_text = Label.new()
	_plate_text.position = Vector2(16, 8)
	_plate_text.size = Vector2(PLATE_RECT.size.x - 200, PLATE_RECT.size.y - 16)
	_plate_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_plate_text.add_theme_font_size_override("font_size", TEXT_SIZE)
	_plate_text.add_theme_color_override("font_color", PixelStyle.COLOR_BONE)
	_plate_text.add_theme_constant_override("line_spacing", -4)
	_plate.add_child(_plate_text)
	_plate_button = Button.new()
	_plate_button.text = data.ui.text(&"map_depart_here")
	_plate_button.add_theme_font_size_override("font_size", TEXT_SIZE)
	_plate_button.position = Vector2(PLATE_RECT.size.x - 176, 22)
	_plate_button.size = Vector2(160, 36)
	_plate_button.pressed.connect(depart_here)
	_plate.add_child(_plate_button)


# --- small parts -----------------------------------------------------------------

func _picture(texture: Texture2D, rect: Rect2) -> TextureRect:
	var pic := TextureRect.new()
	pic.texture = texture
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	pic.position = rect.position
	pic.size = rect.size
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return pic


static func _side_shade(left: bool) -> Texture2D:
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0, 0, 0, 0.85) if left else Color(0, 0, 0, 0))
	gradient.set_color(1, Color(0, 0, 0, 0) if left else Color(0, 0, 0, 0.85))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 64
	texture.height = 4
	return texture


static func _glow() -> Texture2D:
	var gradient := Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1))
	gradient.set_color(1, Color(1, 1, 1, 0))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1.0, 0.5)
	texture.width = 64
	texture.height = 64
	return texture


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE
