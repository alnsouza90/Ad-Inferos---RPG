class_name WalkScreen
extends Control
## The interactive walk of the expedition (screens §4, expedition §2.3, T37):
## holding a finger on the right half walks forward, on the left half walks
## back; the scenery moves in layers at different speeds. The node's content
## stands in the corridor and stops the party; enemies start the battle by
## themselves, with a hard cut (D-359); the entrances of the next layer stand
## in the final stretch, and Entrar sends ChoosePath. The screen only sends
## ExpeditionCommand through `run` and redraws from the state: walking is
## presentation and never touches the rules (item 2).

## T65 (ADR-0013): drawn in pixel art on the 960 × 540 grid, in the same
## frame as the battle (field in the top 360, ground line, party in the same
## place), so the hard cut into the battle changes nothing but the panel.
const STAGE_SIZE := Vector2(960, 540)
const FIELD_HEIGHT: float = BattleScreen.FIELD_HEIGHT
const FRAMES_DIRS: Array[String] = [BattleScreen.PIXEL_ART_DIR, BattleScreen.ART_DIR]
## Length of one corridor in stage pixels at parallax 100%.
const CORRIDOR_LENGTH: float = 1300.0
## Walking speed in stage pixels per second at 1×.
const WALK_SPEED: float = 280.0
## Where the vanguard stands on the screen while the camera follows.
const PARTY_SCREEN_X: float = BattleScreen.SAINT_FRONT_X
## The content and the entrances stand this far ahead of the vanguard when
## the party reaches them.
const AHEAD: float = 170.0
const FEET_Y: float = BattleScreen.GROUND_Y
const FIGURE_HEIGHT: float = BattleScreen.FIGURE_HEIGHT
const FIGURE_STEP: float = BattleScreen.SLOT_STEP
const OBJECT_SIZE := Vector2(90, 110)
const ENTRANCE_SIZE := Vector2(80, 120)
const BUTTON_SIZE := Vector2(140, 32)
## The front layer of the scenery passes low before the party.
const FRONT_DROP: float = 150.0
## Hard cut into the battle (D-359): guard pose, the camera comes a little
## closer and the background darkens.
const CUT_TIME: float = 0.35
const CUT_ZOOM: float = 1.06
const CUT_DARK: float = 0.55
## After the battle the guard holds this long, then the idle comes back.
const GUARD_HOLD: float = 0.5
## Scenery light by the expedition Light (§2.3 item 10, only looks).
const DARKEST: float = 0.55
const COLOR_BACKGROUND := Color("0D0C10")
const COLOR_SAINT := Color("54483B")
const COLOR_OBJECT := Color("3E2A1E")
const COLOR_OBJECT_DONE := Color("2B2A27")
const COLOR_STRAIGHT := Color("654E3D")
const COLOR_DETOUR := Color("33313A")
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const COLOR_LIGHT_ON := Color("E07B1F")
const COLOR_LIGHT_OFF := Color("33313A")
const COLOR_DIM := Color(0.05, 0.047, 0.063, 0.8)
const LIGHT_BAR_SIZE := Vector2(140, 6)
const OVERLAY_MARGIN: float = 400.0
const LIST_BUTTON_SIZE := Vector2(300, 28)

## A command was accepted that leaves this corridor (ChoosePath, or content
## that opens its own screen): the flow shows the next phase.
signal node_entered(node_id: StringName)
## The party stopped: the flow keeps the place in the save (save-load §3.1).
signal position_changed(node_id: StringName, fraction: float)

var data: GameData
var texts: WalkTexts
var ctrl: ExpeditionController
## Takes an ExpeditionCommand and returns the refusal reason (&"" when
## accepted). The game passes GameState.execute (saves after each command);
## tests and the default use the controller directly.
var run: Callable
## Animation speed index of BattleScreen.SPEEDS (1×, 2×, instant).
var speed_index: int = 0
## Saved place in this corridor (save-load §3.1): {"node": id, "x": 0..1}.
## Ignored when it is for another node or invalid.
var saved_place: Dictionary = {}
## True during the hard cut or the guard after a battle: input waits.
var busy: bool = false
## -1 walking back, 1 walking forward, 0 stopped.
var holding: int = 0
## Target of a tap on an entrance: the party walks there by itself.
var walking_to: float = -1.0
var selected_entrance: StringName = &""
## Provision waiting for a target saint (Holy Water).
var pending_provision: StringName = &""
var corridor: CorridorWalk

