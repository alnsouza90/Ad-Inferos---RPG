extends GutTest
## T03: battle state and formation (combat §2 and §8).


func _ids(list: Array[Combatant]) -> Array[StringName]:
	var result: Array[StringName] = []
	for c: Combatant in list:
		result.append(c.def_id)
	return result


# --- formation ------------------------------------------------------------------

func test_initial_formation() -> void:
	var s := CombatFixture.battle()
	assert_eq(s.party_at(1).id, &"saint_a")
	assert_eq(s.party_at(3).id, &"saint_c")
	assert_null(s.party_at(4))
	assert_eq(s.enemy_at(1).def_id, &"enemy_1")
	assert_eq(s.enemy_at(4).def_id, &"enemy_4")
	assert_eq(s.enemy_slot_of(s.enemy_at(3)), 3)


func test_enemy_instances_have_unique_ids() -> void:
	var e := CombatFixture.enemy(&"enemy_x")
	var s := CombatFixture.battle([e, e] as Array[EnemyDef])
	assert_ne(s.enemies[0].id, s.enemies[1].id)
	assert_eq(s.find(s.enemies[1].id), s.enemies[1])


func test_large_enemy_occupies_consecutive_slots() -> void:
	var s := CombatFixture.battle([CombatFixture.enemy(&"small"), CombatFixture.enemy(&"big", 50, 2), CombatFixture.enemy(&"tail")] as Array[EnemyDef])
	assert_eq(s.enemy_at(2).def_id, &"big")
	assert_eq(s.enemy_at(3).def_id, &"big")
	assert_eq(s.enemy_at(4).def_id, &"tail")
	assert_eq(s.enemy_slot_of(s.enemy_at(3)), 2)


# --- C06 ---------------------------------------------------------------------------

func test_C06_swap_with_ally_that_already_acted() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	b.has_acted = true
	assert_eq(s.swap_party(a, 1), "")
	assert_eq(s.party_at(1), b)
	assert_eq(s.party_at(2), a)
	assert_true(a.has_acted, "quem se move gasta a ação")
	assert_true(b.has_acted, "aliado continua 'já agiu'")


func test_swap_does_not_spend_the_displaced_ally_action() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	s.swap_party(a, 1)
	assert_false(b.has_acted)


func test_swap_with_fallen_ally_is_allowed() -> void:
	var s := CombatFixture.battle()
	var b: Combatant = s.party_at(2)
	s.lose_hp(b, 999)
	assert_eq(s.swap_party(s.party_at(3), -1), "")
	assert_eq(s.party_at(3), b)


func test_swap_rejected_cases_change_nothing() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	assert_eq(s.swap_party(a, -1), "no_slot")
	a.conditions[&"stun"] = 1
	assert_eq(s.swap_party(a, 1), "stunned")
	a.conditions.clear()
	a.has_acted = true
	assert_eq(s.swap_party(a, 1), "already_acted")
	assert_eq(s.party_at(1), a)


# --- forced movement --------------------------------------------------------------

func test_push_saint_stops_at_last_slot() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	assert_eq(s.move_party(a, 5), 2)
	assert_eq(s.party_slot_of(a), 3)
	assert_eq(_ids(s.party), [&"saint_b", &"saint_c", &"saint_a"] as Array[StringName])
	assert_false(a.has_acted, "movimento forçado não gasta ação")


func test_push_enemy_two_slots() -> void:
	var s := CombatFixture.battle()
	var first: Combatant = s.enemy_at(1)
	assert_eq(s.move_enemy(first, 2), 2)
	assert_eq(s.enemy_slot_of(first), 3)
	assert_eq(s.enemy_at(1).def_id, &"enemy_2")


func test_pull_enemy_forward() -> void:
	var s := CombatFixture.battle()
	var last: Combatant = s.enemy_at(4)
	assert_eq(s.move_enemy(last, -1), 1)
	assert_eq(s.enemy_slot_of(last), 3)


func test_large_enemy_ignores_forced_movement() -> void:
	var s := CombatFixture.battle([CombatFixture.enemy(&"big", 50, 2), CombatFixture.enemy(&"small")] as Array[EnemyDef])
	var big: Combatant = s.enemy_at(1)
	assert_eq(s.move_enemy(big, 1), 0)
	assert_eq(s.enemy_slot_of(big), 1)


# --- C07 ---------------------------------------------------------------------------

func test_C07_enemy_in_slot_2_dies_and_queue_closes() -> void:
	var s := CombatFixture.battle()
	var third: Combatant = s.enemy_at(3)
	var fourth: Combatant = s.enemy_at(4)
	s.lose_hp(s.enemy_at(2), 999)
	assert_eq(s.enemy_at(2), third)
	assert_eq(s.enemy_at(3), fourth)
	assert_null(s.enemy_at(4))


