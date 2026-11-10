class_name CombatantView
extends Control
## One saint or enemy on screen (architecture §8). T15 draws a coloured
## rectangle with the name in place of the art; the animation interface
## (play_idle, play_action, play_hit, play_fall) stays the same when the art
## arrives (ADR-0007). It only shows state; it never decides a rule.
## With CharacterFrames (T35, D-194) the figure is animated from frame
## sheets and the engine links the poses (slide, trail, blow, return).

signal tapped(combatant_id: StringName)
## The blow of an attack lands (T35): the screen shakes, zooms and flashes
## at `at` (global position), and the target reacts. `strength` is 1 for a
## physical blow and less for a spiritual one (D-233). `kind` tells the
## target how to react: &"physical", &"spell" or &"outline" (the target
## trembles in a dark light, Vertigo, D-236).
signal impact(at: Vector2, strength: float, kind: StringName)

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
## Frame animation (T35): seconds at speed 1 and distances in pixels of the
## view (presentation only).
const DASH_MAX_TIME: float = 0.22
const HOLD_TIME: float = 0.25
const RETURN_TIME: float = 0.3
const DEFEND_HOLD: float = 0.5
const DEFAULT_REACH: float = 160.0
const TRAIL_EVERY: float = 0.035
const TRAIL_TIME: float = 0.3
const TRAIL_ALPHA: float = 0.45
const STATIONARY_LEAN: float = 18.0
## Spiritual actions (D-233): the orb's flight, the strength of their
## impact on the camera, and the colours of the light (saints, enemies).
const ORB_TIME: float = 0.35
## E1: seconds the crosses orbit and burst around the enemy (D-237).
const CROSSES_TIME: float = 1.4
## G1: the blow's blood flies for this long (D-237).
const SPLATTER_TIME: float = 0.6
const SPELL_STRENGTH: float = 0.5
const BLESSING_TIME: float = 1.1
const COLOR_HOLY := Color(1.0, 0.86, 0.45)
const COLOR_DARK := Color(0.68, 0.42, 1.0)
## A dark spell on the target: seconds, shakes and their width in pixels.
const SPIRIT_HIT_TIME: float = 1.1
const SPIRIT_SHAKES: int = 8
const SPIRIT_SHAKE_PX: float = 4.0

var combatant_id: StringName
var is_saint: bool = true
## Animation speed factor: 1 normal, 2 fast, 0 instant (no tween at all).
var speed: float = 1.0:
	set(value):
		speed = value
		if _player != null:
			_player.speed = value
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
## Frame animation (T35); null: the still images or the rectangle.
var _frames: CharacterFrames
var _player: FramePlayer
var _trail_left: float = 0.0
var _trail_clock: float = 0.0
## Where a ranged blow or a spell lands (global), or INF.
var _target_global: Vector2 = Vector2.INF
## The view of the enemy a spell is cast on (the crosses pass behind it).
var _target_view: Node


## `art` and `halo_settings` are optional: without them the combatant is a
## coloured rectangle with its name (T15). `frames` (T35) animates the
## figure from frame sheets instead of the still images.
func setup(p_id: StringName, p_is_saint: bool, width: float, art: CombatantArt = null, halo_settings: HaloSettings = null, frames: CharacterFrames = null) -> void:
	_frames = frames
	_art = art if halo_settings != null and frames == null else null
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
	elif _frames != null:
		_build_player(width)
	_slot = _label(Vector2(0, 8), Vector2(width, 30), 20, _body)
	if has_figure():
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
	if _player != null and _down and _player.clip_id() != &"fall":
		_player.play(&"fall")
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
	if _player != null and value != _spirit_desolation:
		_spirit_desolation = value
		_apply_player_look(true)
		return
	if _art == null or value == _spirit_desolation:
		return
	_spirit_desolation = value
	_apply_spirit(true)


## Live update while events play (state_changed): body image and halo.
func set_spirit_state(state_id: StringName) -> void:
	if _player != null and state_id != _spirit_state:
		_spirit_state = state_id
		_apply_player_look(true)
		return
	if _art == null or state_id == _spirit_state:
		return
	_spirit_state = state_id
	_apply_spirit(true)


func has_art() -> bool:
	return _art != null


## True when a figure (still images or frames) replaces the rectangle.
func has_figure() -> bool:
	return _art != null or _frames != null


func player() -> FramePlayer:
	return _player


## Labels and bars under the figure; the animation test screen hides them.
func set_info_visible(on: bool) -> void:
	for node: Control in [_intent, _slot, _name, _status, _hp_bar, _hp, _desolation, _conditions, _preview]:
		node.visible = on
	_style.draw_center = on
	_style.set_border_width_all(6 if on else 0)


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
	if _player != null and not _down:
		_player.play(&"idle")
	return 0.0