var _stage: Control
var _world: Control
var _field_clip: Control
var _scenery_back: ParallaxScenery
var _scenery_front: ParallaxScenery
var _objects: Control
var _party: Control
var _figures: Array[FramePlayer] = []
var _dark: ColorRect
var _content_view: Control
var _entrance_views: Dictionary = {}
var _info: Label
var _action_box: HBoxContainer
var _light_fill: ColorRect
var _light_label: Label
var _alms_label: Label
var _provisions_button: Button
var _provisions_overlay: Control
var _provisions_list: VBoxContainer
var _minimap_overlay: Control
var _minimap: MiniMapView
var _straight: StringName = &""
var _facing: int = 1
var _moving: bool = false


func setup(p_data: GameData, p_ctrl: ExpeditionController, p_run: Callable = Callable()) -> void:
	data = p_data
	texts = WalkTexts.new(p_data)
	ctrl = p_ctrl
	run = p_run if p_run.is_valid() else func(cmd: ExpeditionCommand) -> StringName: return ctrl.execute(cmd)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build()
	_center_stage()
	arrive()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


func _process(delta: float) -> void:
	if busy or corridor == null:
		return
	var step: float = _speed() * delta / CORRIDOR_LENGTH
	if walking_to >= 0.0:
		var gap: float = walking_to - corridor.position
		if absf(gap) <= step:
			_walk(gap)
			walking_to = -1.0
			_stopped()
		else:
			_walk(signf(gap) * step)
		return
	if holding != 0:
		_walk(holding * step)


func _gui_input(event: InputEvent) -> void:
	var pressed: bool
	var x: float
	if event is InputEventScreenTouch:
		pressed = (event as InputEventScreenTouch).pressed
		x = (event as InputEventScreenTouch).position.x
	elif event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		pressed = (event as InputEventMouseButton).pressed
		x = (event as InputEventMouseButton).position.x
	else:
		return
	if pressed:
		hold(1 if x >= size.x * 0.5 else -1)
	else:
		release()
	accept_event()


# --- player input (also called by the tests) ------------------------------------

## Builds the corridor of the node the party is in (or the gate's) and
## places the party: at the saved place, else before content already met,
## else at the start (§2.3 item 11).
func arrive() -> void:
	selected_entrance = &""
	pending_provision = &""
	holding = 0
	walking_to = -1.0
	busy = false
	_provisions_overlay.visible = false
	_minimap_overlay.visible = false
	var n: MapNode = ctrl.current_node()
	var at_fork: bool = ctrl.phase == ExpeditionController.Phase.AT_FORK
	var entrance_ids: Array[StringName] = []
	if at_fork:
		for e: MapNode in ctrl.entrances():
			entrance_ids.append(e.id)
		_straight = CorridorLook.straight_entrance(ctrl.map, n, ctrl.entrances())
	else:
		_straight = &""
	var content: bool = ExpeditionController.has_corridor_content(n)
	corridor = CorridorWalk.make(content, ctrl.phase == ExpeditionController.Phase.PENDING, entrance_ids, _straight)
	var after_battle: bool = content and at_fork and n.is_battle_like()
	corridor.place(corridor.content_at if content and at_fork else 0.0)
	var node_id: StringName = n.id if n != null else &""
	if StringName(str(saved_place.get("node", ""))) == node_id and saved_place.get("x") is float:
		corridor.place(float(saved_place["x"]))
		after_battle = after_battle and is_equal_approx(corridor.position, corridor.content_at)
	_build_party()
	_build_objects()
	_place_world()
	_refresh()
	if after_battle:
		_guard_then_idle()
	elif corridor.at_pending_content():
		_reached_content()


## Holding the finger: 1 walks forward, -1 walks back (D-178).
func hold(direction: int) -> void:
	if busy or _overlay_open():
		return
	walking_to = -1.0
	holding = signi(direction)
	selected_entrance = &""
	_refresh()


func release() -> void:
	if holding == 0:
		return
	holding = 0
	_stopped()


## Walks by `fraction` of the corridor at once (tests; also what holding does
## frame by frame).
func walk_by(fraction: float) -> void:
	if busy:
		return
	_walk(fraction)
	_stopped()


