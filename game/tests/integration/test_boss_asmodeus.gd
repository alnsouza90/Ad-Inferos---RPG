extends GutTest
## T41: Asmodeus (bosses.md §5) with the real data: phases, several actions a
## round, the Domínio, his own Vendaval, the liver and Raphael. Cases B09 to
## B13 of bosses.md §7.

const SEED: int = 9

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _state(claws: Array[StringName], liver: bool, seed: int = SEED) -> BattleState:
	var enc: EncounterDef = data.encounters[&"c02_boss_asmodeus"]
	var foes: Array[EnemyDef] = []
	for id: StringName in enc.slots:
		foes.append(data.catalog.enemies[id])
	var state := BattleState.create(data.catalog, data.m0_party(), foes, [] as Array[StringName], enc.type, seed)
	state.hazard = enc.hazard
	state.setup_boss(claws, liver)
	return state


func _ctrl(claws: Array[StringName], liver: bool = false, seed: int = SEED) -> BattleController:
	var c := BattleController.new(_state(claws, liver, seed))
	c.start()
	return c


func _events(c: BattleController, type: StringName) -> Array[BattleEvent]:
	return c.history.filter(func(e: BattleEvent) -> bool: return e.type == type)


func _win(c: BattleController) -> void:
	for e: Combatant in c.state.enemies:
		e.hp = 0
		e.state = Combatant.State.DEAD
	c._check_outcome()


func test_B09_with_three_claws_two_shades_two_actions_and_three_phases() -> void:
	var c: BattleController = _ctrl(Dominion.claws(0, false))
	var boss: Combatant = c.state.boss()
	assert_eq(boss.def_id, &"boss_asmodeus")
	var shades: int = c.state.enemies.filter(func(e: Combatant) -> bool: return e.def_id == &"enemy_shade_of_desire").size()
	assert_eq(shades, 2, "escolta de 2 Sombras")
	assert_eq(c.state.boss_actions_per_round(boss), 2, "age 2 vezes")
	assert_eq(c.state.intents_of(boss).size(), 2, "duas intenções, cada uma visível")
	assert_ne(c.state.intents_of(boss)[0].action_id, c.state.intents_of(boss)[1].action_id, "ações diferentes")
	assert_eq(c.state.boss_phase_count(), 3, "3 fases")


func test_B10_each_reach_yields_a_claw_in_order_and_the_liver_the_extra_phase() -> void:
	assert_eq(Dominion.claws(0, false), [Dominion.ESCORT, Dominion.EXTRA_ACTION, Dominion.EXTRA_PHASE] as Array[StringName])
	assert_eq(Dominion.claws(1, false), [Dominion.EXTRA_ACTION, Dominion.EXTRA_PHASE] as Array[StringName], "1º alcance: escolta")
	assert_eq(Dominion.claws(2, false), [Dominion.EXTRA_PHASE] as Array[StringName], "2º alcance: ação a mais")
	assert_eq(Dominion.claws(0, true), [Dominion.ESCORT, Dominion.EXTRA_ACTION] as Array[StringName], "o fígado: fase extra")
	assert_eq(Dominion.claws(2, true), [] as Array[StringName], "Domínio a 0 com os três")
	var c: BattleController = _ctrl(Dominion.claws(2, true))
	assert_eq(c.state.enemies.size(), 1, "sem escolta")
	assert_eq(c.state.boss_actions_per_round(c.state.boss()), 1)
	assert_eq(c.state.boss_phase_count(), 2, "2 fases")


func test_the_phase_follows_the_hp_and_never_goes_back() -> void:
	var c: BattleController = _ctrl(Dominion.claws(0, false))
	var boss: Combatant = c.state.boss()
	boss.hp = int(boss.max_hp * 0.6)
	c._check_outcome()
	assert_eq(c.state.boss_phase, 2, "abaixo de 66%: fase 2")
	boss.hp = int(boss.max_hp * 0.3)
	c._check_outcome()
	assert_eq(c.state.boss_phase, 3)
	assert_eq(_events(c, BattleController.EV_BOSS_PHASE).size(), 2)
	boss.hp = boss.max_hp
	c._check_outcome()
	assert_eq(c.state.boss_phase, 3, "não volta")


## D-410 (Alan): the Encanto from phase 1, the three heads from phase 2.
func test_the_encanto_comes_in_phase_1_and_the_three_heads_in_phase_2() -> void:
	var c: BattleController = _ctrl(Dominion.claws(2, true))
	var boss: Combatant = c.state.boss()
	c.state.round_number = 1
	EnemyBrain.choose_intents(c.state)
	assert_eq(c.state.intents_of(boss)[0].action_id, &"asmodeus_enchant", "Encanto já na fase 1")
	boss.cooldowns[&"asmodeus_enchant"] = 99
	boss.cooldowns[&"asmodeus_breath"] = 99
	EnemyBrain.choose_intents(c.state)
	assert_eq(c.state.intents_of(boss)[0].action_id, &"asmodeus_lance", "na fase 1, sem Três cabeças")
	c.state.boss_phase = 2
	EnemyBrain.choose_intents(c.state)
	assert_eq(c.state.intents_of(boss)[0].action_id, &"asmodeus_three_heads", "Três cabeças na fase 2")


