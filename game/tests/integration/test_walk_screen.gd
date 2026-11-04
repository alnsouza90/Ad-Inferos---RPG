extends GutTest
## T27: walk screen (screens §4, expedition §2.3) — the corridor, the
## entrances of each bifurcation (one tap shows, the second confirms), the
## top bar, provisions at the fork and the mini-map. The screen only sends
## commands; the rules stay in ExpeditionController.

const MAX_LAYERS: int = 10

var data: GameData
var cat: ExpeditionCatalog
var ctrl: ExpeditionController
var walk: WalkScreen
## Every command the screen sent, in order.
var sent: Array[ExpeditionCommand] = []


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func before_each() -> void:
	sent.clear()
	ctrl = _new_ctrl(1)
	walk = _new_walk(ctrl)


func _new_ctrl(seed: int) -> ExpeditionController:
	return ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)


func _new_walk(c: ExpeditionController) -> WalkScreen:
	var w := WalkScreen.new()
	w.speed_index = BattleScreen.SPEED_INSTANT
	w.setup(data, c, func(cmd: ExpeditionCommand) -> StringName:
		sent.append(cmd)
		return c.execute(cmd))
	add_child_autofree(w)
	return w


## Finishes the node without the node screens (T28 to T30), then back to the corridor.
func _finish_node(c: ExpeditionController, w: WalkScreen) -> void:
	DevNodeResolver.resolve(c, c.execute)
	if c.phase == ExpeditionController.Phase.AT_FORK:
		w.arrive()


# --- acceptance: the whole path of a leg chosen only by touch -----------------------

func test_the_whole_path_of_a_leg_is_chosen_by_touch() -> void:
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
			w.tap_entrance(pick)
			w.tap_entrance(pick)
			chosen.append(pick)
			assert_eq(c.state.current_node, pick, "semente %d: entrou no nó tocado" % seed)
			_finish_node(c, w)
		if c.phase == ExpeditionController.Phase.AT_CAMP:
			assert_eq(chosen.size(), c.map.layer_count(), "semente %d: um nó por camada até o Pouso" % seed)
		else:
			assert_true(c.is_over(), "semente %d: terminou no Pouso ou no fim da expedição" % seed)
		var choose_paths: int = 0
		for cmd: ExpeditionCommand in sent:
			assert_eq(cmd.type, ExpeditionCommand.CHOOSE_PATH, "a tela só envia ChoosePath aqui")
			choose_paths += 1
		assert_eq(choose_paths, chosen.size())


func test_first_tap_only_shows_the_entrance_and_sends_nothing() -> void:
	var target: StringName = walk.entrance_ids()[0]
	walk.tap_entrance(target)
	assert_eq(sent.size(), 0, "o primeiro toque não envia comando")
	assert_eq(walk.selected_entrance, target)
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_FORK)
	var n: MapNode = ctrl.map.find(target)
	assert_true(walk.info_text().contains(data.ui.text(n.type)), walk.info_text())
	assert_true(walk.info_text().contains(data.ui.text(&"walk_hint_confirm")), walk.info_text())


func test_tapping_another_entrance_moves_the_selection() -> void:
	var ids: Array[StringName] = walk.entrance_ids()
	walk.tap_entrance(ids[0])
	walk.tap_entrance(ids[1])
	assert_eq(sent.size(), 0)
	assert_eq(walk.selected_entrance, ids[1])
	walk.tap_entrance(ids[1])
	assert_eq(sent.size(), 1)
	assert_eq(sent[0].node_id, ids[1])


func test_a_refused_command_shows_the_reason_and_nothing_changes() -> void:
	var refusing := WalkScreen.new()
	refusing.speed_index = BattleScreen.SPEED_INSTANT
	refusing.setup(data, ctrl, func(_cmd: ExpeditionCommand) -> StringName: return ExpeditionController.REJECT_WRONG_PHASE)
	add_child_autofree(refusing)
	var target: StringName = refusing.entrance_ids()[0]
	refusing.tap_entrance(target)
	refusing.tap_entrance(target)
	assert_eq(ctrl.state.current_node, &"", "continua no Portão")
	assert_eq(refusing.info_text(), data.ui.text(&"walk_reason_wrong_phase"))


# --- entrances ------------------------------------------------------------------

func test_every_entrance_shows_its_type_in_text_and_one_goes_straight() -> void:
	for seed: int in 20:
		var c := _new_ctrl(seed)
		var w := _new_walk(c)
		var straight: int = 0
		var ids: Array[StringName] = w.entrance_ids()
		assert_eq(ids.size(), c.map.layer_nodes(1).size(), "do Portão, todos os nós da camada 1")
		for id: StringName in ids:
			var text: String = w.entrance_text(id)
			assert_true(text.contains(data.ui.text(c.map.find(id).type)), text)
			assert_false(text.contains("["), "sem texto faltando: %s" % text)
			if text.contains(data.ui.text(&"walk_path_straight")):
				straight += 1
		assert_eq(straight, 1, "semente %d: exatamente um caminho reto" % seed)


