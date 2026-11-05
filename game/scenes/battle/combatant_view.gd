class_name CombatantView
extends Control
## One saint or enemy on screen (architecture §8). T15 draws a coloured
## rectangle with the name in place of the art; the animation interface
## (play_idle, play_action, play_hit, play_fall) stays the same when the art
## arrives (ADR-0007). It only shows state; it never decides a rule.

signal tapped(combatant_id: StringName)

enum Mark { NONE, SELECTED, TARGETABLE, PENDING, INTENT_TARGET }

const BODY_HEIGHT: float = 200.0
const INTENT_HEIGHT: float = 56.0
const COLOR_SAINT := Color(0.24, 0.36, 0.62)
const COLOR_ENEMY := Color(0.55, 0.18, 0.16)
const COLOR_DOWN := Color(0.22, 0.22, 0.24)
const COLOR_TEXT := Color(0.96, 0.94, 0.88)
const COLOR_PREVIEW := Color(1.0, 0.86, 0.35)
const MARK_COLORS: Dictionary = {
	Mark.NONE: Color(0, 0, 0, 0),
	Mark.SELECTED: Color(1.0, 0.84, 0.3),
	Mark.TARGETABLE: Color(0.45, 0.95, 0.55),
	Mark.PENDING: Color(1.0, 1.0, 1.0),
	Mark.INTENT_TARGET: Color(1.0, 0.4, 0.3),
}
## Seconds of each animation at speed 1 (presentation only).
const ACTION_TIME: float = 0.3
const HIT_TIME: float = 0.25
const FALL_TIME: float = 0.45
const FLOAT_TIME: float = 0.8
## Saint figure on screen (2:3, like the body textures of asset-pipeline §4).
const FIGURE_SIZE := Vector2(200, 300)
const COLOR_OUTLINE := Color(0, 0, 0, 0.9)
const SHADER_PATH: String = "res://shaders/halo.gdshader"

var combatant_id: StringName
var is_saint: bool = true
## Animation speed factor: 1 normal, 2 fast, 0 instant (no tween at all).
var speed: float = 1.0
var mark: Mark = Mark.NONE

var _intent: Label
var _body: Panel
var _style: StyleBoxFlat
var _name: Label
var _slot: Label
var _status: Label
var _hp_bar: ProgressBar
var _hp: Label
var _desolation: Label
var _conditions: Label
var _preview: Label
var _down: bool = false
var _dimmed: bool = false
## Art of the saint (null: the T15 placeholder rectangle).
var _art: CombatantArt
var _halo_settings: HaloSettings
var _figure: TextureRect
var _figure_material: ShaderMaterial
var _halo: HaloView
var _spirit_state: StringName = Desolation.NORMAL
var _spirit_desolation: int = 0
## Action pose on screen (&"attack", &"hit", &"fall") or &"" for the body
## of the spiritual state.
var _pose: StringName = &""


## `art` and `halo_settings` are optional: without them the combatant is a
## coloured rectangle with its name (T15).
func setup(p_id: StringName, p_is_saint: bool, width: float, art: CombatantArt = null, halo_settings: HaloSettings = null) -> void:
	_art = art if halo_settings != null else null
	_halo_settings = halo_settings
	combatant_id = p_id
	is_saint = p_is_saint
	name = String(p_id)
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(width, 0)
	size = Vector2(width, INTENT_HEIGHT + BODY_HEIGHT + 200.0)
	_intent = _label(Vector2(0, 0), Vector2(width, INTENT_HEIGHT), 22)
	_intent.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_body = Panel.new()
	_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_body.position = Vector2(0, INTENT_HEIGHT)
	_body.size = Vector2(width, BODY_HEIGHT)
	_style = StyleBoxFlat.new()
	_style.set_corner_radius_all(10)
	_style.set_border_width_all(6)
	_body.add_theme_stylebox_override("panel", _style)
	add_child(_body)
	if _art != null:
		_build_figure(width)
	_slot = _label(Vector2(0, 8), Vector2(width, 30), 20, _body)
	if _art != null:
		# The figure fills the panel: name and state go at its feet, outlined.
		_name = _label(Vector2(0, BODY_HEIGHT - 44), Vector2(width, 40), 24, _body)
		_status = _label(Vector2(0, BODY_HEIGHT - 80), Vector2(width, 36), 22, _body)
		for label: Label in [_slot, _name, _status]:
			label.add_theme_color_override("font_outline_color", COLOR_OUTLINE)
			label.add_theme_constant_override("outline_size", 6)
	else:
		_name = _label(Vector2(8, 40), Vector2(width - 16, 90), 28, _body)
		_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_status = _label(Vector2(0, 140), Vector2(width, 40), 22, _body)
	var below: float = INTENT_HEIGHT + BODY_HEIGHT + 8.0
	_hp_bar = ProgressBar.new()
	_hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hp_bar.show_percentage = false
	_hp_bar.position = Vector2(0, below)
	_hp_bar.size = Vector2(width, 16)
	add_child(_hp_bar)
	_hp = _label(Vector2(0, below + 18), Vector2(width, 30), 22)
	_desolation = _label(Vector2(0, below + 46), Vector2(width, 30), 22)
	_conditions = _label(Vector2(0, below + 74), Vector2(width, 56), 20)
	_conditions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_preview = _label(Vector2(-20, below + 128), Vector2(width + 40, 64), 22)
	_preview.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_preview.add_theme_color_override("font_color", COLOR_PREVIEW)
	_apply_style()


