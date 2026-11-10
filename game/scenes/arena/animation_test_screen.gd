class_name AnimationTestScreen
extends Control
## "Animações (teste)" (T35): every character with frame sheets, one button
## per movement. The chosen character stands on its side of the field (saints
## on the left, enemies on the right) with an opponent on the other side who
## takes the blow. Opened from the test arena; built in code on the
## 1920×1080 stage.

signal back_requested

const STAGE_SIZE := Vector2(1920, 1080)
const COLOR_BACKGROUND := Color(0.09, 0.07, 0.08)
const COLOR_GROUND := Color(0.16, 0.12, 0.11)
const COLOR_CHOSEN := Color(1.0, 0.9, 0.55)
const FRAMES_DIR: String = "res://scenes/battle/combatants"
const FRAMES_SUFFIX: String = "_frames.tres"
## Layout of the field (presentation only).
const GROUND_Y: float = 820.0
const VIEW_WIDTH: float = 200.0
## 1.7 × 1.2: Alan asked for the figures 20% bigger (D-233).
const VIEW_SCALE: float = 2.04
const SAINT_CENTER_X: float = 480.0
const ENEMY_CENTER_X: float = 1400.0
## Share of the two figures' widths kept apart when the attacker arrives
## (the frames have room around the figure).
const CONTACT_SHARE: float = 0.55
## G1: how long the camera holds on a physical blow (seconds at speed 1).
const BLOW_HOLD: float = 0.45
const CHAR_BUTTON := Vector2(290, 80)
const MOVE_BUTTON := Vector2(196, 90)
## Who takes the blow (any listed character of the other side if missing).
const SAINTS_OPPONENT: StringName = &"elite_sin_vertigo"
const ENEMIES_OPPONENT: StringName = &"saint_george"
const MOVES: Array[StringName] = [&"idle", &"walk", &"attack", &"spell", &"blessing", &"defend", &"hit", &"fall"]

var data: GameData
var character_ids: Array[StringName] = []
var chosen: StringName = &""
var speed: float = 1.0
## The chosen character and its opponent on the field.
var actor: CombatantView
var opponent: CombatantView
var camera: ImpactCamera

var _stage: Control
var _field: Control
var _flash: ColorRect
var _dim: ColorRect
var _char_buttons: Array[Button] = []
var _halo_settings: HaloSettings


func setup(p_data: GameData) -> void:
	data = p_data


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if data == null:
		data = GameData.load_all()
	_halo_settings = load(BattleScreen.HALO_SETTINGS_PATH) as HaloSettings
	character_ids = list_characters()
	_build()
	_center_stage()
	if not character_ids.is_empty():
		choose(character_ids[0])


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_center_stage()


## Every character with frames: saints first, then the others, by id.
static func list_characters() -> Array[StringName]:
	# Sorted as text: StringName sorts by identity, not alphabetically.
	var saints: Array[String] = []
	var others: Array[String] = []
	for file: String in ResourceLoader.list_directory(FRAMES_DIR):
		if not file.ends_with(FRAMES_SUFFIX):
			continue
		var id: String = file.trim_suffix(FRAMES_SUFFIX)
		if id.begins_with("saint_"):
			saints.append(id)
		else:
			others.append(id)
	saints.sort()
	others.sort()
	var ids: Array[StringName] = []
	for id: String in saints + others:
		ids.append(StringName(id))
	return ids


static func frames_of(id: StringName) -> CharacterFrames:
	return load("%s/%s%s" % [FRAMES_DIR, id, FRAMES_SUFFIX]) as CharacterFrames


static func is_saint_id(id: StringName) -> bool:
	return String(id).begins_with("saint_")


# --- input (also called by the tests) ------------------------------------------

func choose(id: StringName) -> void:
	if not character_ids.has(id):
		return
	chosen = id
	_rebuild_views()
	for i: int in _char_buttons.size():
		_char_buttons[i].modulate = COLOR_CHOSEN if character_ids[i] == chosen else Color.WHITE


## Plays one movement of the chosen character; returns its length.
func play(move: StringName) -> float:
	if actor == null:
		return 0.0
	if actor.player() != null and actor.player().clip_id() == &"fall" and move != &"fall":
		_rebuild_views()  # stand up again after the fall
	match move:
		&"idle":
			return actor.play_idle()
		&"walk":
			return actor.play_walk()
		&"attack":
			return actor.play_action(&"", reach(), opponent.chest_global() if opponent != null else Vector2.INF)
		&"spell":
			return actor.play_spell(opponent.chest_global() if opponent != null else actor.chest_global(), opponent)
		&"blessing":
			return actor.play_blessing()
		&"defend":
			return actor.play_defend()
		&"hit":
			return actor.play_hit()
		&"fall":
			return actor.play_fall()
	return 0.0


## How dark the scenery is right now (G1 darkens it on a blow).
func dim_alpha() -> float:
	return _dim.color.a if _dim != null else 0.0


func press_back() -> void:
	back_requested.emit()


