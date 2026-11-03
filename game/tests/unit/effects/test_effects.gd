extends GutTest
## T06: effect queue and damage formula (combat §7 and §9).

var c: BattleController
var s: BattleState


class LoopHandler:
	extends EffectHandler
	## Test-only: re-queues itself forever, like a counter-attack loop.
	func per_target() -> bool:
		return false

	func apply(ctx: EffectContext, effect: EffectDef, _target: Combatant) -> void:
		ctx.queue.enqueue(ctx, effect)


func _setup(enemy_defs: Array[EnemyDef] = []) -> void:
	c = BattleController.new(CombatFixture.battle(enemy_defs))
	s = c.state
	c.start()


func _run(actor: Combatant, effects: Array[EffectDef], targets: Array[Combatant]) -> Array[BattleEvent]:
	var before: int = c.history.size()
	c.resolve_effects(actor, &"test", effects, targets)
	return c.history.slice(before)


func _of(events: Array[BattleEvent], type: StringName) -> Array[BattleEvent]:
	return events.filter(func(e: BattleEvent) -> bool: return e.type == type)


func _e(type: StringName, amount: float = 0.0, damage_type: StringName = &"", condition_id: StringName = &"", stacks: int = 0, params: Dictionary = {}) -> EffectDef:
	return CombatFixture.effect(type, amount, damage_type, condition_id, stacks, params)


# --- damage formula: mandatory cases -------------------------------------------------

func test_C10_dragon_lance_example_deals_37() -> void:
	_setup([CombatFixture.enemy(&"elite_x", 80, 1, &"corporeal", 1, &"elite")] as Array[EnemyDef])
	var george: Combatant = s.party_at(1)
	george.conditions[&"strength"] = 1
	var target: Combatant = s.enemy_at(1)
	_run(george, [_e(&"damage", 12, &"strike", &"", 0, {"elite": 2.0, "boss": 2.0})] as Array[EffectDef], [target] as Array[Combatant])
	assert_eq(target.max_hp - target.hp, 37)
	assert_false(george.has_condition(&"strength"), "Força consumida")


func test_C11_one_damage_against_armor_3_deals_1() -> void:
	_setup([CombatFixture.enemy(&"armored", 20, 1, &"corporeal", 3)] as Array[EnemyDef])
	var target: Combatant = s.enemy_at(1)
	_run(s.party_at(1), [_e(&"damage", 1, &"untyped")] as Array[EffectDef], [target] as Array[Combatant])
	assert_eq(target.hp, 19)


func test_C12_strength_on_group_attack_is_consumed_once_and_boosts_every_target() -> void:
	_setup([CombatFixture.enemy(&"e1"), CombatFixture.enemy(&"e2"), CombatFixture.enemy(&"e3")] as Array[EnemyDef])
	var actor: Combatant = s.party_at(1)
	actor.conditions[&"strength"] = 2
	var targets: Array[Combatant] = [s.enemy_at(1), s.enemy_at(2), s.enemy_at(3)]
	_run(actor, [_e(&"damage", 8, &"untyped")] as Array[EffectDef], targets)
	for t: Combatant in targets:
		assert_eq(t.max_hp - t.hp, 10, "8 × 1,25 = 10 em cada alvo")
	assert_eq(actor.stacks(&"strength"), 1, "uma pilha por ação")


func test_C13_ward_is_consumed_by_the_first_of_two_hits() -> void:
	_setup()
	var saint: Combatant = s.party_at(1)
	saint.conditions[&"ward"] = 1
	var hit: EffectDef = _e(&"damage", 6, &"untyped")
	var events: Array[BattleEvent] = _run(s.enemy_at(1), [hit, hit] as Array[EffectDef], [saint] as Array[Combatant])
	var hits: Array[BattleEvent] = _of(events, &"damage_dealt")
	assert_eq(hits[0].data["amount"], 3)
	assert_eq(hits[1].data["amount"], 6)
	assert_false(saint.has_condition(&"ward"))


func test_K07_ward_2_halves_both_hits() -> void:
	_setup()
	var saint: Combatant = s.party_at(1)
	saint.conditions[&"ward"] = 2
	var hit: EffectDef = _e(&"damage", 6, &"untyped")
	_run(s.enemy_at(1), [hit, hit] as Array[EffectDef], [saint] as Array[Combatant])
	assert_eq(saint.max_hp - saint.hp, 6)
	assert_false(saint.has_condition(&"ward"))


