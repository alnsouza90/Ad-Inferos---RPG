extends GutTest
## T35: timing of one frame clip (which frame shows at which time).


func _clip(count: int, fps: float, looping: bool) -> FrameClip:
	var c := FrameClip.new()
	c.count = count
	c.fps = fps
	c.looping = looping
	c.columns = 4
	c.frame_size = Vector2i(10, 20)
	return c


func test_a_loop_wraps_around() -> void:
	var c: FrameClip = _clip(5, 10.0, true)
	assert_eq(c.frame_at(0.0), 0)
	assert_eq(c.frame_at(0.15), 1)
	assert_eq(c.frame_at(0.49), 4)
	assert_eq(c.frame_at(0.5), 0, "volta ao primeiro quadro")
	assert_almost_eq(c.duration(), 0.5, 0.0001)


func test_a_clip_that_does_not_loop_stops_on_its_last_frame() -> void:
	var c: FrameClip = _clip(5, 10.0, false)
	assert_eq(c.frame_at(0.45), 4)
	assert_eq(c.frame_at(3.0), 4)
	assert_eq(c.frame_at(-1.0), 0)


func test_a_single_pose_holds_for_its_pose_time() -> void:
	var c: FrameClip = _clip(1, 0.0, false)
	assert_eq(c.frame_at(2.0), 0)
	assert_eq(c.duration(), c.pose_time)
	assert_eq(c.impact_time(), 0.0)


func test_regions_walk_the_grid_row_by_row() -> void:
	var c: FrameClip = _clip(6, 10.0, true)
	assert_eq(c.region(0), Rect2(0, 0, 10, 20))
	assert_eq(c.region(3), Rect2(30, 0, 10, 20))
	assert_eq(c.region(4), Rect2(0, 20, 10, 20), "segunda linha")
	assert_eq(c.region(99), c.region(5), "quadro fora do clipe fica no último")


func test_impact_time_comes_from_the_impact_frame() -> void:
	var c: FrameClip = _clip(12, 15.0, false)
	c.impact_frame = 3
	assert_almost_eq(c.impact_time(), 0.2, 0.0001)
