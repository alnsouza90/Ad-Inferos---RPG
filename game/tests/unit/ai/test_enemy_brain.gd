extends GutTest
## T09: enemy AI and intents (enemy-ai.md).

var c: BattleController
var s: BattleState


func _hit(amount: float = 4) -> Array[EffectDef]:
	return [CombatFixture.effect(&"damage", amount, &"untyped")] as Array[EffectDef]


func _enemy(id: StringName, actions: Array[EnemyActionDef], hp: int = 30) -> EnemyDef:
	var d := CombatFixture.enemy(id, hp)
	d.actions = actions
	return d


func _setup(enemy_defs: Array[EnemyDef], seed: int = 0) -> void:
	var saints: Array[SaintDef] = [CombatFixture.kit_saint(&"saint_a"), CombatFixture.kit_saint(&"saint_b"), CombatFixture.kit_saint(&"saint_c")]
	c = BattleController.new(BattleState.create(CombatFixture.catalog(), saints, enemy_defs, [] as Array[StringName], &"common", seed))
	s = c.state
	c.start()


func _intent(slot: int) -> Intent:
	return s.intent_of(s.enemy_at(slot))


func _always() -> Array[Dictionary]:
	return [{"name": "always", "param": null}] as Array[Dictionary]


# --- A01 to A03: choosing ------------------------------------------------------------

func test_A01_two_valid_actions_picks_priority_1() -> void:
	var first := CombatFixture.action(&"first", 1, _hit())
	var second := CombatFixture.action(&"second", 2, _hit())
	_setup([_enemy(&"e", [first, second] as Array[EnemyActionDef])] as Array[EnemyDef])
	assert_eq(_intent(1).action_id, &"first")


func test_A02_priority_1_on_cooldown_picks_priority_2() -> void:
	var crush := CombatFixture.action(&"crush", 1, _hit(9), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"front_most", _always(), 2)
	var slam := CombatFixture.action(&"slam", 2, _hit(6))
	_setup([_enemy(&"e", [crush, slam] as Array[EnemyActionDef], 100)] as Array[EnemyDef])
	assert_eq(_intent(1).action_id, &"crush")
	c.end_party_turn()
	assert_eq(_intent(1).action_id, &"slam", "recarga de 2 rodadas")
	c.end_party_turn()
	assert_eq(_intent(1).action_id, &"slam")
	c.end_party_turn()
	assert_eq(_intent(1).action_id, &"crush", "volta depois da recarga")


func test_A03_lowest_hp_tie_goes_to_lowest_slot() -> void:
	var bite := CombatFixture.action(&"bite", 1, _hit(), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"lowest_hp")
	_setup([_enemy(&"e", [bite] as Array[EnemyActionDef])] as Array[EnemyDef])
	assert_eq(_intent(1).target_slot, 1, "todos com a mesma vida: menor posição")
	s.lose_hp(s.party_at(3), 5)
	s.lose_hp(s.party_at(2), 5)
	c.end_party_turn()
	# Slot 1 took 4 from the bite (26 hp); slots 2 and 3 are tied at 25: slot 2.
	assert_eq(_intent(1).target_slot, 2)


# --- A04 to A07: execution ----------------------------------------------------------------

func test_A04_target_swaps_slot_and_whoever_is_there_is_hit() -> void:
	_setup([_enemy(&"e", [CombatFixture.action(&"hit", 1, _hit(5))] as Array[EnemyActionDef])] as Array[EnemyDef])
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	assert_eq(_intent(1).target_slot, 1)
	c.execute(BattleCommand.swap_slots(&"saint_a", 1))
	c.end_party_turn()
	assert_eq(b.hp, b.max_hp - 5, "quem estava na posição 1")
	assert_eq(a.hp, a.max_hp)


func test_A05_fallen_in_target_slot_retargets_and_without_target_reports_no_target() -> void:
	var front := CombatFixture.action(&"jab", 1, _hit(3), &"single", [1] as Array[int])
	_setup([_enemy(&"e", [front] as Array[EnemyActionDef])] as Array[EnemyDef])
	s.lose_hp(s.party_at(1), 999)
	var before: int = c.history.size()
	c.end_party_turn()
	var types: Array[StringName] = []
	for ev: BattleEvent in c.history.slice(before):
		types.append(ev.type)
	assert_false(types.has(&"damage_dealt"))
	assert_eq(_intent(1).kind, Intent.KIND_WAIT, "nova rodada: sem alvo válido, aguarda")
	var wide := CombatFixture.action(&"claw", 1, _hit(3))
	_setup([_enemy(&"e", [wide] as Array[EnemyActionDef])] as Array[EnemyDef])
	assert_eq(_intent(1).target_slot, 1)
	s.lose_hp(s.party_at(1), 999)
	c.end_party_turn()
	assert_eq(s.party_at(2).hp, s.party_at(2).max_hp - 3, "reescolhe pela mesma regra")