## A tap on an entrance: the party walks to it by itself (instantly at the
## instant speed) and stops before it.
func tap_entrance(node_id: StringName) -> void:
	if busy or not corridor.entrance_at.has(node_id) or ctrl.phase != ExpeditionController.Phase.AT_FORK:
		return
	_provisions_overlay.visible = false
	var target: float = float(corridor.entrance_at[node_id])
	if BattleScreen.SPEEDS[speed_index] <= 0.0:
		_walk(target - corridor.position)
		_stopped()
		return
	holding = 0
	walking_to = target


## Entrar at the entrance the party stands before: ChoosePath (item 7).
func press_enter() -> void:
	if busy or selected_entrance == &"" or ctrl.phase != ExpeditionController.Phase.AT_FORK:
		return
	var node_id: StringName = selected_entrance
	var reason: StringName = run.call(ExpeditionCommand.choose_path(node_id))
	if reason != &"":
		_info.text = texts.reason(reason)
		return
	selected_entrance = &""
	node_entered.emit(node_id)


## Entrar (tent), Abrir (relic) or Falar (soul): EngageNode.
func press_engage() -> void:
	if busy or not corridor.at_pending_content():
		return
	_engage()


## Passar ao largo of the tent: PassBy, the first safe option (D-184).
func press_pass_by() -> void:
	var n: MapNode = ctrl.pending_node()
	if busy or not corridor.at_pending_content() or n == null or n.type != MapNode.TYPE_TEMPTATION:
		return
	var reason: StringName = run.call(ExpeditionCommand.pass_by())
	if reason != &"":
		_info.text = texts.reason(reason)
		return
	_content_resolved_here()


func press_minimap() -> void:
	if _minimap_overlay.visible:
		close_minimap()
		return
	holding = 0
	_minimap_overlay.visible = true
	_minimap.rebuild()


func close_minimap() -> void:
	_minimap_overlay.visible = false


func press_provisions() -> void:
	if not _can_use_provisions():
		return
	pending_provision = &""
	_provisions_overlay.visible = not _provisions_overlay.visible
	_refresh()


## Uses a provision; one that needs a saint (Holy Water) asks for him first.
func press_provision(id: StringName) -> void:
	if busy:
		return
	var def: ProvisionDef = data.catalog.provision(id)
	if def != null and FieldProvisions.needs_target(def) and ctrl.field_provision_problem(id) == FieldProvisions.REJECT_NEEDS_TARGET:
		pending_provision = id
		_refresh()
		return
	_use(id, &"")


func press_provision_target(saint_id: StringName) -> void:
	if pending_provision == &"":
		return
	var id: StringName = pending_provision
	pending_provision = &""
	_use(id, saint_id)


# --- queries for the tests ---------------------------------------------------------

func entrance_ids() -> Array[StringName]:
	return corridor.entrance_order() if corridor != null else [] as Array[StringName]


func entrance_text(node_id: StringName) -> String:
	var view: Control = _entrance_views.get(node_id)
	return str(view.get_meta(&"text", "")) if view != null else ""


func straight_entrance() -> StringName:
	return _straight


func position_in_corridor() -> float:
	return corridor.position


func info_text() -> String:
	return _info.text


## Texts of the buttons shown now beside the content or the entrance.
func action_texts() -> Array[String]:
	var list: Array[String] = []
	for child: Node in _action_box.get_children():
		if child is Button and not child.is_queued_for_deletion():
			list.append((child as Button).text)
	return list


func light_text() -> String:
	return _light_label.text


func alms_text() -> String:
	return _alms_label.text


func minimap_open() -> bool:
	return _minimap_overlay.visible


func minimap() -> MiniMapView:
	return _minimap


func provisions_open() -> bool:
	return _provisions_overlay.visible


## Text of the provision's button in the open list ("" when not listed).
func provision_text(id: StringName) -> String:
	for child: Node in _provisions_list.get_children():
		if child is Button and (child as Button).get_meta(&"provision", &"") == id:
			return (child as Button).text
	return ""


func provision_disabled(id: StringName) -> bool:
	for child: Node in _provisions_list.get_children():
		if child is Button and (child as Button).get_meta(&"provision", &"") == id:
			return (child as Button).disabled
	return true


func stage_position() -> Vector2:
	return _stage.position if _stage != null else Vector2.ZERO


