class_name TitleScreen
extends Control
## The game's first screen in the M1 (screens §2): Continue (the saved leg)
## and New leg (preparation, then the walk). In dev builds it also opens the
## M0 arena. It holds the loaded data and swaps the screens it opens.

## M1 data ids: one leg of Circle 2 with the arena groups and the fixed kit
## (expedition §13, D-123).
const CIRCLE: StringName = &"circle_02"
const KIT: StringName = &"m1_kit"
const EXPEDITION_NUMBER: int = 1
const STAGE_SIZE := Vector2(1920, 1080)
const BUTTON_SIZE := Vector2(720, 110)
const COLOR_BACKGROUND := Color(0.06, 0.05, 0.06)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)

var data: GameData
var catalog: ExpeditionCatalog
## Commands saved through GameState / SaveService. Off in tests.
var use_game_state: bool = true
## Campaign seed of the next new leg; 0 draws one from the clock.
var fixed_seed: int = 0
## Animation speed of the leg; -1 uses the saved preference (tests: instant).
var speed_override: int = -1
## Dev builds (debug or "dev_tools" exports) show the arena button.
var dev_tools: bool = OS.is_debug_build() or OS.has_feature("dev_tools")
## The leg, preparation or arena on top of the menu, or null.
var screen: Control
var leg: LegScreen
## New leg tapped once while a save exists (the second tap confirms).
var new_armed: bool = false

var _menu: Control
var _continue: Button
var _new: Button
var _message: Label


func setup(p_data: GameData, p_catalog: ExpeditionCatalog) -> void:
	data = p_data
	catalog = p_catalog


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if data == null:
		data = GameData.load_all()
		catalog = data.load_expedition_catalog()
	_build()
	refresh()


func refresh() -> void:
	_continue.disabled = not has_save()
	_new.modulate = COLOR_CHOSEN if new_armed else Color.WHITE


func has_save() -> bool:
	var service: Node = _service()
	if service == null:
		return false
	return (service.get("store") as SaveStore).exists()


# --- player input (also called by the tests) ------------------------------------

func press_continue() -> void:
	var state: Node = _game_state()
	if state == null:
		return
	var status: StringName = state.call("continue_saved", catalog)
	var ctrl: ExpeditionController = state.get("expedition")
	if ctrl == null:
		var key: StringName = &"title_save_corrupt"
		if status == SaveStore.STATUS_FUTURE:
			key = &"title_save_future"
		elif status == SaveStore.STATUS_NONE:
			key = &"title_no_save"
		_message.text = data.ui.text(key)
		return
	_message.text = data.ui.text(&"title_save_from_backup") if status == SaveStore.STATUS_FROM_BACKUP else ""
	open_leg(ctrl)


## New leg: with a save, the first tap warns that it will be replaced.
func press_new_leg() -> void:
	if has_save() and not new_armed:
		new_armed = true
		_message.text = data.ui.text(&"title_confirm_new")
		refresh()
		return
	new_armed = false
	_message.text = ""
	_open(_preparation())


## Preparation's "Partir": a new expedition from the gate, saved at once.
func press_depart() -> void:
	var campaign_seed: int = fixed_seed if fixed_seed != 0 else int(Time.get_unix_time_from_system()) ^ Time.get_ticks_usec()
	var map_seed: int = ExpeditionController.map_seed_for(campaign_seed, CIRCLE, EXPEDITION_NUMBER)
	var ctrl := ExpeditionController.start_new(catalog, CIRCLE, map_seed, GameData.M0_FORMATION, catalog.kit_provisions(KIT), EncounterDef.ARENA_CIRCLE)
	var state: Node = _game_state()
	if state != null:
		state.call("start_expedition", catalog, ctrl, campaign_seed)
	open_leg(ctrl)


func press_arena() -> void:
	if not dev_tools:
		return
	var arena := ArenaScreen.new()
	arena.setup(data)
	arena.title_requested.connect(back_to_menu)
	_open(arena)


