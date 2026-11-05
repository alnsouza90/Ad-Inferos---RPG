class_name RigFigure
extends Node2D
## A character drawn on the 2D skeleton (T35, ADR-0007, D-176): one Bone2D per
## part of its RigDef, the part textures drawn flat in depth order and each
## glued to its bone by a RemoteTransform2D (the draw order never depends on
## the bone tree), and an AnimationPlayer with the shared humanoid motions
## (RigMotions). The node's origin is the centre of the feet.
##
## Presentation only: it plays what the screen asks and never decides a rule.

signal motion_finished(motion: StringName)

var def: RigDef
var current: StringName = &""

var _mover: Node2D
var _skeleton: Skeleton2D
var _parts: Node2D
var _player: AnimationPlayer
var _bones: Dictionary = {}
var _sprites: Dictionary = {}


func setup(p_def: RigDef) -> void:
	def = p_def
	_mover = Node2D.new()
	_mover.name = "Mover"
	add_child(_mover)
	_skeleton = Skeleton2D.new()
	_skeleton.name = "Skeleton2D"
	_mover.add_child(_skeleton)
	_parts = Node2D.new()
	_parts.name = "Parts"
	_mover.add_child(_parts)
	_build_bones()
	_build_parts()
	_build_player()


## The material every part is drawn with (the saturation shader of the view).
func set_parts_material(material: Material) -> void:
	_parts.material = material


func play(motion: StringName, speed: float = 1.0) -> float:
	if not _player.has_animation(_anim_name(motion)):
		return 0.0
	current = motion
	_player.speed_scale = speed if speed > 0.0 else 1.0
	_player.play(_anim_name(motion))
	if speed <= 0.0:
		# Instant: jump to the last frame (a held pose such as the fall).
		_player.seek(_player.current_animation_length, true)
		return 0.0
	return motion_length(motion) / speed


func motion_length(motion: StringName) -> float:
	var anim: Animation = _player.get_animation(_anim_name(motion)) if _player.has_animation(_anim_name(motion)) else null
	return anim.length if anim != null else 0.0


## Puts every bone back in its rest pose and stops the animation.
func rest() -> void:
	_player.stop()
	current = &""
	for bone_name: StringName in _bones:
		(_bones[bone_name] as Bone2D).rotation = 0.0
	_mover.position = Vector2.ZERO


func bone(bone_name: StringName) -> Bone2D:
	return _bones.get(bone_name)


func part_sprite(part_name: StringName) -> Sprite2D:
	return _sprites.get(part_name)


func bone_count() -> int:
	return _bones.size()


## The halo point in this node's coordinates: it follows the head bone.
func head_position() -> Vector2:
	var head: Bone2D = _bones.get(&"head")
	if head == null:
		return def.head_point
	var local: Vector2 = def.head_point - (def.part(&"head")["pivot"] as Vector2)
	return _mover.position + _skeleton_transform_of(head) * local


func animation_player() -> AnimationPlayer:
	return _player


# --- building ---------------------------------------------------------------------

func _build_bones() -> void:
	var root := _new_bone(RigDef.ROOT, def.root_pivot)
	_skeleton.add_child(root)
	_bones[RigDef.ROOT] = root
	# Parents may be listed after their children: add in passes.
	var pending: Array[Dictionary] = def.parts.duplicate()
	while not pending.is_empty():
		var progressed: bool = false
		for entry: Dictionary in pending.duplicate():
			var parent_name: StringName = entry["parent"]
			if not _bones.has(parent_name):
				continue
			var parent_pivot: Vector2 = def.root_pivot if parent_name == RigDef.ROOT else def.part(parent_name)["pivot"]
			var bone_node := _new_bone(entry["name"], (entry["pivot"] as Vector2) - parent_pivot)
			(_bones[parent_name] as Bone2D).add_child(bone_node)
			_bones[entry["name"]] = bone_node
			pending.erase(entry)
			progressed = true
		if not progressed:
			push_error("RigFigure: part with an unknown parent in %s" % def.character_id)
			return


func _new_bone(bone_name: StringName, pos: Vector2) -> Bone2D:
	var b := Bone2D.new()
	b.name = String(bone_name)
	b.position = pos
	b.set_autocalculate_length_and_angle(false)
	b.set_length(16.0)
	b.rest = Transform2D(0.0, pos)
	return b


func _build_parts() -> void:
	for entry: Dictionary in def.parts_by_depth():
		var sprite := Sprite2D.new()
		sprite.name = String(entry["name"])
		sprite.texture = entry["texture"]
		sprite.centered = false
		sprite.offset = (entry["offset"] as Vector2) - (entry["pivot"] as Vector2)
		sprite.use_parent_material = true
		sprite.position = entry["pivot"]
		_parts.add_child(sprite)
		_sprites[entry["name"]] = sprite
		var glue := RemoteTransform2D.new()
		glue.name = "Glue"
		(_bones[entry["name"]] as Bone2D).add_child(glue)
		glue.remote_path = glue.get_path_to(sprite)


func _build_player() -> void:
	_player = AnimationPlayer.new()
	_player.name = "AnimationPlayer"
	add_child(_player)
	var bone_paths: Dictionary = {}
	for bone_name: StringName in _bones:
		bone_paths[bone_name] = get_path_to(_bones[bone_name])
	var library := AnimationLibrary.new()
	for motion: StringName in RigMotions.names():
		library.add_animation(motion, RigMotions.build(motion, bone_paths, get_path_to(_mover)))
	_player.add_animation_library(&"", library)
	_player.animation_finished.connect(func(anim_name: StringName) -> void: motion_finished.emit(anim_name))


func _anim_name(motion: StringName) -> StringName:
	return motion


## Transform of a bone relative to the skeleton (works outside the tree, so
## the tests can ask it without a frame).
func _skeleton_transform_of(b: Node2D) -> Transform2D:
	var t := Transform2D.IDENTITY
	var node: Node = b
	while node != null and node != _skeleton:
		t = (node as Node2D).transform * t
		node = node.get_parent()
	return t
