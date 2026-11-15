class_name CircleLook
extends RefCounted
## How the scenery of one circle is tinted and layered (T65). The filter of
## the circle is model B of D-379: a colour ramp by brightness, mixed with
## the converted painting. Presentation only: colours and file names, never
## a rule, so nothing here comes from docs/balance.

const SHADER_PATH: String = "res://shaders/circle_filter.gdshader"
const SCENERY_DIR: String = "res://assets/pixel/environments"
## Circle 2 (D-379): ramp from the reserved colours of the palette and the
## strength of the mix.
const CIRCLE_02_RAMP: Array[Color] = [
	Color("0D0C10"), Color("241A30"), Color("3B2A4D"), Color("5B3F7A"), Color("8A6BB0"), Color("E4DDCF"),
]
const CIRCLE_02_STRENGTH: float = 0.55
## Parallax of each layer (asset-pipeline §4): the sky far away, the middle
## with the ground the characters walk on, the front a little faster.
const PARALLAX_BACK: float = 0.2
const PARALLAX_MID: float = 1.0
const PARALLAX_FRONT: float = 1.3
## Scenery sets of Circle 2 that are in the game now.
const SET_LEG_1: StringName = &"t1"
const SET_BOSS: StringName = &"boss"

static var _materials: Dictionary = {}


## The material every scenery layer of `circle` shares.
static func filter_material(circle: StringName = &"circle_02") -> ShaderMaterial:
	if _materials.has(circle):
		return _materials[circle]
	var gradient := Gradient.new()
	var offsets := PackedFloat32Array()
	var colors := PackedColorArray()
	for i: int in CIRCLE_02_RAMP.size():
		offsets.append(float(i) / (CIRCLE_02_RAMP.size() - 1))
		colors.append(CIRCLE_02_RAMP[i])
	gradient.offsets = offsets
	gradient.colors = colors
	var ramp := GradientTexture1D.new()
	ramp.gradient = gradient
	var mat := ShaderMaterial.new()
	mat.shader = load(SHADER_PATH)
	mat.set_shader_parameter("ramp", ramp)
	mat.set_shader_parameter("strength", CIRCLE_02_STRENGTH)
	_materials[circle] = mat
	return mat


## Layers behind the characters, back to front: {"path", "parallax"}.
static func back_layers(set_id: StringName, circle: StringName = &"circle_02") -> Array[Dictionary]:
	return [
		{"path": _path(circle, set_id, "back"), "parallax": PARALLAX_BACK},
		{"path": _path(circle, set_id, "mid"), "parallax": PARALLAX_MID},
	]


## Layers in front of the characters.
static func front_layers(set_id: StringName, circle: StringName = &"circle_02") -> Array[Dictionary]:
	return [{"path": _path(circle, set_id, "front"), "parallax": PARALLAX_FRONT}]


static func _path(circle: StringName, set_id: StringName, layer: String) -> String:
	return "%s/%s/env_%s_%s_%s.png" % [SCENERY_DIR, circle, circle, set_id, layer]
