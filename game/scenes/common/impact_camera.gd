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
## Shake offsets in pixels, one per step.
const SHAKE: Array[Vector2] = [Vector2(14, -6), Vector2(-12, 8), Vector2(9, 5), Vector2(-6, -4), Vector2(3, 2)]
const SHAKE_STEP: float = 0.035

var field: Control
var flash: ColorRect
var _home: Vector2
var _tween: Tween


func _init(p_field: Control, p_flash: ColorRect) -> void:
	field = p_field
	flash = p_flash
	_home = field.position


## `at` is a global position; `speed` 0 skips the effect.
func punch(at: Vector2, speed: float = 1.0) -> void:
	if speed <= 0.0 or not field.is_inside_tree():
		return
	if _tween != null and _tween.is_valid():
		_tween.kill()
	field.position = _home
	field.scale = Vector2.ONE
	field.pivot_offset = field.get_global_transform().affine_inverse() * at
	_tween = field.create_tween()
	_tween.tween_property(field, "scale", Vector2(ZOOM, ZOOM), ZOOM_IN_TIME / speed)
	for offset: Vector2 in SHAKE:
		_tween.tween_property(field, "position", _home + offset, SHAKE_STEP / speed)
	_tween.tween_property(field, "position", _home, SHAKE_STEP / speed)
	_tween.tween_property(field, "scale", Vector2.ONE, ZOOM_OUT_TIME / speed)
	if flash != null:
		flash.color.a = FLASH_ALPHA
		var fade := flash.create_tween()
		fade.tween_property(flash, "color:a", 0.0, FLASH_TIME / speed)
