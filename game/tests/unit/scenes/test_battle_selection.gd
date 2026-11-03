extends GutTest
## T15: the touch flow of the battle screen (screens §3) without any Node.

var c: BattleController
var s: BattleState
var sel: BattleSelection


func before_each() -> void:
	c = BattleController.new(CombatFixture.battle())
	s = c.state
	c.start()
	s.catalog.ability(&"strike").effects = [CombatFixture.effect(&"damage", 7, &"untyped")] as Array[EffectDef]
	s.catalog.ability(&"miracle_two").effects = [CombatFixture.effect(&"damage", 5, &"untyped")] as Array[EffectDef]
	sel = BattleSelection.new(c)


func _ids(slots: Array[int]) -> Array[StringName]:
	var ids: Array[StringName] = []
	for slot: int in slots:
		ids.append(s.enemy_at(slot).id)
	return ids


func test_slot_sets_cover_every_subset_once() -> void:
	var sets: Array = BattleSelection.slot_sets()
	assert_eq(sets.size(), 16)
	assert_eq(sets[0], [] as Array[int])
	assert_true(sets.has([1, 3] as Array[int]))


func test_single_target_tap_previews_then_second_tap_confirms() -> void:
	assert_true(sel.select_actor(&"saint_a"))
	assert_true(sel.choose_ability(&"strike"))
	assert_eq(sel.side, BattleSelection.SIDE_ENEMY)
	assert_eq(sel.targetable_ids(), _ids([1, 2] as Array[int]), "só as posições 1 e 2 acendem")
	assert_null(sel.pending, "sem alvo ainda")
	var first: StringName = s.enemy_at(1).id
	assert_eq(sel.tap_combatant(first), BattleSelection.PREVIEW)
	assert_eq(sel.preview.size(), 1)
	assert_eq(sel.preview[0].damage, 7)
	assert_eq(s.enemy_at(1).hp, s.enemy_at(1).max_hp, "a prévia não muda o combate")
	assert_eq(sel.tap_combatant(first), BattleSelection.CONFIRM)
	var cmd: BattleCommand = sel.take_pending()
	assert_eq(cmd.to_dict(), BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int]).to_dict())
	assert_eq(sel.mode, BattleSelection.Mode.NONE)
	assert_eq(sel.actor_id, &"saint_a", "o santo continua escolhido")


func test_tapping_another_valid_target_moves_the_preview() -> void:
	sel.select_actor(&"saint_a")
	sel.choose_ability(&"strike")
	sel.tap_combatant(s.enemy_at(1).id)
	assert_eq(sel.tap_combatant(s.enemy_at(2).id), BattleSelection.PREVIEW)
	assert_eq(sel.pending.target_slots, [2] as Array[int])


func test_target_out_of_reach_and_wrong_side_are_ignored() -> void:
	sel.select_actor(&"saint_a")
	sel.choose_ability(&"strike")
	assert_eq(sel.tap_combatant(s.enemy_at(3).id), BattleSelection.IGNORED)
	assert_eq(sel.tap_combatant(&"saint_b"), BattleSelection.IGNORED)
	assert_null(sel.pending)


func test_chosen_slots_need_every_tap_before_the_preview() -> void:
	c.fervor.amount = 6
	sel.select_actor(&"saint_c")
	assert_true(sel.choose_miracle())
	assert_eq(sel.tap_combatant(s.enemy_at(1).id), BattleSelection.PICKED)
	assert_null(sel.pending)
	assert_eq(sel.tap_combatant(s.enemy_at(3).id), BattleSelection.PREVIEW)
	assert_eq(sel.pending.type, BattleCommand.USE_MIRACLE)
	assert_eq(sel.pending.target_slots, [1, 3] as Array[int])
	assert_eq(sel.preview.size(), 2)
	assert_eq(sel.tap_combatant(s.enemy_at(3).id), BattleSelection.CONFIRM)


func test_action_without_target_previews_at_once() -> void:
	sel.select_actor(&"saint_a")
	assert_true(sel.choose_ability(&"guard_self"))
	assert_not_null(sel.pending)
	assert_eq(sel.pending.target_slots, [] as Array[int])


func test_ally_ability_aims_at_the_party() -> void:
	sel.select_actor(&"saint_a")
	assert_true(sel.choose_ability(&"heal_other"))
	assert_eq(sel.side, BattleSelection.SIDE_PARTY)
	assert_eq(sel.targetable_ids(), [&"saint_b", &"saint_c"] as Array[StringName], "sem allow_self, o próprio santo não acende")
	assert_eq(sel.tap_combatant(&"saint_c"), BattleSelection.PREVIEW)


func test_refusal_reasons_come_from_the_controller() -> void:
	c.fervor.amount = 0
	sel.select_actor(&"saint_b")
	assert_eq(sel.ability_reason(&"front_only", false), CommandResult.WRONG_SLOT)
	assert_eq(sel.ability_reason(&"costly", false), CommandResult.NOT_ENOUGH_FERVOR)
	assert_eq(sel.ability_reason(&"strike", false), &"")
	assert_false(sel.choose_ability(&"costly"), "habilidade recusada não fica escolhida")
	assert_eq(sel.mode, BattleSelection.Mode.NONE)


func test_swap_aims_at_the_neighbours() -> void:
	sel.select_actor(&"saint_b")
	assert_true(sel.choose_swap())
	assert_eq(sel.targetable_ids(), [&"saint_a", &"saint_c"] as Array[StringName])
	assert_eq(sel.tap_combatant(&"saint_c"), BattleSelection.PREVIEW)
	assert_eq(sel.pending.to_dict(), BattleCommand.swap_slots(&"saint_b", 1).to_dict())


func test_pass_waits_for_confirmation() -> void:
	sel.select_actor(&"saint_a")
	assert_true(sel.choose_pass())
	assert_eq(sel.take_pending().type, BattleCommand.PASS)


func test_ready_saints_skip_those_who_acted() -> void:
	c.execute(BattleCommand.pass_turn(&"saint_a"))
	var ready_ids: Array[StringName] = []
	for saint: Combatant in sel.ready_saints():
		ready_ids.append(saint.id)
	assert_eq(ready_ids, [&"saint_b", &"saint_c"] as Array[StringName])
