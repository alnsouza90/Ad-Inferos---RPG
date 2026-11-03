extends GutTest
## T04: round structure (combat §3).


func _types(events: Array[BattleEvent]) -> Array[StringName]:
	var result: Array[StringName] = []
	for e: BattleEvent in events:
		result.append(e.type)
	return result


func _controller(enemy_defs: Array[EnemyDef] = []) -> BattleController:
	return BattleController.new(CombatFixture.battle(enemy_defs))


func test_start_runs_round_1_until_party_turn() -> void:
	var c := _controller()
	var events: Array[BattleEvent] = c.start()
	assert_eq(c.phase, BattleController.Phase.PARTY_TURN)
	assert_eq(c.state.round_number, 1)
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_PER_ROUND, "começa em 0 e ganha a base")
	assert_eq(_types(events), [
		BattleController.EV_BATTLE_STARTED,
		BattleController.EV_ROUND_STARTED,
		BattleController.EV_FERVOR_GAINED,
		BattleController.EV_INTENTS_CHOSEN,
		BattleController.EV_ROUND_START_CONDITIONS,
		BattleController.EV_PARTY_TURN_STARTED,
		BattleController.EV_PARTY_TURN_CONDITIONS,
	] as Array[StringName])


func test_full_round_without_abilities_runs_every_step_in_order() -> void:
	var enemy_defs: Array[EnemyDef] = [CombatFixture.enemy(&"enemy_1"), CombatFixture.enemy(&"enemy_2")]
	var c := _controller(enemy_defs)
	c.start()
	var events: Array[BattleEvent] = c.end_party_turn()
	assert_eq(_types(events), [
		BattleController.EV_PARTY_TURN_ENDED,
		BattleController.EV_ENEMY_TURN_STARTED,
		BattleController.EV_ENEMY_TURN_CONDITIONS,
		BattleController.EV_ENEMY_ACTION,
		BattleController.EV_ENEMY_TURN_CONDITIONS,
		BattleController.EV_ENEMY_ACTION,
		BattleController.EV_HAZARD,
		BattleController.EV_CONDITIONS_DECAYED,
		BattleController.EV_FALLS_COUNTED,
		BattleController.EV_ROUND_STARTED,
		BattleController.EV_FERVOR_GAINED,
		BattleController.EV_INTENTS_CHOSEN,
		BattleController.EV_ROUND_START_CONDITIONS,
		BattleController.EV_PARTY_TURN_STARTED,
		BattleController.EV_PARTY_TURN_CONDITIONS,
	] as Array[StringName])
	assert_eq(c.state.round_number, 2)
	assert_eq(c.phase, BattleController.Phase.PARTY_TURN)


func test_enemies_act_from_slot_1_to_4() -> void:
	var c := _controller()
	c.start()
	var slots: Array[int] = []
	for e: BattleEvent in c.end_party_turn():
		if e.type == BattleController.EV_ENEMY_ACTION:
			slots.append(int(e.data["slot"]))
	assert_eq(slots, [1, 2, 3, 4] as Array[int])


func test_fervor_leftover_carries_to_next_round() -> void:
	var c := _controller()
	c.start()
	c.fervor.spend(1)
	c.end_party_turn()
	assert_eq(c.fervor.amount, 2 + CombatFixture.FERVOR_PER_ROUND)


func test_acted_flags_reset_each_round() -> void:
	var c := _controller()
	c.start()
	c.state.party_at(1).has_acted = true
	c.end_party_turn()
	for saint: Combatant in c.state.party:
		assert_false(saint.has_acted)


func test_end_party_turn_outside_party_turn_does_nothing() -> void:
	var c := _controller()
	assert_eq(c.end_party_turn(), [] as Array[BattleEvent], "antes de start()")
	assert_eq(c.phase, BattleController.Phase.SETUP)


func test_fallen_saint_window_counted_at_round_end() -> void:
	var c := _controller()
	c.start()
	var b: Combatant = c.state.party_at(2)
	c.state.lose_hp(b, 999)
	c.end_party_turn()
	assert_true(b.is_fallen())
	c.end_party_turn()
	assert_true(b.is_out())


func test_defeat_ends_battle_and_resets_fervor() -> void:
	var c := _controller()
	c.start()
	for saint: Combatant in c.state.party:
		c.state.lose_hp(saint, 999)
	var events: Array[BattleEvent] = c.end_party_turn()
	assert_eq(c.phase, BattleController.Phase.DEFEAT)
	assert_true(c.is_over())
	assert_eq(c.fervor.amount, 0)
	assert_eq(events.back().type, BattleController.EV_BATTLE_ENDED)
	assert_eq(events.back().data["result"], &"defeat")
	assert_eq(c.end_party_turn(), [] as Array[BattleEvent], "combate encerrado")


func test_victory_when_all_enemies_die() -> void:
	var enemy_defs: Array[EnemyDef] = [CombatFixture.enemy(&"only")]
	var c := _controller(enemy_defs)
	c.start()
	c.state.lose_hp(c.state.enemy_at(1), 999)
	c.end_party_turn()
	assert_eq(c.phase, BattleController.Phase.VICTORY)


func test_events_signal_carries_each_batch() -> void:
	var c := _controller()
	watch_signals(c)
	c.start()
	assert_signal_emitted(c, "events_emitted")
	assert_eq(c.history.size(), 7)
