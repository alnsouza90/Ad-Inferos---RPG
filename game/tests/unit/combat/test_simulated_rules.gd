extends GutTest
## T61: the rules being simulated (D-268 to D-271, D-285) live in core but
## stay off until their numbers are in constants.csv (D-363). The simulator
## turns them on in memory. These tests check both: off by default, and the
## rule itself when its numbers are given.

var c: BattleController


func before_each() -> void:
	c = BattleController.new(CombatFixture.battle())
	c.start()


func _put(key: String, value: float) -> void:
	c.state.constants.values[key] = value


func test_every_simulated_rule_is_off_without_its_numbers() -> void:
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 2)).reason, CommandResult.RULE_OFF)
	assert_eq(c.execute(BattleCommand.give_consolation(&"saint_a", 2)).reason, CommandResult.RULE_OFF)
	assert_eq(c.state.prepared_bonus(c.state.party_at(1)), 0.0)
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 20, "sem a regra por rodadas, o valor fixo vale")


func test_intercede_moves_desolation_without_multipliers() -> void:
	_put("intercede_amount", 15)
	var a: Combatant = c.state.party_at(1)
	var b: Combatant = c.state.party_at(2)
	b.desolation = 40
	c.state.light = 0  # the lowest Lume band multiplies gains: Interceder ignores it
	assert_true(c.execute(BattleCommand.intercede(a.id, 2)).ok)
	assert_eq(b.desolation, 25, "o aliado perde o valor")
	assert_eq(a.desolation, 15, "quem intercede recebe o mesmo valor, sem multiplicador")
	assert_true(a.has_acted, "gasta a ação")
	assert_eq(c.state.helped_by.get(b.id, []), [a.id], "conta como ajuda para o teste de Fé")


func test_intercede_takes_at_most_what_the_ally_has() -> void:
	_put("intercede_amount", 15)
	c.state.party_at(2).desolation = 6
	assert_true(c.execute(BattleCommand.intercede(&"saint_a", 2)).ok)
	assert_eq(c.state.party_at(2).desolation, 0)
	assert_eq(c.state.party_at(1).desolation, 6)


func test_intercede_needs_an_other_standing_ally_with_desolation() -> void:
	_put("intercede_amount", 15)
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 1)).reason, CommandResult.INVALID_TARGET)
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 2)).reason, CommandResult.NOTHING_TO_TAKE)


func test_gift_of_consolation_purifies_a_dark_night_and_the_giver_goes_back_to_normal() -> void:
	_put("consolation_gift_desolation", 30)
	var a: Combatant = c.state.party_at(1)
	var b: Combatant = c.state.party_at(2)
	assert_eq(c.execute(BattleCommand.give_consolation(a.id, 2)).reason, CommandResult.NOT_IN_CONSOLATION)
	a.spirit_state = Desolation.CONSOLATION
	b.spirit_state = Desolation.DARK_NIGHT
	b.desolation = 90
	assert_true(c.execute(BattleCommand.give_consolation(a.id, 2)).ok)
	assert_eq(b.spirit_state, Desolation.NORMAL, "Purificação")
	assert_true(b.purified)
	assert_eq(a.spirit_state, Desolation.NORMAL, "quem deu volta ao normal")


func test_gift_of_consolation_lowers_desolation_of_a_normal_ally() -> void:
	_put("consolation_gift_desolation", 30)
	c.state.party_at(1).spirit_state = Desolation.CONSOLATION
	c.state.party_at(2).desolation = 70
	assert_true(c.execute(BattleCommand.give_consolation(&"saint_a", 2)).ok)
	assert_eq(c.state.party_at(2).desolation, 40)


func test_prepared_faith_test_adds_per_ally_with_a_maximum_and_the_vigil() -> void:
	_put("faith_prepared_per_ally", 0.05)
	_put("faith_prepared_ally_max", 0.1)
	_put("faith_prepared_vigil", 0.05)
	_put("faith_prepared_cap", 0.7)
	var a: Combatant = c.state.party_at(1)
	c.state.note_help(a, c.state.party_at(2))
	assert_almost_eq(c.state.prepared_bonus(a), 0.05, 0.0001)
	c.state.note_help(a, c.state.party_at(3))
	c.state.note_help(a, c.state.party_at(3))
	assert_almost_eq(c.state.prepared_bonus(a), 0.1, 0.0001, "o mesmo aliado conta uma vez; máximo de +10%")
	c.state.vigil_saints.append(a.id)
	assert_almost_eq(c.state.prepared_bonus(a), 0.15, 0.0001, "Vigília soma +5%")
	a.faith = 20
	var chance: float = Desolation.faith_chance(a, c.state.desolation_context(a))
	assert_almost_eq(chance, 0.7, 0.0001, "com preparo, o teto sobe para 70%")


func test_battle_end_desolation_by_rounds() -> void:
	_put("desolation_battle_end_base", 8)
	_put("desolation_battle_end_per_round", 3)
	c.state.round_number = 2
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 8, "até a 2ª rodada, só a base")
	c.state.round_number = 5
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 8 + 3 * 3, "+3 por rodada a partir da 3ª")