func party_figure_count() -> int:
	return _party.get_child_count() if _party != null else 0


## Clip each saint plays now (idle, walk, defend...).
func figure_clips() -> Array[StringName]:
	var list: Array[StringName] = []
	for f: FramePlayer in _figures:
		list.append(f.clip_id())
	return list


## Horizontal offset of a scenery layer (index in back-to-front order).
func layer_offset(index: int) -> float:
	var behind: int = _scenery_back.layer_count()
	if index < behind:
		return _scenery_back.layer_offset(index)
	return _scenery_front.layer_offset(index - behind)


func darkness() -> float:
	return _dark.color.a


# --- flow ------------------------------------------------------------------------

func _speed() -> float:
	var factor: float = BattleScreen.SPEEDS[speed_index]
	# "Instantâneo" walks at 2× (item 1): walking is the player's own pace.
	return WALK_SPEED * (factor if factor > 0.0 else 2.0)


func _walk(delta: float) -> void:
	if delta == 0.0:
		return
	var before: float = corridor.position
	corridor.move(delta)
	if not is_equal_approx(before, corridor.position):
		_facing = 1 if corridor.position > before else -1
		_set_moving(true)
	_place_world()
	if corridor.at_pending_content():
		holding = 0
		walking_to = -1.0
		_stopped()
		_reached_content()


## The party stopped walking: idle again, the place is kept, the panel shows
## what stands here.
func _stopped() -> void:
	_set_moving(false)
	var here: StringName = corridor.entrance_here() if ctrl.phase == ExpeditionController.Phase.AT_FORK else &""
	selected_entrance = here
	var n: MapNode = ctrl.current_node()
	position_changed.emit(n.id if n != null else &"", corridor.position)
	_refresh()


## Content reached (item 4): enemies attack at once; the tent, the chest and
## the soul wait for a button.
func _reached_content() -> void:
	var n: MapNode = ctrl.pending_node()
	if n == null:
		return
	if n.is_battle_like():
		_engage()
		return
	_refresh()


func _engage() -> void:
	var n: MapNode = ctrl.pending_node()
	if n == null:
		return
	var reason: StringName = run.call(ExpeditionCommand.engage_node())
	if reason != &"":
		_info.text = texts.reason(reason)
		return
	if ctrl.phase == ExpeditionController.Phase.IN_BATTLE:
		_hard_cut(n.id)
	elif ctrl.phase == ExpeditionController.Phase.AT_FORK:
		_content_resolved_here()
	else:
		node_entered.emit(n.id)


## The content was settled without leaving the corridor (Passar ao largo):
## the party goes on from here.
func _content_resolved_here() -> void:
	var n: MapNode = ctrl.current_node()
	if ctrl.phase != ExpeditionController.Phase.AT_FORK and ctrl.phase != ExpeditionController.Phase.PENDING:
		node_entered.emit(n.id if n != null else &"")
		return
	saved_place = {"node": n.id if n != null else &"", "x": corridor.position}
	arrive()


## D-359: everyone takes the guard pose, the camera comes a little closer
## and the background darkens; then the battle screen.
func _hard_cut(node_id: StringName) -> void:
	_play_all(&"defend")
	if BattleScreen.SPEEDS[speed_index] <= 0.0:
		_dark.color.a = CUT_DARK
		node_entered.emit(node_id)
		return
	busy = true
	_world.pivot_offset = Vector2(PARTY_SCREEN_X, FEET_Y)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_world, "scale", Vector2(CUT_ZOOM, CUT_ZOOM), CUT_TIME)
	tween.tween_property(_dark, "color:a", CUT_DARK, CUT_TIME)
	tween.chain().tween_callback(func() -> void:
		busy = false
		node_entered.emit(node_id))


## Back from the battle: the guard comes undone and the idle returns.
func _guard_then_idle() -> void:
	_play_all(&"defend")
	if BattleScreen.SPEEDS[speed_index] <= 0.0:
		_play_all(&"idle")
		return
	busy = true
	get_tree().create_timer(GUARD_HOLD).timeout.connect(func() -> void:
		busy = false
		_play_all(&"idle")
		_refresh())


func _use(id: StringName, target: StringName) -> void:
	var reason: StringName = run.call(ExpeditionCommand.use_provision(id, target))
	_provisions_overlay.visible = false
	_build_objects()
	_place_world()
	_refresh()
	if reason != &"":
		_info.text = texts.reason(reason)
	else:
		_info.text = texts.t(&"walk_provision_used", {"provision": texts.provision_name(id)})


