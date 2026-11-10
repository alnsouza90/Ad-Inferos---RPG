class_name FramePlayer
extends Control
## Draws one character from its frame sheets (D-194, T35). The feet of the
## character stand on `feet` (local position) and the standing figure is
## `display_height` pixels tall. Presentation only.

signal clip_finished(clip_id: StringName)

## Breathing over the idle loop: a slow stretch of the figure from its feet.
const BREATH_AMOUNT: float = 0.012
const BREATH_PERIOD: float = 3.2
## A single drawn pose (Minos) pops in: it starts a little bigger.
const POSE_POP: float = 0.06
const POSE_POP_TIME: float = 0.15

## Sheets already loaded, shared by every player (one texture per path).
static var _sheets: Dictionary = {}

var frames: CharacterFrames
var feet: Vector2 = Vector2.ZERO
var display_height: float = 300.0
## Animation speed factor: 1 normal, 2 fast, 0 still (first frame only).
var speed: float = 1.0

var _clip: FrameClip
var _time: float = 0.0
var _finished: bool = false
var _breath_time: float = 0.0
## Outline of light around the figure (a dark spell on it, D-236); 0: none.
var outline_strength: float = 0.0:
	set(value):
		outline_strength = value
		queue_redraw()
var outline_color: Color = Color(0.68, 0.42, 1.0)
## Offsets of the outline copies, in screen pixels.
const OUTLINE_OFFSETS: Array[Vector2] = [Vector2(-5, 0), Vector2(5, 0), Vector2(0, -5), Vector2(0, 5), Vector2(-4, -4), Vector2(4, 4), Vector2(-4, 4), Vector2(4, -4)]
const OUTLINE_SHADER_PATH: String = "res://shaders/silhouette.gdshader"
const OUTLINE_PULSE: float = 0.25
var _outline: Control


func setup(p_frames: CharacterFrames, p_feet: Vector2, p_display_height: float) -> void:
	frames = p_frames
	feet = p_feet
	display_height = p_display_height
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# The outline is drawn by a child behind the figure, with its own shader
	# (a light-coloured silhouette added to what is under it).
	_outline = Control.new()
	_outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_outline.show_behind_parent = true
	var mat := ShaderMaterial.new()
	mat.shader = load(OUTLINE_SHADER_PATH)
	_outline.material = mat
	_outline.draw.connect(_draw_outline)
	add_child(_outline)
	play(&"idle")


## Starts a clip from its first frame; returns how long one pass lasts at
## the current speed (0 when the clip is missing or speed is 0).
func play(clip_id: StringName) -> float:
	var next: FrameClip = frames.clip(clip_id) if frames != null else null
	if next == null:
		return 0.0
	_clip = next
	_time = 0.0
	_finished = false
	queue_redraw()
	return scaled(_clip.duration())


## Seconds at the current speed.
func scaled(seconds: float) -> float:
	return seconds / speed if speed > 0.0 else 0.0


func clip_id() -> StringName:
	return _clip.id if _clip != null else &""


func frame() -> int:
	return _clip.frame_at(_time) if _clip != null else 0


func is_finished() -> bool:
	return _finished


## Moves the clock (called every frame; tests call it directly).
func advance(delta: float) -> void:
	if _clip == null or speed <= 0.0:
		return
	var before: int = frame()
	_time += delta * speed
	_breath_time += delta * speed
	if not _clip.looping and not _finished and _time >= _clip.duration():
		_finished = true
		clip_finished.emit(_clip.id)
	if frame() != before or _clip.id == &"idle" or _time < POSE_POP_TIME:
		queue_redraw()


## Screen scale of the frames.
func pixel_scale() -> float:
	if frames == null or frames.figure_height <= 0.0:
		return 1.0
	return display_height / frames.figure_height


## Width of the standing figure on screen (its idle frame), in local pixels.
func figure_width() -> float:
	var idle: FrameClip = frames.clip(&"idle") if frames != null else null
	return idle.frame_size.x * pixel_scale() if idle != null else 0.0


## The texture, the area of the sheet and where it lands (local), for the
## frame on screen now; also used for the trail of the attack.
func current_draw() -> Dictionary:
	if _clip == null:
		return {}
	var texture: Texture2D = sheet(_clip.sheet_path)
	if texture == null:
		return {}
	var s: float = pixel_scale()
	var stretch := Vector2(s, s)
	if _clip.id == &"idle":
		stretch.y *= 1.0 + BREATH_AMOUNT * sin(TAU * _breath_time / BREATH_PERIOD)
	if _clip.fps <= 0.0 and not _clip.looping and _time < POSE_POP_TIME:
		stretch *= 1.0 + POSE_POP * (1.0 - _time / POSE_POP_TIME)
	var rect := Rect2(feet - _clip.anchor * stretch, Vector2(_clip.frame_size) * stretch)
	return {"texture": texture, "region": _clip.region(frame()), "rect": rect}


static func sheet(path: String) -> Texture2D:
	if not _sheets.has(path):
		_sheets[path] = load(path) as Texture2D if ResourceLoader.exists(path) else null
	return _sheets[path]


func _process(delta: float) -> void:
	advance(delta)


func _draw_outline() -> void:
	if outline_strength <= 0.0:
		return
	var d: Dictionary = current_draw()
	if d.is_empty():
		return
	var pulse: float = 1.0 - OUTLINE_PULSE + OUTLINE_PULSE * sin(_breath_time * 14.0)
	var tint := Color(outline_color, outline_strength * pulse)
	var rect: Rect2 = d["rect"]
	for offset: Vector2 in OUTLINE_OFFSETS:
		_outline.draw_texture_rect_region(d["texture"], Rect2(rect.position + offset, rect.size), d["region"], tint)


func _draw() -> void:
	if _outline != null:
		_outline.queue_redraw()
	var d: Dictionary = current_draw()
	if d.is_empty():
		return
	draw_texture_rect_region(d["texture"], d["rect"], d["region"])
