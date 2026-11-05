class_name RigMotions
extends RefCounted
## The motions of a humanoid on the 2D skeleton (T35, D-176), shared by every
## humanoid character: the bones are named the same in each cut map
## (tools/art/rigs/). Presentation only, like the animation times of
## CombatantView: nothing here changes a rule.
##
## Angles in degrees, Godot's sense (clockwise on screen). For a character
## facing right: a positive torso angle leans it forward; a negative angle on
## a limb that hangs down (thigh, arm) swings it forward.
## Each motion: length (s), loop, and per bone a list of [time, angle];
## "root_move" is a list of [time, Vector2] offsets of the whole figure.

const IDLE: StringName = &"idle"
const IDLE_WEARY: StringName = &"idle_weary"
const WALK: StringName = &"walk"
const ATTACK: StringName = &"attack"
const DEFEND: StringName = &"defend"
const HIT: StringName = &"hit"
const FALL: StringName = &"fall"
const ROOT_MOVE: String = "root_move"

const HUMANOID: Dictionary = {
	IDLE: {
		"length": 2.4, "loop": true,
		"torso": [[0.0, 0.0], [1.2, 1.2], [2.4, 0.0]],
		"head": [[0.0, 0.0], [1.2, -1.0], [2.4, 0.0]],
		"arm_upper": [[0.0, 0.0], [1.2, -1.5], [2.4, 0.0]],
		"cape": [[0.0, 0.0], [1.2, 1.5], [2.4, 0.0]],
		"shield": [[0.0, 0.0], [1.2, 1.0], [2.4, 0.0]],
		ROOT_MOVE: [[0.0, Vector2.ZERO], [1.2, Vector2(0, 4)], [2.4, Vector2.ZERO]],
	},
	# Dark Night: slumped and slow (D-210).
	IDLE_WEARY: {
		"length": 3.2, "loop": true,
		"torso": [[0.0, 7.0], [1.6, 8.5], [3.2, 7.0]],
		"head": [[0.0, 14.0], [1.6, 16.0], [3.2, 14.0]],
		"arm_upper": [[0.0, 6.0], [1.6, 7.0], [3.2, 6.0]],
		"arm_fore": [[0.0, 4.0], [3.2, 4.0]],
		"shield": [[0.0, 10.0], [1.6, 11.0], [3.2, 10.0]],
		"cape": [[0.0, 3.0], [3.2, 3.0]],
		ROOT_MOVE: [[0.0, Vector2(0, 10)], [1.6, Vector2(0, 13)], [3.2, Vector2(0, 10)]],
	},
	WALK: {
		"length": 0.9, "loop": true,
		"thigh_front": [[0.0, -22.0], [0.45, 20.0], [0.9, -22.0]],
		"shin_front": [[0.0, 4.0], [0.25, 6.0], [0.45, 30.0], [0.65, 18.0], [0.9, 4.0]],
		"thigh_back": [[0.0, 20.0], [0.45, -22.0], [0.9, 20.0]],
		"shin_back": [[0.0, 30.0], [0.2, 18.0], [0.45, 4.0], [0.7, 6.0], [0.9, 30.0]],
		"torso": [[0.0, 3.0], [0.225, 4.0], [0.45, 3.0], [0.675, 4.0], [0.9, 3.0]],
		"arm_upper": [[0.0, 5.0], [0.45, -5.0], [0.9, 5.0]],
		"arm_fore": [[0.0, -2.0], [0.45, -4.0], [0.9, -2.0]],
		"head": [[0.0, -2.0], [0.45, -1.0], [0.9, -2.0]],
		"cape": [[0.0, 4.0], [0.45, 7.0], [0.9, 4.0]],
		ROOT_MOVE: [[0.0, Vector2(0, 6)], [0.225, Vector2.ZERO], [0.45, Vector2(0, 6)], [0.675, Vector2.ZERO], [0.9, Vector2(0, 6)]],
	},
	# Wind-up, thrust (spear level with the target) and recovery. The step
	# toward the target is the CombatantView's own lunge.
	ATTACK: {
		"length": 0.8, "loop": false,
		"torso": [[0.0, 0.0], [0.25, -7.0], [0.4, 10.0], [0.6, 10.0], [0.8, 0.0]],
		"arm_upper": [[0.0, 0.0], [0.25, 28.0], [0.4, -42.0], [0.6, -42.0], [0.8, 0.0]],
		"arm_fore": [[0.0, 0.0], [0.25, 8.0], [0.4, -18.0], [0.6, -18.0], [0.8, 0.0]],
		"head": [[0.0, 0.0], [0.25, -4.0], [0.4, 2.0], [0.8, 0.0]],
		"thigh_front": [[0.0, 0.0], [0.25, 6.0], [0.4, -24.0], [0.6, -24.0], [0.8, 0.0]],
		"shin_front": [[0.0, 0.0], [0.4, 10.0], [0.6, 10.0], [0.8, 0.0]],
		"thigh_back": [[0.0, 0.0], [0.4, 14.0], [0.6, 14.0], [0.8, 0.0]],
		"cape": [[0.0, 0.0], [0.25, -3.0], [0.4, 12.0], [0.6, 9.0], [0.8, 0.0]],
		"shield": [[0.0, 0.0], [0.4, 6.0], [0.8, 0.0]],
		ROOT_MOVE: [[0.0, Vector2.ZERO], [0.25, Vector2(-14, 0)], [0.4, Vector2(26, 8)], [0.6, Vector2(26, 8)], [0.8, Vector2.ZERO]],
	},
	# Shield up, weight back; held at the end (the view returns to idle).
	DEFEND: {
		"length": 0.5, "loop": false,
		"torso": [[0.0, 0.0], [0.18, -8.0], [0.5, -7.0]],
		"shield": [[0.0, 0.0], [0.18, -28.0], [0.5, -25.0]],
		"head": [[0.0, 0.0], [0.18, 10.0], [0.5, 9.0]],
		"arm_upper": [[0.0, 0.0], [0.18, 10.0], [0.5, 9.0]],
		"arm_fore": [[0.0, 0.0], [0.18, -6.0], [0.5, -5.0]],
		"thigh_front": [[0.0, 0.0], [0.18, -6.0], [0.5, -6.0]],
		"shin_front": [[0.0, 0.0], [0.18, 6.0], [0.5, 6.0]],
		"thigh_back": [[0.0, 0.0], [0.18, 6.0], [0.5, 6.0]],
		"shin_back": [[0.0, 0.0], [0.18, 4.0], [0.5, 4.0]],
		"cape": [[0.0, 0.0], [0.18, -4.0], [0.5, -3.0]],
		ROOT_MOVE: [[0.0, Vector2.ZERO], [0.18, Vector2(-12, 8)], [0.5, Vector2(-12, 8)]],
	},
	HIT: {
		"length": 0.45, "loop": false,
		"torso": [[0.0, 0.0], [0.08, -12.0], [0.25, -4.0], [0.45, 0.0]],
		"head": [[0.0, 0.0], [0.08, -10.0], [0.25, -3.0], [0.45, 0.0]],
		"arm_upper": [[0.0, 0.0], [0.08, 14.0], [0.45, 0.0]],
		"arm_fore": [[0.0, 0.0], [0.08, 10.0], [0.45, 0.0]],
		"cape": [[0.0, 0.0], [0.08, -6.0], [0.3, 3.0], [0.45, 0.0]],
		"shield": [[0.0, 0.0], [0.08, -6.0], [0.45, 0.0]],
		ROOT_MOVE: [[0.0, Vector2.ZERO], [0.08, Vector2(-22, 0)], [0.45, Vector2.ZERO]],
	},
	# Knees give way and the hips drop (thigh and shin lengths of a humanoid
	# rig ~ 1:2.6), the body slumps forward; held at the end.
	FALL: {
		"length": 0.9, "loop": false,
		"thigh_front": [[0.0, 0.0], [0.5, -30.0], [0.9, -48.0]],
		"shin_front": [[0.0, 0.0], [0.5, 55.0], [0.9, 88.0]],
		"thigh_back": [[0.0, 0.0], [0.5, -24.0], [0.9, -40.0]],
		"shin_back": [[0.0, 0.0], [0.5, 50.0], [0.9, 85.0]],
		"torso": [[0.0, 0.0], [0.3, -5.0], [0.9, 18.0]],
		"head": [[0.0, 0.0], [0.5, 10.0], [0.9, 22.0]],
		"arm_upper": [[0.0, 0.0], [0.5, 10.0], [0.9, 20.0]],
		"arm_fore": [[0.0, 0.0], [0.9, 10.0]],
		"shield": [[0.0, 0.0], [0.9, 25.0]],
		"cape": [[0.0, 0.0], [0.9, 8.0]],
		ROOT_MOVE: [[0.0, Vector2.ZERO], [0.5, Vector2(20, 50)], [0.9, Vector2(45, 122)]],
	},
}


