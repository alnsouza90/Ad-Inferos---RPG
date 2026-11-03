extends GutTest
## T11: preview (combat §15).

var c: BattleController
var s: BattleState


func before_each() -> void:
	var foes: Array[EnemyDef] = [CombatFixture.enemy(&"e1", 30), CombatFixture.enemy(&"e2", 30)]
	for foe: EnemyDef in foes:
		foe.actions = [CombatFixture.action(&"claw", 1, [CombatFixture.effect(&"damage", 3, &"untyped")] as Array[EffectDef])] as Array[EnemyActionDef]
	c = BattleController.new(CombatFixture.battle(foes, [&"bread"] as Array[StringName]))
	s = c.state
	c.start()
	s.catalog.ability(&"strike").effects = [CombatFixture.effect(&"damage", 7, &"untyped"), CombatFixture.effect(&"apply_condition", 0, &"", &"stun", 1)] as Array[EffectDef]
	s.catalog.ability(&"sweep").effects = [CombatFixture.effect(&"damage", 4, &"untyped")] as Array[EffectDef]
	s.catalog.provision(&"bread").effects = [CombatFixture.effect(&"heal", 5)] as Array[EffectDef]


func _snapshot(ctrl: BattleController) -> String:
	return JSON.stringify({"state": ctrl.state.to_dict(), "fervor": ctrl.fervor.amount, "phase": ctrl.phase, "log": ctrl.command_log}, "", true)


func _dicts(entries: Array[PreviewEntry]) -> Array:
	var list: Array = []
	for e: PreviewEntry in entries:
		list.append(e.to_dict())
	return list


func test_C19_preview_then_execute_give_identical_results_and_preview_changes_nothing() -> void:
	var cmd := BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int])
	var before: String = _snapshot(c)
	var predicted: Array[PreviewEntry] = c.preview(cmd)
	assert_eq(_snapshot(c), before, "a prévia não altera o combate")
	assert_eq(predicted.size(), 1)
	assert_eq(predicted[0].target_id, s.enemy_at(1).id)
	assert_eq(predicted[0].damage, 7)
	assert_eq(predicted[0].applied, {&"stun": 1})
	assert_true(predicted[0].intent_cancelled, "o atordoamento cancela a intenção")
	var target: Combatant = s.enemy_at(1)
	c.execute(cmd)
	assert_eq(target.max_hp - target.hp, 7)
	assert_true(target.has_condition(&"stun"))


func test_preview_of_group_attack_lists_every_target() -> void:
	c.fervor.amount = 6
	var entries: Array[PreviewEntry] = c.preview(BattleCommand.use_ability(&"saint_a", &"sweep"))
	assert_eq(entries.size(), 2)
	for e: PreviewEntry in entries:
		assert_eq(e.damage, 4)


func test_preview_shows_kill_heal_and_move() -> void:
	s.enemy_at(1).hp = 5
	var kill: Array[PreviewEntry] = c.preview(BattleCommand.use_ability(&"saint_a", &"strike", [1] as Array[int]))
	assert_true(kill[0].falls)
	s.lose_hp(s.party_at(2), 10)
	var bread: Array[PreviewEntry] = c.preview(BattleCommand.use_provision(&"bread", 2, &"saint_a"))
	assert_eq(bread[0].heal, 5)
	assert_eq(s.provisions, [&"bread"] as Array[StringName], "a prévia não gasta a provisão")


func test_preview_of_invalid_command_is_empty() -> void:
	assert_eq(c.preview(BattleCommand.use_ability(&"saint_b", &"front_only", [1] as Array[int])), [] as Array[PreviewEntry])


func test_clone_shares_no_combatant_with_the_original() -> void:
	var copy: BattleController = c.clone()
	for i: int in s.party.size():
		assert_ne(copy.state.party[i], s.party[i])
	copy.state.lose_hp(copy.state.party_at(1), 5)
	assert_eq(s.party_at(1).hp, s.party_at(1).max_hp)
	assert_eq(JSON.stringify(copy.state.rng.to_dict()), JSON.stringify(s.rng.to_dict()))