## Updates every label from already formatted texts (BattleTexts).
func show_state(c: Combatant, display_name: String, slot_text: String, status_text: String, hp_text: String, desolation_text: String, conditions_text: String, intent_text: String) -> void:
	_name.text = display_name
	_slot.text = slot_text
	_status.text = status_text
	_hp_bar.max_value = c.max_hp
	_hp_bar.value = c.hp
	_hp.text = hp_text
	_desolation.text = desolation_text
	_desolation.visible = c.is_saint()
	_conditions.text = conditions_text
	_intent.text = intent_text
	_down = not c.is_standing()
	_dimmed = c.is_saint() and c.has_acted and c.is_standing()
	_apply_style()
	if _art != null:
		var wanted: StringName = &"fall" if _down else &""
		if wanted != _pose and (wanted == &"" or _art.pose_texture(wanted) != null):
			_set_pose(wanted)
	if _art != null and (c.spirit_state != _spirit_state or c.desolation != _spirit_desolation or _figure.texture == null):
		_spirit_state = c.spirit_state
		_spirit_desolation = c.desolation
		_apply_spirit(false)


## Live update while events play (desolation_changed): the halo follows.
func set_desolation(value: int) -> void:
	if _art == null or value == _spirit_desolation:
		return
	_spirit_desolation = value
	_apply_spirit(true)


## Live update while events play (state_changed): body image and halo.
func set_spirit_state(state_id: StringName) -> void:
	if _art == null or state_id == _spirit_state:
		return
	_spirit_state = state_id
	_apply_spirit(true)


func has_art() -> bool:
	return _art != null


func figure_texture() -> Texture2D:
	return _figure.texture if _figure != null else null


func halo() -> HaloView:
	return _halo


func pose() -> StringName:
	return _pose


func figure_saturation() -> float:
	return float(_figure_material.get_shader_parameter("saturation")) if _figure_material != null else 1.0


func set_hp(hp: int) -> void:
	_hp_bar.value = hp


func set_mark(p_mark: Mark) -> void:
	mark = p_mark
	_apply_style()


func show_preview(text: String) -> void:
	_preview.text = text


func center() -> Vector2:
	return position + Vector2(size.x * 0.5, INTENT_HEIGHT + BODY_HEIGHT * 0.5)


# --- animation interface (architecture §8, ADR-0007) --------------------------
# Each call returns how long it lasts, so the screen can wait before the next
# event. At speed 0 nothing is tweened and the duration is 0.

func play_idle() -> float:
	_body.position = Vector2(0, INTENT_HEIGHT)
	_body.rotation = 0.0
	return 0.0


## A quick lunge toward the other side and back. `pose_id` picks the pose
## image once the art exists (unused by the placeholder).
func play_action(_pose_id: StringName = &"") -> float:
	if speed <= 0.0:
		return 0.0
	var t: float = ACTION_TIME / speed
	var home := Vector2(0, INTENT_HEIGHT)
	var reach := home + Vector2(40.0 if is_saint else -40.0, 0)
	var posed: bool = _show_pose_briefly(&"attack")
	if posed:
		# With a real attack pose the step is longer and the pose is held.
		t = ACTION_TIME * 2.0 / speed
		reach = home + Vector2(70.0, 0)
	var tw := create_tween()
	tw.tween_property(_body, "position", reach, t * 0.35)
	tw.tween_interval(t * 0.3)
	tw.tween_property(_body, "position", home, t * 0.35)
	if posed:
		tw.tween_callback(_set_pose.bind(&""))
	return t


## Red flash, shake and a small recoil.
func play_hit() -> float:
	if speed <= 0.0:
		return 0.0
	var t: float = HIT_TIME / speed
	var home := Vector2(0, INTENT_HEIGHT)
	var recoil := home + Vector2(-14.0 if is_saint else 14.0, 0)
	_body.modulate = Color(1.6, 0.5, 0.5)
	var posed: bool = _show_pose_briefly(&"hit")
	if posed:
		t = HIT_TIME * 2.0 / speed
	var tw := create_tween()
	tw.tween_property(_body, "position", recoil, t * 0.3)
	tw.parallel().tween_property(_body, "modulate", Color.WHITE, t)
	tw.tween_property(_body, "position", home, t * 0.7)
	if posed:
		tw.tween_callback(_set_pose.bind(&""))
	return t


