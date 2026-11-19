class_name SaintMini
extends RefCounted
## The small pictures of a saint in the village buildings (T49, D-503): the
## head cut from the approved portrait, in a square, for the stacked roster,
## the reserve, the beds and the places of the Garden.

## The square of each 192 × 256 portrait shown small: the head and the
## shoulders, so the face still reads at 50 pixels (D-504).
const HEAD_REGIONS: Dictionary = {
	&"saint_george": Rect2(16, 8, 168, 168),
	&"saint_benedict": Rect2(24, 8, 168, 168),
	&"saint_therese": Rect2(20, 0, 168, 168),
	&"saint_anthony_abbot": Rect2(24, 12, 168, 168),
}
## The thin iron edge of a tile (D-504: thinner than ui_tile_frame).
const EDGE: int = 2
const EDGE_COLOR := Color("4A4650")
const EDGE_LIGHT := Color("6E6A74")


## The head of the saint, or null when the saint has no portrait yet.
static func head(saint_id: StringName) -> Texture2D:
	var whole: Texture2D = BattleScreen.saint_portrait(saint_id)
	if whole == null or not HEAD_REGIONS.has(saint_id):
		return whole
	var cut := AtlasTexture.new()
	cut.atlas = whole
	cut.region = HEAD_REGIONS[saint_id]
	return cut


## A picture that fills its square, sharp pixels, no taps of its own.
static func picture(texture: Texture2D, rect: Rect2) -> TextureRect:
	var pic := TextureRect.new()
	pic.texture = texture
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	pic.position = rect.position
	pic.size = rect.size
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return pic


## A square tile with a thin iron edge, tappable, with a picture inside. A
## chosen tile glows amber; a closed one is dark.
static func tile(rect: Rect2, texture: Texture2D, on_tap: Callable, chosen: bool = false, dim: bool = false) -> Button:
	var button := Button.new()
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.position = rect.position
	button.size = rect.size
	button.custom_minimum_size = rect.size
	var box := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(PixelStyle.COLOR_PITCH, 0.85)
	style.set_border_width_all(EDGE)
	style.border_color = PixelStyle.COLOR_AMBER if chosen else EDGE_COLOR
	style.anti_aliasing = false
	box.add_theme_stylebox_override("panel", style)
	box.size = rect.size
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(box)
	if texture != null:
		var pic := picture(texture, Rect2(Vector2(EDGE, EDGE), rect.size - Vector2(EDGE, EDGE) * 2))
		if dim:
			pic.modulate = Color(0.12, 0.11, 0.14)
		button.add_child(pic)
	# A one-pixel light line on the top edge, as lit iron.
	var lit := ColorRect.new()
	lit.color = PixelStyle.COLOR_AMBER if chosen else EDGE_LIGHT
	lit.position = Vector2(EDGE, 0)
	lit.size = Vector2(rect.size.x - EDGE * 2, 1)
	lit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(lit)
	if on_tap.is_valid():
		button.pressed.connect(func() -> void: on_tap.call())
	return button


## The iron padlock of a closed place (PixelLab, D-504), centred.
static func padlock(center: Vector2) -> Control:
	var texture: Texture2D = PixelStyle.piece("ui_padlock")
	return picture(texture, Rect2((center - texture.get_size() * 0.5).floor(), texture.get_size()))