func test_enemy_with_remains_holds_the_slot_then_leaves() -> void:
	var corpse := CombatFixture.enemy(&"corpse")
	corpse.leaves_remains = true
	corpse.remains_rounds = 1
	var s := CombatFixture.battle([corpse, CombatFixture.enemy(&"behind")] as Array[EnemyDef])
	var c: Combatant = s.enemy_at(1)
	s.lose_hp(c, 999)
	assert_eq(s.enemy_at(1), c, "o resto ocupa a posição")
	assert_eq(c.state, Combatant.State.REMAINS)
	s.end_round_falls()
	assert_eq(s.enemy_at(1).def_id, &"behind")


# --- C08 ---------------------------------------------------------------------------

func test_C08_intent_hits_whoever_is_in_the_slot() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	var intent := Intent.create(s.enemy_at(1).id, &"hit", 1)
	assert_eq(s.intent_target(intent), a)
	s.swap_party(a, 1)
	assert_eq(s.intent_target(intent), b)


# --- falling ------------------------------------------------------------------------

func test_fall_keeps_slot_and_removes_only_positive_conditions() -> void:
	var s := CombatFixture.battle()
	var b: Combatant = s.party_at(2)
	b.conditions = {&"strength": 1, &"ward": 2, &"bleed": 3}
	s.lose_hp(b, 999)
	assert_true(b.is_fallen())
	assert_eq(b.hp, 0)
	assert_eq(s.party_at(2), b)
	assert_eq(b.conditions, {&"bleed": 3})


func test_fallen_ally_gives_desolation_to_standing_allies() -> void:
	var s := CombatFixture.battle()
	s.lose_hp(s.party_at(2), 999)
	assert_eq(s.party_at(1).desolation, CombatFixture.DESOLATION_ALLY_FALLEN)
	assert_eq(s.party_at(3).desolation, CombatFixture.DESOLATION_ALLY_FALLEN)
	assert_eq(s.party_at(2).desolation, 0)


func test_C14_fallen_saint_healed_inside_window_stands_up_with_the_heal() -> void:
	var s := CombatFixture.battle()
	var b: Combatant = s.party_at(2)
	s.lose_hp(b, 999)
	s.end_round_falls()
	assert_true(b.is_fallen(), "ainda dentro da janela")
	assert_eq(s.heal(b, 7), 7)
	assert_true(b.is_standing())
	assert_eq(b.hp, 7)


func test_C15_fallen_for_two_round_ends_is_out_and_cannot_be_healed() -> void:
	var s := CombatFixture.battle()
	var b: Combatant = s.party_at(2)
	s.lose_hp(b, 999)
	for i: int in CombatFixture.REVIVE_WINDOW:
		s.end_round_falls()
	assert_true(b.is_out())
	assert_eq(s.heal(b, 10), 0)
	assert_eq(s.revive(b, 10), 0)
	assert_eq(b.hp, 0)


func test_C16_prostration_cannot_be_raised_and_gives_no_ally_desolation() -> void:
	var s := CombatFixture.battle()
	var b: Combatant = s.party_at(2)
	s.prostrate(b)
	assert_true(b.is_fallen())
	assert_eq(s.heal(b, 10), 0)
	assert_eq(s.revive(b, 10), 0)
	assert_eq(s.party_at(1).desolation, 0)
	assert_eq(s.party_at(3).desolation, 0)


func test_C17_three_fallen_saints_is_immediate_defeat() -> void:
	var s := CombatFixture.battle()
	s.lose_hp(s.party_at(1), 999)
	s.lose_hp(s.party_at(2), 999)
	assert_false(s.is_defeat())
	s.prostrate(s.party_at(3))
	assert_true(s.is_defeat())


func test_victory_when_no_enemy_is_fighting() -> void:
	var s := CombatFixture.battle([CombatFixture.enemy(&"only")] as Array[EnemyDef])
	assert_false(s.is_victory())
	s.lose_hp(s.enemy_at(1), 999)
	assert_true(s.is_victory())


func test_heal_does_not_exceed_max_hp() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	s.lose_hp(a, 5)
	assert_eq(s.heal(a, 50), 5)
	assert_eq(a.hp, a.max_hp)


func test_desolation_never_goes_below_zero_and_200_means_prostration() -> void:
	var s := CombatFixture.battle()
	var a: Combatant = s.party_at(1)
	s.add_desolation(a, -999)
	assert_eq(a.desolation, 0)
	s.add_desolation(a, 500)
	assert_eq(a.desolation, 150, "Prostração (desolation §5)")
	assert_true(a.is_fallen())
