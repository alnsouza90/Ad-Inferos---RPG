extends GutTest
## T05: commands and validation (combat §4).

var c: BattleController


func before_each() -> void:
	var provisions: Array[StringName] = [&"bread", &"bread", &"candle"]
	c = BattleController.new(CombatFixture.battle([], provisions))
	c.start()


func _cmd_ability(actor: StringName, ability: StringName, targets: Array[int] = []) -> CommandResult:
	return c.execute(BattleCommand.use_ability(actor, ability, targets))


func _assert_rejected(result: CommandResult, reason: StringName) -> void:
	assert_false(result.ok, "deveria ser recusado")
	assert_eq(result.reason, reason)


# --- C01, C02, C05 ------------------------------------------------------------------

func test_C01_ability_outside_use_slots_is_rejected_and_state_unchanged() -> void:
	var before: String = JSON.stringify(c.state.to_dict(), "", true)
	var fervor_before: int = c.fervor.amount
	_assert_rejected(_cmd_ability(&"saint_b", &"front_only", [1] as Array[int]), CommandResult.WRONG_SLOT)
	assert_eq(JSON.stringify(c.state.to_dict(), "", true), before)
	assert_eq(c.fervor.amount, fervor_before)
	assert_eq(c.command_log, [] as Array[Dictionary])


func test_C02_second_action_in_the_same_round_is_rejected() -> void:
	assert_true(_cmd_ability(&"saint_a", &"strike", [1] as Array[int]).ok)
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [1] as Array[int]), CommandResult.ALREADY_ACTED)


func test_C05_dark_night_rejects_cost_1_and_accepts_cost_0() -> void:
	var a: Combatant = c.state.party_at(1)
	a.spirit_state = &"dark_night"
	_assert_rejected(_cmd_ability(&"saint_a", &"costly", [1] as Array[int]), CommandResult.DARK_NIGHT)
	assert_true(_cmd_ability(&"saint_a", &"strike", [1] as Array[int]).ok)


func test_D10_dark_night_rejects_miracle() -> void:
	c.fervor.amount = 6
	c.state.party_at(1).spirit_state = &"dark_night"
	_assert_rejected(c.execute(BattleCommand.use_miracle(&"saint_a")), CommandResult.DARK_NIGHT)


# --- accepted ability -------------------------------------------------------------

func test_accepted_ability_spends_fervor_marks_acted_and_logs() -> void:
	var result: CommandResult = _cmd_ability(&"saint_a", &"costly", [3] as Array[int])
	assert_true(result.ok)
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_PER_ROUND - 1)
	assert_true(c.state.party_at(1).has_acted)
	assert_eq(c.command_log, [{"type": "UseAbility", "actor": "saint_a", "ability": "costly", "targets": [3]}] as Array[Dictionary])
	assert_eq(result.events[0].type, BattleController.EV_ABILITY_USED)


func test_miracle_does_not_need_to_be_equipped() -> void:
	c.fervor.amount = 6
	var result: CommandResult = c.execute(BattleCommand.use_miracle(&"saint_a"))
	assert_true(result.ok)
	assert_eq(c.fervor.amount, 3)


# --- every rejection reason -------------------------------------------------------

func test_rejects_outside_party_turn() -> void:
	var fresh := BattleController.new(CombatFixture.battle())
	_assert_rejected(fresh.execute(BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int])), CommandResult.NOT_PARTY_TURN)
	_assert_rejected(fresh.execute(BattleCommand.end_party_turn()), CommandResult.NOT_PARTY_TURN)


func test_rejects_unknown_actor() -> void:
	_assert_rejected(_cmd_ability(&"saint_x", &"strike", [1] as Array[int]), CommandResult.UNKNOWN_ACTOR)


func test_rejects_fallen_actor() -> void:
	c.state.lose_hp(c.state.party_at(1), 999)
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [1] as Array[int]), CommandResult.NOT_STANDING)


func test_rejects_stunned_actor() -> void:
	c.state.party_at(1).conditions[&"stun"] = 1
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [1] as Array[int]), CommandResult.STUNNED)


func test_rejects_unequipped_ability() -> void:
	c.state.party_at(1).equipped.erase(&"strike")
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [1] as Array[int]), CommandResult.NOT_EQUIPPED)


func test_rejects_unknown_ability() -> void:
	_assert_rejected(_cmd_ability(&"saint_a", &"nope", [1] as Array[int]), CommandResult.UNKNOWN_ABILITY)


