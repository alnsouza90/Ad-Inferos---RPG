class_name ImpactCamera
extends RefCounted
## The blow of an attack on screen (T35, D-194): the field zooms in toward
## the point of impact, shakes and flashes white for a moment, as in
## Darkest Dungeon. Presentation only; the shake is a fixed pattern, not
## chance (combat stays deterministic, ADR-0003).

const ZOOM: float = 1.07
const ZOOM_IN_TIME: float = 0.08
const ZOOM_OUT_TIME: float = 0.35
const FLASH_ALPHA: float = 0.45
const FLASH_TIME: float = 0.18
## G1 (D-237), the frame of a physical blow as in Darkest Dungeon: the
## camera closes in on the two fighters and holds, the scenery goes dark.
const BLOW_ZOOM: float = 1.18
const BLOW_IN_TIME: float = 0.07
const BLOW_OUT_TIME: float = 0.35
const BLOW_DIM: float = 0.6
const BLOW_SHAKE: float = 0.5
## Shake offsets in pixels, one per step.
const SHAKE: Array[Vector2] = [Vector2(14, -6), Vector2(-12, 8), Vector2(9, 5), Vector2(-6, -4), Vector2(3, 2)]
const SHAKE_STEP: float = 0.035

var field: Control
var flash: ColorRect
## Darkens the scenery behind the fighters during a blow (G1); optional.
var dim: ColorRect
var _home: Vector2
var _tween: Tween


func _init(p_field: Control, p_flash: ColorRect, p_dim: ColorRect = null) -> void:
	field = p_field
	flash = p_flash
	dim = p_dim
	_home = field.position


## `at` is a global position; `speed` 0 skips the effect; `strength` scales
## the zoom, the shake and the flash (a spell is lighter than a blow).
func punch(at: Vector2, speed: float = 1.0, strength: float = 1.0) -> void:
	if speed <= 0.0 or not field.is_inside_tree():
		return
	if _tween != null and _tween.is_valid():
		_tween.kill()
	field.position = _home
	field.scale = Vector2.ONE
	field.pivot_offset = field.get_global_transform().affine_inverse() * at
	_tween = field.create_tween()
	var zoom: float = 1.0 + (ZOOM - 1.0) * strength
	_tween.tween_property(field, "scale", Vector2(zoom, zoom), ZOOM_IN_TIME / speed)
	for offset: Vector2 in SHAKE:
		_tween.tween_property(field, "position", _home + offset * strength, SHAKE_STEP / speed)
	_tween.tween_property(field, "position", _home, SHAKE_STEP / speed)
	_tween.tween_property(field, "scale", Vector2.ONE, ZOOM_OUT_TIME / speed)
	if flash != null:
		flash.color.a = FLASH_ALPHA * strength
		var fade := flash.create_tween()
		fade.tween_property(flash, "color:a", 0.0, FLASH_TIME / speed)


## G1: closes in on `at` (global), darkens the scenery, flashes and shakes
## a little, holds for `hold` seconds (already scaled) and comes back.
## T59 (D-353): `push` moves the field toward the side of the blow while it
## holds (the blow has a side), `shake` scales the shake by the weight.
func blow(at: Vector2, speed: float, hold: float, push: Vector2 = Vector2.ZERO, shake: float = 1.0) -> void:
	if speed <= 0.0 or not field.is_inside_tree():
		return
	if _tween != null and _tween.is_valid():
		_tween.kill()
	field.position = _home
	field.scale = Vector2.ONE
	field.pivot_offset = field.get_global_transform().affine_inverse() * at
	_tween = field.create_tween()
	_tween.tween_property(field, "scale", Vector2(BLOW_ZOOM, BLOW_ZOOM), BLOW_IN_TIME / speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.parallel().tween_property(field, "position", _home + push, BLOW_IN_TIME / speed)
	for offset: Vector2 in SHAKE:
		_tween.tween_property(field, "position", _home + push + offset * BLOW_SHAKE * shake, SHAKE_STEP / speed)
	_tween.tween_property(field, "position", _home + push, SHAKE_STEP / speed)
	_tween.tween_interval(maxf(hold - SHAKE_STEP * (SHAKE.size() + 1) / speed, 0.0))
	_tween.tween_property(field, "scale", Vector2.ONE, BLOW_OUT_TIME / speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	_tween.parallel().tween_property(field, "position", _home, BLOW_OUT_TIME / speed)
	if dim != null:
		var shade := dim.create_tween()
		shade.tween_property(dim, "color:a", BLOW_DIM, BLOW_IN_TIME / speed)
		shade.tween_interval(hold)
		shade.tween_property(dim, "color:a", 0.0, BLOW_OUT_TIME / speed)
	if flash != null:
		flash.color.a = FLASH_ALPHA
		flash.create_tween().tween_property(flash, "color:a", 0.0, FLASH_TIME / speed)