## Walking on the spot (the walk itself moves the scenery, T37).
func play_walk() -> float:
	if _player != null and not _down and _frames.has_clip(&"walk"):
		_player.play(&"walk")
	return 0.0


## Guard pose, held a moment, then back to idle.
func play_defend() -> float:
	if _player == null or _down or not _frames.has_clip(&"defend") or speed <= 0.0:
		return 0.0
	var t: float = _player.play(&"defend") + _player.scaled(DEFEND_HOLD)
	var tw := create_tween()
	tw.tween_interval(t)
	tw.tween_callback(_back_to_idle)
	return t


## A quick lunge toward the other side and back. `pose_id` picks the pose
## image once the art exists (unused by the placeholder). With frames,
## `reach` is how far the figure slides to its target (negative: default).
func play_action(_pose_id: StringName = &"", reach_px: float = -1.0, target_global: Vector2 = Vector2.INF) -> float:
	if speed <= 0.0:
		return 0.0
	if _player != null and not _down:
		_target_global = target_global
		return _play_frame_attack(reach_px if reach_px >= 0.0 else DEFAULT_REACH)
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


## A spiritual action (exorcism or untyped damage, D-233): cast from where
## the caster stands, a light flies to `target_global` and lands there.
func play_spell(target_global: Vector2, target_view: Node = null) -> float:
	if speed <= 0.0 or _player == null or _down:
		return 0.0
	_player.speed = speed
	_target_global = target_global
	_target_view = target_view
	var windup: float = _player.play(&"windup") if _frames.has_clip(&"windup") else 0.0
	var strike: FrameClip = _frames.clip(&"strike")
	var strike_time: float = _player.scaled(strike.duration()) if strike != null else 0.0
	var release: float = _player.scaled(strike.impact_time()) if strike != null else 0.0
	var hold: float = _player.scaled(HOLD_TIME)
	# The orb flies and the crosses orbit before landing; the boss' own smoke
	# and Vertigo's spell land at once.
	var flight: float = 0.0
	match _frames.spell_style:
		&"orb":
			flight = _player.scaled(ORB_TIME)
		&"crosses":
			flight = _player.scaled(CROSSES_TIME)
	var tw := create_tween()
	tw.tween_interval(windup)
	tw.tween_callback(_player.play.bind(&"strike"))
	tw.tween_interval(release)
	match _frames.spell_style:
		&"orb":
			tw.tween_callback(_cast_orb.bind(flight))
		&"crosses":
			tw.tween_callback(_cast_crosses.bind(flight))
		&"outline":
			tw.tween_callback(func() -> void: impact.emit(_target_global, SPELL_STRENGTH, &"outline"))
		_:
			tw.tween_callback(func() -> void: impact.emit(_target_global, SPELL_STRENGTH, &"spell"))
	tw.tween_interval(maxf(strike_time - release, flight) + hold)
	tw.tween_callback(_back_to_idle)
	return windup + release + maxf(strike_time - release, flight) + hold


## A blessing (support with no damage, D-233): the caster raises its sign in
## place and a light rises on the one it helps (`target_global`: the feet;
## INF blesses the caster).
func play_blessing(target_global: Vector2 = Vector2.INF) -> float:
	if speed <= 0.0 or _player == null or _down:
		return 0.0
	_player.speed = speed
	var windup: float = _player.play(&"windup") if _frames.has_clip(&"windup") else 0.0
	var strike_time: float = _player.scaled(_frames.clip(&"strike").duration()) if _frames.has_clip(&"strike") else 0.0
	var glow: float = _player.scaled(BLESSING_TIME)
	var feet: Vector2 = target_global if target_global != Vector2.INF else feet_global()
	var tw := create_tween()
	tw.tween_interval(windup)
	tw.tween_callback(_player.play.bind(&"strike"))
	tw.tween_callback(_spawn_blessing.bind(feet, glow))
	tw.tween_interval(maxf(strike_time, glow))
	tw.tween_callback(_back_to_idle)
	return windup + maxf(strike_time, glow)


## Where the feet of the figure stand, in global coordinates.
func feet_global() -> Vector2:
	return get_global_transform() * (_body.position + Vector2(size.x * 0.5, BODY_HEIGHT))


## Where blows and spells land on this combatant (global): its chest.
func chest_global() -> Vector2:
	return get_global_transform() * (_body.position + Vector2(size.x * 0.5, BODY_HEIGHT * 0.45))


