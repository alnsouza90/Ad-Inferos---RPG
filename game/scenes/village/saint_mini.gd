class_name SaintMini
extends RefCounted
## The small pictures of a saint in the village buildings (T49, D-503): the
## head cut from the approved portrait, in a square, for the stacked roster,
## the reserve, the beds and the places of the Garden.

## The square around the head in each 192 × 256 portrait.
const HEAD_REGIONS: Dictionary = {
	&"saint_george": Rect2(48, 22, 110, 110),
	&"saint_benedict": Rect2(70, 30, 110, 110),
	&"saint_therese": Rect2(62, 8, 112, 112),
	&"saint_anthony_abbot": Rect2(68, 34, 110, 110),
}


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


## A square tile in the iron frame (ui_tile_frame), tappable, with a picture
## inside. A chosen tile glows amber; a closed one is dark.
static func tile(rect: Rect2, texture: Texture2D, on_tap: Callable, chosen: bool = false, dim: bool = false) -> Button:
	var button := Button.new()
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.position = rect.position
	button.size = rect.size
	button.custom_minimum_size = rect.size
	var back := ColorRect.new()
	back.color = PixelStyle.COLOR_PITCH
	back.position = Vector2(4, 4)
	back.size = rect.size - Vector2(8, 8)
	back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(back)
	if texture != null:
		var pic := picture(texture, Rect2(Vector2(5, 5), rect.size - Vector2(10, 10)))
		if dim:
			pic.modulate = Color(0.12, 0.11, 0.14)
		button.add_child(pic)
	var frame := TextureRect.new()
	frame.texture = PixelStyle.piece("ui_tile_frame")
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	frame.size = rect.size
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if chosen:
		frame.modulate = Color(1.6, 1.0, 0.45)
	button.add_child(frame)
	if on_tap.is_valid():
		button.pressed.connect(func() -> void: on_tap.call())
	return button


## The padlock of a closed place (drawn by the engine until the PixelLab
## piece is approved).
static func padlock(center: Vector2) -> Control:
	var lock := Padlock.new()
	lock.position = center - Padlock.SIZE * 0.5
	lock.size = Padlock.SIZE
	lock.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return lock
