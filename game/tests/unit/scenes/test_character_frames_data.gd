extends GutTest
## T35: the frame sheets made by tools/art/process_frames.py are complete
## and consistent for every animated character.

const SAINT_CLIPS: Array[StringName] = [&"idle", &"walk", &"windup", &"strike", &"defend", &"hit", &"fall"]
const ENEMY_CLIPS: Array[StringName] = [&"idle", &"windup", &"strike", &"defend", &"fall"]


func test_the_six_characters_of_the_pilot_are_animated() -> void:
	var ids: Array[StringName] = AnimationTestScreen.list_characters()
	assert_eq(ids, [&"saint_benedict", &"saint_george", &"saint_therese", &"boss_asmodeus", &"elite_minos", &"elite_sin_vertigo"] as Array[StringName])


func test_every_character_has_its_clips() -> void:
	for id: StringName in AnimationTestScreen.list_characters():
		var frames: CharacterFrames = AnimationTestScreen.frames_of(id)
		assert_not_null(frames, String(id))
		assert_eq(frames.character_id, id)
		assert_gt(frames.figure_height, 100.0, String(id))
		var wanted: Array[StringName] = SAINT_CLIPS if AnimationTestScreen.is_saint_id(id) else ENEMY_CLIPS
		for clip_id: StringName in wanted:
			assert_true(frames.has_clip(clip_id), "%s tem %s" % [id, clip_id])
		assert_true(frames.clip(&"idle").looping, "%s: parado em ciclo" % id)
		assert_false(frames.clip(&"fall").looping, "%s: a queda para no fim" % id)
		assert_gte(frames.clip(&"strike").impact_frame, 0, "%s: golpe tem o momento do impacto" % id)


func test_every_sheet_holds_its_frames() -> void:
	for id: StringName in AnimationTestScreen.list_characters():
		for clip: FrameClip in AnimationTestScreen.frames_of(id).clips:
			var label: String = "%s/%s" % [id, clip.id]
			var sheet: Texture2D = FramePlayer.sheet(clip.sheet_path)
			assert_not_null(sheet, label)
			if sheet == null:
				continue
			var last: Rect2 = clip.region(clip.count - 1)
			assert_true(last.end.x <= sheet.get_width() and last.end.y <= sheet.get_height(), "%s cabe na folha" % label)
			assert_true(clip.columns * clip.frame_size.x <= sheet.get_width(), label)
			assert_lte(maxi(sheet.get_width(), sheet.get_height()), 4096, "%s: folha cabe no celular" % label)
			assert_true(clip.impact_frame < clip.count, label)
			# The feet are inside the frame: the figure stands on them.
			assert_true(clip.anchor.x > 0.0 and clip.anchor.x < clip.frame_size.x, "%s: pés dentro do quadro" % label)
			assert_true(clip.anchor.y > clip.frame_size.y * 0.5 and clip.anchor.y <= clip.frame_size.y, "%s: pés embaixo" % label)


func test_only_minos_attacks_where_he_sits() -> void:
	# Minos never rises from the throne (D-219); Asmodeus lunges with his own
	# frame (D-236).
	for id: StringName in AnimationTestScreen.list_characters():
		var expected: StringName = &"throne" if id == &"elite_minos" else &"melee"
		assert_eq(AnimationTestScreen.frames_of(id).attack_style, expected, String(id))
	assert_true(AnimationTestScreen.frames_of(&"boss_asmodeus").has_clip(&"melee_strike"))


func test_spell_styles_follow_alan() -> void:
	# D-236: Vertigo's spell is a dark outline on the target; Asmodeus' is
	# his own smoke.
	assert_eq(AnimationTestScreen.frames_of(&"elite_sin_vertigo").spell_style, &"outline")
	assert_eq(AnimationTestScreen.frames_of(&"boss_asmodeus").spell_style, &"own")


func test_the_boss_is_bigger_than_the_saints() -> void:
	assert_gt(AnimationTestScreen.frames_of(&"boss_asmodeus").display_scale, 1.0)
	assert_eq(AnimationTestScreen.frames_of(&"saint_george").display_scale, 1.0)


func test_george_stands_sideways_and_only_breathes() -> void:
	var idle: FrameClip = AnimationTestScreen.frames_of(&"saint_george").clip(&"idle")
	assert_eq(idle.count, 1, "um quadro lateral; o motor faz a respiração (D-233)")


func test_asmodeus_moves_faster_than_the_video() -> void:
	# Alan found him slow and stiff (D-235): his clips play 1.35× faster.
	var frames: CharacterFrames = AnimationTestScreen.frames_of(&"boss_asmodeus")
	assert_gt(frames.clip(&"strike").fps, 15.0 * 1.3)
	assert_gt(frames.clip(&"idle").fps, 10.0 * 1.3)
