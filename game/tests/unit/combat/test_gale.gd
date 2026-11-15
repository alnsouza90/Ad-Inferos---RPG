extends GutTest
## T39: the Vendaval of Circle 2 (expedition §10, bosses.md §2.1), Firmar o
## pé (§2.2) and the Firmeza (§2.4). Cases B01, B02, B06 of bosses.md §7.
## Fixture battles; the numbers of the Firmeza are put in by each test.

const FIRMNESS_FERVOR: int = 1


func _battle(hazard: StringName = &"gale", clausura_on: StringName = &"") -> BattleController:
	var state: BattleState = CombatFixture.battle()
	state.hazard = hazard
	state.constants.values["firmness_fervor"] = float(FIRMNESS_FERVOR)
	state.constants.values["firmness_per_round"] = 1.0
	if clausura_on != &"":
		state.find(clausura_on).trait_def = CombatFixture.trait_def(&"clausura", {"adjacent_move_immune": 1})
	var c := BattleController.new(state)
	c.start()
	return c


func _ids(c: BattleController) -> Array[StringName]:
	var ids: Array[StringName] = []
	for saint: Combatant in c.state.party:
		ids.append(saint.id)
	return ids


func _marked_saint(c: BattleController) -> Combatant:
	return c.state.party_at(c.state.gale_slots[0])


func test_each_round_marks_two_adjacent_saint_slots() -> void:
	var c: BattleController = _battle()
	for i: int in 4:
		var slots: Array[int] = c.state.gale_slots
		assert_eq(slots.size(), 2, "rodada %d" % c.state.round_number)
		assert_eq(slots[1] - slots[0], 1, "posições vizinhas")
		assert_between(slots[0], 1, c.state.party_size() - 1)
		c.end_party_turn()


func test_no_vendaval_without_the_hazard() -> void:
	var c: BattleController = _battle(&"")
	assert_true(c.state.gale_slots.is_empty())
	assert_eq(c.validate(BattleCommand.stand_firm(&"saint_a")), CommandResult.NO_GALE)


func test_the_marked_saints_swap_at_the_hazard_step() -> void:
	var c: BattleController = _battle()
	var slots: Array[int] = c.state.gale_slots.duplicate()
	var a: Combatant = c.state.party_at(slots[0])
	var b: Combatant = c.state.party_at(slots[1])
	var events: Array[BattleEvent] = c.end_party_turn()
	if c.is_over():
		pass_test("combate acabou antes do Vendaval")
		return
	assert_eq(c.state.party_slot_of(a), slots[1], "trocados")
	assert_eq(c.state.party_slot_of(b), slots[0])
	assert_true(events.any(func(e: BattleEvent) -> bool: return e.type == BattleController.EV_GALE_SWAPPED))


func test_the_vendaval_is_the_same_with_the_same_seed() -> void:
	var first: Array = []
	var second: Array = []
	for list: Array in [first, second]:
		var c: BattleController = _battle()
		for i: int in 3:
			list.append(c.state.gale_slots.duplicate())
			c.end_party_turn()
	assert_eq(first, second)


func test_B01_standing_firm_holds_the_swap_spends_the_action_and_gives_fervor_next_round() -> void:
	var c: BattleController = _battle()
	var before: Array[StringName] = _ids(c)
	var saint: Combatant = _marked_saint(c)
	var result: CommandResult = c.execute(BattleCommand.stand_firm(saint.id))
	assert_true(result.ok)
	assert_true(saint.has_acted, "gasta a ação")
	assert_eq(c.state.firmness_pending, 1, "uma ficha de Firmeza")
	c.fervor.amount = 0
	c.end_party_turn()
	if c.is_over():
		pass_test("combate acabou")
		return
	assert_eq(_ids(c).slice(0, before.size()), before, "a troca não aconteceu")
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_PER_ROUND + FIRMNESS_FERVOR, "+1 de Fervor na rodada seguinte")
	assert_eq(c.state.firmness_pending, 0)


func test_B01_firmness_stays_inside_the_extra_fervor_limit() -> void:
	var c: BattleController = _battle()
	c.execute(BattleCommand.stand_firm(_marked_saint(c).id))
	c.fervor.amount = CombatFixture.FERVOR_CAP
	c.end_party_turn()
	if c.is_over():
		pass_test("combate acabou")
		return
	assert_eq(c.fervor.amount, CombatFixture.FERVOR_CAP, "nunca passa do teto")


func test_B02_stand_firm_is_refused_when_it_cannot_hold_anything() -> void:
	var c: BattleController = _battle()
	var slots: Array[int] = c.state.gale_slots
	for saint: Combatant in c.state.party:
		if not slots.has(c.state.party_slot_of(saint)):
			assert_eq(c.validate(BattleCommand.stand_firm(saint.id)), CommandResult.NO_GALE, "não marcado")
	var marked: Combatant = _marked_saint(c)
	marked.conditions[&"stun"] = 1
	assert_eq(c.validate(BattleCommand.stand_firm(marked.id)), CommandResult.STUNNED)
	marked.conditions.erase(&"stun")
	marked.has_acted = true
	assert_eq(c.validate(BattleCommand.stand_firm(marked.id)), CommandResult.ALREADY_ACTED)


func test_B02_the_clausura_holds_the_swap_so_standing_firm_is_not_offered() -> void:
	var c: BattleController = _battle(&"gale", &"saint_b")  # Benedict-like in slot 2
	assert_true(c.state.gale_blocked_by_clausura(), "com Bento no meio, toda dupla tem um vizinho dele")
	assert_eq(c.validate(BattleCommand.stand_firm(_marked_saint(c).id)), CommandResult.NO_GALE)
	var before: Array[StringName] = _ids(c)
	var events: Array[BattleEvent] = c.end_party_turn()
	if c.is_over():
		pass_test("combate acabou")
		return
	assert_eq(_ids(c), before, "a Clausura segura a troca")
	assert_true(events.any(func(e: BattleEvent) -> bool: return e.type == BattleController.EV_GALE_HELD))


func test_B06_at_most_one_firmness_a_round() -> void:
	var c: BattleController = _battle()
	assert_true(c.state.earn_firmness())
	assert_false(c.state.earn_firmness(), "a segunda ficha da rodada não conta")
	assert_eq(c.state.firmness_pending, 1)


func test_stand_firm_previews_without_moving_anyone_and_replays() -> void:
	var c: BattleController = _battle()
	var cmd: BattleCommand = BattleCommand.stand_firm(_marked_saint(c).id)
	assert_eq(c.preview(cmd).size(), 0, "nada a mostrar em números: o aviso vem do texto")
	assert_eq(BattleCommand.from_dict(cmd.to_dict()).type, BattleCommand.STAND_FIRM)
	assert_true(c.execute(cmd).ok)
