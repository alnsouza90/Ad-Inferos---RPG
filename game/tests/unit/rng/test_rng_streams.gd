extends GutTest
## T01: named streams derived from the campaign seed.

const SEED: int = 4242


func test_has_all_named_streams() -> void:
	var streams := RngStreams.new(SEED)
	for stream_name: StringName in [&"battle", &"map", &"rewards", &"events", &"faith"]:
		assert_not_null(streams.get_stream(stream_name))
		assert_eq(streams.get_stream(stream_name).stream, stream_name)


func test_drawing_from_one_stream_does_not_affect_another() -> void:
	var a := RngStreams.new(SEED)
	var b := RngStreams.new(SEED)
	for i: int in 25:
		a.battle().next_u32()
	assert_eq(a.faith().next_u32(), b.faith().next_u32())
	assert_eq(b.battle().counter, 0)


func test_save_and_restore_all_counters() -> void:
	var original := RngStreams.new(SEED)
	for i: int in 3:
		original.map().next_u32()
	for i: int in 7:
		original.faith().next_float()
	var data: Dictionary = JSON.parse_string(JSON.stringify(original.to_dict())) as Dictionary
	var restored := RngStreams.from_dict(data)
	assert_eq(restored.get_counters(), {"battle": 0, "map": 3, "rewards": 0, "events": 0, "faith": 7})
	for stream_name: StringName in RngStreams.NAMES:
		assert_eq(restored.get_stream(stream_name).next_u32(), original.get_stream(stream_name).next_u32(), String(stream_name))


func test_same_seed_same_results_across_instances() -> void:
	var a := RngStreams.new(SEED)
	var b := RngStreams.new(SEED)
	for stream_name: StringName in RngStreams.NAMES:
		assert_eq(a.get_stream(stream_name).next_u32(), b.get_stream(stream_name).next_u32())
