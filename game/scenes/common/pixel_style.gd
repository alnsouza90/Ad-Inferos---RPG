class_name PixelStyle
extends RefCounted
## The look of the interface in pixel art (T65, ADR-0013, D-367): the
## "chapel in the dark" of the Art Bible with the approved cathedral pieces
## (D-368), Jacquard 12 for names and titles and Jersey 10 for text and
## numbers (D-377), both at their natural size on the 960 × 540 grid.
## Presentation only: colours, art paths and the theme, never a rule.

const TITLE_FONT_PATH: String = "res://assets/pixel/fonts/Jacquard12-Regular.ttf"
const TEXT_FONT_PATH: String = "res://assets/pixel/fonts/Jersey10-Regular.ttf"
const UI_DIR: String = "res://assets/pixel/ui"
## Natural sizes of the two fonts: one font pixel is one screen pixel.
const TEXT_SIZE: int = 10
const TITLE_SIZE: int = 12
## Twice the grid, for the few big words (the result of a battle).
const BIG_TITLE_SIZE: int = 24

## Reserved colours of the palette (docs/fable/piloto-pixel/paleta.json).
const COLOR_PITCH := Color("0D0C10")
const COLOR_IRON := Color("1B1A20")
const COLOR_LEAD := Color("33313A")
const COLOR_LEAD_LIGHT := Color("55525D")
const COLOR_GREY := Color("8A8791")
const COLOR_BONE := Color("E4DDCF")
const COLOR_BLOOD := Color("9B1C1C")
const COLOR_GOLD := Color("D9A520")
const COLOR_AMBER := Color("E07B1F")
const COLOR_VIOLET := Color("8A6BB0")
const COLOR_HEAL := Color("8FB573")

## Corners of the iron plate that never stretch (pixels of ui_plate9).
const PLATE_MARGIN: int = 14
## Corners of the iron button that never stretch (pixels of ui_button).
const BUTTON_MARGIN: int = 8

static var _title_font: Font
static var _text_font: Font
static var _textures: Dictionary = {}


static func title_font() -> Font:
	if _title_font == null:
		_title_font = _pixel_font(TITLE_FONT_PATH)
	return _title_font


static func text_font() -> Font:
	if _text_font == null:
		_text_font = _pixel_font(TEXT_FONT_PATH)
	return _text_font


static func piece(file_name: String) -> Texture2D:
	var path: String = "%s/%s.png" % [UI_DIR, file_name]
	if not _textures.has(path):
		_textures[path] = load(path) as Texture2D if ResourceLoader.exists(path) else null
	return _textures[path]


## The theme of a screen on the pixel grid: Jersey 10 in every Label and
## Button, flat iron buttons with a lead edge.
static func theme() -> Theme:
	var t := Theme.new()
	t.default_font = text_font()
	t.default_font_size = TEXT_SIZE
	t.set_color(&"font_color", &"Label", COLOR_BONE)
	t.set_color(&"font_outline_color", &"Label", COLOR_PITCH)
	t.set_constant(&"outline_size", &"Label", 2)
	t.set_constant(&"line_spacing", &"Label", 0)
	for state: StringName in [&"normal", &"hover", &"pressed", &"disabled", &"focus"]:
		t.set_stylebox(state, &"Button", button_box(state))
	t.set_color(&"font_color", &"Button", COLOR_BONE)
	t.set_color(&"font_hover_color", &"Button", COLOR_BONE)
	t.set_color(&"font_pressed_color", &"Button", COLOR_GOLD)
	t.set_color(&"font_focus_color", &"Button", COLOR_BONE)
	t.set_color(&"font_disabled_color", &"Button", COLOR_LEAD_LIGHT)
	t.set_constant(&"line_spacing", &"Button", 0)
	return t


## The approved forged-iron button (ui_button, D-368, D-442) for every plain
## button: its riveted corners kept, its middle stretched; pressed shows the
## pressed piece, disabled is darker.
static func button_box(state: StringName) -> StyleBox:
	if state == &"focus":
		return StyleBoxEmpty.new()
	var tex: Texture2D = piece("ui_button_pressed" if state == &"pressed" else "ui_button")
	if tex == null:
		return StyleBoxEmpty.new()
	var box := StyleBoxTexture.new()
	box.texture = tex
	box.texture_margin_left = BUTTON_MARGIN
	box.texture_margin_right = BUTTON_MARGIN
	box.texture_margin_top = BUTTON_MARGIN
	box.texture_margin_bottom = BUTTON_MARGIN
	box.content_margin_left = 6
	box.content_margin_right = 6
	box.content_margin_top = 2
	box.content_margin_bottom = 2
	match state:
		&"hover":
			box.modulate_color = Color(1.12, 1.08, 1.0)
		&"disabled":
			box.modulate_color = Color(0.55, 0.55, 0.6)
	return box


## A title in Jacquard 12 (names, the round, headings).
static func title(label: Label, color: Color = COLOR_BONE, font_size: int = TITLE_SIZE) -> void:
	label.add_theme_font_override("font", title_font())
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)


## A flat iron plate with a lead edge (the bottom panel, the overlays).
static func plate(rect: Rect2, fill: Color = COLOR_IRON, edge: Color = COLOR_LEAD) -> Panel:
	var panel := Panel.new()
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = edge
	box.set_border_width_all(1)
	box.anti_aliasing = false
	panel.add_theme_stylebox_override("panel", box)
	panel.position = rect.position
	panel.size = rect.size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return panel


## The stone of the panel (D-441): dark chapel stone under an iron band,
## repeated sideways over `rect`.
static func stone_panel(rect: Rect2) -> TextureRect:
	var stone := TextureRect.new()
	stone.texture = piece("ui_panel_stone")
	stone.stretch_mode = TextureRect.STRETCH_TILE
	stone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stone.position = rect.position
	stone.size = rect.size
	stone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return stone


## An iron plate with riveted corners that stretches to `rect` (D-441):
## the note, the sheet, the cards, the opened alforje.
static func iron_plate(rect: Rect2) -> NinePatchRect:
	var plate := NinePatchRect.new()
	plate.texture = piece("ui_plate9")
	plate.patch_margin_left = PLATE_MARGIN
	plate.patch_margin_top = PLATE_MARGIN
	plate.patch_margin_right = PLATE_MARGIN
	plate.patch_margin_bottom = PLATE_MARGIN
	plate.position = rect.position
	plate.size = rect.size
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return plate


## Tint of the portrait arch by the saint's spiritual state (D-258 (5)):
## iron when calm, blood as desolation rises, gold in Consolation, violet
## in the Dark Night.
static func frame_tint(spirit_state: StringName, desolation: int, desolation_max: int) -> Color:
	if spirit_state == Desolation.CONSOLATION:
		return Color(1.3, 1.1, 0.6)
	if spirit_state == Desolation.DARK_NIGHT:
		return Color(0.55, 0.45, 0.75)
	var share: float = clampf(float(desolation) / maxf(float(desolation_max), 1.0), 0.0, 1.0)
	return Color.WHITE.lerp(Color(1.25, 0.5, 0.45), share)


## No smoothing and no hinting: every pixel of the font is a whole pixel.
static func _pixel_font(path: String) -> Font:
	var file := FontFile.new()
	file.load_dynamic_font(path)
	file.antialiasing = TextServer.FONT_ANTIALIASING_NONE
	file.hinting = TextServer.HINTING_NONE
	file.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	file.force_autohinter = false
	return file
