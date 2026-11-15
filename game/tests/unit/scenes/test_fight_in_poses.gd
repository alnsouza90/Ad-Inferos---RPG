extends GutTest
## T60 (D-359, D-360, D-368): the fight in poses. In the battle every
## action shows its last, safe frame, held; the idle steps slowly through a
## few of its frames; the blow taken shows the guard. The walk keeps whole
## clips. In-memory frames only.


func _clip(id: StringName, count: int, fps: float, looping: bool, impact: int = -1) -> FrameClip:
	var c := FrameClip.new()
	c.id = id
	c.sheet_path = "res://none.png"
	c.frame_size = Vector2i(8, 8)
	c.columns = count
	c.count = count
	c.fps = fps
	c.looping = looping
	c.impact_frame = impact
	c.pose_time = 0.4
	return c


func _frames() -> CharacterFrames:
	var f := CharacterFrames.new()
	f.figure_height = 8.0
	f.clips = [
		_clip(&"idle", 9, 8.0, true),
		_clip(&"walk", 8, 8.0, true),
		_clip(&"windup", 5, 8.0, false),
		_clip(&"strike", 5, 8.0, false, 2),
		_clip(&"defend", 5, 8.0, false),
		_clip(&"fall", 5, 8.0, false),
	] as Array[FrameClip]
	return f


func _player(pose: bool) -> FramePlayer:
	var p := FramePlayer.new()
	p.setup(_frames(), Vector2.ZERO, 8.0)
	p.pose_mode = pose
	add_child_autofree(p)
	return p


func test_an_action_is_its_last_frame_held() -> void:
	var p: FramePlayer = _player(true)
	for id: StringName in [&"windup", &"strike", &"defend", &"fall"]:
		var seconds: float = p.play(id)
		assert_eq(p.frame(), 4, "%s: a pose final, desde o primeiro instante" % id)
		assert_almost_eq(seconds, 0.4, 0.0001, "%s: segura pelo tempo da pose" % id)
		p.advance(0.3)
		assert_eq(p.frame(), 4, "%s: continua na pose" % id)


func test_the_blow_of_a_pose_lands_at_once() -> void:
	var p: FramePlayer = _player(true)
	var strike: FrameClip = p.frames.clip(&"strike")
	assert_eq(p.impact_of(strike), 0.0)
	assert_eq(p.duration_of(strike), strike.pose_time)


func test_the_fight_idle_steps_slowly_through_three_frames() -> void:
	var p: FramePlayer = _player(true)
	p.play(&"idle")
	var seen: Array[int] = []
	for i: int in 12:
		if not seen.has(p.frame()):
			seen.append(p.frame())
		p.advance(1.0 / FramePlayer.POSE_IDLE_FPS)
	assert_eq(seen.size(), FramePlayer.POSE_IDLE_FRAMES, "só alguns quadros do parado (D-360)")
	assert_eq(seen, [0, 3, 6] as Array[int])


func test_the_walk_keeps_the_whole_clip() -> void:
	var p: FramePlayer = _player(false)
	p.play(&"walk")
	var seen: Array[int] = []
	for i: int in 8:
		seen.append(p.frame())
		p.advance(1.0 / 8.0)
	assert_eq(seen, [0, 1, 2, 3, 4, 5, 6, 7] as Array[int], "caminhada fluida (D-359)")
	p.play(&"strike")
	assert_eq(p.frame(), 0, "fora da luta o clipe começa do primeiro quadro")
	assert_eq(p.impact_of(p.frames.clip(&"strike")), 2.0 / 8.0)


func test_the_blow_taken_shows_the_guard() -> void:
	var view := CombatantView.new()
	view.setup(&"saint_a", true, 110.0, null, null, _frames())
	add_child_autofree(view)
	view.player().pose_mode = true
	view.speed = 1.0
	watch_signals(view.player())
	view.play_hit()
	assert_eq(view.player().clip_id(), &"defend", "sem pose própria: a guarda (D-368)")
	assert_eq(view.player().frame(), 4)
