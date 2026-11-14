extends GutTest
## T27 and T37: the walk screen (screens §4, expedition §2.3) — walking the
## corridor by holding, the content that stops the party (E15 to E22), the
## entrances in the final stretch with Entrar, the hard cut into battle, the
## top bar, provisions and the mini-map. The screen only sends commands; the
## rules stay in ExpeditionController.

const MAX_LAYERS: int = 10

var data: GameData
var cat: ExpeditionCatalog
var ctrl: ExpeditionController
var walk: WalkScreen
## Every command the screen sent, in order.
var sent: Array[ExpeditionCommand] = []
## Last place the screen reported (node, fraction).
var places: Array[Dictionary] = []


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func before_each() -> void:
	sent.clear()
	places.clear()
	ctrl = _new_ctrl(1)
	walk = _new_walk(ctrl)


func _new_ctrl(seed: int) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


func _new_walk(c: ExpeditionController, place: Dictionary = {}) -> WalkScreen:
	var w := WalkScreen.new()
	w.speed_index = BattleScreen.SPEED_INSTANT
	w.saved_place = place
	w.setup(data, c, func(cmd: ExpeditionCommand) -> StringName:
		sent.append(cmd)
		return c.execute(cmd))
	w.position_changed.connect(func(node_id: StringName, x: float) -> void: places.append({"node": node_id, "x": x}))
	add_child_autofree(w)
	return w


## Walks to the entrance and taps Entrar (ChoosePath).
func _enter(w: WalkScreen, node_id: StringName) -> void:
	w.tap_entrance(node_id)
	w.press_enter()


## Enters a layer-1 node turned into `type` (the map is the screen's input;
## the content waits in the corridor).
func _corridor_with(type: StringName) -> WalkScreen:
	var n: MapNode = ctrl.map.find(walk.entrance_ids()[0])
	n.type = type
	_enter(walk, n.id)
	assert_eq(ctrl.phase, ExpeditionController.Phase.PENDING)
	sent.clear()
	return _new_walk(ctrl)


## A controller entered into a battle node of layer 1, if the seed has one.
func _battle_seed() -> int:
	for seed: int in 30:
		var c := _new_ctrl(seed)
		for n: MapNode in c.entrances():
			if n.is_battle_like():
				return seed
	return -1


## Finishes the node without the node screens, then back to the corridor.
func _finish_node(c: ExpeditionController, w: WalkScreen) -> void:
	DevNodeResolver.resolve(c, c.execute)
	if c.phase == ExpeditionController.Phase.AT_FORK:
		w.arrive()


# --- acceptance: a whole leg by walking and Entrar -------------------------------

func test_the_whole_path_of_a_leg_is_chosen_by_walking() -> void:
	for seed: int in [1, 2, 3]:
		sent.clear()
		var c := _new_ctrl(seed)
		var w := _new_walk(c)
		var chosen: Array[StringName] = []
		for i: int in MAX_LAYERS:
			if c.phase != ExpeditionController.Phase.AT_FORK:
				break
			var ids: Array[StringName] = w.entrance_ids()
			var pick: StringName = ids[ids.size() - 1]
			_enter(w, pick)
			chosen.append(pick)
			assert_eq(c.state.current_node, pick, "semente %d: entrou no nó escolhido" % seed)
			_finish_node(c, w)
		if c.phase == ExpeditionController.Phase.AT_CAMP:
			assert_eq(chosen.size(), c.map.layer_count(), "semente %d: um nó por camada até o Pouso" % seed)
		else:
			assert_true(c.is_over(), "semente %d: terminou no Pouso ou no fim da expedição" % seed)
		var choose_paths: int = 0
		for cmd: ExpeditionCommand in sent:
			if cmd.type == ExpeditionCommand.CHOOSE_PATH:
				choose_paths += 1
		assert_eq(choose_paths, chosen.size())


# --- walking (E15, E16) -----------------------------------------------------------

func test_E15_walking_back_at_the_start_does_not_move_nor_send() -> void:
	walk.hold(-1)
	walk._process(1.0)
	walk.release()
	assert_eq(walk.position_in_corridor(), 0.0)
	assert_eq(sent.size(), 0)
	assert_eq(ctrl.command_log.size(), 0)


