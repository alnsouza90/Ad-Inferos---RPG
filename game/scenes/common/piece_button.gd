class_name PieceButton
extends Button
## A button drawn with a piece of the cathedral interface (T65, D-368): a
## lancet window for an ability, the rose window for the miracle, a hook
## with its bag for a provision. One image per state; the words go on a dark
## plate so they read over the glass. It is still a Button (text, disabled,
## pressed), so the screens and the tests use it like any other.

var piece_normal: Texture2D
var piece_chosen: Texture2D
var piece_disabled: Texture2D
## The piece that was chosen and waits for the target or the confirmation.
var chosen: bool = false:
	set(value):
		chosen = value
		queue_redraw()
## Where the words go inside the piece; they are centred and grow upwards
## from the bottom of this area.
var text_area := Rect2()
var text_color: Color = PixelStyle.COLOR_BONE
var plate_color: Color = PixelStyle.COLOR_PITCH
var show_plate: bool = true


func _init() -> void:
	# The button draws only the piece and its own words.
	for state: StringName in [&"normal", &"hover", &"pressed", &"disabled", &"focus"]:
		add_theme_stylebox_override(state, StyleBoxEmpty.new())
	for color: StringName in [&"font_color", &"font_hover_color", &"font_pressed_color", &"font_focus_color", &"font_disabled_color", &"font_hover_pressed_color"]:
		add_theme_color_override(color, Color(0, 0, 0, 0))
	clip_text = true


func setup(normal: Texture2D, p_chosen: Texture2D, p_disabled: Texture2D, p_text_area: Rect2) -> void:
	piece_normal = normal
	piece_chosen = p_chosen
	piece_disabled = p_disabled
	text_area = p_text_area
	if normal != null:
		custom_minimum_size = normal.get_size()
		size = normal.get_size()


## The image shown now.
func piece() -> Texture2D:
	if disabled and piece_disabled != null:
		return piece_disabled
	if chosen and piece_chosen != null:
		return piece_chosen
	return piece_normal


func _draw() -> void:
	var tex: Texture2D = piece()
	if tex != null:
		draw_texture(tex, Vector2.ZERO)
	if text.is_empty() or text_area.size.x <= 0.0:
		return
	var font: Font = PixelStyle.text_font()
	var font_size: int = PixelStyle.TEXT_SIZE
	var block: Vector2 = font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, text_area.size.x, font_size)
	var height: float = minf(block.y, text_area.size.y)
	var top: float = text_area.end.y - height
	if show_plate:
		draw_rect(Rect2(text_area.position.x, top - 1.0, text_area.size.x, height + 1.0), plate_color)
	var color: Color = PixelStyle.COLOR_LEAD_LIGHT if disabled else (PixelStyle.COLOR_GOLD if chosen else text_color)
	draw_multiline_string(font, Vector2(text_area.position.x, top + font.get_ascent(font_size)), text, HORIZONTAL_ALIGNMENT_CENTER, text_area.size.x, font_size, -1, color)
