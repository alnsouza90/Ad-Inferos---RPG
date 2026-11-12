class_name BlowGestures
extends RefCounted
## Which gestures of the weight of the blow are on (D-353, D-358): all on in
## the battle; "Animações (teste)" turns each one on and off so Alan feels
## the difference on the phone. Presentation only.

const FREEZE: StringName = &"freeze"
const RECOIL: StringName = &"recoil"
const CAMERA_PUSH: StringName = &"camera_push"
const SHADOW: StringName = &"shadow"
const ANTICIPATION: StringName = &"anticipation"
const BLUR: StringName = &"blur"
## In the order of the buttons on the test screen.
const ALL: Array[StringName] = [FREEZE, RECOIL, CAMERA_PUSH, SHADOW, ANTICIPATION, BLUR]

var _on: Dictionary = {}


func _init() -> void:
	for g: StringName in ALL:
		_on[g] = true


func is_on(gesture: StringName) -> bool:
	return bool(_on.get(gesture, false))


func set_on(gesture: StringName, on: bool) -> void:
	if ALL.has(gesture):
		_on[gesture] = on


func toggle(gesture: StringName) -> bool:
	set_on(gesture, not is_on(gesture))
	return is_on(gesture)
