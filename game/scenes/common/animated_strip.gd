class_name AnimatedStrip
extends TextureRect
## A small looping animation of the scenery (D-446: the souls in the wind,
## the fish in its leap): the frames side by side in one texture, shown one
## at a time. Presentation only.

const FPS: float = 8.0

var frame_count: int = 1
var frame: int = 0
var _atlas := AtlasTexture.new()
var _time: float = 0.0


func setup(strip: Texture2D, frames: int) -> void:
	frame_count = maxi(frames, 1)
	_atlas.atlas = strip
	var side := Vector2(strip.get_width() / float(frame_count), strip.get_height())
	_atlas.region = Rect2(Vector2.ZERO, side)
	texture = _atlas
	size = side
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(delta: float) -> void:
	if frame_count < 2:
		return
	_time += delta
	var next: int = int(_time * FPS) % frame_count
	if next != frame:
		frame = next
		_atlas.region.position.x = frame * _atlas.region.size.x