func _can_use_provisions() -> bool:
	var corridor_phase: bool = ctrl.phase == ExpeditionController.Phase.AT_FORK or ctrl.phase == ExpeditionController.Phase.PENDING
	return corridor_phase and not busy and holding == 0 and walking_to < 0.0


func _overlay_open() -> bool:
	return _provisions_overlay.visible or _minimap_overlay.visible


# --- drawing -----------------------------------------------------------------------

func _set_moving(moving: bool) -> void:
	if moving == _moving and (not moving or _figure_facing() == _facing):
		return
	_moving = moving
	for f: FramePlayer in _figures:
		f.scale.x = _facing
		f.play(&"walk" if moving else &"idle")


func _figure_facing() -> int:
	return int(signf(_figures[0].scale.x)) if not _figures.is_empty() else 1


func _play_all(clip: StringName) -> void:
	for f: FramePlayer in _figures:
		f.scale.x = 1
		f.play(clip)


## The camera follows the party: the world moves under it.
func _place_world() -> void:
	var walked: float = roundf(corridor.position * CORRIDOR_LENGTH)
	_scenery_back.set_camera_x(walked)
	_scenery_front.set_camera_x(walked)
	_objects.position.x = -walked
	var shade: float = lerpf(DARKEST, 1.0, clampf(ctrl.state.light / float(ExpeditionLight.LIGHT_MAX), 0.0, 1.0))
	_scenery_back.modulate = Color(shade, shade, shade)
	_scenery_front.modulate = Color(shade, shade, shade)


func _refresh() -> void:
	if _stage == null:
		return
	for child: Node in _action_box.get_children():
		_action_box.remove_child(child)
		child.queue_free()
	for id: StringName in _entrance_views:
		(_entrance_views[id] as Control).modulate = COLOR_CHOSEN if id == selected_entrance else Color.WHITE
	_info.text = _panel_text()
	if not busy and holding == 0 and walking_to < 0.0:
		_fill_actions()
	_light_fill.size.x = LIGHT_BAR_SIZE.x * clampf(ctrl.state.light / float(ExpeditionLight.LIGHT_MAX), 0.0, 1.0)
	_light_label.text = texts.light(ctrl)
	_alms_label.text = texts.alms(ctrl)
	_provisions_button.text = texts.t(&"walk_provisions", {"count": ctrl.state.provisions.size()})
	_provisions_button.disabled = not _can_use_provisions()
	_fill_provisions()


func _panel_text() -> String:
	if busy or holding != 0 or walking_to >= 0.0:
		return ""
	var pending: MapNode = ctrl.pending_node()
	if pending != null and corridor.at_pending_content():
		return texts.type_name(pending)
	if selected_entrance != &"":
		return _entrance_info(ctrl.map.find(selected_entrance))
	return texts.t(&"walk_hint_walk")


func _fill_actions() -> void:
	var pending: MapNode = ctrl.pending_node()
	if pending != null and corridor.at_pending_content():
		match pending.type:
			MapNode.TYPE_TEMPTATION:
				_action(texts.t(&"walk_enter"), press_engage)
				_action(_pass_by_text(), press_pass_by)
			MapNode.TYPE_RELIC:
				_action(texts.t(&"walk_open"), press_engage)
			MapNode.TYPE_SOUL:
				_action(texts.t(&"walk_talk"), press_engage)
		return
	if selected_entrance != &"":
		_action(texts.t(&"walk_enter"), press_enter)


## "Passar ao largo" with its cost in view (screens §4).
func _pass_by_text() -> String:
	var option: Dictionary = ctrl.pass_by_option()
	var costs: Array[String] = []
	for out: Variant in option.get("outcomes", []):
		if not out is Dictionary:
			continue
		var kind: String = str((out as Dictionary).get("type", ""))
		if kind in ["light", "desolation", "alms"]:
			costs.append(texts.t(StringName("walk_cost_%s" % kind), {"amount": EventTexts.signed(int((out as Dictionary).get("amount", 0)))}))
	var text: String = texts.t(&"walk_pass_by")
	return text if costs.is_empty() else "%s (%s)" % [text, ", ".join(costs)]


