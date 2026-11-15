extends GutTest
## T62 (D-396): the rules chosen after the simulation of T61 — Interceder
## (D-268), the gift of Consolation (D-285), the preparation of the Faith
## test (D-270) and the battle-end desolation by rounds (D-269). The fixture
## has none of their constants, so each test turns on the approved numbers it
## needs; the last test checks that the real data has them all.

var c: BattleController


func before_each() -> void:
	c = BattleController.new(CombatFixture.battle())
	c.start()


func _put(key: String, value: float) -> void:
	c.state.constants.values[key] = value


func _put_approved() -> void:
	_put("intercede_amount", 15)
	_put("consolation_gift_desolation", 30)
	_put("faith_prepared_per_ally", 0.05)
	_put("faith_prepared_ally_max", 0.1)
	_put("faith_prepared_vigil", 0.05)
	_put("faith_prepared_cap", 0.7)
	_put("desolation_battle_end_base", 20)
	_put("desolation_battle_end_per_round", 3)
	_put("desolation_battle_end_from_round", 1)


func _entry(entries: Array[PreviewEntry], id: StringName) -> PreviewEntry:
	for e: PreviewEntry in entries:
		if e.target_id == id:
			return e
	return null


func test_every_rule_is_off_without_its_numbers() -> void:
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 2)).reason, CommandResult.RULE_OFF)
	assert_eq(c.execute(BattleCommand.give_consolation(&"saint_a", 2)).reason, CommandResult.RULE_OFF)
	assert_eq(c.state.prepared_bonus(c.state.party_at(1)), 0.0)
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 20, "sem a regra por rodadas, o valor fixo vale")


func test_the_real_data_has_every_approved_number() -> void:
	var real: ConstantsDef = RealData.catalog().constants
	var approved: Dictionary = {
		"desolation_battle_end_base": 20, "desolation_battle_end_per_round": 3, "desolation_battle_end_from_round": 1,
		"intercede_amount": 15, "fidelity_marks": 3, "fidelity_reset_value": 50,
		"faith_prepared_per_ally": 0.05, "faith_prepared_ally_max": 0.1, "faith_prepared_vigil": 0.05,
		"faith_prepared_cap": 0.7, "consolation_gift_desolation": 30,
	}
	for key: String in approved:
		assert_almost_eq(real.get_float(StringName(key)), float(approved[key]), 0.0001, key)
	assert_false(real.has_key(&"consolation_gift_revive_hp"), "levantar um Caído espera o número de Alan")


# --- Interceder ------------------------------------------------------------------

func test_intercede_moves_15_desolation_without_multipliers() -> void:
	_put_approved()
	var a: Combatant = c.state.party_at(1)
	var b: Combatant = c.state.party_at(2)
	b.desolation = 40
	c.state.light = 0  # the lowest Lume band multiplies gains: Interceder ignores it
	assert_true(c.execute(BattleCommand.intercede(a.id, 2)).ok)
	assert_eq(b.desolation, 25, "o aliado perde 15")
	assert_eq(a.desolation, 15, "quem intercede recebe os mesmos 15, sem multiplicador")
	assert_true(a.has_acted, "gasta a ação")
	assert_eq(c.fervor.amount, c.clone().fervor.amount, "sem Fervor")
	assert_eq(c.state.helped_by.get(b.id, []), [a.id], "conta como ajuda para o teste de Fé")


func test_intercede_skips_the_consolation_multiplier_too() -> void:
	_put_approved()
	var a: Combatant = c.state.party_at(1)
	a.spirit_state = Desolation.CONSOLATION
	c.state.party_at(2).desolation = 40
	assert_true(c.execute(BattleCommand.intercede(a.id, 2)).ok)
	assert_eq(a.desolation, 15, "a Consolação não apaga a metade (desolation §8)")


func test_intercede_takes_at_most_what_the_ally_has() -> void:
	_put_approved()
	c.state.party_at(2).desolation = 6
	assert_true(c.execute(BattleCommand.intercede(&"saint_a", 2)).ok)
	assert_eq(c.state.party_at(2).desolation, 0)
	assert_eq(c.state.party_at(1).desolation, 6)


func test_intercede_needs_an_other_standing_ally_with_something_to_take() -> void:
	_put_approved()
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 1)).reason, CommandResult.INVALID_TARGET)
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 2)).reason, CommandResult.NOTHING_TO_TAKE)
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 2, &"bleed")).reason, CommandResult.NOTHING_TO_TAKE)
	c.state.party_at(2).conditions[&"ward"] = 1
	assert_eq(c.execute(BattleCommand.intercede(&"saint_a", 2, &"ward")).reason, CommandResult.NOTHING_TO_TAKE, "só condição negativa")


func test_intercede_takes_every_stack_of_a_negative_condition() -> void:
	_put_approved()
	var a: Combatant = c.state.party_at(1)
	var b: Combatant = c.state.party_at(2)
	b.conditions[&"bleed"] = 3
	b.desolation = 40
	assert_eq(c.intercede_conditions(b), [&"bleed"] as Array[StringName])
	assert_true(c.execute(BattleCommand.intercede(a.id, 2, &"bleed")).ok)
	assert_false(b.has_condition(&"bleed"), "o aliado fica sem as pilhas")
	assert_eq(a.stacks(&"bleed"), 3, "quem intercede leva todas")
	assert_eq(b.desolation, 40, "a desolação não muda nesta escolha")