func test_K08_strength_is_not_consumed_by_an_action_that_only_heals() -> void:
	_setup()
	var actor: Combatant = s.party_at(1)
	actor.conditions[&"strength"] = 1
	_run(actor, [_e(&"heal", 5)] as Array[EffectDef], [s.party_at(2)] as Array[Combatant])
	assert_eq(actor.stacks(&"strength"), 1)


func test_C20_counter_attack_loop_is_aborted_at_the_limit_with_an_error() -> void:
	_setup()
	var loop := _e(&"loop")
	var events: Array[BattleEvent] = []
	var ctx: EffectContext = c.new_effect_context(s.party_at(1), &"loop_test", [] as Array[Combatant])
	ctx.emit = func(type: StringName, data: Dictionary) -> void: events.append(BattleEvent.create(type, data))
	ctx.queue.register(&"loop", LoopHandler.new())
	ctx.queue.enqueue(ctx, loop)
	assert_false(ctx.queue.process(), "abortada")
	assert_eq(ctx.queue.errors.size(), 1)
	assert_eq(_of(events, EffectQueue.EV_OVERFLOW).size(), 1)
	assert_eq(_of(events, EffectQueue.EV_OVERFLOW)[0].data["limit"], 64)


# --- type and category multipliers ---------------------------------------------------

func test_vulnerable_and_resistant_types() -> void:
	_setup([CombatFixture.enemy(&"flesh", 50, 1, &"corporeal"), CombatFixture.enemy(&"ghost", 50, 1, &"spiritual")] as Array[EnemyDef])
	var flesh: Combatant = s.enemy_at(1)
	var ghost: Combatant = s.enemy_at(2)
	var actor: Combatant = s.party_at(1)
	_run(actor, [_e(&"damage", 8, &"strike")] as Array[EffectDef], [flesh, ghost] as Array[Combatant])
	assert_eq(flesh.max_hp - flesh.hp, 10, "Corpóreo é vulnerável a Golpe")
	assert_eq(ghost.max_hp - ghost.hp, 6, "Espiritual resiste a Golpe")
	_run(actor, [_e(&"damage", 8, &"exorcism")] as Array[EffectDef], [flesh, ghost] as Array[Combatant])
	assert_eq(flesh.max_hp - flesh.hp, 16)
	assert_eq(ghost.max_hp - ghost.hp, 16)


func test_saints_take_no_type_multiplier() -> void:
	_setup()
	var saint: Combatant = s.party_at(1)
	_run(s.enemy_at(1), [_e(&"damage", 8, &"strike")] as Array[EffectDef], [saint] as Array[Combatant])
	assert_eq(saint.max_hp - saint.hp, 8)


func test_saint_armor_reduces_enemy_damage() -> void:
	_setup()
	var saint: Combatant = s.party_at(1)
	saint.armor = 2
	_run(s.enemy_at(1), [_e(&"damage", 5, &"untyped")] as Array[EffectDef], [saint] as Array[Combatant])
	assert_eq(saint.max_hp - saint.hp, 3)


func test_rounding_half_up_happens_once_at_the_end() -> void:
	assert_eq(Damage.round_half_up(2.5), 3)
	assert_eq(Damage.round_half_up(2.4999), 2)
	assert_eq(Damage.round_half_up(37.5), 38)
	_setup([CombatFixture.enemy(&"ghost", 50, 1, &"spiritual")] as Array[EnemyDef])
	var ghost: Combatant = s.enemy_at(1)
	_run(s.party_at(1), [_e(&"damage", 5, &"strike")] as Array[EffectDef], [ghost] as Array[Combatant])
	assert_eq(ghost.max_hp - ghost.hp, 4, "5 × 0,75 = 3,75 → 4")


func test_dead_enemy_mid_action_is_not_hit_again() -> void:
	_setup([CombatFixture.enemy(&"weak", 5), CombatFixture.enemy(&"other")] as Array[EnemyDef])
	var weak: Combatant = s.enemy_at(1)
	var hit: EffectDef = _e(&"damage", 6, &"untyped")
	var events: Array[BattleEvent] = _run(s.party_at(1), [hit, hit] as Array[EffectDef], [weak] as Array[Combatant])
	assert_eq(_of(events, &"damage_dealt").size(), 1)
	assert_eq(_of(events, &"enemy_died").size(), 1)
	assert_eq(s.enemy_at(1).def_id, &"other")


# --- other effect types ----------------------------------------------------------------