func test_E16_walking_the_whole_corridor_changes_nothing() -> void:
	var before: Dictionary = ctrl.snapshot()
	walk.walk_by(1.0)
	assert_eq(walk.position_in_corridor(), 1.0)
	walk.walk_by(-1.0)
	walk.walk_by(0.5)
	assert_eq(ctrl.snapshot(), before, "Lume e estado iguais")
	assert_eq(sent.size(), 0, "nenhum comando no log")


func test_holding_moves_by_the_walking_speed_and_releasing_stops() -> void:
	walk.hold(1)
	walk._process(0.5)
	var expected: float = WalkScreen.WALK_SPEED * 2.0 * 0.5 / WalkScreen.CORRIDOR_LENGTH
	assert_almost_eq(walk.position_in_corridor(), expected, 0.0001, "instantâneo anda a 2×")
	assert_eq(walk.figure_clips()[0], &"walk")
	walk.release()
	walk._process(0.5)
	assert_almost_eq(walk.position_in_corridor(), expected, 0.0001)
	assert_eq(walk.figure_clips()[0], &"idle")
	assert_eq(places.back()["x"], walk.position_in_corridor(), "a posição é guardada ao parar")


func test_the_scenery_moves_in_layers_at_different_speeds() -> void:
	walk.walk_by(0.5)
	var back: float = walk.layer_offset(0)
	var mid: float = walk.layer_offset(1)
	assert_lt(mid, back, "o meio anda mais que o fundo")
	assert_almost_eq(back, -0.5 * WalkScreen.CORRIDOR_LENGTH * 0.2, 0.01)
	assert_almost_eq(mid, -0.5 * WalkScreen.CORRIDOR_LENGTH, 0.01)


func test_walking_back_turns_the_saints_around() -> void:
	walk.walk_by(0.3)
	walk.hold(-1)
	walk._process(0.1)
	for f: FramePlayer in walk._figures:
		assert_lt(f.scale.x, 0.0, "virados para trás")
	walk.release()


# --- content in the corridor (E17 to E20) ------------------------------------------

func test_E17_reaching_the_enemies_starts_the_battle_without_a_touch() -> void:
	var seed: int = _battle_seed()
	if seed < 0:
		pass_test("nenhuma semente com combate na camada 1")
		return
	var c := _new_ctrl(seed)
	var w := _new_walk(c)
	var target: MapNode
	for n: MapNode in c.entrances():
		if n.is_battle_like():
			target = n
	_enter(w, target.id)
	var entered: Array[StringName] = []
	var w2 := _new_walk(c)
	w2.node_entered.connect(func(id: StringName) -> void: entered.append(id))
	w2.walk_by(1.0)
	assert_almost_eq(w2.position_in_corridor(), CorridorWalk.CONTENT_AT, 0.0001, "não passa do ponto")
	assert_eq(c.phase, ExpeditionController.Phase.IN_BATTLE, "o combate começou sem toque")
	assert_eq(sent.back().type, ExpeditionCommand.ENGAGE_NODE)
	assert_eq(entered, [target.id] as Array[StringName])
	assert_eq(w2.figure_clips()[0], &"defend", "corte seco: todos em guarda (D-359)")
	assert_gt(w2.darkness(), 0.0, "o fundo escurece")


func test_E18_passing_by_the_tent_applies_the_safe_option() -> void:
	var w := _corridor_with(MapNode.TYPE_TEMPTATION)
	var light: int = ctrl.state.light
	w.walk_by(1.0)
	assert_true(w.action_texts().has(data.ui.text(&"walk_enter")), str(w.action_texts()))
	var pass_text: String = data.ui.text(&"walk_pass_by") + " (" + data.ui.text(&"walk_cost_light", {"amount": EventTexts.signed(-5)}) + ")"
	assert_true(w.action_texts().has(pass_text), "custo à vista: %s" % str(w.action_texts()))
	w.press_pass_by()
	assert_eq(ctrl.state.light, light - 5, "mesmo custo de \"Seguir os rastros\"")
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].type, ExpeditionCommand.PASS_BY)
	assert_ne(ctrl.phase, ExpeditionController.Phase.IN_EVENT, "o evento não abre")


