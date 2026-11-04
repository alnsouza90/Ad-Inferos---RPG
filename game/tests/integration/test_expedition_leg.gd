extends GutTest
## T21: expedition controller (expedition §2.3, §8 and §9; combat §8 and §11)
## with the real M0 saints and encounters, read from the CSVs.

const MAX_STEPS: int = 3000

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


func _new(seed: int) -> ExpeditionController:
	var provisions: Array[StringName] = [&"bread", &"holy_water"]
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), provisions, EncounterDef.ARENA_CIRCLE)


func _ok(ctrl: ExpeditionController, cmd: ExpeditionCommand) -> void:
	var reason: StringName = ctrl.execute(cmd)
	assert_eq(reason, &"", "comando recusado: %s" % [cmd.to_dict()])


## Fixed policy: first entrance, pass-through nodes, FirstValidPolicy in battle.
func _step(ctrl: ExpeditionController) -> void:
	match ctrl.phase:
		ExpeditionController.Phase.AT_FORK:
			_ok(ctrl, ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
		ExpeditionController.Phase.IN_NODE:
			_ok(ctrl, ExpeditionCommand.complete_node())
		ExpeditionController.Phase.IN_EVENT:
			_ok(ctrl, ExpeditionCommand.choose_option(&"refuse"))
		ExpeditionController.Phase.IN_BATTLE:
			_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))


func _play(ctrl: ExpeditionController) -> void:
	var steps: int = 0
	while ctrl.phase != ExpeditionController.Phase.AT_CAMP and not ctrl.is_over() and steps < MAX_STEPS:
		_step(ctrl)
		steps += 1


## Walks until a battle starts, preferring battle entrances.
func _go_to_battle(ctrl: ExpeditionController) -> void:
	for i: int in 10:
		if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
			return
		if ctrl.phase == ExpeditionController.Phase.IN_NODE:
			_ok(ctrl, ExpeditionCommand.complete_node())
			continue
		if ctrl.phase == ExpeditionController.Phase.IN_EVENT:
			_ok(ctrl, ExpeditionCommand.choose_option(&"refuse"))
			continue
		var pick: MapNode = ctrl.entrances()[0]
		for n: MapNode in ctrl.entrances():
			if n.is_battle_like():
				pick = n
		_ok(ctrl, ExpeditionCommand.choose_path(pick.id))
	fail_test("nenhum combate encontrado")


func test_a_whole_leg_is_played_without_a_screen_and_replays_exactly() -> void:
	for seed: int in 5:
		var ctrl := _new(seed)
		_play(ctrl)
		assert_true(ctrl.phase == ExpeditionController.Phase.AT_CAMP or ctrl.is_over(), "semente %d não terminou" % seed)
		var again := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
		assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(ctrl.snapshot()), "semente %d" % seed)
		assert_eq(again.command_log, ctrl.command_log)


func test_reaching_the_camp_visits_one_node_per_layer_and_spends_light() -> void:
	var ctrl := _new(1)
	_play(ctrl)
	if ctrl.is_over():
		pass_test("equipe derrotada antes do Pouso nesta semente")
		return
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_CAMP)
	assert_eq(ctrl.state.visited.size(), 3)
	assert_eq(ctrl.current_layer(), 4)
	assert_eq(ctrl.state.light, 75, "4 nós (−20) e a recusa da Tentação (−5)")


func test_choosing_a_node_that_is_not_an_entrance_is_rejected() -> void:
	var ctrl := _new(2)
	assert_eq(ctrl.execute(ExpeditionCommand.choose_path(&"l3_n0")), ExpeditionController.REJECT_NOT_AN_ENTRANCE)
	assert_eq(ctrl.execute(ExpeditionCommand.complete_node()), ExpeditionController.REJECT_WRONG_PHASE)
	assert_eq(ctrl.command_log.size(), 0)
	assert_eq(ctrl.state.light, 100)


func test_won_battle_gives_alms_and_battle_end_desolation() -> void:
	var ctrl := _new(3)
	_go_to_battle(ctrl)
	var before: Dictionary = {}
	for c: Combatant in ctrl.battle.state.party:
		before[c.id] = c.desolation
	while ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	assert_eq(ctrl.last_battle.phase, BattleController.Phase.VICTORY)
	assert_eq(ctrl.state.alms_unbanked, 70, "70 Esmolas, Lume alto sem multiplicador")
	for id: StringName in ctrl.saints:
		var status: SaintStatus = ctrl.saints[id]
		assert_gt(status.desolation, int(before[id]) - 1, "desolação de fim de combate em %s" % id)
	assert_true(ctrl.phase == ExpeditionController.Phase.AT_FORK or ctrl.phase == ExpeditionController.Phase.AT_CAMP)