func test_intercede_preview_is_exact() -> void:
	_put_approved()
	var b: Combatant = c.state.party_at(2)
	b.desolation = 40
	var cmd: BattleCommand = BattleCommand.intercede(&"saint_a", 2)
	var preview: Array[PreviewEntry] = c.preview(cmd)
	assert_eq(_entry(preview, b.id).desolation, -15)
	assert_eq(_entry(preview, &"saint_a").desolation, 15)
	var real: Array[PreviewEntry] = PreviewEntry.from_events(c.execute(cmd).events, [] as Array[StringName])
	assert_eq(JSON.stringify(preview.map(func(e: PreviewEntry) -> Dictionary: return e.to_dict())), JSON.stringify(real.map(func(e: PreviewEntry) -> Dictionary: return e.to_dict())))


func test_intercede_condition_preview_is_exact() -> void:
	_put_approved()
	c.state.party_at(2).conditions[&"bleed"] = 2
	var cmd: BattleCommand = BattleCommand.intercede(&"saint_a", 2, &"bleed")
	var preview: Array[PreviewEntry] = c.preview(cmd)
	assert_eq(_entry(preview, c.state.party_at(2).id).removed.get(&"bleed", 0), 2)
	assert_eq(_entry(preview, &"saint_a").applied.get(&"bleed", 0), 2)
	var real: Array[PreviewEntry] = PreviewEntry.from_events(c.execute(cmd).events, [] as Array[StringName])
	assert_eq(JSON.stringify(preview.map(func(e: PreviewEntry) -> Dictionary: return e.to_dict())), JSON.stringify(real.map(func(e: PreviewEntry) -> Dictionary: return e.to_dict())))


func test_intercede_with_a_condition_replays_from_the_log() -> void:
	var cmd: BattleCommand = BattleCommand.intercede(&"saint_a", 2, &"bleed")
	var again: BattleCommand = BattleCommand.from_dict(cmd.to_dict())
	assert_eq(again.condition_id, &"bleed")
	assert_eq(BattleCommand.from_dict(BattleCommand.intercede(&"saint_a", 2).to_dict()).condition_id, &"")


# --- the gift of Consolation -------------------------------------------------------

func test_gift_of_consolation_purifies_a_dark_night_and_the_giver_goes_back_to_normal() -> void:
	_put_approved()
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


func test_gift_of_consolation_lowers_desolation_of_a_normal_ally_by_30() -> void:
	_put_approved()
	c.state.party_at(1).spirit_state = Desolation.CONSOLATION
	c.state.party_at(2).desolation = 70
	var preview: Array[PreviewEntry] = c.preview(BattleCommand.give_consolation(&"saint_a", 2))
	assert_eq(_entry(preview, c.state.party_at(2).id).desolation, -30, "prévia exata")
	assert_true(c.execute(BattleCommand.give_consolation(&"saint_a", 2)).ok)
	assert_eq(c.state.party_at(2).desolation, 40)


func test_gift_cannot_raise_a_fallen_ally_without_the_revive_number() -> void:
	_put_approved()
	c.state.party_at(1).spirit_state = Desolation.CONSOLATION
	var b: Combatant = c.state.party_at(2)
	b.hp = 0
	b.state = Combatant.State.FALLEN
	assert_eq(c.execute(BattleCommand.give_consolation(&"saint_a", 2)).reason, CommandResult.INVALID_TARGET)
	_put("consolation_gift_revive_hp", 0.5)
	assert_true(c.execute(BattleCommand.give_consolation(&"saint_a", 2)).ok)
	assert_eq(b.hp, Damage.round_half_up(b.max_hp * 0.5), "levanta com a fração dada")


# --- preparation of the Faith test ---------------------------------------------------

func test_prepared_faith_test_adds_per_ally_with_a_maximum_and_the_vigil() -> void:
	_put_approved()
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


func test_without_preparation_the_cap_stays_at_60() -> void:
	_put_approved()
	var a: Combatant = c.state.party_at(1)
	a.faith = 20
	assert_almost_eq(Desolation.faith_chance(a, c.state.desolation_context(a)), c.state.constants.get_float(&"faith_check_cap"), 0.0001)


# --- battle-end desolation by rounds --------------------------------------------------

func test_battle_end_desolation_is_20_plus_3_per_round_from_the_1st() -> void:
	_put_approved()
	c.state.encounter_type = &"common"
	c.state.round_number = 1
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 23)
	c.state.round_number = 4
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 32, "luta de 4 rodadas dá 32 (D-396)")


func test_the_first_counted_round_comes_from_the_data() -> void:
	_put_approved()
	_put("desolation_battle_end_base", 8)
	_put("desolation_battle_end_from_round", 3)
	c.state.encounter_type = &"common"
	c.state.round_number = 2
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 8, "até a 2ª rodada, só a base")
	c.state.round_number = 5
	assert_eq(ExpeditionController.battle_end_desolation(c.state, 20), 8 + 3 * 3)


func test_elite_and_boss_keep_their_fixed_value() -> void:
	_put_approved()
	c.state.round_number = 6
	for kind: StringName in [&"elite", &"boss"]:
		c.state.encounter_type = kind
		assert_eq(ExpeditionController.battle_end_desolation(c.state, 35), 35, String(kind))
