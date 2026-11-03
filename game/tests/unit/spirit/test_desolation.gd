extends GutTest
## T08: desolation and spiritual states (desolation.md). D10 is in
## tests/unit/combat/test_commands.gd (Dark Night rejects the miracle).

var c: BattleController
var s: BattleState


func before_each() -> void:
	c = BattleController.new(CombatFixture.battle())
	s = c.state
	c.start()


## First seed whose first Faith-stream draw falls in [low, high). Searching
## keeps the tests honest about the real generator instead of faking the roll.
func _seed_with_first_faith_roll(low: float, high: float) -> int:
	for seed: int in 100000:
		var roll: float = RngStream.new(seed, RngStreams.FAITH).next_float()
		if roll >= low and roll < high:
			return seed
	fail_test("nenhuma semente encontrada")
	return 0


func _use_seed(seed: int) -> void:
	s.rng = RngStreams.new(seed)


func _events(type: StringName) -> Array[BattleEvent]:
	return c.history.filter(func(e: BattleEvent) -> bool: return e.type == type)


func test_D01_90_plus_12_with_light_80_gains_10_and_triggers_faith_check() -> void:
	var a: Combatant = s.party_at(1)
	a.desolation = 90
	s.light = 80
	s.add_desolation(a, 12, &"battle_end")
	var change: BattleEvent = _events(&"desolation_changed")[0]
	assert_eq(int(change.data["new"]) - int(change.data["old"]), 10, "12 × 0,8 = 9,6 → 10")
	assert_eq(_events(&"faith_check").size(), 1)


func test_D02_faith_5_and_roll_0_29_succeeds_into_consolation_at_50() -> void:
	var a: Combatant = s.party_at(1)
	a.faith = 5
	a.desolation = 95
	_use_seed(_seed_with_first_faith_roll(0.29, 0.295))
	s.add_desolation(a, 10)
	var check: BattleEvent = _events(&"faith_check")[0]
	assert_almost_eq(float(check.data["chance"]), 0.30, 0.0001)
	assert_true(check.data["success"])
	assert_eq(a.desolation, 50)
	assert_eq(a.spirit_state, &"consolation")


func test_D03_faith_5_and_roll_0_31_fails_into_dark_night() -> void:
	var a: Combatant = s.party_at(1)
	a.faith = 5
	a.desolation = 95
	_use_seed(_seed_with_first_faith_roll(0.31, 0.315))
	s.add_desolation(a, 10)
	assert_false(_events(&"faith_check")[0].data["success"])
	assert_eq(a.spirit_state, &"dark_night")
	assert_eq(a.desolation, 105, "na Noite Escura o valor fica")


func test_D04_faith_chance_is_capped_at_60_percent() -> void:
	var a: Combatant = s.party_at(1)
	a.faith = 15
	assert_almost_eq(Desolation.faith_chance(a, s.desolation_context()), 0.6, 0.0001)


func test_D05_dark_night_dropping_from_60_to_45_is_purification() -> void:
	var a: Combatant = s.party_at(1)
	a.spirit_state = &"dark_night"
	a.desolation = 60
	s.add_desolation(a, -15)
	assert_eq(a.spirit_state, &"normal")
	assert_true(a.purified)
	assert_eq(_events(&"purification").size(), 1)


func test_D06_consolation_halves_a_gain_of_20() -> void:
	var a: Combatant = s.party_at(1)
	a.spirit_state = &"consolation"
	a.desolation = 50
	s.add_desolation(a, 20)
	assert_eq(a.desolation, 60)


func test_D07_195_plus_10_in_battle_is_prostration() -> void:
	var a: Combatant = s.party_at(1)
	a.desolation = 195
	s.add_desolation(a, 10)
	assert_eq(a.desolation, 150)
	assert_eq(a.pending_injury, &"major")
	assert_true(a.is_fallen())
	assert_false(a.revivable)
	assert_eq(s.party_at(2).desolation, 0, "aliados sem desolação de aliado caído")
	assert_eq(s.party_at(3).desolation, 0)


