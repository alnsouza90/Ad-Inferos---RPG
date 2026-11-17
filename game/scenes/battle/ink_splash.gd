class_name InkSplash
extends TextureRect
## An enemy's ink on the saint it hits (Art Bible §6.2, D-454): the frames of
## one sheet played once over the target, then gone. Presentation only.

const PATH: String = "res://assets/pixel/vfx/ink_%s.png"
const SLASH: StringName = &"slash"
const FRAMES: int = 6
const FPS: float = 14.0

var kind: StringName = &""
var _atlas := AtlasTexture.new()
var _time: float = 0.0
var _speed: float = 1.0


static func texture_of(ink_kind: StringName) -> Texture2D:
	var path: String = PATH % ink_kind
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## Plays `ink_kind` centred on `at` (parent coordinates) at `speed`; returns
## how long it lasts, 0 when it cannot play (and frees itself).
func play(ink_kind: StringName, at: Vector2, speed: float) -> float:
	kind = ink_kind
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var strip: Texture2D = texture_of(ink_kind)
	if strip == null or speed <= 0.0:
		queue_free()
		return 0.0
	_speed = speed
	_atlas.atlas = strip
	var cell := Vector2(strip.get_width() / float(FRAMES), strip.get_height())
	_atlas.region = Rect2(Vector2.ZERO, cell)
	texture = _atlas
	size = cell
	position = (at - cell * 0.5).round()
	return FRAMES / FPS / speed


func _process(delta: float) -> void:
	if texture == null:
		return
	_time += delta * _speed
	var frame: int = int(_time * FPS)
	if frame >= FRAMES:
		queue_free()
		return
	_atlas.region.position.x = frame * _atlas.region.size.x
