extends GutTest
## T35: the 2D skeleton (ADR-0007, D-176). A RigDef becomes one bone per
## part, the parts are drawn in depth order, and the shared humanoid motions
## play, hold and return to rest. In-memory rig for the rules; the real cut of
## São Jorge is checked at the end.

const GEORGE_RIG: String = "res://assets/characters/saints/saint_george/rig/saint_george_rig.tres"

var def: RigDef


func _texture() -> Texture2D:
	return ImageTexture.create_from_image(Image.create(8, 8, false, Image.FORMAT_RGBA8))


func _part(part_name: StringName, parent: StringName, pivot: Vector2, z: int) -> Dictionary:
	return {"name": part_name, "parent": parent, "pivot": pivot, "offset": pivot - Vector2(4, 4), "texture": _texture(), "z": z}


func before_each() -> void:
	def = RigDef.new()
	def.character_id = &"test_saint"
	def.root_pivot = Vector2(0, -400)
	def.head_point = Vector2(0, -1100)
	# Listed child-first on purpose: the builder must not depend on order.
	def.parts = [
		_part(&"head", &"torso", Vector2(0, -1000), 4),
		_part(&"torso", RigDef.ROOT, Vector2(0, -400), 3),
		_part(&"arm_upper", &"torso", Vector2(-40, -900), 5),
		_part(&"arm_fore", &"arm_upper", Vector2(-40, -750), 6),
		_part(&"thigh_back", RigDef.ROOT, Vector2(-20, -400), 0),
		_part(&"shin_back", &"thigh_back", Vector2(-20, -300), 1),
		_part(&"thigh_front", RigDef.ROOT, Vector2(20, -400), 2),
		_part(&"shin_front", &"thigh_front", Vector2(20, -300), 2),
	]


func _figure() -> RigFigure:
	var f := RigFigure.new()
	f.setup(def)
	add_child_autofree(f)
	return f


func test_one_bone_per_part_plus_the_root() -> void:
	var f := _figure()
	assert_eq(f.bone_count(), def.parts.size() + 1)
	for part_name: StringName in def.part_names():
		assert_not_null(f.bone(part_name), String(part_name))
		assert_not_null(f.part_sprite(part_name), String(part_name))
	assert_eq(f.bone(&"arm_fore").get_parent(), f.bone(&"arm_upper"), "o antebraço pende do braço")


func test_parts_are_drawn_back_to_front_whatever_the_bone_tree() -> void:
	var f := _figure()
	var back: int = f.part_sprite(&"thigh_back").get_index()
	var torso: int = f.part_sprite(&"torso").get_index()
	var fore: int = f.part_sprite(&"arm_fore").get_index()
	assert_lt(back, torso, "a perna de trás fica atrás do tronco")
	assert_lt(torso, fore, "o antebraço fica na frente do tronco")


func test_every_motion_exists_and_the_idle_and_walk_loop() -> void:
	var f := _figure()
	for motion: StringName in RigMotions.names():
		assert_gt(f.motion_length(motion), 0.0, String(motion))
	var player: AnimationPlayer = f.animation_player()
	assert_eq(player.get_animation(RigMotions.IDLE).loop_mode, Animation.LOOP_LINEAR)
	assert_eq(player.get_animation(RigMotions.WALK).loop_mode, Animation.LOOP_LINEAR)
	assert_eq(player.get_animation(RigMotions.ATTACK).loop_mode, Animation.LOOP_NONE)


func test_a_rig_without_shield_or_cape_still_plays_every_motion() -> void:
	# The test rig has no shield and no cape: those tracks are skipped.
	var f := _figure()
	var anim: Animation = f.animation_player().get_animation(RigMotions.ATTACK)
	for i: int in anim.get_track_count():
		var path := String(anim.track_get_path(i))
		assert_false(path.contains("shield") or path.contains("cape"), path)


func test_play_returns_the_duration_at_the_given_speed() -> void:
	var f := _figure()
	var length: float = f.motion_length(RigMotions.ATTACK)
	assert_almost_eq(f.play(RigMotions.ATTACK, 1.0), length, 0.001)
	assert_almost_eq(f.play(RigMotions.ATTACK, 2.0), length / 2.0, 0.001)
	assert_eq(f.current, RigMotions.ATTACK)


func test_instant_speed_jumps_to_the_held_end_of_the_fall() -> void:
	var f := _figure()
	assert_eq(f.play(RigMotions.FALL, 0.0), 0.0)
	assert_gt(f.get_node("Mover").position.y, 50.0, "caído: o quadril desceu")
	assert_ne(f.bone(&"shin_front").rotation, 0.0, "joelhos dobrados")


func test_rest_puts_every_bone_back() -> void:
	var f := _figure()
	f.play(RigMotions.FALL, 0.0)
	f.rest()
	for part_name: StringName in def.part_names():
		assert_eq(f.bone(part_name).rotation, 0.0, String(part_name))
	assert_eq(f.get_node("Mover").position, Vector2.ZERO)
	assert_eq(f.current, &"")


func test_the_halo_point_follows_the_head() -> void:
	var f := _figure()
	var at_rest: Vector2 = f.head_position()
	assert_almost_eq(at_rest.x, def.head_point.x, 0.01)
	assert_almost_eq(at_rest.y, def.head_point.y, 0.01)
	f.bone(&"torso").rotation_degrees = 20.0
	assert_gt(f.head_position().x, at_rest.x + 50.0, "tronco inclinado para a frente leva a cabeça junto")


func test_combatant_view_uses_the_skeleton_when_the_art_has_one() -> void:
	var settings := HaloSettings.new()
	settings.disk = _texture()
	settings.rays = _texture()
	var art := CombatantArt.new()
	art.body_normal = _texture()
	art.body_fall = _texture()
	art.rig = def
	var saint := Combatant.from_saint(CombatFixture.saint(&"saint_a"))
	var view := CombatantView.new()
	view.speed = 1.0
	view.setup(saint.id, true, 220.0, art, settings)
	add_child_autofree(view)
	view.show_state(saint, "Santo", "1", "", "30/30", "0", "", "")
	assert_not_null(view.rig())
	assert_eq(view.rig().current, RigMotions.IDLE)
	assert_almost_eq(view.play_action(), view.rig().motion_length(RigMotions.ATTACK), 0.001)
	assert_eq(view.rig().current, RigMotions.ATTACK)
	assert_eq(view.pose(), &"", "com esqueleto, as imagens de pose não são usadas")
	view.play_fall()
	assert_eq(view.rig().current, RigMotions.FALL)
	saint.state = Combatant.State.STANDING
	view.show_state(saint, "Santo", "1", "", "10/30", "0", "", "")
	assert_eq(view.rig().current, RigMotions.IDLE, "levantado, volta a ficar de pé")


func test_the_real_cut_of_george_loads_whole() -> void:
	var real: RigDef = load(GEORGE_RIG)
	assert_not_null(real)
	assert_eq(real.parts.size(), 11)
	var names: Array[StringName] = real.part_names()
	for entry: Dictionary in real.parts:
		assert_not_null(entry["texture"], String(entry["name"]))
		var parent: StringName = entry["parent"]
		assert_true(parent == RigDef.ROOT or names.has(parent), "pai conhecido: %s" % entry["name"])
	var f := RigFigure.new()
	f.setup(real)
	add_child_autofree(f)
	assert_eq(f.bone_count(), 12)
	assert_lt(real.head_point.y, -1000.0, "a cabeça fica no alto da figura de 1200 px")