func test_entering_the_tent_opens_the_event() -> void:
	var w := _corridor_with(MapNode.TYPE_TEMPTATION)
	w.walk_by(1.0)
	w.press_engage()
	assert_eq(ctrl.phase, ExpeditionController.Phase.IN_EVENT)
	assert_eq(sent[0].type, ExpeditionCommand.ENGAGE_NODE)


func test_E19_opening_a_relic_is_a_logged_command() -> void:
	var w := _corridor_with(MapNode.TYPE_RELIC)
	w.walk_by(1.0)
	assert_eq(w.action_texts(), [data.ui.text(&"walk_open")] as Array[String])
	w.press_engage()
	assert_eq(sent[0].type, ExpeditionCommand.ENGAGE_NODE)
	assert_true(ctrl.phase == ExpeditionController.Phase.IN_RELIC or ctrl.phase == ExpeditionController.Phase.IN_BATTLE, "relíquia ou guardiões")


func test_E20_the_soul_does_not_let_the_party_pass() -> void:
	var w := _corridor_with(MapNode.TYPE_SOUL)
	w.walk_by(1.0)
	assert_almost_eq(w.position_in_corridor(), CorridorWalk.CONTENT_AT, 0.0001)
	assert_eq(w.action_texts(), [data.ui.text(&"walk_talk")] as Array[String])
	assert_eq(sent.size(), 0)
	w.press_pass_by()
	assert_eq(sent.size(), 0, "sem Passar ao largo diante da alma")
	assert_eq(ctrl.phase, ExpeditionController.Phase.PENDING)


func test_provisions_can_be_used_before_pending_content() -> void:
	var w := _corridor_with(MapNode.TYPE_TEMPTATION)
	w.walk_by(0.2)
	w.press_provisions()
	assert_true(w.provisions_open())
	assert_false(w.provision_disabled(&"candle"))


# --- resuming (E21) ----------------------------------------------------------------

func test_E21_reopening_in_the_middle_of_the_corridor_lands_on_the_same_place() -> void:
	walk.walk_by(0.3)
	var place: Dictionary = places.back()
	var resumed := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
	var again := _new_walk(resumed, place)
	assert_almost_eq(again.position_in_corridor(), 0.3, 0.0001)
	assert_eq(resumed.command_log.size(), 0)


func test_E21_reopening_before_the_tent_shows_the_same_buttons() -> void:
	var w := _corridor_with(MapNode.TYPE_TEMPTATION)
	w.walk_by(1.0)
	var buttons: Array[String] = w.action_texts()
	var log_size: int = ctrl.command_log.size()
	var again := _new_walk(ctrl, places.back())
	assert_almost_eq(again.position_in_corridor(), CorridorWalk.CONTENT_AT, 0.0001)
	assert_eq(again.action_texts(), buttons)
	assert_eq(ctrl.command_log.size(), log_size, "nenhum comando novo no log")


func test_a_place_saved_for_another_node_is_ignored() -> void:
	var again := _new_walk(ctrl, {"node": "l9_n9", "x": 0.8})
	assert_eq(again.position_in_corridor(), 0.0)


func test_after_a_battle_the_party_stands_where_the_enemies_were() -> void:
	var seed: int = _battle_seed()
	if seed < 0:
		pass_test("nenhuma semente com combate na camada 1")
		return
	var c := _new_ctrl(seed)
	var w := _new_walk(c)
	for n: MapNode in c.entrances():
		if n.is_battle_like():
			_enter(w, n.id)
			break
	c.execute(ExpeditionCommand.engage_node())
	DevNodeResolver.resolve(c, c.execute)
	if c.phase != ExpeditionController.Phase.AT_FORK:
		pass_test("a expedição terminou neste combate")
		return
	var after := _new_walk(c)
	assert_almost_eq(after.position_in_corridor(), CorridorWalk.CONTENT_AT, 0.0001)
	assert_eq(after.figure_clips()[0], &"idle", "a guarda se desfaz e o parado volta")
	after.walk_by(1.0)
	assert_eq(after.position_in_corridor(), 1.0, "o caminho está livre")