func _action(text: String, callback: Callable) -> void:
	var button := _button(text, BUTTON_SIZE)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	button.pressed.connect(callback)
	_action_box.add_child(button)


func _entrance_info(n: MapNode) -> String:
	var lines: Array[String] = [texts.type_name(n) + " · " + texts.path_name(CorridorLook.path_kind(n.id, _straight))]
	var known: String = texts.content(ctrl, n)
	if known != "":
		lines.append(known)
	return "\n".join(lines)


## World x (at parallax 100%) where something at `fraction` stands.
func _world_x(fraction: float) -> float:
	return fraction * CORRIDOR_LENGTH + PARTY_SCREEN_X + AHEAD


## The content of the node and the entrances, placed in the corridor.
func _build_objects() -> void:
	for child: Node in _objects.get_children():
		_objects.remove_child(child)
		child.queue_free()
	_entrance_views.clear()
	_content_view = null
	var n: MapNode = ctrl.current_node()
	if corridor.has_content() and not n.is_battle_like():
		_content_view = _block(texts.type_name(n), COLOR_OBJECT if corridor.content_pending else COLOR_OBJECT_DONE, OBJECT_SIZE)
		_content_view.position = Vector2(roundf(_world_x(corridor.content_at) - OBJECT_SIZE.x * 0.5), FEET_Y - OBJECT_SIZE.y)
		_objects.add_child(_content_view)
	for id: StringName in corridor.entrance_order():
		var e: MapNode = ctrl.map.find(id)
		var kind: StringName = CorridorLook.path_kind(id, _straight)
		var text: String = texts.type_name(e) + "\n" + texts.path_name(kind)
		var view := _block(text, COLOR_STRAIGHT if kind == CorridorLook.STRAIGHT else COLOR_DETOUR, ENTRANCE_SIZE)
		view.set_meta(&"text", text)
		view.mouse_filter = Control.MOUSE_FILTER_STOP
		view.gui_input.connect(func(event: InputEvent) -> void:
			if _is_tap(event):
				tap_entrance(id)
				view.accept_event())
		view.position = Vector2(roundf(_world_x(float(corridor.entrance_at[id])) - ENTRANCE_SIZE.x * 0.5), FEET_Y - ENTRANCE_SIZE.y)
		_objects.add_child(view)
		_entrance_views[id] = view


static func _is_tap(event: InputEvent) -> bool:
	if event is InputEventScreenTouch:
		return not (event as InputEventScreenTouch).pressed
	return event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and not (event as InputEventMouseButton).pressed


## The party in formation, the vanguard (first) on the right, walking right.
func _build_party() -> void:
	for child: Node in _party.get_children():
		_party.remove_child(child)
		child.queue_free()
	_figures.clear()
	_moving = false
	for i: int in ctrl.state.party.size():
		var saint_id: StringName = ctrl.state.party[i]
		var x: float = PARTY_SCREEN_X - i * FIGURE_STEP
		var frames: CharacterFrames = _frames_for(saint_id)
		if frames != null:
			var player := FramePlayer.new()
			player.position = Vector2(x, FEET_Y)
			player.speed = maxf(BattleScreen.SPEEDS[speed_index], 1.0)
			player.setup(frames, Vector2.ZERO, BattleScreen.figure_px_of(frames) * frames.display_scale)
			CircleLook.light_figure(player, true)
			if not BattleScreen.is_pixel_art(frames):
				player.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			_party.add_child(player)
			_figures.append(player)
			continue
		var block := _block(texts.saint_name(saint_id), COLOR_SAINT, Vector2(80, 200))
		block.position = Vector2(x - 40, FEET_Y - 200)
		_party.add_child(block)


## Pixel art frames first (T64); a saint without them keeps the painted ones.
func _frames_for(saint_id: StringName) -> CharacterFrames:
	for dir: String in FRAMES_DIRS:
		var path: String = dir.path_join("%s_frames.tres" % saint_id)
		if ResourceLoader.exists(path):
			return load(path) as CharacterFrames
	return null


