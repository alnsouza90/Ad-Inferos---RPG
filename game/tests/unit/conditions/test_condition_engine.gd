extends GutTest
## T07: condition engine (conditions.md). K14 (Freeze) belongs to M3.

var c: BattleController
var s: BattleState
var engine: ConditionEngine


func _setup(enemy_defs: Array[EnemyDef] = [], saint_will: int = 0) -> void:
	var saints: Array[SaintDef] = [CombatFixture.kit_saint(&"saint_a"), CombatFixture.kit_saint(&"saint_b"), CombatFixture.kit_saint(&"saint_c")]
	for saint: SaintDef in saints:
		saint.will = saint_will
	if enemy_defs.is_empty():
		enemy_defs = [CombatFixture.enemy(&"enemy_1", 40), CombatFixture.enemy(&"enemy_2", 40)]
	c = BattleController.new(BattleState.create(CombatFixture.catalog(), saints, enemy_defs))
	s = c.state
	engine = s.engine
	c.start()


func _types(from: int) -> Array[StringName]:
	var result: Array[StringName] = []
	for e: BattleEvent in c.history.slice(from):
		result.append(e.type)
	return result


# --- K01 to K04: bleed and Will --------------------------------------------------------

func test_K01_bleed_3_deals_3_ignoring_armor_and_ward_then_drops_to_2() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	a.armor = 3
	a.conditions[&"ward"] = 1
	engine.apply(a, &"bleed", 3)
	c.end_party_turn()
	assert_eq(a.hp, a.max_hp - 3)
	assert_eq(a.stacks(&"bleed"), 2)
	assert_eq(a.stacks(&"ward"), 1, "Amparo não é gasto pelo Sangramento")


func test_K02_bleed_4_on_will_1_gives_3() -> void:
	_setup([], 1)
	assert_eq(engine.apply(s.party_at(1), &"bleed", 4), 3)
	assert_eq(s.party_at(1).stacks(&"bleed"), 3)


func test_K03_bleed_1_on_will_1_is_resisted() -> void:
	_setup([], 1)
	var before: int = c.history.size()
	assert_eq(engine.apply(s.party_at(1), &"bleed", 1), 0)
	assert_false(s.party_at(1).has_condition(&"bleed"))
	assert_true(_types(before).has(&"condition_resisted"))


func test_K04_bleed_5_plus_2_stays_5() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"bleed", 5)
	assert_eq(engine.apply(a, &"bleed", 2), 0)
	assert_eq(a.stacks(&"bleed"), 5)


func test_bleed_can_make_a_saint_fall() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	s.lose_hp(a, a.max_hp - 2)
	engine.apply(a, &"bleed", 3)
	c.end_party_turn()
	assert_true(a.is_fallen())


func test_bleed_ticks_on_enemy_right_before_its_action() -> void:
	_setup()
	var e: Combatant = s.enemy_at(1)
	engine.apply(e, &"bleed", 2)
	c.end_party_turn()
	assert_eq(e.hp, e.max_hp - 2)
	assert_eq(e.stacks(&"bleed"), 1)


# --- K05, K06: stun -----------------------------------------------------------------------

func test_K05_stunned_enemy_loses_intent_and_is_immune_until_end_of_next_round() -> void:
	_setup()
	var e: Combatant = s.enemy_at(1)
	engine.apply(e, &"stun", 1)
	var before: int = c.history.size()
	c.end_party_turn()
	assert_false(e.has_condition(&"stun"))
	assert_true(_types(before).has(&"stun_consumed"))
	var action: BattleEvent = c.history.slice(before).filter(func(ev: BattleEvent) -> bool: return ev.type == BattleController.EV_ENEMY_ACTION and ev.data["enemy"] == e.id)[0]
	assert_false(action.data["acted"], "intenção cancelada")
	assert_eq(engine.apply(e, &"stun", 1), 0, "imune na rodada seguinte")
	c.end_party_turn()
	assert_eq(engine.apply(e, &"stun", 1), 1, "imunidade acabou")