static func names() -> Array[StringName]:
	var out: Array[StringName] = []
	for key: StringName in HUMANOID:
		out.append(key)
	return out


## One Godot Animation for `motion`, animating the bones under `skeleton_path`
## (paths are relative to the AnimationPlayer's root node). Bones the rig
## does not have are skipped, so a rig without a shield still plays.
static func build(motion: StringName, bone_paths: Dictionary, root_path: NodePath) -> Animation:
	var spec: Dictionary = HUMANOID[motion]
	var anim := Animation.new()
	anim.length = spec["length"]
	anim.loop_mode = Animation.LOOP_LINEAR if spec["loop"] else Animation.LOOP_NONE
	for key: Variant in spec:
		if key in ["length", "loop"]:
			continue
		var keys: Array = spec[key]
		var track: int
		if key == ROOT_MOVE:
			track = anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_path(track, NodePath(String(root_path) + ":position"))
		else:
			var bone := StringName(key)
			if not bone_paths.has(bone):
				continue
			track = anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_path(track, NodePath(String(bone_paths[bone]) + ":rotation_degrees"))
		anim.value_track_set_update_mode(track, Animation.UPDATE_CONTINUOUS)
		anim.track_set_interpolation_type(track, Animation.INTERPOLATION_CUBIC)
		for pair: Array in keys:
			anim.track_insert_key(track, float(pair[0]), pair[1])
	return anim
