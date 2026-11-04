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
			if screen.event_screen != null:
				_play_event(screen.event_screen)
			elif screen.overlay_shown():
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


## Pages, then the first option that can be taken (two taps), then the result.
func _play_event(event_screen: EventScreen) -> void:
	while not event_screen.options_shown():
		event_screen.press_next()
	for id: StringName in event_screen.option_ids():
		if not event_screen.option_disabled(id):
			event_screen.tap_option(id)
			event_screen.tap_option(id)
			break
	event_screen.press_next()


func test_a_temptation_opens_the_event_screen() -> void:
	for seed: int in 30:
		var screen := _new_screen(seed)
		for n: MapNode in screen.ctrl.map.layer_nodes(1):
			if n.type == MapNode.TYPE_TEMPTATION:
				screen.walk.tap_entrance(n.id)
				screen.walk.tap_entrance(n.id)
				assert_not_null(screen.event_screen, "semente %d: a Tentação abre a tela do evento" % seed)
				assert_false(screen.overlay_shown())
				_play_event(screen.event_screen)
				assert_null(screen.event_screen, "o evento fechou")
				return
	pass_test("nenhuma Tentação na camada 1 destas sementes")


func test_entering_a_node_shows_the_placeholder_with_the_node_type() -> void:
	var screen := _new_screen(1)
	var pick: StringName = _not_a_temptation(screen)
	screen.walk.tap_entrance(pick)
	screen.walk.tap_entrance(pick)
	assert_true(screen.overlay_shown())
	var type_text: String = data.ui.text(screen.ctrl.map.find(pick).type)
	assert_true(screen.message_text().contains(type_text), screen.message_text())


func test_resolving_a_node_returns_to_the_corridor() -> void:
	var screen := _new_screen(1)
	var pick: StringName = _not_a_temptation(screen)
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


## An entrance whose node shows the placeholder (a Temptation opens its screen).
func _not_a_temptation(screen: WalkTestScreen) -> StringName:
	for id: StringName in screen.walk.entrance_ids():
		if screen.ctrl.map.find(id).type != MapNode.TYPE_TEMPTATION:
			return id
	return screen.walk.entrance_ids()[0]