func open_leg(ctrl: ExpeditionController) -> void:
	leg = LegScreen.new()
	leg.use_game_state = use_game_state
	leg.speed_index = speed_override if speed_override >= 0 else _speed()
	leg.setup(data, catalog, ctrl)
	leg.title_requested.connect(back_to_menu)
	_open(leg)


func back_to_menu() -> void:
	if screen != null and is_instance_valid(screen):
		screen.queue_free()
	screen = null
	leg = null
	_menu.visible = true
	refresh()


func message_text() -> String:
	return _message.text


func menu_shown() -> bool:
	return _menu.visible


# --- drawing -----------------------------------------------------------------------

func _open(p_screen: Control) -> void:
	if screen != null and is_instance_valid(screen):
		screen.queue_free()
	screen = p_screen
	_menu.visible = false
	add_child(p_screen)


## Party in formation and the provisions of the kit, then "Partir".
func _preparation() -> Control:
	var root := CenterContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.set_meta(&"kind", &"preparation")
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 24)
	root.add_child(box)
	box.add_child(_label(data.ui.text(&"prep_title"), 52))
	var names: Array[String] = []
	for id: StringName in GameData.M0_FORMATION:
		var def: SaintDef = data.saints.get(id)
		names.append(def.name_pt if def != null else String(id))
	box.add_child(_label(data.ui.text(&"prep_party") + "\n" + " · ".join(names), 30))
	var counts: Dictionary = {}
	var order: Array[StringName] = []
	for id: StringName in catalog.kit_provisions(KIT):
		if not counts.has(id):
			order.append(id)
		counts[id] = int(counts.get(id, 0)) + 1
	var items: Array[String] = []
	for id: StringName in order:
		var def: ProvisionDef = data.catalog.provision(id)
		items.append(data.ui.text(&"walk_provision_line", {"provision": def.name_pt if def != null else String(id), "count": counts[id]}))
	box.add_child(_label(data.ui.text(&"prep_kit") + "\n" + " · ".join(items), 30))
	var depart := _button(data.ui.text(&"prep_depart"))
	depart.pressed.connect(press_depart)
	box.add_child(depart)
	var back := _button(data.ui.text(&"prep_back"))
	back.pressed.connect(back_to_menu)
	box.add_child(back)
	return root


func _build() -> void:
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_menu = CenterContainer.new()
	_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_menu)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 26)
	_menu.add_child(box)
	box.add_child(_label(data.ui.text(&"title_name"), 84))
	box.add_child(_label(data.ui.text(&"title_subtitle"), 40))
	_continue = _button(data.ui.text(&"title_continue"))
	_continue.pressed.connect(press_continue)
	box.add_child(_continue)
	_new = _button(data.ui.text(&"title_new_leg"))
	_new.pressed.connect(press_new_leg)
	box.add_child(_new)
	if dev_tools:
		var arena := _button(data.ui.text(&"title_arena"))
		arena.pressed.connect(press_arena)
		box.add_child(arena)
	_message = _label("", 28)
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.custom_minimum_size = Vector2(BUTTON_SIZE.x + 300, 0)
	box.add_child(_message)


func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = BUTTON_SIZE
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.add_theme_font_size_override("font_size", 36)
	return button


## The remembered animation speed (settings.json), 0 without SaveService.
func _speed() -> int:
	var service: Node = _service()
	if service == null:
		return 0
	var settings: SettingsStore = service.get("settings")
	return clampi(int(settings.get_value("animation_speed", 0)), 0, BattleScreen.SPEEDS.size() - 1)


func _service() -> Node:
	if not use_game_state or not is_inside_tree():
		return null
	return get_node_or_null("/root/SaveService")


func _game_state() -> Node:
	if not use_game_state or not is_inside_tree():
		return null
	return get_node_or_null("/root/GameState")