# --- entrances (E22) ---------------------------------------------------------------

func test_E22_standing_before_an_entrance_shows_it_and_entrar_chooses_the_path() -> void:
	var target: StringName = walk.entrance_ids()[0]
	var light: int = ctrl.state.light
	walk.tap_entrance(target)
	assert_eq(sent.size(), 0, "chegar diante da entrada não envia comando")
	assert_eq(walk.selected_entrance, target)
	var n: MapNode = ctrl.map.find(target)
	assert_true(walk.info_text().contains(data.ui.text(n.type)), walk.info_text())
	assert_eq(walk.action_texts(), [data.ui.text(&"walk_enter")] as Array[String])
	walk.press_enter()
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].type, ExpeditionCommand.CHOOSE_PATH)
	assert_eq(ctrl.state.light, light - 5, "Lume −5 ao entrar")


func test_walking_away_from_an_entrance_hides_entrar() -> void:
	walk.tap_entrance(walk.entrance_ids()[0])
	walk.walk_by(-0.5)
	assert_eq(walk.selected_entrance, &"")
	assert_eq(walk.action_texts(), [] as Array[String])
	walk.press_enter()
	assert_eq(sent.size(), 0)


func test_entrances_stand_in_the_final_stretch_and_the_straight_one_last() -> void:
	for seed: int in 20:
		var c := _new_ctrl(seed)
		var w := _new_walk(c)
		var ids: Array[StringName] = w.entrance_ids()
		assert_eq(ids.size(), c.map.layer_nodes(1).size(), "do Portão, todos os nós da camada 1")
		assert_eq(ids.back(), w.straight_entrance(), "semente %d: o reto fica no fim" % seed)
		assert_eq(float(w.corridor.entrance_at[ids.back()]), CorridorWalk.STRAIGHT_AT)
		var straight: int = 0
		for id: StringName in ids:
			assert_gt(float(w.corridor.entrance_at[id]), CorridorWalk.CONTENT_AT, "depois do conteúdo")
			var text: String = w.entrance_text(id)
			assert_true(text.contains(data.ui.text(c.map.find(id).type)), text)
			assert_false(text.contains("["), "sem texto faltando: %s" % text)
			if text.contains(data.ui.text(&"walk_path_straight")):
				straight += 1
		assert_eq(straight, 1, "semente %d: exatamente um caminho reto" % seed)


func test_a_refused_command_shows_the_reason_and_nothing_changes() -> void:
	var refusing := WalkScreen.new()
	refusing.speed_index = BattleScreen.SPEED_INSTANT
	refusing.setup(data, ctrl, func(_cmd: ExpeditionCommand) -> StringName: return ExpeditionController.REJECT_WRONG_PHASE)
	add_child_autofree(refusing)
	_enter(refusing, refusing.entrance_ids()[0])
	assert_eq(ctrl.state.current_node, &"", "continua no Portão")
	assert_eq(refusing.info_text(), data.ui.text(&"walk_reason_wrong_phase"))


func test_the_straight_entrance_is_the_generator_straight_link() -> void:
	_enter(walk, walk.entrance_ids()[0])
	_finish_node(ctrl, walk)
	if ctrl.phase != ExpeditionController.Phase.AT_FORK:
		pass_test("expedição terminou no primeiro nó")
		return
	var origin: MapNode = ctrl.current_node()
	var expected: int = MapGenerator.nearest_index(origin.index, ctrl.map.layer_nodes(origin.layer).size(), ctrl.map.layer_nodes(origin.layer + 1).size())
	assert_eq(ctrl.map.find(walk.straight_entrance()).index, expected)


func test_the_look_of_a_fork_is_the_same_after_resuming() -> void:
	_enter(walk, walk.entrance_ids()[0])
	_finish_node(ctrl, walk)
	var resumed := ExpeditionController.replay(cat, ctrl.initial_snapshot(), ctrl.command_log)
	var again := _new_walk(resumed)
	assert_eq(again.entrance_ids(), walk.entrance_ids())
	for id: StringName in walk.entrance_ids():
		assert_eq(again.entrance_text(id), walk.entrance_text(id), "mesma aparência ao retomar")