## Struck by a dark spell (Vertigo, D-236): the figure trembles inside a
## pulsing outline of `color`, with no recoil.
func play_spirit_hit(color: Color = COLOR_DARK) -> float:
	if speed <= 0.0 or _player == null or _down:
		return 0.0
	var t: float = SPIRIT_HIT_TIME / speed
	var home := Vector2(0, INTENT_HEIGHT)
	_player.outline_color = color
	var tw := create_tween()
	tw.tween_property(_player, "outline_strength", 1.0, t * 0.15)
	for i: int in SPIRIT_SHAKES:
		var side: float = SPIRIT_SHAKE_PX if i % 2 == 0 else -SPIRIT_SHAKE_PX
		tw.tween_property(_body, "position", home + Vector2(side, 0), t * 0.5 / SPIRIT_SHAKES)
	tw.tween_property(_body, "position", home, t * 0.05)
	tw.tween_property(_player, "outline_strength", 0.0, t * 0.3)
	return t


## Red flash, shake and a small recoil.
func play_hit() -> float:
	if speed <= 0.0:
		return 0.0
	var t: float = HIT_TIME / speed
	var home := Vector2(0, INTENT_HEIGHT)
	var recoil := home + Vector2(-14.0 if is_saint else 14.0, 0)
	_body.modulate = Color(1.6, 0.5, 0.5)
	if _player != null and not _down:
		var clip_time: float = _player.play(&"hit") if _frames.has_clip(&"hit") else 0.0
		t = maxf(t, clip_time)
		var hit_tw := create_tween()
		hit_tw.tween_property(_body, "position", recoil, t * 0.3)
		hit_tw.parallel().tween_property(_body, "modulate", Color.WHITE, t)
		hit_tw.tween_property(_body, "position", home, t * 0.7)
		hit_tw.tween_callback(_back_to_idle)
		return t
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
	if _player != null:
		var clip_time: float = _player.play(&"fall")
		if speed <= 0.0:
			return 0.0
		return maxf(clip_time, FALL_TIME / speed)
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
	if _player != null:
		_style.bg_color = Color(0, 0, 0, 0.25)
		_player.self_modulate = Color(0.55, 0.55, 0.55) if _dimmed else Color.WHITE
	if _art != null:
		# The figure replaces the coloured block; the border still marks it.
		_style.bg_color = Color(0, 0, 0, 0.25)
		_figure.self_modulate = Color(0.55, 0.55, 0.55) if (_dimmed or _down) else Color.WHITE
		_halo.visible = not _down


# --- frame animation (T35) --------------------------------------------------------

func _build_player(width: float) -> void:
	_figure_material = ShaderMaterial.new()
	_figure_material.shader = load(SHADER_PATH)
	_player = FramePlayer.new()
	_player.material = _figure_material
	_player.speed = speed
	# Feet on the bottom of the panel, like the still figure.
	_player.setup(_frames, Vector2(width * 0.5, BODY_HEIGHT), FIGURE_SIZE.y * _frames.display_scale)
	_body.add_child(_player)


## The figure loses colour as desolation grows, like the still images; the
## halo over animated frames waits for head points per frame (T52).
func _apply_player_look(animated: bool) -> void:
	if _halo_settings == null:
		return
	var look: HaloLook = HaloLook.of(_halo_settings, _spirit_state, _spirit_desolation)
	var duration: float = _halo_settings.transition_time / speed if animated and speed > 0.0 else 0.0
	if duration > 0.0 and is_inside_tree():
		create_tween().tween_property(_figure_material, "shader_parameter/saturation", look.saturation, duration)
	else:
		_figure_material.set_shader_parameter("saturation", look.saturation)


## Halo settings for the look of the frames (desaturation by state).
func set_halo_settings(settings: HaloSettings) -> void:
	_halo_settings = settings
	if _player != null:
		_apply_player_look(false)


## Prepare, slide to the target leaving a trail, blow (impact), hold, come
## back. Only a melee attacker slides; Minos on his throne (D-219) and a
## ranged attacker (Asmodeus' smoke, D-233) lean where they stand.
func _play_frame_attack(reach_px: float) -> float:
	_player.speed = speed
	var home := Vector2(0, INTENT_HEIGHT)
	var direction: float = 1.0 if is_saint else -1.0
	var windup_id: StringName = &"melee_windup" if _frames.has_clip(&"melee_windup") else &"windup"
	var windup: float = _player.play(windup_id) if _frames.has_clip(windup_id) else 0.0
	var strike: FrameClip = _frames.clip(_melee_strike_id())
	var strike_time: float = _player.scaled(strike.duration()) if strike != null else 0.0
	var blow: float = _player.scaled(strike.impact_time()) if strike != null else 0.0
	var dash: float = _player.scaled(DASH_MAX_TIME)
	if blow > 0.0:
		dash = minf(dash, blow)
	var distance: float = reach_px if _frames.slides_to_target() else STATIONARY_LEAN
	var target := home + Vector2(direction * distance, 0)
	var hold: float = _player.scaled(HOLD_TIME)
	var back: float = _player.scaled(RETURN_TIME)
	var tw := create_tween()
	tw.tween_interval(windup)
	tw.tween_callback(_start_strike)
	tw.tween_property(_body, "position", target, dash).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_interval(maxf(blow - dash, 0.0))
	tw.tween_callback(_emit_impact)
	tw.tween_interval(maxf(strike_time - blow, 0.0) + hold)
	tw.tween_callback(_back_to_idle)
	tw.tween_property(_body, "position", home, back).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	return windup + maxf(strike_time, dash) + hold + back