func test_rejects_not_enough_fervor() -> void:
	c.fervor.amount = 2
	_assert_rejected(c.execute(BattleCommand.use_miracle(&"saint_a")), CommandResult.NOT_ENOUGH_FERVOR)


func test_rejects_second_use_of_once_per_battle() -> void:
	assert_true(_cmd_ability(&"saint_a", &"once").ok)
	c.end_party_turn()
	_assert_rejected(_cmd_ability(&"saint_a", &"once"), CommandResult.ALREADY_USED)


func test_rejects_unknown_command() -> void:
	var cmd := BattleCommand.new()
	cmd.type = &"Dance"
	_assert_rejected(c.execute(cmd), CommandResult.UNKNOWN_COMMAND)


# --- targets (combat §6.1) ----------------------------------------------------------

func test_enemy_target_must_be_in_target_slots_and_alive() -> void:
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [3] as Array[int]), CommandResult.INVALID_TARGET)
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [] as Array[int]), CommandResult.INVALID_TARGET)
	_assert_rejected(_cmd_ability(&"saint_a", &"strike", [1, 2] as Array[int]), CommandResult.INVALID_TARGET)
	assert_true(_cmd_ability(&"saint_a", &"strike", [2] as Array[int]).ok)


func test_ally_target_respects_allow_self() -> void:
	_assert_rejected(_cmd_ability(&"saint_a", &"heal_other", [1] as Array[int]), CommandResult.INVALID_TARGET)
	assert_true(_cmd_ability(&"saint_a", &"heal_other", [2] as Array[int]).ok)
	assert_true(_cmd_ability(&"saint_b", &"heal_any", [2] as Array[int]).ok)


func test_ally_target_cannot_be_fallen_and_ally_fallen_must_be_fallen() -> void:
	c.fervor.amount = 6
	c.state.lose_hp(c.state.party_at(3), 999)
	_assert_rejected(_cmd_ability(&"saint_a", &"heal_other", [3] as Array[int]), CommandResult.INVALID_TARGET)
	_assert_rejected(_cmd_ability(&"saint_a", &"raise", [2] as Array[int]), CommandResult.INVALID_TARGET)
	assert_true(_cmd_ability(&"saint_a", &"raise", [3] as Array[int]).ok)


func test_self_and_group_targets_take_no_slots() -> void:
	_assert_rejected(_cmd_ability(&"saint_a", &"guard_self", [1] as Array[int]), CommandResult.INVALID_TARGET)
	assert_true(_cmd_ability(&"saint_a", &"guard_self").ok)
	var result: CommandResult = _cmd_ability(&"saint_b", &"sweep")
	assert_true(result.ok)
	assert_eq(result.events[0].data["targets"].size(), 2)


func test_chosen_slots_need_n_distinct_living_enemies() -> void:
	c.fervor.amount = 6
	_assert_rejected(c.execute(BattleCommand.use_miracle(&"saint_c", [1] as Array[int])), CommandResult.INVALID_TARGET)
	_assert_rejected(c.execute(BattleCommand.use_miracle(&"saint_c", [2, 2] as Array[int])), CommandResult.INVALID_TARGET)
	assert_true(c.execute(BattleCommand.use_miracle(&"saint_c", [1, 4] as Array[int])).ok)


func test_chosen_slots_with_a_single_enemy_left_accepts_one_slot() -> void:
	var enemies: Array[EnemyDef] = [CombatFixture.enemy(&"lonely")]
	c = BattleController.new(CombatFixture.battle(enemies))
	c.start()
	c.fervor.amount = 6
	assert_true(c.execute(BattleCommand.use_miracle(&"saint_c", [1] as Array[int])).ok)


# --- swap, pass, provision, end turn, retreat ------------------------------------------

func test_swap_command_logs_and_rejects_reasons() -> void:
	_assert_rejected(c.execute(BattleCommand.swap_slots(&"saint_a", -1)), &"no_slot")
	assert_true(c.execute(BattleCommand.swap_slots(&"saint_a", 1)).ok)
	assert_eq(c.state.party_at(2).id, &"saint_a")
	_assert_rejected(c.execute(BattleCommand.swap_slots(&"saint_a", 1)), &"already_acted")


func test_stunned_saint_can_only_pass() -> void:
	c.state.party_at(1).conditions[&"stun"] = 1
	_assert_rejected(c.execute(BattleCommand.swap_slots(&"saint_a", 1)), &"stunned")
	_assert_rejected(c.execute(BattleCommand.use_provision(&"bread", 2, &"saint_a")), CommandResult.STUNNED)
	assert_true(c.execute(BattleCommand.pass_turn(&"saint_a")).ok)
	assert_true(c.state.party_at(1).has_acted)