func test_with_the_liver_there_are_only_two_phases() -> void:
	var two: BattleController = _ctrl(Dominion.claws(0, true))
	two.state.boss().hp = 1
	two._check_outcome()
	assert_eq(two.state.boss_phase, 2, "com o fígado, só 2 fases")


func test_three_heads_strike_three_times() -> void:
	var c: BattleController = _ctrl(Dominion.claws(2, true))
	var boss: Combatant = c.state.boss()
	var action: EnemyActionDef = EnemyBrain.action_of(c.state, boss, &"asmodeus_three_heads")
	var before: int = c.history.size()
	c.resolve_effects(boss, action.id, action.effects, EnemyBrain.valid_party_targets(c.state, action))
	var hits: int = c.history.slice(before).filter(func(e: BattleEvent) -> bool: return e.type == &"damage_dealt").size()
	assert_eq(hits, 3, "3 golpes em santos ao acaso")


func test_B11_with_the_liver_raphael_binds_him_and_the_smoke_opens_the_fight() -> void:
	var c: BattleController = _ctrl(Dominion.claws(0, true), true)
	assert_eq(_events(c, BattleController.EV_LIVER_SMOKE).size(), 1, "a fumaça abre a luta")
	_win(c)
	var ends: Array[BattleEvent] = _events(c, BattleController.EV_BOSS_DEFEATED)
	assert_eq(ends.size(), 1)
	assert_true(bool(ends[0].data["bound"]), "Rafael prende Asmodeu")
	assert_eq(c.phase, BattleController.Phase.VICTORY)


func test_B11_without_the_liver_asmodeus_flees_and_the_victory_is_the_same() -> void:
	var c: BattleController = _ctrl(Dominion.claws(0, false))
	assert_eq(_events(c, BattleController.EV_LIVER_SMOKE).size(), 0)
	_win(c)
	assert_false(bool(_events(c, BattleController.EV_BOSS_DEFEATED)[0].data["bound"]), "Asmodeu foge")
	assert_eq(c.phase, BattleController.Phase.VICTORY)


func test_B12_no_circle_vendaval_and_no_retreat() -> void:
	var c: BattleController = _ctrl(Dominion.claws(0, false))
	assert_eq(c.state.hazard, &"", "sem o Vendaval do círculo")
	assert_true(c.state.gale_slots.is_empty(), "na fase 1 Asmodeu não sopra")
	assert_eq(c.execute(BattleCommand.retreat()).reason, CommandResult.RETREAT_NOT_ALLOWED)


func test_B12_standing_firm_against_the_vendaval_of_asmodeus() -> void:
	var c: BattleController = _ctrl(Dominion.claws(2, true))
	c.state.boss_phase = 2
	c.state.round_number = 2
	c.state.intents.clear()
	EnemyBrain.choose_intents(c.state)
	assert_eq(c.state.intents_of(c.state.boss())[0].action_id, &"asmodeus_gale", "na fase 2, a cada 2 rodadas")
	c._mark_boss_gale()
	var slots: Array[int] = c.state.gale_slots.duplicate()
	assert_eq(slots.size(), 2, "a intenção mostra os dois santos")
	var a: Combatant = c.state.party_at(slots[0])
	assert_true(c.execute(BattleCommand.stand_firm(a.id)).ok, "Firmar o pé vale contra ele")
	assert_eq(c.state.firmness_pending, 1, "e dá Firmeza")
	c.end_party_turn()
	if c.is_over():
		pass_test("combate acabou")
		return
	assert_eq(c.state.party_slot_of(a), slots[0], "a troca não aconteceu")


func test_B12_the_vendaval_of_asmodeus_swaps_in_his_turn() -> void:
	var c: BattleController = _ctrl(Dominion.claws(2, true))
	c.state.boss_phase = 2
	c.state.round_number = 2
	c.state.intents.clear()
	EnemyBrain.choose_intents(c.state)
	c._mark_boss_gale()
	var slots: Array[int] = c.state.gale_slots.duplicate()
	var a: Combatant = c.state.party_at(slots[0])
	var boss: Combatant = c.state.boss()
	c._execute_intent(boss, c.state.intents_of(boss)[0])
	assert_eq(c.state.party_slot_of(a), slots[1], "trocados no turno do chefe")
	assert_true(c.state.gale_slots.is_empty())


func test_B13_same_seed_and_log_give_the_same_fight_byte_by_byte() -> void:
	var first: BattleController = _ctrl(Dominion.claws(0, false))
	for i: int in 60:
		if first.is_over():
			break
		first.execute(FirstValidPolicy.choose(first))
	var again: BattleController = _ctrl(Dominion.claws(0, false))
	for entry: Dictionary in first.command_log:
		again.execute(BattleCommand.from_dict(entry))
	assert_eq(JSON.stringify(again.state.to_dict()), JSON.stringify(first.state.to_dict()))
	assert_eq(again.history.size(), first.history.size())