func test_heal_caps_at_max_and_raises_fallen_inside_window() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	s.lose_hp(a, 4)
	s.lose_hp(b, 999)
	_run(s.party_at(3), [_e(&"heal", 10)] as Array[EffectDef], [a, b] as Array[Combatant])
	assert_eq(a.hp, a.max_hp)
	assert_true(b.is_standing())
	assert_eq(b.hp, 10)


func test_revive_with_fraction_and_heal_if_alive() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	s.lose_hp(a, 20)
	s.lose_hp(b, 999)
	var rose: EffectDef = _e(&"revive", 0, &"", &"", 0, {"hp_fraction": 0.4, "heal_if_alive": 1.0})
	_run(s.party_at(3), [rose] as Array[EffectDef], [a, b] as Array[Combatant])
	assert_eq(b.hp, 12, "40% de 30")
	assert_eq(a.hp, 22, "10 + 12")


func test_apply_and_remove_conditions() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	_run(s.enemy_at(1), [_e(&"apply_condition", 0, &"", &"bleed", 4), _e(&"apply_condition", 0, &"", &"bleed", 4)] as Array[EffectDef], [a] as Array[Combatant])
	assert_eq(a.stacks(&"bleed"), 5, "limite de pilhas")
	_run(s.party_at(2), [_e(&"remove_condition", 0, &"", &"bleed", 2)] as Array[EffectDef], [a] as Array[Combatant])
	assert_eq(a.stacks(&"bleed"), 3)


func test_remove_negative_by_polarity_follows_display_priority() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	a.conditions = {&"bleed": 2, &"corruption": 1, &"ward": 1}
	var cleanse: EffectDef = _e(&"remove_condition", 0, &"", &"", 2)
	cleanse.polarity = &"negative"
	_run(s.party_at(3), [cleanse] as Array[EffectDef], [a] as Array[Combatant])
	assert_eq(a.conditions, {&"bleed": 1, &"ward": 1}, "Corrupção (prioridade 2) sai antes de Sangramento (3)")


func test_strip_positive_tokens() -> void:
	_setup()
	var enemy: Combatant = s.enemy_at(1)
	enemy.conditions = {&"ward": 2, &"strength": 1, &"bleed": 1}
	_run(s.party_at(1), [_e(&"strip_positive_tokens")] as Array[EffectDef], [enemy] as Array[Combatant])
	assert_eq(enemy.conditions, {&"bleed": 1})


func test_push_and_pull() -> void:
	_setup()
	var first: Combatant = s.enemy_at(1)
	var push: EffectDef = _e(&"move")
	push.move_kind = &"push"
	push.n = 2
	_run(s.party_at(1), [push] as Array[EffectDef], [first] as Array[Combatant])
	assert_eq(s.enemy_slot_of(first), 3)
	var joan: Combatant = s.party_at(2)
	var advance: EffectDef = _e(&"move")
	advance.move_kind = &"pull"
	advance.n = 1
	advance.target_override = &"self"
	_run(joan, [advance] as Array[EffectDef], [s.enemy_at(1)] as Array[Combatant])
	assert_eq(s.party_slot_of(joan), 1)
	assert_false(joan.has_acted, "movimento por efeito não gasta ação")


func test_swap_with_actor_spends_no_action() -> void:
	_setup()
	var john: Combatant = s.party_at(3)
	var ally: Combatant = s.party_at(1)
	var toledo: EffectDef = _e(&"move", 0, &"", &"", 0, {"with": "actor"})
	toledo.move_kind = &"swap"
	toledo.n = 1
	_run(john, [toledo] as Array[EffectDef], [ally] as Array[Combatant])
	assert_eq(s.party_slot_of(john), 1)
	assert_eq(s.party_slot_of(ally), 3)
	assert_false(ally.has_acted)


func test_gain_fervor_respects_extra_limit() -> void:
	_setup()
	_run(s.party_at(1), [_e(&"gain_fervor", 3)] as Array[EffectDef], [] as Array[Combatant])
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_PER_ROUND + CombatFixture.FERVOR_BONUS_CAP)


func test_desolation_and_dark_night_amount() -> void:
	_setup()
	var a: Combatant = s.party_at(1)
	var b: Combatant = s.party_at(2)
	a.desolation = 60
	b.desolation = 60
	b.spirit_state = &"dark_night"
	_run(s.party_at(3), [_e(&"desolation", -25, &"", &"", 0, {"dark_night_amount": -40.0})] as Array[EffectDef], [a, b] as Array[Combatant])
	assert_eq(a.desolation, 35)
	assert_eq(b.desolation, 20)


