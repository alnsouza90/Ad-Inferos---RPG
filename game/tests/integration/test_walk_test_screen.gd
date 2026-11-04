extends GutTest
## T27: the walk test of the arena (dev only) — a whole leg walked by touch,
## with the nodes finished by DevNodeResolver until their screens exist.

const MAX_TAPS: int = 40

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _new_screen(seed: int) -> WalkTestScreen:
	var screen := WalkTestScreen.new()
	screen.use_game_state = false
	screen.speed_index = BattleScreen.SPEED_INSTANT
	screen.setup(data, cat, seed)
	add_child_autofree(screen)
	return screen


func test_a_whole_leg_is_walked_by_touch_to_the_end() -> void:
	for seed: int in [1, 2, 3]:
		var screen := _new_screen(seed)
		var ended: Array[bool] = [false]
		screen.back_requested.connect(func() -> void: ended[0] = true)
		for i: int in MAX_TAPS:
			if ended[0]:
				break
			if screen.overlay_shown():
				assert_false(screen.message_text().contains("["), "sem texto faltando: %s" % screen.message_text())
				screen.press_action()
			else:
				var pick: StringName = screen.walk.entrance_ids()[0]
				screen.walk.tap_entrance(pick)
				screen.walk.tap_entrance(pick)
		assert_true(ended[0], "semente %d: chegou ao fim e voltou à arena" % seed)
		assert_true(screen.ctrl.is_over())
		var again := ExpeditionController.replay(cat, screen.ctrl.initial_snapshot(), screen.ctrl.command_log)
		assert_eq(JSON.stringify(again.snapshot()), JSON.stringify(screen.ctrl.snapshot()), "tudo passou por comandos registrados")


func test_entering_a_node_shows_the_placeholder_with_the_node_type() -> void:
	var screen := _new_screen(1)
	var pick: StringName = screen.walk.entrance_ids()[0]
	screen.walk.tap_entrance(pick)
	screen.walk.tap_entrance(pick)
	assert_true(screen.overlay_shown())
	var type_text: String = data.ui.text(screen.ctrl.map.find(pick).type)
	assert_true(screen.message_text().contains(type_text), screen.message_text())


func test_resolving_a_node_returns_to_the_corridor() -> void:
	var screen := _new_screen(1)
	var pick: StringName = screen.walk.entrance_ids()[0]
	screen.walk.tap_entrance(pick)
	screen.walk.tap_entrance(pick)
	screen.press_action()
	if screen.ctrl.phase == ExpeditionController.Phase.AT_FORK:
		assert_false(screen.overlay_shown())
		var expected: Array[StringName] = []
		for n: MapNode in screen.ctrl.entrances():
			expected.append(n.id)
		assert_eq(screen.walk.entrance_ids(), expected)
	else:
		assert_true(screen.overlay_shown(), "fim da expedição mostra o aviso")