func test_provision_spends_no_action_and_one_per_turn() -> void:
	assert_true(c.execute(BattleCommand.use_provision(&"bread", 2, &"saint_a")).ok)
	assert_false(c.state.party_at(1).has_acted)
	assert_eq(c.state.provisions, [&"bread", &"candle"] as Array[StringName])
	_assert_rejected(c.execute(BattleCommand.use_provision(&"bread", 2, &"saint_a")), CommandResult.PROVISION_LIMIT)
	c.end_party_turn()
	assert_true(c.execute(BattleCommand.use_provision(&"bread", 1, &"saint_b")).ok, "o limite volta na rodada seguinte")


func test_provision_rejections() -> void:
	_assert_rejected(c.execute(BattleCommand.use_provision(&"holy_water", 1, &"saint_a")), CommandResult.NO_PROVISION)
	_assert_rejected(c.execute(BattleCommand.use_provision(&"candle", 1, &"saint_a")), CommandResult.NOT_USABLE_IN_BATTLE)
	c.state.lose_hp(c.state.party_at(3), 999)
	_assert_rejected(c.execute(BattleCommand.use_provision(&"bread", 3, &"saint_a")), CommandResult.INVALID_TARGET)


func test_end_party_turn_command_is_logged() -> void:
	assert_true(c.execute(BattleCommand.end_party_turn()).ok)
	assert_eq(c.state.round_number, 2)
	assert_eq(c.command_log, [{"type": "EndPartyTurn"}] as Array[Dictionary])


func test_retreat_ends_battle_except_against_boss() -> void:
	assert_true(c.execute(BattleCommand.retreat()).ok)
	assert_eq(c.phase, BattleController.Phase.RETREAT)
	var boss := BattleController.new(CombatFixture.battle([], [] as Array[StringName], &"boss"))
	boss.start()
	_assert_rejected(boss.execute(BattleCommand.retreat()), CommandResult.RETREAT_NOT_ALLOWED)


func test_validate_matches_execute() -> void:
	var cmds: Array[BattleCommand] = [
		BattleCommand.use_ability(&"saint_b", &"front_only", [1] as Array[int]),
		BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int]),
		BattleCommand.swap_slots(&"saint_a", 1),
		BattleCommand.use_provision(&"candle", 1, &"saint_b"),
		BattleCommand.pass_turn(&"saint_c"),
	]
	for cmd: BattleCommand in cmds:
		var predicted: StringName = c.validate(cmd)
		var result: CommandResult = c.execute(cmd)
		assert_eq(result.reason, predicted, "validate e execute concordam em %s" % cmd.to_dict())


# --- the log rebuilds the battle ------------------------------------------------------

func test_command_round_trip_through_dict_and_json() -> void:
	var cmd := BattleCommand.use_provision(&"bread", 2, &"saint_a")
	var back := BattleCommand.from_dict(JSON.parse_string(JSON.stringify(cmd.to_dict())) as Dictionary)
	assert_eq(back.to_dict(), cmd.to_dict())


func test_log_replay_rebuilds_the_same_final_state() -> void:
	var played: Array[BattleCommand] = [
		BattleCommand.use_ability(&"saint_a", &"costly", [4] as Array[int]),
		BattleCommand.use_ability(&"saint_b", &"strike", [1] as Array[int]),
		BattleCommand.use_ability(&"saint_b", &"strike", [1] as Array[int]),
		BattleCommand.use_provision(&"bread", 1, &"saint_c"),
		BattleCommand.swap_slots(&"saint_c", -1),
		BattleCommand.end_party_turn(),
		BattleCommand.use_ability(&"saint_a", &"rally"),
		BattleCommand.pass_turn(&"saint_b"),
		BattleCommand.end_party_turn(),
	]
	for cmd: BattleCommand in played:
		c.execute(cmd)
	assert_eq(c.command_log.size(), played.size() - 1, "o comando recusado não entra no log")
	var log_text: String = JSON.stringify(c.command_log)
	var replay := BattleController.new(CombatFixture.battle([], [&"bread", &"bread", &"candle"] as Array[StringName]))
	replay.start()
	for data: Variant in JSON.parse_string(log_text):
		assert_true(replay.execute(BattleCommand.from_dict(data as Dictionary)).ok)
	assert_eq(JSON.stringify(replay.state.to_dict(), "", true), JSON.stringify(c.state.to_dict(), "", true))
	assert_eq(replay.fervor.amount, c.fervor.amount)
	assert_eq(replay.phase, c.phase)