func test_A05_no_valid_target_at_execution_emits_no_target() -> void:
	var front := CombatFixture.action(&"jab", 1, _hit(3), &"single", [1] as Array[int])
	_setup([_enemy(&"e", [front] as Array[EnemyActionDef])] as Array[EnemyDef])
	s.lose_hp(s.party_at(1), 999)
	var before: int = c.history.size()
	c.end_party_turn()
	assert_true(c.history.slice(before).any(func(ev: BattleEvent) -> bool: return ev.type == BattleController.EV_NO_TARGET))


func test_A06_taunt_applied_after_choice_redirects_and_redraws_intent() -> void:
	_setup([_enemy(&"e", [CombatFixture.action(&"hit", 1, _hit(5))] as Array[EnemyActionDef])] as Array[EnemyDef])
	assert_eq(_intent(1).target_slot, 1)
	var c_saint: Combatant = s.party_at(3)
	c.state.catalog.ability(&"guard_self").effects = [CombatFixture.effect(&"apply_condition", 0, &"", &"taunt", 1)] as Array[EffectDef]
	var result: CommandResult = c.execute(BattleCommand.use_ability(&"saint_c", &"guard_self"))
	assert_eq(_intent(1).target_slot, 3)
	assert_true(result.events.any(func(ev: BattleEvent) -> bool: return ev.type == BattleController.EV_INTENTS_UPDATED))
	c.end_party_turn()
	assert_eq(c_saint.hp, c_saint.max_hp - 5)


func test_A07_enemy_stunned_after_choice_has_intent_cancelled() -> void:
	_setup([_enemy(&"e", [CombatFixture.action(&"hit", 1, _hit(5))] as Array[EnemyActionDef])] as Array[EnemyDef])
	c.state.catalog.ability(&"strike").effects = [CombatFixture.effect(&"apply_condition", 0, &"", &"stun", 1)] as Array[EffectDef]
	c.execute(BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int]))
	assert_eq(_intent(1).kind, Intent.KIND_STUNNED, "intenção redesenhada como atordoado")
	c.end_party_turn()
	for saint: Combatant in s.party:
		assert_eq(saint.hp, saint.max_hp)


# --- A08, A09 -------------------------------------------------------------------------------

func test_A08_summon_without_free_slot_is_not_chosen() -> void:
	var brood_effect := CombatFixture.effect(&"summon")
	brood_effect.summon_id = &"swarmling"
	brood_effect.max_alive = 5
	var free_slot: Array[Dictionary] = [{"name": "free_enemy_slot", "param": null}]
	var brood := CombatFixture.action(&"brood", 1, [brood_effect] as Array[EffectDef], &"self", [] as Array[int], [1, 2, 3, 4] as Array[int], &"front_most", free_slot)
	var sting := CombatFixture.action(&"sting", 2, _hit(2))
	var mother := _enemy(&"mother", [brood, sting] as Array[EnemyActionDef])
	var filler := _enemy(&"filler", [sting] as Array[EnemyActionDef])
	_setup([mother, filler, filler, filler] as Array[EnemyDef])
	assert_eq(_intent(1).action_id, &"sting")
	_setup([mother, filler] as Array[EnemyDef])
	assert_eq(_intent(1).action_id, &"brood")


func test_A09_same_seed_same_intents() -> void:
	var random_hit := CombatFixture.action(&"wild", 1, _hit(2), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"random")
	var defs: Array[EnemyDef] = [_enemy(&"e1", [random_hit] as Array[EnemyActionDef]), _enemy(&"e2", [random_hit] as Array[EnemyActionDef]), _enemy(&"e3", [random_hit] as Array[EnemyActionDef])]
	var runs: Array[String] = []
	for i: int in 2:
		_setup(defs, 9001)
		var record: Array = []
		for r: int in 4:
			for intent: Intent in s.intents:
				record.append(intent.target_slot)
			c.end_party_turn()
		runs.append(str(record))
	assert_eq(runs[0], runs[1])


# --- conditions, rules and preview ------------------------------------------------------------

func test_conditions_self_and_ally_hp_round_and_every_n() -> void:
	var low := CombatFixture.action(&"desperate", 1, _hit(), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"front_most", [{"name": "self_hp_below", "param": 50}] as Array[Dictionary])
	var later := CombatFixture.action(&"later", 2, _hit(), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"front_most", [{"name": "round_at_least", "param": 2}] as Array[Dictionary])
	var even := CombatFixture.action(&"even", 3, _hit(), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"front_most", [{"name": "every_n_rounds", "param": 2}] as Array[Dictionary])
	var base := CombatFixture.action(&"base", 4, _hit())
	_setup([_enemy(&"e", [low, later, even, base] as Array[EnemyActionDef], 100)] as Array[EnemyDef])
	assert_eq(_intent(1).action_id, &"base", "rodada 1")
	c.end_party_turn()
	assert_eq(_intent(1).action_id, &"later", "rodada 2")
	s.lose_hp(s.enemy_at(1), 60)
	c.end_party_turn()
	assert_eq(_intent(1).action_id, &"desperate", "abaixo de 50%")