func test_battle_entrance_shows_its_enemies_when_the_gate_reveals_them() -> void:
	for id: StringName in walk.entrance_ids():
		var n: MapNode = ctrl.map.find(id)
		if not n.is_battle_like():
			continue
		walk.tap_entrance(id)
		var enc: EncounterDef = data.encounters[n.encounter_id]
		var first_enemy: EnemyDef = data.catalog.enemies[enc.slots[0]]
		assert_true(walk.info_text().contains(first_enemy.name_pt), walk.info_text())
		return
	pass_test("sem combate na camada 1 desta semente")


func test_hidden_content_says_so() -> void:
	var texts := WalkTexts.new(data)
	var far: MapNode = ctrl.map.layer_nodes(3)[0]
	assert_false(ctrl.content_visible(far))
	assert_eq(texts.content(ctrl, far), data.ui.text(&"walk_content_hidden"))


func test_path_kind_depends_only_on_the_node_id() -> void:
	assert_eq(CorridorLook.path_kind(&"l2_n1", &"l2_n1"), CorridorLook.STRAIGHT)
	var kind: StringName = CorridorLook.path_kind(&"l2_n0", &"l2_n1")
	assert_true(CorridorLook.DETOURS.has(kind))
	assert_eq(CorridorLook.path_kind(&"l2_n0", &"l2_n2"), kind, "o desenho não depende de qual é o reto")


# --- top bar ------------------------------------------------------------------

func test_top_bar_shows_light_and_both_kinds_of_alms() -> void:
	assert_eq(walk.light_text(), data.ui.text(&"walk_light", {"value": ctrl.state.light}))
	assert_eq(walk.alms_text(), data.ui.text(&"walk_alms", {"banked": 0, "unbanked": 0}))
	_enter(walk, walk.entrance_ids()[0])
	_finish_node(ctrl, walk)
	assert_eq(walk.light_text(), data.ui.text(&"walk_light", {"value": ctrl.state.light}), "Lume depois do nó")
	assert_eq(walk.alms_text(), data.ui.text(&"walk_alms", {"banked": ctrl.state.alms_banked, "unbanked": ctrl.state.alms_unbanked}))


# --- mini-map -----------------------------------------------------------------

func test_minimap_shows_every_node_type_and_closes() -> void:
	walk.press_minimap()
	assert_true(walk.minimap_open())
	for n: MapNode in ctrl.map.all_nodes():
		assert_true(walk.minimap().label_of(n.id).begins_with(data.ui.text(n.type)), "nó %s" % n.id)
	walk.close_minimap()
	assert_false(walk.minimap_open())


func test_minimap_sends_no_command_and_stops_the_walk() -> void:
	walk.hold(1)
	walk.press_minimap()
	assert_eq(walk.holding, 0)
	walk.press_minimap()
	assert_false(walk.minimap_open(), "o segundo toque no botão fecha")
	assert_eq(sent.size(), 0)


func test_minimap_marks_the_walked_path() -> void:
	var target: StringName = walk.entrance_ids()[0]
	_enter(walk, target)
	_finish_node(ctrl, walk)
	walk.press_minimap()
	assert_eq(walk.minimap().centres.size(), ctrl.map.all_nodes().size())
	assert_eq(walk.minimap()._node_color(ctrl.map.find(target)), MiniMapView.COLOR_CURRENT)


# --- provisions ----------------------------------------------------------------

func test_provisions_list_shows_the_kit_and_why_some_cannot_be_used() -> void:
	walk.press_provisions()
	assert_true(walk.provisions_open())
	assert_true(walk.provision_text(&"bread").contains(data.ui.text(&"walk_reason_not_usable_here")), walk.provision_text(&"bread"))
	assert_true(walk.provision_disabled(&"bread"), "Pão só no Pouso (D-136)")
	assert_true(walk.provision_disabled(&"bandages"), "Ataduras só em combate (D-136)")
	assert_false(walk.provision_disabled(&"candle"))


