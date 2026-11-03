extends GutTest
## T10: M0 traits (Duel, Clausura, Little Way) and affinities (combat §12).
## K12 and K13 (Duel condition) are in tests/unit/conditions/test_condition_engine.gd.

var c: BattleController
var s: BattleState


## Saints a, b, c in slots 1, 2, 3 with the given traits and affinities.
func _setup(traits: Array = [null, null, null], affinities: Array = [[], [], []], enemy_defs: Array[EnemyDef] = []) -> void:
	var saints: Array[SaintDef] = []
	for i: int in 3:
		var d := CombatFixture.kit_saint(StringName("saint_" + "abc"[i]))
		d.trait_def = traits[i]
		for a: StringName in affinities[i]:
			d.affinities.append(a)
		saints.append(d)
	if enemy_defs.is_empty():
		enemy_defs = [CombatFixture.enemy(&"e1", 60), CombatFixture.enemy(&"e2", 60)]
	c = BattleController.new(BattleState.create(CombatFixture.catalog(), saints, enemy_defs))
	s = c.state
	c.start()


func _hit(actor: Combatant, target: Combatant, amount: float, type: StringName = &"untyped") -> void:
	c.resolve_effects(actor, &"hit", [CombatFixture.effect(&"damage", amount, type)] as Array[EffectDef], [target] as Array[Combatant])


# --- Duel (Saint George) ------------------------------------------------------------------

func test_duel_trait_marks_the_first_enemy_hit_in_the_battle() -> void:
	_setup([CombatFixture.trait_def(&"duel_auto_mark", {"first_hit_marks": 1.0}), null, null])
	var george: Combatant = s.party_at(1)
	_hit(george, s.enemy_at(2), 4)
	assert_true(s.enemy_at(2).has_condition(&"duel"))
	assert_eq(s.enemy_at(2).condition_sources[&"duel"], george.id)
	_hit(george, s.enemy_at(1), 4)
	assert_false(s.enemy_at(1).has_condition(&"duel"), "só o primeiro")
	assert_true(s.enemy_at(2).has_condition(&"duel"))


func test_duel_trait_does_not_mark_an_enemy_killed_by_the_first_hit() -> void:
	_setup([CombatFixture.trait_def(&"duel_auto_mark"), null, null], [[], [], []], [CombatFixture.enemy(&"weak", 3), CombatFixture.enemy(&"next", 40)] as Array[EnemyDef])
	var george: Combatant = s.party_at(1)
	_hit(george, s.enemy_at(1), 10)
	_hit(george, s.enemy_at(1), 2)
	assert_false(s.enemy_at(1).has_condition(&"duel"), "a marca era do primeiro golpe")


func test_other_saints_do_not_mark_duel() -> void:
	_setup()
	_hit(s.party_at(1), s.enemy_at(1), 4)
	assert_false(s.enemy_at(1).has_condition(&"duel"))


# --- Clausura (Saint Benedict) --------------------------------------------------------------

func _clausura_setup() -> void:
	_setup([null, CombatFixture.trait_def(&"clausura", {"adjacent_desolation_mult": 0.8, "adjacent_move_immune": 1.0}), null])


func test_clausura_allies_next_to_benedict_take_20_percent_less_desolation() -> void:
	_clausura_setup()
	s.add_desolation(s.party_at(1), 10)
	s.add_desolation(s.party_at(2), 10)
	assert_eq(s.party_at(1).desolation, 8, "vizinho de Bento")
	assert_eq(s.party_at(2).desolation, 10, "o próprio Bento não")


func test_clausura_stops_enemy_displacement_of_adjacent_allies() -> void:
	_clausura_setup()
	var a: Combatant = s.party_at(1)
	var push := CombatFixture.effect(&"move")
	push.move_kind = &"push"
	push.n = 1
	c.resolve_effects(s.enemy_at(1), &"gust", [push] as Array[EffectDef], [a] as Array[Combatant])
	assert_eq(s.party_slot_of(a), 1)


func test_clausura_blocks_pushing_benedict_into_a_protected_ally() -> void:
	_clausura_setup()
	var benedict: Combatant = s.party_at(2)
	var push := CombatFixture.effect(&"move")
	push.move_kind = &"push"
	push.n = 1
	c.resolve_effects(s.enemy_at(1), &"gust", [push] as Array[EffectDef], [benedict] as Array[Combatant])
	assert_eq(s.party_slot_of(benedict), 2, "trocar de lugar deslocaria o vizinho protegido")


func test_clausura_still_allows_party_movement_and_voluntary_swaps() -> void:
	_clausura_setup()
	var a: Combatant = s.party_at(1)
	var pull := CombatFixture.effect(&"move")
	pull.move_kind = &"push"
	pull.n = 1
	c.resolve_effects(s.party_at(3), &"ally_move", [pull] as Array[EffectDef], [a] as Array[Combatant])
	assert_eq(s.party_slot_of(a), 2, "habilidade de aliado move")
	assert_true(c.execute(BattleCommand.swap_slots(&"saint_a", -1)).ok, "troca voluntária")


func test_clausura_stops_when_benedict_falls() -> void:
	_clausura_setup()
	s.lose_hp(s.party_at(2), 999)
	var a: Combatant = s.party_at(1)
	var before: int = a.desolation
	s.add_desolation(a, 10)
	assert_eq(a.desolation - before, 10)


# --- Little Way (Saint Therese) ----------------------------------------------------------------