func test_summon_respects_max_alive_and_free_slots() -> void:
	var swarm := CombatFixture.enemy(&"swarmling", 8)
	_setup([CombatFixture.enemy(&"mother")] as Array[EnemyDef])
	s.catalog.enemies[&"swarmling"] = swarm
	var brood: EffectDef = _e(&"summon")
	brood.summon_id = &"swarmling"
	brood.max_alive = 2
	for i: int in 3:
		_run(s.enemy_at(1), [brood] as Array[EffectDef], [] as Array[Combatant])
	assert_eq(s.enemies.size(), 3, "mãe + 2 enxames (máximo 2 vivos)")
	brood.max_alive = 5
	for i: int in 3:
		_run(s.enemy_at(1), [brood] as Array[EffectDef], [] as Array[Combatant])
	assert_eq(s.occupied_enemy_slots(), 4, "sem posição livre, não invoca")


func test_self_damage_fraction_is_a_cost() -> void:
	_setup()
	var pio: Combatant = s.party_at(2)
	pio.armor = 3
	pio.conditions[&"ward"] = 1
	_run(pio, [_e(&"self_damage", 0, &"", &"", 0, {"hp_fraction": 0.15})] as Array[EffectDef], [] as Array[Combatant])
	assert_eq(pio.hp, 30 - 5, "15% de 30 = 4,5 → 5, sem armadura nem Amparo")
	assert_true(pio.has_condition(&"ward"))


func test_target_overrides() -> void:
	_setup()
	var sebastian: Combatant = s.party_at(1)
	var wall: Array[EffectDef] = [
		_e(&"apply_condition", 0, &"", &"ward", 3),
		_e(&"apply_condition", 0, &"", &"ward", 1, {"exclude_self": 1.0}),
	]
	wall[0].target_override = &"self"
	wall[1].target_override = &"all_allies"
	_run(sebastian, wall, [sebastian] as Array[Combatant])
	assert_eq(sebastian.stacks(&"ward"), 3)
	assert_eq(s.party_at(2).stacks(&"ward"), 1)
	assert_eq(s.party_at(3).stacks(&"ward"), 1)
	var flame: EffectDef = _e(&"damage", 5, &"untyped")
	flame.target_override = &"all_enemies"
	_run(s.party_at(2), [flame] as Array[EffectDef], [s.party_at(1)] as Array[Combatant])
	for enemy: Combatant in s.enemies:
		assert_eq(enemy.hp, enemy.max_hp - 5)


# --- through a real command --------------------------------------------------------------

func test_use_ability_command_applies_its_effects_in_order() -> void:
	_setup([CombatFixture.enemy(&"target", 30)] as Array[EnemyDef])
	var bash: AbilityDef = s.catalog.ability(&"strike")
	bash.effects = [_e(&"damage", 4, &"untyped"), _e(&"apply_condition", 0, &"", &"stun", 1)] as Array[EffectDef]
	var result: CommandResult = c.execute(BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int]))
	assert_true(result.ok)
	var types: Array[StringName] = []
	for e: BattleEvent in result.events:
		types.append(e.type)
	assert_eq(types, [BattleController.EV_ABILITY_USED, &"damage_dealt", &"condition_applied"] as Array[StringName])
	assert_eq(s.enemy_at(1).hp, 26)
	assert_true(s.enemy_at(1).has_condition(&"stun"))


func test_killing_the_last_enemy_wins_immediately() -> void:
	_setup([CombatFixture.enemy(&"last", 3)] as Array[EnemyDef])
	s.catalog.ability(&"strike").effects = [_e(&"damage", 10, &"untyped")] as Array[EffectDef]
	c.execute(BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int]))
	assert_eq(c.phase, BattleController.Phase.VICTORY)


func test_provision_effects_apply_to_target() -> void:
	c = BattleController.new(CombatFixture.battle([], [&"bread"] as Array[StringName]))
	s = c.state
	c.start()
	s.catalog.provision(&"bread").effects = [_e(&"heal", 5)] as Array[EffectDef]
	var b: Combatant = s.party_at(2)
	s.lose_hp(b, 10)
	assert_true(c.execute(BattleCommand.use_provision(&"bread", 2, &"saint_a")).ok)
	assert_eq(b.hp, b.max_hp - 5)
