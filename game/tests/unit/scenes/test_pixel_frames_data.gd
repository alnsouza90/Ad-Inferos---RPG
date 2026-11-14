extends GutTest
## T64 (ADR-0013): the PixelLab clips brought in by tools/art/import_pixel.py
## are complete and follow the pixel grid.

const DIR: String = "res://scenes/battle/combatants/pixel"
const SUFFIX: String = "_frames.tres"
const FRAME: int = 256
const PILOT: Array[String] = [
	"enemy_mud_devil", "enemy_shade_of_desire", "saint_benedict", "saint_george", "saint_therese",
]


func _ids() -> Array[String]:
	var ids: Array[String] = []
	for file: String in ResourceLoader.list_directory(DIR):
		if file.ends_with(SUFFIX):
			ids.append(file.trim_suffix(SUFFIX))
	ids.sort()
	return ids


func _frames(id: String) -> CharacterFrames:
	return load("%s/%s%s" % [DIR, id, SUFFIX]) as CharacterFrames


func test_the_pilot_characters_are_in() -> void:
	var ids: Array[String] = _ids()
	for id: String in PILOT:
		assert_has(ids, id)


func test_every_clip_is_on_the_pixel_grid() -> void:
	for id: String in _ids():
		var frames: CharacterFrames = _frames(id)
		assert_not_null(frames, id)
		if frames == null:
			continue
		assert_eq(String(frames.character_id), id)
		assert_true(frames.has_clip(&"idle"), "%s tem o parado" % id)
		assert_true(frames.clip(&"idle").looping, "%s: parado em ciclo" % id)
		assert_lte(frames.figure_height, float(FRAME), "%s: figura cabe no quadro" % id)
		for clip: FrameClip in frames.clips:
			var label: String = "%s/%s" % [id, clip.id]
			assert_eq(clip.frame_size, Vector2i(FRAME, FRAME), label)
			var sheet: Texture2D = FramePlayer.sheet(clip.sheet_path)
			assert_not_null(sheet, label)
			if sheet == null:
				continue
			assert_eq(sheet.get_width() % FRAME, 0, "%s: folha em quadros inteiros" % label)
			assert_eq(sheet.get_height() % FRAME, 0, "%s: folha em quadros inteiros" % label)
			var last: Rect2 = clip.region(clip.count - 1)
			assert_true(last.end.x <= sheet.get_width() and last.end.y <= sheet.get_height(), "%s cabe na folha" % label)
			# Feet on one point in every clip: the figure never hops.
			assert_eq(clip.anchor, frames.clip(&"idle").anchor, "%s: pés na mesma linha" % label)
			assert_eq(clip.anchor, clip.anchor.round(), "%s: pés em pixel inteiro" % label)


func test_the_halo_sits_on_each_saint() -> void:
	for id: String in ["saint_benedict", "saint_george", "saint_therese"]:
		var frames: CharacterFrames = _frames(id)
		assert_gt(frames.halo_diameter, 0.0, id)
		var c: Vector2 = frames.halo_center
		assert_true(c.x > 0.0 and c.x < FRAME and c.y > 0.0 and c.y < FRAME / 2.0, "%s: auréola no alto do quadro" % id)


func test_benedict_has_his_approved_clips() -> void:
	# D-368: idle, walk, windup, defend, fall and the final pose of the
	# strike; the blow taken uses the defence with the engine's tremor.
	var frames: CharacterFrames = _frames("saint_benedict")
	for clip_id: StringName in [&"idle", &"walk", &"windup", &"strike", &"defend", &"fall"]:
		assert_true(frames.has_clip(clip_id), String(clip_id))
	assert_false(frames.has_clip(&"hit"))
	assert_false(frames.clip(&"fall").looping, "a queda para no fim")
	assert_gte(frames.clip(&"strike").impact_frame, 0)


func test_therese_is_smaller_than_the_men() -> void:
	# D-259, D-368: the women are smaller, by the engine.
	assert_lt(_frames("saint_therese").display_scale, _frames("saint_george").display_scale)