func test_hp_and_desolation_carry_over_to_the_next_battle() -> void:
	var ctrl := _new(4)
	_go_to_battle(ctrl)
	while ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	if ctrl.is_over():
		pass_test("expedição terminou")
		return
	var status: SaintStatus = ctrl.saints[&"saint_george"]
	status.hp = 9
	status.desolation = 33
	_go_to_battle(ctrl)
	var george: Combatant = null
	for c: Combatant in ctrl.battle.state.party:
		if c.id == &"saint_george":
			george = c
	assert_eq(george.hp, 9)
	assert_eq(george.desolation, 33)


func test_D134_next_battle_keeps_the_formation_of_the_last_one() -> void:
	var ctrl := _new(5)
	_go_to_battle(ctrl)
	_ok(ctrl, ExpeditionCommand.battle(BattleCommand.swap_slots(&"saint_george", 1)))
	assert_eq(ctrl.battle.state.party[1].id, &"saint_george")
	while ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	assert_eq(ctrl.state.party[1], &"saint_george")
	if ctrl.is_over():
		return
	_go_to_battle(ctrl)
	assert_eq(ctrl.battle.state.party[1].id, &"saint_george")


func test_E08_emergency_retreat_with_300_unbanked_alms_loses_150() -> void:
	var ctrl := _new(6)
	_go_to_battle(ctrl)
	ctrl.state.alms_unbanked = 300
	var before: Dictionary = {}
	for c: Combatant in ctrl.battle.state.party:
		before[c.id] = c.desolation
	_ok(ctrl, ExpeditionCommand.battle(BattleCommand.retreat()))
	assert_eq(ctrl.state.alms_unbanked, 150)
	assert_true(ctrl.is_over())
	assert_eq(ctrl.ended_reason, ExpeditionController.END_RETREATED)
	for id: StringName in ctrl.saints:
		var status: SaintStatus = ctrl.saints[id]
		assert_eq(status.injury, SaintStatus.INJURY_MINOR)
		assert_gt(status.desolation, int(before[id]), "+desolação da retirada em %s" % id)


func test_E09_defeat_loses_unbanked_alms_and_injures_everyone_badly() -> void:
	var ctrl := _new(7)
	_go_to_battle(ctrl)
	ctrl.state.alms_unbanked = 140
	var bs: BattleState = ctrl.battle.state
	for c: Combatant in bs.party:
		bs.fall(c, BattleState.CAUSE_HP)
	_ok(ctrl, ExpeditionCommand.battle(BattleCommand.end_party_turn()))
	assert_true(ctrl.is_over())
	assert_eq(ctrl.ended_reason, ExpeditionController.END_DEFEATED)
	assert_eq(ctrl.state.alms_unbanked, 0)
	for id: StringName in ctrl.saints:
		var status: SaintStatus = ctrl.saints[id]
		assert_eq(status.injury, SaintStatus.INJURY_MAJOR)
		assert_eq(status.hp, 1)


func test_fallen_saint_returns_with_1_hp_and_minor_then_major_injury() -> void:
	var ctrl := _new(8)
	_go_to_battle(ctrl)
	var bs: BattleState = ctrl.battle.state
	var therese: Combatant = bs.party_at(3)
	bs.fall(therese, BattleState.CAUSE_HP)
	ctrl._settle_saints(bs)
	var status: SaintStatus = ctrl.saints[therese.id]
	assert_eq(status.hp, 1)
	assert_eq(status.injury, SaintStatus.INJURY_MINOR)
	assert_true(ctrl.state.fallen_once.has(therese.id))
	ctrl._settle_saints(bs)
	assert_eq(status.injury, SaintStatus.INJURY_MAJOR, "segunda queda na mesma expedição")


func test_low_light_raises_battle_alms_by_half() -> void:
	var ctrl := _new(9)
	ctrl.state.light = 20
	assert_eq(ctrl.battle_alms(&"common"), 105)
	ctrl.state.light = 50
	assert_eq(ctrl.battle_alms(&"common"), 70)
	assert_eq(ctrl.circle_number(), 2)


func test_provisions_spent_in_battle_leave_the_pack() -> void:
	var ctrl := _new(10)
	_go_to_battle(ctrl)
	var bs: BattleState = ctrl.battle.state
	bs.party_at(1).hp -= 6
	_ok(ctrl, ExpeditionCommand.battle(BattleCommand.use_provision(&"bread", 1, bs.party_at(1).id)))
	while ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		_ok(ctrl, ExpeditionCommand.battle(FirstValidPolicy.choose(ctrl.battle)))
	assert_eq(ctrl.state.provisions, [&"holy_water"] as Array[StringName])