func _fill_provisions() -> void:
	for child: Node in _provisions_list.get_children():
		_provisions_list.remove_child(child)
		child.queue_free()
	if pending_provision != &"":
		_provisions_list.add_child(_label(texts.t(&"walk_choose_saint", {"provision": texts.provision_name(pending_provision)})))
		for saint_id: StringName in ctrl.state.party:
			var target := _button(texts.saint_name(saint_id), LIST_BUTTON_SIZE)
			target.pressed.connect(press_provision_target.bind(saint_id))
			_provisions_list.add_child(target)
		return
	var counts: Dictionary = {}
	var order: Array[StringName] = []
	for id: StringName in ctrl.state.provisions:
		if not counts.has(id):
			order.append(id)
		counts[id] = int(counts.get(id, 0)) + 1
	if order.is_empty():
		_provisions_list.add_child(_label(texts.t(&"walk_no_provisions")))
	for id: StringName in order:
		var problem: StringName = ctrl.field_provision_problem(id, ctrl.state.party[0] if not ctrl.state.party.is_empty() else &"")
		var line: String = texts.t(&"walk_provision_line", {"provision": texts.provision_name(id), "count": counts[id]})
		if problem != &"":
			line += " · " + texts.reason(problem)
		var button := _button(line, LIST_BUTTON_SIZE)
		button.set_meta(&"provision", id)
		button.disabled = problem != &""
		button.pressed.connect(press_provision.bind(id))
		_provisions_list.add_child(button)


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((_screen_size() - STAGE_SIZE) * 0.5).floor()
		_layout_field()


## Never centre on a zero size (the T17 phone bug, lessons.md).
func _screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


## The field takes the whole width of the screen, as in the battle.
func _layout_field() -> void:
	if _field_clip == null:
		return
	var margin: float = maxf(_stage.position.x, 0.0)
	var wide := Vector2(STAGE_SIZE.x + margin * 2.0, FIELD_HEIGHT)
	_field_clip.position = Vector2(-margin, 0)
	_field_clip.size = wide
	_world.position = Vector2(margin, 0)
	for scenery: ParallaxScenery in [_scenery_back, _scenery_front]:
		scenery.position = Vector2(-margin, 0)
		scenery.size = wide
	_dark.size = wide


func _build() -> void:
	# The interface in pixel art (T65): Jersey 10, flat iron buttons.
	theme = PixelStyle.theme()
	clip_contents = true
	# The screen itself takes the held finger; buttons on top take their taps.
	mouse_filter = Control.MOUSE_FILTER_STOP
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_field_clip = Control.new()
	_field_clip.size = Vector2(STAGE_SIZE.x, FIELD_HEIGHT)
	_field_clip.clip_contents = true
	_field_clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_field_clip)
	_world = Control.new()
	_world.size = _field_clip.size
	_world.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field_clip.add_child(_world)
	# Scenery of leg 1 of Circle 2 (asset-pipeline §4: the sky moves about
	# 20%, the middle 100%, the front about 130%); the party walks between
	# the middle and the front.
	_scenery_back = ParallaxScenery.new()
	_scenery_back.setup(CircleLook.back_layers(CircleLook.SET_LEG_1), CircleLook.filter_material())
	_world.add_child(_scenery_back)
	_objects = Control.new()
	_objects.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_world.add_child(_objects)
	_party = Control.new()
	_party.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_world.add_child(_party)
	_scenery_front = ParallaxScenery.new()
	_scenery_front.setup(CircleLook.front_layers(CircleLook.SET_LEG_1), CircleLook.filter_material())
	_scenery_front.drop = FRONT_DROP
	_world.add_child(_scenery_front)
	_dark = ColorRect.new()
	_dark.color = Color(0, 0, 0, 0)
	_dark.size = _field_clip.size
	_dark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_field_clip.add_child(_dark)
	_build_panel()
	_build_provisions_overlay()
	_build_minimap_overlay()
	_layout_field()


