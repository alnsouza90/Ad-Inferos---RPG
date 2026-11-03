extends GutTest
## T01: seeded random streams (architecture §4, backlog m0 T01).

const SEED: int = 123456789
const DRAWS: int = 200


func _draw_many(rng: RngStream, count: int) -> Array[int]:
	var values: Array[int] = []
	for i: int in count:
		values.append(rng.next_u32())
	return values


func test_same_seed_same_sequence() -> void:
	var a := RngStream.new(SEED, &"battle")
	var b := RngStream.new(SEED, &"battle")
	assert_eq(_draw_many(a, DRAWS), _draw_many(b, DRAWS))


func test_different_seed_different_sequence() -> void:
	var a := RngStream.new(SEED, &"battle")
	var b := RngStream.new(SEED + 1, &"battle")
	assert_ne(_draw_many(a, 20), _draw_many(b, 20))


func test_different_stream_names_are_independent() -> void:
	var a := RngStream.new(SEED, &"battle")
	var b := RngStream.new(SEED, &"faith")
	assert_ne(_draw_many(a, 20), _draw_many(b, 20))


func test_counter_counts_every_draw() -> void:
	var rng := RngStream.new(SEED, &"map")
	rng.next_u32()
	rng.next_float()
	rng.next_int_range(1, 6)
	rng.chance(0.5)
	rng.pick_index(3)
	assert_eq(rng.counter, 5)


func test_state_round_trip_restores_sequence() -> void:
	var original := RngStream.new(SEED, &"rewards")
	_draw_many(original, 37)
	var saved: Dictionary = original.to_dict()
	var json_text: String = JSON.stringify(saved)
	var restored := RngStream.from_dict(JSON.parse_string(json_text) as Dictionary)
	assert_eq(restored.counter, 37)
	assert_eq(_draw_many(restored, DRAWS), _draw_many(original, DRAWS))


func test_restore_matches_fresh_stream_after_skipping() -> void:
	var fresh := RngStream.new(SEED, &"events")
	var skipped: Array[int] = _draw_many(fresh, 50)
	var resumed := RngStream.new(SEED, &"events", 10)
	assert_eq(_draw_many(resumed, 40), skipped.slice(10, 50))


func test_large_and_negative_seeds_are_deterministic() -> void:
	for s: int in [0, -1, 9223372036854775807, -9223372036854775808]:
		var a := RngStream.new(s, &"battle")
		var b := RngStream.new(s, &"battle")
		assert_eq(_draw_many(a, 10), _draw_many(b, 10), "seed %d" % s)


func test_values_stay_in_range() -> void:
	var rng := RngStream.new(SEED, &"battle")
	for i: int in 2000:
		var u: int = rng.next_u32()
		assert_true(u >= 0 and u <= RngStream.MASK_32)
		var f: float = rng.next_float()
		assert_true(f >= 0.0 and f < 1.0)
		var r: int = rng.next_int_range(-2, 3)
		assert_true(r >= -2 and r <= 3)


func test_int_range_covers_all_values() -> void:
	var rng := RngStream.new(SEED, &"map")
	var seen: Dictionary = {}
	for i: int in 600:
		seen[rng.next_int_range(1, 6)] = true
	assert_eq(seen.size(), 6)


func test_float_mean_is_roughly_half() -> void:
	var rng := RngStream.new(SEED, &"faith")
	var total: float = 0.0
	var n: int = 5000
	for i: int in n:
		total += rng.next_float()
	assert_almost_eq(total / n, 0.5, 0.02)


func test_mul32_matches_known_values() -> void:
	assert_eq(RngStream.mul32(0xFFFFFFFF, 0xFFFFFFFF), 1)
	assert_eq(RngStream.mul32(0x10000, 0x10000), 0)
	assert_eq(RngStream.mul32(123456, 654321), (123456 * 654321) & RngStream.MASK_32)


func test_fnv1a32_known_vector() -> void:
	# Published FNV-1a 32-bit test vector for "a".
	assert_eq(RngStream.fnv1a32("a"), 0xE40C292C)