func test_K06_stunning_an_immune_enemy_has_no_effect() -> void:
	var breath := CombatFixture.enemy(&"breath")
	breath.immune = [&"stun"] as Array[StringName]
	_setup([breath] as Array[EnemyDef])
	var before: int = c.history.size()
	assert_eq(engine.apply(s.enemy_at(1), &"stun", 1), 0)
	assert_false(s.enemy_at(1).has_condition(&"stun"))
	assert_true(_types(before).has(&"condition_immune"))


func test_stunned_saint_loses_turn_when_passing_and_becomes_immune() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"stun", 1)
	assert_true(c.execute(BattleCommand.pass_turn(&"saint_a")).ok)
	assert_false(a.has_condition(&"stun"))
	assert_eq(engine.apply(a, &"stun", 1), 0, "imune até o fim da rodada seguinte")
	c.end_party_turn()
	assert_eq(engine.apply(a, &"stun", 1), 0)
	c.end_party_turn()
	assert_eq(engine.apply(a, &"stun", 1), 1)


func test_stunned_saint_who_does_not_act_still_loses_the_stun_at_end_of_turn() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"stun", 1)
	c.end_party_turn()
	assert_false(a.has_condition(&"stun"))


# --- K07, K08 are covered in tests/unit/effects/test_effects.gd -------------------------

# --- K09: taunt ----------------------------------------------------------------------------

func test_K09_taunt_from_party_turn_expires_at_the_end_of_the_same_round() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"taunt", 1)
	var seen_during_enemy_turn := false
	var before: int = c.history.size()
	c.end_party_turn()
	for ev: BattleEvent in c.history.slice(before):
		if ev.type == BattleController.EV_ENEMY_TURN_STARTED:
			seen_during_enemy_turn = true
		if ev.type == &"condition_expired":
			assert_true(seen_during_enemy_turn, "expira depois do turno inimigo")
	assert_false(a.has_condition(&"taunt"))


func test_taunt_applied_during_enemy_turn_lasts_until_next_round_end() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	s.in_enemy_phase = true
	engine.apply(a, &"taunt", 1)
	s.in_enemy_phase = false
	c.end_party_turn()
	assert_true(a.has_condition(&"taunt"), "protege o próximo turno inimigo")
	c.end_party_turn()
	assert_false(a.has_condition(&"taunt"))


# --- K10, K11 -------------------------------------------------------------------------------

func test_K10_falling_removes_strength_and_keeps_bleed() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"strength", 1)
	engine.apply(a, &"bleed", 2)
	s.lose_hp(a, 999)
	assert_false(a.has_condition(&"strength"))
	assert_eq(a.stacks(&"bleed"), 2)


func test_K11_enemies_are_immune_to_corruption() -> void:
	_setup()
	assert_eq(engine.apply(s.enemy_at(1), &"corruption", 2), 0)
	assert_false(s.enemy_at(1).has_condition(&"corruption"))


func test_corruption_gives_3_desolation_per_stack_and_decays() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"corruption", 2)
	c.end_party_turn()
	assert_eq(a.desolation, 6)
	assert_eq(a.stacks(&"corruption"), 1)


# --- K12, K13: Duel ---------------------------------------------------------------------------

func test_K12_challenging_b_ends_the_duel_with_a() -> void:
	_setup()
	var george: Combatant = s.party_at(1)
	var a: Combatant = s.enemy_at(1)
	var b: Combatant = s.enemy_at(2)
	engine.apply(a, &"duel", 1, george)
	engine.apply(b, &"duel", 1, george)
	assert_false(a.has_condition(&"duel"))
	assert_true(b.has_condition(&"duel"))


func test_K13_dueled_enemy_hits_george_then_george_counters_with_3() -> void:
	_setup([CombatFixture.enemy(&"ghost", 40, 1, &"spiritual")] as Array[EnemyDef])
	var george: Combatant = s.party_at(1)
	var foe: Combatant = s.enemy_at(1)
	engine.apply(foe, &"duel", 1, george)
	var before: int = c.history.size()
	c.resolve_effects(foe, &"claw", [CombatFixture.effect(&"damage", 5, &"untyped")] as Array[EffectDef], [george] as Array[Combatant])
	var events: Array[BattleEvent] = c.history.slice(before)
	var types: Array[StringName] = []
	for ev: BattleEvent in events:
		types.append(ev.type)
	assert_eq(types, [&"damage_dealt", &"duel_counter", &"damage_dealt"] as Array[StringName])
	assert_eq(george.hp, george.max_hp - 5)
	# Golpe 3 × 0,75 (Espiritual resiste a Golpe) × 1,25 (Duelo) = 2,81 → 3.
	assert_eq(foe.max_hp - foe.hp, 3)