func test_back_most_and_highest_desolation_rules() -> void:
	var sting := CombatFixture.action(&"sting", 1, _hit(), &"single", [2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"back_most")
	var whisper := CombatFixture.action(&"whisper", 1, _hit(), &"single", [1, 2, 3] as Array[int], [1, 2, 3, 4] as Array[int], &"highest_desolation")
	s = null
	_setup([_enemy(&"gadfly", [sting] as Array[EnemyActionDef]), _enemy(&"shade", [whisper] as Array[EnemyActionDef])] as Array[EnemyDef])
	assert_eq(_intent(1).target_slot, 3)
	s.party_at(2).desolation = 40
	c.end_party_turn()
	assert_eq(_intent(2).target_slot, 2)


func test_use_slots_limit_which_actions_are_available() -> void:
	var back_only := CombatFixture.action(&"brood", 1, _hit(), &"single", [1, 2, 3] as Array[int], [3, 4] as Array[int])
	var any := CombatFixture.action(&"sting", 2, _hit())
	_setup([_enemy(&"m", [back_only, any] as Array[EnemyActionDef])] as Array[EnemyDef])
	assert_eq(_intent(1).action_id, &"sting", "na posição 1 não usa a ação de 3–4")


func test_preview_includes_ward_and_armor_and_updates() -> void:
	_setup([_enemy(&"e", [CombatFixture.action(&"hit", 1, _hit(9))] as Array[EnemyActionDef])] as Array[EnemyDef])
	s.party_at(1).armor = 1
	EnemyBrain.refresh_intents(s)
	assert_eq(_intent(1).preview_value, 8)
	c.state.catalog.ability(&"heal_any").effects = [CombatFixture.effect(&"apply_condition", 0, &"", &"ward", 1)] as Array[EffectDef]
	c.execute(BattleCommand.use_ability(&"saint_b", &"heal_any", [1] as Array[int]))
	assert_eq(_intent(1).preview_value, 4, "9 × 0,5 = 4,5 → 5, − 1 de armadura")


func test_all_party_and_ally_enemy_targets() -> void:
	var lament := CombatFixture.action(&"lament", 1, [CombatFixture.effect(&"desolation", 5)] as Array[EffectDef], &"all_party", [] as Array[int])
	var carapace := CombatFixture.action(&"carapace", 1, [CombatFixture.effect(&"apply_condition", 0, &"", &"ward", 1)] as Array[EffectDef], &"ally_enemy", [] as Array[int], [1, 2, 3, 4] as Array[int], &"lowest_hp_pct", [{"name": "ally_hp_below", "param": 60}] as Array[Dictionary])
	var bite := CombatFixture.action(&"bite", 2, _hit(1))
	_setup([_enemy(&"scarab", [carapace, bite] as Array[EnemyActionDef]), _enemy(&"breath", [lament] as Array[EnemyActionDef])] as Array[EnemyDef])
	var breath: Combatant = s.enemy_at(2)
	s.lose_hp(breath, 20)
	EnemyBrain.choose_intents(s)
	assert_eq(_intent(1).action_id, &"carapace")
	assert_eq(_intent(1).target_enemy_id, breath.id)
	c.end_party_turn()
	assert_eq(breath.stacks(&"ward"), 1)
	for saint: Combatant in s.party:
		assert_eq(saint.desolation, 5)


func test_summoned_enemies_act_from_the_next_round() -> void:
	var swarm := _enemy(&"swarmling", [CombatFixture.action(&"bite", 1, _hit(1))] as Array[EnemyActionDef], 8)
	var brood_effect := CombatFixture.effect(&"summon")
	brood_effect.summon_id = &"swarmling"
	brood_effect.max_alive = 2
	var brood := CombatFixture.action(&"brood", 1, [brood_effect] as Array[EffectDef], &"self", [] as Array[int])
	_setup([_enemy(&"mother", [brood] as Array[EnemyActionDef])] as Array[EnemyDef])
	s.catalog.enemies[&"swarmling"] = swarm
	c.end_party_turn()
	assert_eq(s.enemies.size(), 2)
	assert_eq(s.party_at(1).hp, s.party_at(1).max_hp, "o enxame invocado ainda não agiu")
	assert_eq(_intent(2).action_id, &"bite", "na rodada seguinte já tem intenção")