## A boss can have its own frames for the blow (Asmodeus' lunge, D-236);
## the "strike" clip is then its spiritual attack.
func _melee_strike_id() -> StringName:
	return &"melee_strike" if _frames.has_clip(&"melee_strike") else &"strike"


func _start_strike() -> void:
	_player.play(_melee_strike_id())
	if _frames.slides_to_target():
		_trail_left = _player.scaled(DASH_MAX_TIME) + TRAIL_EVERY
		_trail_clock = 0.0


func _emit_impact() -> void:
	var at: Vector2 = _target_global
	if at == Vector2.INF or _frames.slides_to_target():
		var front: float = 1.0 if is_saint else 0.0
		at = get_global_transform() * (_body.position + Vector2(size.x * front, BODY_HEIGHT * 0.5))
	# G1: dark blood flies from the blow, away from the attacker.
	var holder: Node = get_parent() if get_parent() != null else self
	var to_local: Transform2D = (holder as CanvasItem).get_global_transform().affine_inverse()
	SpellEffect.splatter(holder, to_local * at, 1.0 if is_saint else -1.0, _player.scaled(SPLATTER_TIME))
	impact.emit(at, 1.0, &"physical")


## E1: crosses of light orbit the enemy, close in and burst (D-237).
func _cast_crosses(seconds: float) -> void:
	var holder: Node = get_parent() if get_parent() != null else self
	var to_local: Transform2D = (holder as CanvasItem).get_global_transform().affine_inverse()
	var target: Vector2 = _target_global if _target_global != Vector2.INF else chest_global()
	var fx := SpellEffect.crosses(holder, to_local * target, seconds, _target_view)
	fx.arrived.connect(func(_at: Vector2) -> void: impact.emit(target, SPELL_STRENGTH, &"spell"))


## The light of a spell leaves the caster's raised hand toward the target.
func _cast_orb(flight: float) -> void:
	var holder: Node = get_parent() if get_parent() != null else self
	var to_local: Transform2D = (holder as CanvasItem).get_global_transform().affine_inverse()
	var hand: Vector2 = get_global_transform() * (_body.position + Vector2(size.x * (0.8 if is_saint else 0.2), BODY_HEIGHT * 0.1))
	var target: Vector2 = _target_global if _target_global != Vector2.INF else hand
	var fx := SpellEffect.orb(holder, to_local * hand, to_local * target, flight, COLOR_HOLY if is_saint else COLOR_DARK)
	fx.arrived.connect(func(_at: Vector2) -> void: impact.emit(target, SPELL_STRENGTH, &"spell"))


## Each saint blesses with its own sign (D-237): Teresinha's petals (B1),
## Bento's ring of light (B2).
func _spawn_blessing(feet: Vector2, seconds: float) -> void:
	var holder: Node = get_parent() if get_parent() != null else self
	var at: Vector2 = (holder as CanvasItem).get_global_transform().affine_inverse() * feet
	match _frames.blessing_style:
		&"petals":
			SpellEffect.petals(holder, at, seconds)
		_:
			SpellEffect.ring(holder, at, seconds)


func _back_to_idle() -> void:
	if _player != null and not _down:
		_player.play(&"idle")


func _process(delta: float) -> void:
	if _trail_left <= 0.0:
		return
	_trail_left -= delta
	_trail_clock += delta
	if _trail_clock >= TRAIL_EVERY:
		_trail_clock = 0.0
		_drop_ghost()


## A fading copy of the figure where it is now: the trail of the slide.
func _drop_ghost() -> void:
	var d: Dictionary = _player.current_draw()
	if d.is_empty():
		return
	var atlas := AtlasTexture.new()
	atlas.atlas = d["texture"]
	atlas.region = d["region"]
	var ghost := TextureRect.new()
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.texture = atlas
	ghost.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ghost.stretch_mode = TextureRect.STRETCH_SCALE
	var rect: Rect2 = d["rect"]
	ghost.position = _body.position + rect.position
	ghost.size = rect.size
	ghost.modulate = Color(1.0, 0.92, 0.75, TRAIL_ALPHA)
	add_child(ghost)
	move_child(ghost, _body.get_index())
	var tw := ghost.create_tween()
	tw.tween_property(ghost, "modulate:a", 0.0, TRAIL_TIME)
	tw.tween_callback(ghost.queue_free)


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