func test_duel_counter_does_not_spend_georges_strength() -> void:
	_setup([CombatFixture.enemy(&"ghost", 40, 1, &"spiritual")] as Array[EnemyDef])
	var george: Combatant = s.party_at(1)
	var foe: Combatant = s.enemy_at(1)
	engine.apply(george, &"strength", 1)
	engine.apply(foe, &"duel", 1, george)
	c.resolve_effects(foe, &"claw", [CombatFixture.effect(&"damage", 5, &"untyped")] as Array[EffectDef], [george] as Array[Combatant])
	assert_eq(george.stacks(&"strength"), 1)


func test_no_duel_counter_on_group_attack_or_when_stunned() -> void:
	_setup()
	var george: Combatant = s.party_at(1)
	var foe: Combatant = s.enemy_at(1)
	engine.apply(foe, &"duel", 1, george)
	var group: Array[Combatant] = [george, s.party_at(2)]
	c.resolve_effects(foe, &"howl", [CombatFixture.effect(&"damage", 2, &"untyped")] as Array[EffectDef], group)
	assert_eq(foe.hp, foe.max_hp, "ataque em grupo não provoca contra-ataque")
	george.conditions[&"stun"] = 1
	c.resolve_effects(foe, &"claw", [CombatFixture.effect(&"damage", 2, &"untyped")] as Array[EffectDef], [george] as Array[Combatant])
	assert_eq(foe.hp, foe.max_hp, "Jorge atordoado não contra-ataca")


func test_george_deals_more_damage_to_his_duel_target() -> void:
	_setup([CombatFixture.enemy(&"ghost", 40, 1, &"spiritual"), CombatFixture.enemy(&"other", 40, 1, &"spiritual")] as Array[EnemyDef])
	var george: Combatant = s.party_at(1)
	var foe: Combatant = s.enemy_at(1)
	var other: Combatant = s.enemy_at(2)
	engine.apply(foe, &"duel", 1, george)
	c.resolve_effects(george, &"thrust", [CombatFixture.effect(&"damage", 8, &"untyped")] as Array[EffectDef], [foe, other] as Array[Combatant])
	assert_eq(foe.max_hp - foe.hp, 10, "8 × 1,25")
	assert_eq(other.max_hp - other.hp, 8)


func test_duel_ends_when_george_falls() -> void:
	_setup()
	var george: Combatant = s.party_at(1)
	var foe: Combatant = s.enemy_at(1)
	engine.apply(foe, &"duel", 1, george)
	s.lose_hp(george, 999)
	assert_false(foe.has_condition(&"duel"))


# --- K15 and display ----------------------------------------------------------------------------

func test_K15_end_of_battle_removes_every_condition() -> void:
	_setup()
	engine.apply(s.party_at(1), &"bleed", 2)
	engine.apply(s.party_at(2), &"ward", 1)
	engine.apply(s.enemy_at(1), &"stun", 1)
	c.execute(BattleCommand.retreat())
	for x: Combatant in s.party + s.enemies:
		assert_eq(x.conditions, {}, "%s sem condições" % x.id)


func test_visible_conditions_shows_three_by_priority_and_counts_the_rest() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	for id: StringName in [&"strength", &"ward", &"bleed", &"stun"]:
		engine.apply(a, id, 1)
	var view: Dictionary = engine.visible_conditions(a)
	assert_eq(view["shown"], [&"stun", &"bleed", &"ward"] as Array[StringName])
	assert_eq(view["more"], 1)


func test_refresh_stacking_keeps_the_higher_value() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	engine.apply(a, &"taunt", 1)
	assert_eq(engine.apply(a, &"taunt", 1), 0)
	assert_eq(a.stacks(&"taunt"), 1)


func test_conditions_cannot_be_applied_to_fallen_saints() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	s.lose_hp(a, 999)
	assert_eq(engine.apply(a, &"bleed", 2), 0)
