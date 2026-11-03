extends GutTest
## T04: Fervor (combat §5).


func _pool() -> FervorPool:
	return FervorPool.new(CombatFixture.constants())


func test_first_round_gives_base_gain_from_zero() -> void:
	var f := _pool()
	assert_eq(f.amount, 0)
	assert_eq(f.start_round(), CombatFixture.FERVOR_PER_ROUND)
	assert_eq(f.amount, CombatFixture.FERVOR_PER_ROUND)


func test_leftover_accumulates_up_to_cap() -> void:
	var f := _pool()
	f.start_round()
	f.start_round()
	assert_eq(f.amount, CombatFixture.FERVOR_CAP)


func test_C03_fervor_6_stays_6_at_round_start() -> void:
	var f := _pool()
	f.amount = CombatFixture.FERVOR_CAP
	assert_eq(f.start_round(), 0)
	assert_eq(f.amount, CombatFixture.FERVOR_CAP)


func test_C04_three_extra_fervor_in_a_round_only_two_enter() -> void:
	var f := _pool()
	f.start_round()
	assert_eq(f.gain_bonus(1), 1)
	assert_eq(f.gain_bonus(1), 1)
	assert_eq(f.gain_bonus(1), 0, "o terceiro extra se perde")
	assert_eq(f.amount, CombatFixture.FERVOR_PER_ROUND + CombatFixture.FERVOR_BONUS_CAP)


func test_single_gain_of_three_extra_only_two_enter() -> void:
	var f := _pool()
	f.start_round()
	assert_eq(f.gain_bonus(3), 2)


func test_extra_limit_resets_each_round() -> void:
	var f := _pool()
	f.start_round()
	f.gain_bonus(2)
	f.spend(f.amount)
	f.start_round()
	assert_eq(f.gain_bonus(2), 2)


func test_base_gain_does_not_count_against_extra_limit() -> void:
	var f := _pool()
	f.start_round()
	assert_eq(f.bonus_gained_this_round, 0)


func test_extra_clipped_by_cap_only_counts_what_entered() -> void:
	var f := _pool()
	f.amount = CombatFixture.FERVOR_CAP - 1
	assert_eq(f.gain_bonus(2), 1, "só cabe 1 até o teto")
	assert_eq(f.bonus_gained_this_round, 1)
	f.spend(1)
	assert_eq(f.gain_bonus(2), 1, "ainda resta 1 do limite extra")


func test_spend_and_can_afford() -> void:
	var f := _pool()
	f.start_round()
	assert_true(f.can_afford(3))
	assert_false(f.can_afford(4))
	assert_false(f.spend(4))
	assert_eq(f.amount, 3)
	assert_true(f.spend(2))
	assert_eq(f.amount, 1)


func test_reset_between_battles() -> void:
	var f := _pool()
	f.start_round()
	f.gain_bonus(1)
	f.reset()
	assert_eq(f.amount, 0)
	assert_eq(f.bonus_gained_this_round, 0)