func test_the_straight_entrance_is_the_generator_straight_link() -> void:
	walk.tap_entrance(walk.entrance_ids()[0])
	walk.tap_entrance(walk.entrance_ids()[0])
	_finish_node(ctrl, walk)
	if ctrl.phase != ExpeditionController.Phase.AT_FORK:
		pass_test("expedição terminou no primeiro nó")
		return
	var origin: MapNode = ctrl.current_node()
	var expected: int = MapGenerator.nearest_index(origin.index, ctrl.map.layer_nodes(origin.layer).size(), ctrl.map.layer_nodes(origin.layer + 1).size())
	assert_eq(ctrl.map.find(walk.straight_entrance()).index, expected)


func test_the_look_of_a_fork_is_the_same_after_resuming() -> void:
	var first: StringName = walk.entrance_ids()[0]
	walk.tap_entrance(first)
	walk.tap_entrance(first)
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
	var target: StringName = walk.entrance_ids()[0]
	walk.tap_entrance(target)
	walk.tap_entrance(target)
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


func test_minimap_sends_no_command() -> void:
	walk.press_minimap()
	walk.press_minimap()
	assert_false(walk.minimap_open(), "o segundo toque no botão fecha")
	assert_eq(sent.size(), 0)


func test_minimap_marks_the_walked_path() -> void:
	var target: StringName = walk.entrance_ids()[0]
	walk.tap_entrance(target)
	walk.tap_entrance(target)
	_finish_node(ctrl, walk)
	walk.press_minimap()
	assert_eq(walk.minimap().centres.size(), ctrl.map.all_nodes().size())
	assert_eq(walk.minimap()._node_color(ctrl.map.find(target)), MiniMapView.COLOR_CURRENT)


# --- provisions at the fork ------------------------------------------------------

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


# --- layout and texts ------------------------------------------------------------

func test_screen_has_size_and_the_stage_is_centred() -> void:
	assert_gt(walk.size.x, 0.0)
	var expected: Vector2 = ((walk.size - WalkScreen.STAGE_SIZE) * 0.5).floor()
	assert_eq(walk.stage_position(), expected)
	assert_eq(walk.party_figure_count(), ctrl.state.party.size())


func test_the_walk_animates_and_then_shows_the_entrances() -> void:
	var c := _new_ctrl(1)
	var w := WalkScreen.new()
	w.speed_index = 0
	w.setup(data, c)
	add_child_autofree(w)
	assert_true(w.busy, "a equipe está andando")
	w.tap_entrance(w.entrance_ids()[0])
	assert_eq(w.selected_entrance, &"", "as entradas esperam o fim da caminhada")
	await wait_seconds(WalkScreen.WALK_TIME + 0.3)
	assert_false(w.busy)


func test_every_walk_text_exists_in_the_data() -> void:
	var keys: Array[String] = [
		"arena_walk", "walk_light", "walk_alms", "walk_minimap", "walk_minimap_close", "minimap_gate",
		"minimap_camp", "walk_hint_choose", "walk_hint_confirm", "walk_content_hidden", "walk_content_enemies",
		"walk_provisions", "walk_provision_line", "walk_no_provisions", "walk_choose_saint",
		"walk_provision_used", "walk_test_node", "walk_test_resolve", "walk_test_camp",
		"walk_test_leave_camp", "walk_test_ended",
	]
	for type: StringName in [MapNode.TYPE_BATTLE, MapNode.TYPE_ELITE, MapNode.TYPE_TEMPTATION, MapNode.TYPE_SOUL, MapNode.TYPE_RELIC, &"node_camp"]:
		keys.append(String(type))
	keys.append("walk_path_%s" % CorridorLook.STRAIGHT)
	for kind: StringName in CorridorLook.DETOURS:
		keys.append("walk_path_%s" % kind)
	for code: StringName in [FieldProvisions.REJECT_NOT_CARRIED, FieldProvisions.REJECT_NOT_USABLE_HERE, FieldProvisions.REJECT_NEEDS_TARGET, FieldProvisions.REJECT_NOTHING_TO_REVEAL, ExpeditionController.REJECT_WRONG_PHASE, ExpeditionController.REJECT_NOT_AN_ENTRANCE]:
		keys.append("walk_reason_%s" % code)
	for reason: StringName in [ExpeditionController.END_LEG_COMPLETE, ExpeditionController.END_DEFEATED, ExpeditionController.END_RETREATED, ExpeditionController.END_PLANNED_RETREAT]:
		keys.append("walk_end_%s" % reason)
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)