func _little_way_setup() -> Combatant:
	_setup([null, null, CombatFixture.trait_def(&"little_way_counter", {"basic_actions": 3.0})])
	var therese: Combatant = s.party_at(3)
	var heal_one: AbilityDef = s.catalog.ability(&"costly")
	heal_one.targeting = &"ally"
	heal_one.target_slots = [1, 2, 3] as Array[int]
	heal_one.allow_self = true
	heal_one.effects = [CombatFixture.effect(&"heal", 3)] as Array[EffectDef]
	return therese


func _basic_rounds(n: int) -> void:
	for i: int in n:
		assert_true(c.execute(BattleCommand.use_ability(&"saint_c", &"guard_self")).ok)
		c.end_party_turn()


func test_little_way_three_basics_make_the_next_paid_heal_free() -> void:
	var therese: Combatant = _little_way_setup()
	_basic_rounds(3)
	var fervor_before: int = c.fervor.amount
	var result: CommandResult = c.execute(BattleCommand.use_ability(&"saint_c", &"costly", [1] as Array[int]))
	assert_true(result.ok)
	assert_eq(c.fervor.amount, fervor_before, "cura de custo 1 saiu de graça")
	assert_eq(int(therese.trait_counters["little_way"]), 0)
	assert_true(result.events.any(func(e: BattleEvent) -> bool: return e.type == &"little_way_used"))


func test_little_way_not_ready_after_two_basics() -> void:
	_little_way_setup()
	_basic_rounds(2)
	var before: int = c.fervor.amount
	c.execute(BattleCommand.use_ability(&"saint_c", &"costly", [1] as Array[int]))
	assert_eq(c.fervor.amount, before - 1)


func test_little_way_is_kept_by_a_free_heal_and_never_applies_to_the_miracle() -> void:
	_little_way_setup()
	_basic_rounds(3)
	var heal_free: AbilityDef = s.catalog.ability(&"heal_any")
	heal_free.effects = [CombatFixture.effect(&"heal", 2)] as Array[EffectDef]
	assert_true(c.execute(BattleCommand.use_ability(&"saint_c", &"heal_any", [1] as Array[int])).ok)
	assert_true(int(s.party_at(3).trait_counters["little_way"]) >= 3, "Pétala (custo 0) não gasta o bônus")
	var miracle: AbilityDef = s.catalog.ability(&"miracle_two")
	miracle.effects = [CombatFixture.effect(&"heal", 5)] as Array[EffectDef]
	assert_eq(c.effective_cost(s.party_at(3), miracle), miracle.cost, "milagre nunca sai de graça")


func test_little_way_counts_only_basics_of_its_owner() -> void:
	_little_way_setup()
	c.fervor.amount = 6
	c.execute(BattleCommand.use_ability(&"saint_c", &"rally"))
	assert_eq(int(s.party_at(3).trait_counters.get("little_way", 0)), 0, "habilidade de Fervor não conta")
	c.execute(BattleCommand.use_ability(&"saint_a", &"guard_self"))
	assert_eq(int(s.party_at(3).trait_counters.get("little_way", 0)), 0, "básica de outro santo não conta")


# --- affinities -------------------------------------------------------------------------------------

func test_affinity_needs_two_members_and_fallen_members_count() -> void:
	_setup([null, null, null], [[&"soldiers"], [], []])
	assert_false(s.active_affinities.has(&"soldiers"))
	_setup([null, null, null], [[&"soldiers"], [&"soldiers"], []])
	assert_true(s.active_affinities.has(&"soldiers"))


func test_soldiers_strike_bonus_only_for_members() -> void:
	_setup([null, null, null], [[&"soldiers"], [&"soldiers"], []], [CombatFixture.enemy(&"ghost", 60, 1, &"spiritual"), CombatFixture.enemy(&"ghost2", 60, 1, &"spiritual")] as Array[EnemyDef])
	_hit(s.party_at(1), s.enemy_at(1), 20, &"strike")
	assert_eq(s.enemy_at(1).max_hp - s.enemy_at(1).hp, 17, "20 × 0,75 × 1,1 = 16,5 → 17")
	_hit(s.party_at(3), s.enemy_at(2), 20, &"strike")
	assert_eq(s.enemy_at(2).max_hp - s.enemy_at(2).hp, 15, "não membro: 20 × 0,75")


func test_monastics_exorcism_bonus() -> void:
	_setup([null, null, null], [[&"monastics"], [&"monastics"], []], [CombatFixture.enemy(&"flesh", 60, 1, &"corporeal")] as Array[EnemyDef])
	_hit(s.party_at(1), s.enemy_at(1), 20, &"exorcism")
	assert_eq(s.enemy_at(1).max_hp - s.enemy_at(1).hp, 17)
	_hit(s.party_at(1), s.enemy_at(1), 20, &"strike")
	assert_eq(s.enemy_at(1).max_hp - s.enemy_at(1).hp, 17 + 25, "Golpe sem bônus monástico")


func test_carmel_reduces_desolation_of_members() -> void:
	_setup([null, null, null], [[&"carmel"], [], [&"carmel"]])
	s.add_desolation(s.party_at(1), 20)
	s.add_desolation(s.party_at(2), 20)
	assert_eq(s.party_at(1).desolation, 17, "20 × 0,85")
	assert_eq(s.party_at(2).desolation, 20)


func test_franciscans_give_one_extra_fervor_in_round_1_only() -> void:
	_setup([null, null, null], [[&"franciscans"], [&"franciscans"], []])
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_PER_ROUND + 1)
	assert_eq(c.fervor.bonus_gained_this_round, 1, "conta no limite extra")
	c.fervor.spend(c.fervor.amount)
	c.end_party_turn()
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_PER_ROUND)
