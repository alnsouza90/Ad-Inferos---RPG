class_name InkSplash
extends TextureRect
## An enemy's ink on the saint it hits (Art Bible §6.2, D-454): the frames of
## one sheet played once over the target, then gone. Presentation only.

const PATH: String = "res://assets/pixel/vfx/ink_%s.png"
const SLASH: StringName = &"slash"
## A spirit's action: a stain rises from the ground under the saint.
const STAIN: StringName = &"stain"
## Inks drawn on the ground line (their cells sit on the bottom).
const GROUNDED: Array[StringName] = [STAIN]
## Row of a grounded cell that stands on the feet (tools/art INK_GROUND_LINE).
const GROUND_LINE: float = 92.0
const FRAMES: int = 6
const FPS: float = 14.0

var kind: StringName = &""
var _atlas := AtlasTexture.new()
var _time: float = 0.0
var _speed: float = 1.0


static func texture_of(ink_kind: StringName) -> Texture2D:
	var path: String = PATH % ink_kind
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## Plays `ink_kind` centred on `at`, or standing on `at` when it is a
## grounded ink (parent coordinates), at `speed`; returns how long it
## lasts, 0 when it cannot play (and frees itself).
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
	position = (at - Vector2(cell.x * 0.5, GROUND_LINE if GROUNDED.has(ink_kind) else cell.y * 0.5)).round()
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
