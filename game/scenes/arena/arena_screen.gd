class_name ArenaScreen
extends Control
## M0 test arena (screens §2: Abertura → Arena de teste → Combate →
## Resultado): pick one of the arena encounters and a seed, play the battle,
## come back. Built in code on the same 1920×1080 stage as the battle.

const STAGE_SIZE := Vector2(1920, 1080)
const COLOR_BACKGROUND := Color(0.09, 0.07, 0.08)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const BUTTON_SIZE := Vector2(1100, 96)
const DEFAULT_SEED: int = 1

var data: GameData
var encounter_ids: Array[StringName] = []
var chosen: StringName = &""
var arena_seed: int = DEFAULT_SEED
## The running battle, or null while the arena is shown.
var battle: BattleScreen
## The animation test screen (T35), or null.
var animations: AnimationTestScreen
## Speed the next battle starts with (tests use the instant one).
var battle_speed_index: int = 0
## Emitted by "Voltar ao título" (the title opens the arena in dev builds).
signal title_requested

var _stage: Control
var _menu: Control
var _encounter_buttons: Array[Button] = []
var _seed_label: Label


func setup(p_data: GameData) -> void:
	data = p_data


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if data == null:
		data = GameData.load_all()
	encounter_ids = data.arena_encounter_ids()
	if not encounter_ids.is_empty():
		chosen = encounter_ids[0]
	_build()
	_center_stage()
	_refresh()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


# --- input (also called by the tests) ------------------------------------------

func choose(encounter_id: StringName) -> void:
	if encounter_ids.has(encounter_id):
		chosen = encounter_id
		_refresh()


func change_seed(delta: int) -> void:
	arena_seed = maxi(1, arena_seed + delta)
	_refresh()


func start() -> void:
	if chosen == &"" or battle != null:
		return
	battle = BattleScreen.new()
	battle.encounter_id = chosen
	battle.battle_seed = arena_seed
	battle.speed_index = battle_speed_index
	battle.show_back_button = true
	battle.setup(data, BattleController.new(data.battle(chosen, arena_seed)))
	battle.settings = _settings()
	battle.back_requested.connect(back_to_arena)
	_menu.visible = false
	add_child(battle)


func open_animations() -> void:
	if battle != null or animations != null:
		return
	animations = AnimationTestScreen.new()
	animations.setup(data)
	animations.back_requested.connect(close_animations)
	_menu.visible = false
	add_child(animations)


func close_animations() -> void:
	if animations == null:
		return
	animations.queue_free()
	animations = null
	_menu.visible = true


func press_title() -> void:
	title_requested.emit()


func back_to_arena() -> void:
	if battle == null:
		return
	# "Jogar de novo" may have moved the seed on; keep it for the next start.
	arena_seed = battle.battle_seed
	battle.queue_free()
	battle = null
	_menu.visible = true
	_refresh()


func encounter_label(encounter_id: StringName) -> String:
	var enc: EncounterDef = data.encounters[encounter_id]
	var names: Array[String] = []
	for enemy_id: StringName in enc.slots:
		var def: EnemyDef = data.catalog.enemies.get(enemy_id)
		names.append(def.name_pt if def != null else String(enemy_id))
	return data.ui.text(&"arena_encounter", {"pool": data.ui.text(StringName("pool_%s" % enc.pool)), "enemies": ", ".join(names)})


# --- drawing -----------------------------------------------------------------------

func _refresh() -> void:
	if _seed_label == null:
		return
	for i: int in _encounter_buttons.size():
		_encounter_buttons[i].modulate = COLOR_CHOSEN if encounter_ids[i] == chosen else Color.WHITE
	_seed_label.text = data.ui.text(&"arena_seed", {"seed": arena_seed})


## The area this screen fills. A screen created in code (the battle inside
## the arena) only gets its size after layout, so the viewport is the
## fallback; never centre on a zero size (the T17 phone bug).
func screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


func stage_position() -> Vector2:
	return _stage.position if _stage != null else Vector2.ZERO


func _center_stage() -> void:
	if _stage != null:
		_stage.position = ((screen_size() - STAGE_SIZE) * 0.5).floor()


func _build() -> void:
	var ui_theme := Theme.new()
	ui_theme.default_font_size = 30
	theme = ui_theme
	var background := ColorRect.new()
	background.color = COLOR_BACKGROUND
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_menu = Control.new()
	_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_menu)
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu.add_child(_stage)
	var box := VBoxContainer.new()
	box.position = Vector2((STAGE_SIZE.x - BUTTON_SIZE.x) * 0.5, 50)
	box.custom_minimum_size = Vector2(BUTTON_SIZE.x, 0)
	box.add_theme_constant_override("separation", 18)
	_stage.add_child(box)
	box.add_child(_label(data.ui.text(&"arena_title"), 52))
	box.add_child(_label(data.ui.text(&"arena_choose"), 28))
	for id: StringName in encounter_ids:
		var button := _button(encounter_label(id), BUTTON_SIZE)
		button.pressed.connect(choose.bind(id))
		box.add_child(button)
		_encounter_buttons.append(button)
	var seed_row := HBoxContainer.new()
	seed_row.alignment = BoxContainer.ALIGNMENT_CENTER
	seed_row.add_theme_constant_override("separation", 30)
	var minus := _button(data.ui.text(&"arena_seed_minus"), Vector2(120, 96))
	minus.pressed.connect(change_seed.bind(-1))
	seed_row.add_child(minus)
	_seed_label = _label("", 34)
	_seed_label.custom_minimum_size = Vector2(320, 96)
	_seed_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	seed_row.add_child(_seed_label)
	var plus := _button(data.ui.text(&"arena_seed_plus"), Vector2(120, 96))
	plus.pressed.connect(change_seed.bind(1))
	seed_row.add_child(plus)
	box.add_child(seed_row)
	var start_button := _button(data.ui.text(&"arena_start"), Vector2(BUTTON_SIZE.x, 110))
	start_button.pressed.connect(start)
	box.add_child(start_button)
	var animations_button := _button(data.ui.text(&"arena_animations"), Vector2(BUTTON_SIZE.x, 96))
	animations_button.pressed.connect(open_animations)
	box.add_child(animations_button)
	var title_button := _button(data.ui.text(&"back_to_title"), Vector2(BUTTON_SIZE.x, 96))
	title_button.pressed.connect(press_title)
	box.add_child(title_button)


func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	return button


func _init() -> void:
	var saved: SettingsStore = _settings()
	if saved != null:
		battle_speed_index = clampi(int(saved.get_value("animation_speed", 0)), 0, BattleScreen.SPEEDS.size() - 1)


## The remembered preferences (SaveService autoload), if it is running.
static func _settings() -> SettingsStore:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return null
	var service: Node = tree.root.get_node_or_null("SaveService")
	return service.get("settings") if service != null else null