## Slow tilt and fade to grey; the halo goes out (ADR-0007).
func play_fall() -> float:
	_down = true
	_apply_style()
	if _art != null and _art.pose_texture(&"fall") != null:
		_set_pose(&"fall")
	if speed <= 0.0:
		return 0.0
	var t: float = FALL_TIME / speed
	var tw := create_tween()
	tw.tween_property(_body, "rotation", deg_to_rad(-8.0 if is_saint else 8.0), t * 0.5)
	tw.tween_property(_body, "rotation", 0.0, t * 0.5)
	return t


## A number or word rising over the combatant (damage, healing, condition).
func float_text(text: String, color: Color) -> void:
	if speed <= 0.0 or text.is_empty():
		return
	var label := _label(Vector2(-30, INTENT_HEIGHT + 40), Vector2(size.x + 60, 40), 30)
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 6)
	var tw := create_tween()
	tw.tween_property(label, "position:y", label.position.y - 70.0, FLOAT_TIME / speed)
	tw.parallel().tween_property(label, "modulate:a", 0.0, FLOAT_TIME / speed)
	tw.tween_callback(label.queue_free)


# --- internals -------------------------------------------------------------------

func _gui_input(event: InputEvent) -> void:
	# Touch arrives as emulated mouse clicks (project default), so one handler
	# serves both the phone and the desktop.
	var click := event as InputEventMouseButton
	if click != null and click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		tapped.emit(combatant_id)


func _apply_style() -> void:
	if _style == null:
		return
	var base: Color = COLOR_DOWN if _down else (COLOR_SAINT if is_saint else COLOR_ENEMY)
	_style.bg_color = base.darkened(0.45) if _dimmed else base
	_style.border_color = MARK_COLORS[mark]
	_body.modulate = Color(1, 1, 1, 0.75) if _down else Color.WHITE
	if _art != null:
		# The figure replaces the coloured block; the border still marks it.
		_style.bg_color = Color(0, 0, 0, 0.25)
		_figure.self_modulate = Color(0.55, 0.55, 0.55) if (_dimmed or _down) else Color.WHITE
		_halo.visible = not _down


## A short-lived action pose; false when the art has none (or no animation).
func _show_pose_briefly(pose_id: StringName) -> bool:
	if _art == null or speed <= 0.0 or _down or _art.pose_texture(pose_id) == null:
		return false
	_set_pose(pose_id)
	return true


func _set_pose(pose_id: StringName) -> void:
	_pose = pose_id
	_place_figure()


## Image and halo point for the current pose, or for the spiritual state.
func _place_figure() -> void:
	var tex: Texture2D = _art.pose_texture(_pose) if _pose != &"" else null
	var head: Vector2 = _art.head_for(_spirit_state)
	if tex != null:
		head = _art.pose_head(_pose)
	else:
		tex = _art.body_for(_spirit_state)
	_figure.texture = tex
	_halo.position = _figure.position + head * FIGURE_SIZE - _halo.size * 0.5


func _build_figure(width: float) -> void:
	_figure_material = ShaderMaterial.new()
	_figure_material.shader = load(SHADER_PATH)
	_figure = TextureRect.new()
	_figure.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_figure.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_figure.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_figure.material = _figure_material
	_figure.size = FIGURE_SIZE
	# Feet on the bottom of the panel; the head rises above it.
	_figure.position = Vector2((width - FIGURE_SIZE.x) * 0.5, BODY_HEIGHT - FIGURE_SIZE.y)
	_halo = HaloView.new()
	_halo.setup(_halo_settings, _art.halo_diameter * FIGURE_SIZE.x)
	# Added first, so the halo is drawn behind the figure.
	_body.add_child(_halo)
	_body.add_child(_figure)


## Body image, halo position and look for the current spiritual state
## (asset-pipeline §6). `animated` glides the halo when speed allows.
func _apply_spirit(animated: bool) -> void:
	_place_figure()
	var look: HaloLook = HaloLook.of(_halo_settings, _spirit_state, _spirit_desolation)
	var duration: float = _halo_settings.transition_time / speed if animated and speed > 0.0 else 0.0
	_halo.apply(look, duration)
	if duration > 0.0 and is_inside_tree():
		create_tween().tween_property(_figure_material, "shader_parameter/saturation", look.saturation, duration)
	else:
		_figure_material.set_shader_parameter("saturation", look.saturation)


func _label(pos: Vector2, label_size: Vector2, font_size: int, parent: Node = null) -> Label:
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.position = pos
	label.size = label_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", COLOR_TEXT)
	label.clip_text = false
	var holder: Node = parent if parent != null else self
	holder.add_child(label)
	return label