func test_incense_is_used_by_touch_and_logged() -> void:
	walk.press_provisions()
	walk.press_provision(&"incense")
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].type, ExpeditionCommand.USE_PROVISION)
	assert_false(ctrl.state.provisions.has(&"incense"))
	assert_false(ctrl.state.revealed_nodes.is_empty(), "o Incenso revelou mais uma camada (D-129)")
	assert_false(walk.provisions_open())


func test_holy_water_asks_for_a_saint_first() -> void:
	walk.press_provisions()
	walk.press_provision(&"holy_water")
	assert_eq(sent.size(), 0, "ainda falta escolher o santo")
	assert_eq(walk.pending_provision, &"holy_water")
	walk.press_provision_target(&"saint_benedict")
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].target_id, &"saint_benedict")
	assert_eq(ctrl.state.provisions.count(&"holy_water"), 1)


func test_provisions_wait_while_the_party_walks() -> void:
	walk.hold(1)
	walk.press_provisions()
	assert_false(walk.provisions_open(), "só com a equipe parada")


# --- layout and texts ------------------------------------------------------------

func test_screen_has_size_and_the_stage_is_centred() -> void:
	assert_gt(walk.size.x, 0.0)
	var expected: Vector2 = ((walk.size - WalkScreen.STAGE_SIZE) * 0.5).floor()
	assert_eq(walk.stage_position(), expected)
	assert_eq(walk.party_figure_count(), ctrl.state.party.size())
	assert_eq(walk.figure_clips(), [&"idle", &"idle", &"idle"] as Array[StringName], "santos em vídeo parados")


func test_the_hard_cut_animates_before_the_battle_screen() -> void:
	var seed: int = _battle_seed()
	if seed < 0:
		pass_test("nenhuma semente com combate na camada 1")
		return
	var c := _new_ctrl(seed)
	var first := _new_walk(c)
	for n: MapNode in c.entrances():
		if n.is_battle_like():
			_enter(first, n.id)
			break
	var w := WalkScreen.new()
	w.speed_index = 0
	w.setup(data, c)
	var entered: Array[StringName] = []
	w.node_entered.connect(func(id: StringName) -> void: entered.append(id))
	add_child_autofree(w)
	w.walk_by(1.0)
	assert_true(w.busy, "o corte está acontecendo")
	assert_eq(entered.size(), 0)
	await wait_seconds(WalkScreen.CUT_TIME + 0.3)
	assert_eq(entered.size(), 1)


func test_every_walk_text_exists_in_the_data() -> void:
	var keys: Array[String] = [
		"walk_light", "walk_alms", "walk_minimap", "walk_minimap_close", "minimap_gate",
		"minimap_camp", "walk_hint_walk", "walk_enter", "walk_pass_by", "walk_open", "walk_talk",
		"walk_cost_light", "walk_cost_desolation", "walk_cost_alms", "walk_content_hidden", "walk_content_enemies",
		"walk_provisions", "walk_provision_line", "walk_no_provisions", "walk_choose_saint",
		"walk_provision_used",
	]
	for type: StringName in [MapNode.TYPE_BATTLE, MapNode.TYPE_ELITE, MapNode.TYPE_TEMPTATION, MapNode.TYPE_SOUL, MapNode.TYPE_RELIC, &"node_camp"]:
		keys.append(String(type))
	keys.append("walk_path_%s" % CorridorLook.STRAIGHT)
	for kind: StringName in CorridorLook.DETOURS:
		keys.append("walk_path_%s" % kind)
	for code: StringName in [FieldProvisions.REJECT_NOT_CARRIED, FieldProvisions.REJECT_NOT_USABLE_HERE, FieldProvisions.REJECT_NEEDS_TARGET, FieldProvisions.REJECT_NOTHING_TO_REVEAL, ExpeditionController.REJECT_WRONG_PHASE, ExpeditionController.REJECT_NOT_AN_ENTRANCE, ExpeditionController.REJECT_CANNOT_PASS_BY, ExpeditionController.REJECT_REQUIREMENT]:
		keys.append("walk_reason_%s" % code)
	for reason: StringName in [ExpeditionController.END_LEG_COMPLETE, ExpeditionController.END_DEFEATED, ExpeditionController.END_RETREATED, ExpeditionController.END_PLANNED_RETREAT]:
		keys.append("walk_end_%s" % reason)
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)
