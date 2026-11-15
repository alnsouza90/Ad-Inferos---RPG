class_name ParallaxScenery
extends Control
## Scenery in layers on the 960 × 540 grid (T65, ADR-0013). Each layer is
## drawn at its natural size, its bottom on the bottom of this control,
## repeated sideways with every second copy mirrored (so the edges always
## meet) and moved by its own parallax when the camera walks. The filter of
## the circle (CircleLook) tints all of it. Presentation only.

## Texture, parallax and horizontal offset of each layer, back to front.
var _textures: Array[Texture2D] = []
var _parallax: Array[float] = []
## Pixels the layers are pushed down: the battle shows only the top of the
## front layer, in the corners (D-258).
var drop: float = 0.0:
	set(value):
		drop = value
		queue_redraw()
var _camera_x: float = 0.0
var _shift: float = 0.0


## `layers`: [{"path": String, "parallax": float}]; a missing file is skipped.
func setup(layers: Array[Dictionary], filter: Material = null) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	material = filter
	_textures.clear()
	_parallax.clear()
	for layer: Dictionary in layers:
		var path: String = str(layer.get("path", ""))
		if not ResourceLoader.exists(path):
			continue
		_textures.append(load(path) as Texture2D)
		_parallax.append(float(layer.get("parallax", 1.0)))
	queue_redraw()


## The camera stands `x` pixels into the walk (pixels of the layer with
## parallax 1).
func set_camera_x(x: float) -> void:
	if x == _camera_x:
		return
	_camera_x = x
	queue_redraw()


## The whole field was pushed `pixels` sideways (the camera of a blow): the
## far layers follow less, so the depth shows.
func set_shift(pixels: float) -> void:
	if pixels == _shift:
		return
	_shift = pixels
	queue_redraw()


func layer_count() -> int:
	return _textures.size()


## Where the first copy of a layer starts now, in whole pixels.
func layer_offset(index: int) -> float:
	return roundf(-_camera_x * _parallax[index] + _shift * (_parallax[index] - 1.0))


func _draw() -> void:
	for i: int in _textures.size():
		var tex: Texture2D = _textures[i]
		var w: float = tex.get_width()
		var y: float = size.y - tex.get_height() + drop
		var offset: float = layer_offset(i)
		# The layer is centred on the control when the camera is at 0.
		var origin: float = floorf((size.x - w) * 0.5) + offset
		var first: int = int(floorf(-origin / w))
		var last: int = int(floorf((size.x - origin) / w))
		for k: int in range(first, last + 1):
			var x: float = origin + k * w
			if posmod(k, 2) == 0:
				draw_texture(tex, Vector2(x, y))
			else:
				draw_set_transform(Vector2(x + w, y), 0.0, Vector2(-1.0, 1.0))
				draw_texture(tex, Vector2.ZERO)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
