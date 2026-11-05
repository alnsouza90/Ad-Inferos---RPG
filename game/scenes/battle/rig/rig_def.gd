class_name RigDef
extends Resource
## The parts of one character cut for the 2D skeleton (T35, ADR-0007,
## D-176). Written by tools/art/rig_cut.py from the character's neutral pose;
## presentation only.
##
## Positions are in figure pixels with the origin at the centre of the feet
## (y grows downward). Each entry of `parts`:
##   name: StringName     the bone and the part (e.g. &"arm_fore")
##   parent: StringName   parent bone, or &"root"
##   pivot: Vector2       the joint the part turns around
##   offset: Vector2      top-left corner of the texture
##   texture: Texture2D
##   z: int              draw order, back to front

const ROOT: StringName = &"root"

@export var character_id: StringName
## The hips: the root bone the legs and the torso hang from.
@export var root_pivot: Vector2
## Where the halo sits at rest (it follows the head bone).
@export var head_point: Vector2
@export var parts: Array[Dictionary] = []


func part(part_name: StringName) -> Dictionary:
	for entry: Dictionary in parts:
		if entry["name"] == part_name:
			return entry
	return {}


func part_names() -> Array[StringName]:
	var names: Array[StringName] = []
	for entry: Dictionary in parts:
		names.append(entry["name"])
	return names


## Parts in draw order, back to front.
func parts_by_depth() -> Array[Dictionary]:
	var sorted: Array[Dictionary] = parts.duplicate()
	sorted.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["z"]) < int(b["z"]))
	return sorted