## The panel under the field, in the same place as the battle's: the Lume
## and the Alms on the left with Provisões and Mapa (D-258), what stands
## here and its buttons in the middle.
func _build_panel() -> void:
	_stage.add_child(PixelStyle.plate(Rect2(-OVERLAY_MARGIN, FIELD_HEIGHT, STAGE_SIZE.x + OVERLAY_MARGIN * 2.0, STAGE_SIZE.y - FIELD_HEIGHT + 1.0)))
	var top: float = FIELD_HEIGHT
	_light_label = _label("")
	_light_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_light_label.position = Vector2(16, top + 10)
	_light_label.size = Vector2(LIGHT_BAR_SIZE.x, 12)
	_light_label.add_theme_color_override("font_color", PixelStyle.COLOR_AMBER)
	_stage.add_child(_light_label)
	var light_back := ColorRect.new()
	light_back.color = COLOR_LIGHT_OFF
	light_back.position = Vector2(16, top + 24)
	light_back.size = LIGHT_BAR_SIZE
	light_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(light_back)
	_light_fill = ColorRect.new()
	_light_fill.color = COLOR_LIGHT_ON
	_light_fill.size = LIGHT_BAR_SIZE
	_light_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	light_back.add_child(_light_fill)
	_alms_label = _label("")
	_alms_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_alms_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_alms_label.position = Vector2(16, top + 36)
	_alms_label.size = Vector2(LIGHT_BAR_SIZE.x + 20.0, 24)
	_stage.add_child(_alms_label)
	_provisions_button = _button("", BUTTON_SIZE)
	_provisions_button.position = Vector2(16, top + 66)
	_provisions_button.pressed.connect(press_provisions)
	_stage.add_child(_provisions_button)
	var minimap_button := _button(texts.t(&"walk_minimap"), BUTTON_SIZE)
	minimap_button.position = Vector2(16, top + 104)
	minimap_button.pressed.connect(press_minimap)
	_stage.add_child(minimap_button)
	_info = _label("")
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.position = Vector2(190, top + 14)
	_info.size = Vector2(580, 72)
	_stage.add_child(_info)
	_action_box = HBoxContainer.new()
	_action_box.position = Vector2(190, top + 104)
	_action_box.size = Vector2(580, BUTTON_SIZE.y)
	_action_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_action_box.add_theme_constant_override("separation", 10)
	_stage.add_child(_action_box)


func _build_provisions_overlay() -> void:
	_provisions_overlay = Control.new()
	_provisions_overlay.size = STAGE_SIZE
	_provisions_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_provisions_overlay.visible = false
	_stage.add_child(_provisions_overlay)
	_provisions_overlay.add_child(PixelStyle.plate(Rect2(16, 110, LIST_BUTTON_SIZE.x + 16.0, 240), COLOR_DIM))
	_provisions_list = VBoxContainer.new()
	_provisions_list.position = Vector2(24, 118)
	_provisions_list.add_theme_constant_override("separation", 4)
	_provisions_overlay.add_child(_provisions_list)


func _build_minimap_overlay() -> void:
	_minimap_overlay = Control.new()
	_minimap_overlay.size = STAGE_SIZE
	_minimap_overlay.visible = false
	_stage.add_child(_minimap_overlay)
	# A tap anywhere outside the map closes it (screens §4).
	var dim := Button.new()
	dim.flat = true
	dim.position = Vector2(-OVERLAY_MARGIN, 0)
	dim.size = STAGE_SIZE + Vector2(OVERLAY_MARGIN * 2.0, 0)
	var dim_style := StyleBoxFlat.new()
	dim_style.bg_color = COLOR_DIM
	for state_name: String in ["normal", "hover", "pressed", "focus"]:
		dim.add_theme_stylebox_override(state_name, dim_style)
	dim.pressed.connect(close_minimap)
	_minimap_overlay.add_child(dim)
	_minimap_overlay.add_child(PixelStyle.plate(Rect2(30, 44, 900, 440)))
	_minimap = MiniMapView.new()
	_minimap.position = Vector2(50, 60)
	_minimap.size = Vector2(860, 400)
	_minimap.mouse_filter = Control.MOUSE_FILTER_STOP
	_minimap.setup(ctrl, texts)
	_minimap_overlay.add_child(_minimap)
	var close_button := _button(texts.t(&"walk_minimap_close"), BUTTON_SIZE)
	close_button.position = Vector2(STAGE_SIZE.x - BUTTON_SIZE.x - 30, 8)
	close_button.pressed.connect(close_minimap)
	_minimap_overlay.add_child(close_button)


## A plain block with a centred text (provisional art for objects and
## entrances until the drawn ones arrive, T53).
func _block(text: String, color: Color, block_size: Vector2) -> ColorRect:
	var block := ColorRect.new()
	block.color = color
	block.size = block_size
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var label := _label(text)
	label.size = Vector2(block_size.x, 48)
	label.position = Vector2(0, roundf(block_size.y * 0.3))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	block.add_child(label)
	return block


func _label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	return button
