extends GutTest
## T17: test arena (screens §2) — choose an encounter and a seed, play,
## come back.

var data: GameData
var arena: ArenaScreen


func before_all() -> void:
	data = RealData.game_data()


func before_each() -> void:
	arena = ArenaScreen.new()
	arena.setup(data)
	arena.battle_speed_index = BattleScreen.SPEED_INSTANT
	add_child_autofree(arena)


func test_lists_the_four_m0_encounters_with_enemy_names() -> void:
	assert_eq(arena.encounter_ids.size(), 4)
	assert_eq(arena.chosen, arena.encounter_ids[0])
	var label: String = arena.encounter_label(&"m0_easy_01")
	assert_true(label.contains("Diabo de Lodo") and label.contains("Moscardo"), label)
	assert_false(label.contains("["), "sem texto faltando: %s" % label)


func test_start_plays_the_chosen_encounter_with_the_chosen_seed() -> void:
	arena.choose(&"m0_hard_01")
	arena.change_seed(4)
	arena.start()
	assert_not_null(arena.battle)
	assert_eq(arena.battle.encounter_id, &"m0_hard_01")
	assert_eq(arena.battle.battle_seed, 5)
	assert_eq(arena.battle.ctrl.state.enemies.size(), 4, "o difícil 01 tem 4 inimigos")


func test_seed_never_goes_below_one() -> void:
	arena.change_seed(-10)
	assert_eq(arena.arena_seed, 1)


func test_back_to_arena_after_the_result() -> void:
	arena.start()
	var battle: BattleScreen = arena.battle
	battle.press_retreat()
	assert_true(battle.result_shown())
	battle.press_back()
	assert_null(arena.battle, "voltou à arena")