## How far the attacker slides to stand before its opponent, in its own
## (unscaled) pixels.
func reach() -> float:
	if actor == null or opponent == null:
		return 0.0
	var gap: float = (actor.player().figure_width() + opponent.player().figure_width()) * 0.5 * CONTACT_SHARE
	return maxf(0.0, (ENEMY_CENTER_X - SAINT_CENTER_X - gap * VIEW_SCALE) / VIEW_SCALE)


func opponent_of(id: StringName) -> StringName:
	var want_saint: bool = not is_saint_id(id)
	var preferred: StringName = ENEMIES_OPPONENT if want_saint else SAINTS_OPPONENT
	if character_ids.has(preferred):
		return preferred
	for other: StringName in character_ids:
		if is_saint_id(other) == want_saint:
			return other
	return &""


# --- drawing -----------------------------------------------------------------------

func _rebuild_views() -> void:
	for view: CombatantView in [actor, opponent]:
		if view != null:
			view.queue_free()
	actor = _make_view(chosen)
	var other: StringName = opponent_of(chosen)
	opponent = _make_view(other) if other != &"" else null
	if actor != null:
		actor.impact.connect(_on_impact)


func _make_view(id: StringName) -> CombatantView:
	var frames: CharacterFrames = frames_of(id)
	if frames == null:
		return null
	var saint: bool = is_saint_id(id)
	var view := CombatantView.new()
	view.setup(id, saint, VIEW_WIDTH, null, null, frames)
	view.set_halo_settings(_halo_settings)
	view.set_info_visible(false)
	view.speed = speed
	view.scale = Vector2(VIEW_SCALE, VIEW_SCALE)
	var feet_local := Vector2(VIEW_WIDTH * 0.5, CombatantView.INTENT_HEIGHT + CombatantView.BODY_HEIGHT)
	var center_x: float = SAINT_CENTER_X if saint else ENEMY_CENTER_X
	view.position = Vector2(center_x, GROUND_Y) - feet_local * VIEW_SCALE
	_field.add_child(view)
	return view


func _on_impact(at: Vector2, strength: float, kind: StringName) -> void:
	if kind == &"physical":
		camera.blow(at, speed, BLOW_HOLD / speed if speed > 0.0 else 0.0)
	else:
		camera.punch(at, speed, strength)
	if opponent == null:
		return
	if kind == &"outline":
		opponent.play_spirit_hit()
	else:
		opponent.play_hit()


func screen_size() -> Vector2:
	if size.x > 0.0 and size.y > 0.0:
		return size
	return get_viewport_rect().size if is_inside_tree() else STAGE_SIZE


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
	_stage = Control.new()
	_stage.size = STAGE_SIZE
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	_field = Control.new()
	_field.size = STAGE_SIZE
	_field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_field)
	var ground := ColorRect.new()
	ground.color = COLOR_GROUND
	ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ground.position = Vector2(-200, GROUND_Y)
	ground.size = Vector2(STAGE_SIZE.x + 400, STAGE_SIZE.y - GROUND_Y + 200)
	_field.add_child(ground)
	# G1: darkens the scenery (not the fighters, added after it) on a blow.
	_dim = ColorRect.new()
	_dim.color = Color(0.02, 0.01, 0.02, 0.0)
	_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dim.position = Vector2(-400, -400)
	_dim.size = STAGE_SIZE + Vector2(800, 800)
	_field.add_child(_dim)
	_flash = ColorRect.new()
	_flash.color = Color(1, 1, 1, 0)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_flash.size = STAGE_SIZE
	_stage.add_child(_flash)
	camera = ImpactCamera.new(_field, _flash, _dim)
	var title := _label(data.ui.text(&"anim_test_title"), 36)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.position = Vector2(30, 16)
	_stage.add_child(title)
	var chars := HBoxContainer.new()
	chars.alignment = BoxContainer.ALIGNMENT_CENTER
	chars.add_theme_constant_override("separation", 12)
	chars.position = Vector2(0, GROUND_Y + 135)
	chars.custom_minimum_size = Vector2(STAGE_SIZE.x, 0)
	_stage.add_child(chars)
	for id: StringName in character_ids:
		var button := _button(data.ui.text(StringName("anim_name_%s" % id)), CHAR_BUTTON)
		button.pressed.connect(choose.bind(id))
		chars.add_child(button)
		_char_buttons.append(button)
	var moves := HBoxContainer.new()
	moves.alignment = BoxContainer.ALIGNMENT_CENTER
	moves.add_theme_constant_override("separation", 10)
	moves.position = Vector2(0, GROUND_Y + 30)
	moves.custom_minimum_size = Vector2(STAGE_SIZE.x, 0)
	_stage.add_child(moves)
	for move: StringName in MOVES:
		var button := _button(data.ui.text(StringName("anim_%s" % move)), MOVE_BUTTON)
		button.pressed.connect(func() -> void: play(move))
		moves.add_child(button)
	var back := _button(data.ui.text(&"back_to_arena"), MOVE_BUTTON)
	back.pressed.connect(press_back)
	moves.add_child(back)


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