func test_D08_reduction_of_40_with_light_10_reduces_40() -> void:
	var a: Combatant = s.party_at(1)
	a.desolation = 80
	s.light = 10
	s.add_desolation(a, -40)
	assert_eq(a.desolation, 40)


func test_D09_30_minus_40_stays_at_0() -> void:
	var a: Combatant = s.party_at(1)
	a.desolation = 30
	s.add_desolation(a, -40)
	assert_eq(a.desolation, 0)


# --- other rules of desolation.md -----------------------------------------------------

func test_low_light_raises_gains() -> void:
	var a: Combatant = s.party_at(1)
	s.light = 20
	s.add_desolation(a, 10)
	assert_eq(a.desolation, 13)


func test_neutral_light_and_arena_have_no_multiplier() -> void:
	var a: Combatant = s.party_at(1)
	s.light = 50
	s.add_desolation(a, 10)
	assert_eq(a.desolation, 10)
	s.light = -1
	s.add_desolation(a, 10)
	assert_eq(a.desolation, 20)


func test_consolation_reaching_100_again_is_lost_and_retested() -> void:
	var a: Combatant = s.party_at(1)
	a.faith = 0
	a.spirit_state = &"consolation"
	a.desolation = 90
	_use_seed(_seed_with_first_faith_roll(0.5, 0.6))
	s.add_desolation(a, 40)
	assert_eq(_events(&"faith_check").size(), 1)
	assert_eq(a.spirit_state, &"dark_night", "chance 10%: falha")


func test_dark_night_does_not_test_again_at_100() -> void:
	var a: Combatant = s.party_at(1)
	a.spirit_state = &"dark_night"
	a.desolation = 95
	s.add_desolation(a, 10)
	assert_eq(_events(&"faith_check").size(), 0)


func test_prostration_keeps_dark_night_and_loses_consolation() -> void:
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	a.spirit_state = &"dark_night"
	b.spirit_state = &"consolation"
	a.desolation = 199
	b.desolation = 199
	s.add_desolation(a, 5)
	s.add_desolation(b, 50)
	assert_eq(a.spirit_state, &"dark_night")
	assert_eq(b.spirit_state, &"normal")


func test_consolation_increases_damage_and_healing_dealt() -> void:
	var a: Combatant = s.party_at(1)
	a.spirit_state = &"consolation"
	var enemy: Combatant = s.enemy_at(1)
	c.resolve_effects(a, &"hit", [CombatFixture.effect(&"damage", 10, &"untyped")] as Array[EffectDef], [enemy] as Array[Combatant])
	assert_eq(enemy.max_hp - enemy.hp, 12, "10 × 1,15 = 11,5 → 12")
	var b: Combatant = s.party_at(2)
	s.lose_hp(b, 20)
	c.resolve_effects(a, &"heal", [CombatFixture.effect(&"heal", 10)] as Array[EffectDef], [b] as Array[Combatant])
	assert_eq(b.hp, b.max_hp - 20 + 12)


func test_corruption_and_ally_fallen_go_through_the_same_rules() -> void:
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	a.spirit_state = &"consolation"
	s.lose_hp(b, 999)
	assert_eq(a.desolation, 8, "15 × 0,5 = 7,5 → 8")


func test_faith_check_is_deterministic_with_the_same_seed() -> void:
	var results: Array[bool] = []
	for i: int in 2:
		var battle := BattleState.create(CombatFixture.catalog(), [CombatFixture.saint(&"x")] as Array[SaintDef], [CombatFixture.enemy(&"e")] as Array[EnemyDef], [] as Array[StringName], &"common", 777)
		var saint: Combatant = battle.party_at(1)
		saint.faith = 5
		saint.desolation = 99
		battle.add_desolation(saint, 1)
		results.append(saint.spirit_state == &"consolation")
	assert_eq(results[0], results[1])
