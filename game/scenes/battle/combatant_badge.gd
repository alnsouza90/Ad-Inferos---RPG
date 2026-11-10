class_name CombatantBadge
extends Control
## What the battle shows around one combatant (T36, D-258): health bar and
## desolation pips at the feet, the selection marker on the ground, and the
## intent and conditions over the head. The battle screen places it at the
## feet and fills it from already formatted state; it never decides a rule.

const BAR_WIDTH: float = 128.0
const BAR_HEIGHT: float = 10.0
const BAR_GAP: float = 16.0
const PIPS: int = 10
const PIP_SIZE: float = 9.0
const PIP_GAP: float = 3.8
const MARK_HALF: float = 100.0
const MARK_DASH: float = 18.0
const MARK_STEP: float = 30.0
const INTENT_SIZE: float = 84.0
const INTENT_DISC: float = 104.0
const CONDITION_SIZE: float = 44.0
const PREVIEW_WIDTH: float = 300.0

var is_saint: bool = true
var hp_share: float = 1.0
## Pips lit for desolation, out of PIPS.
var desolation_pips: int = 0
var down: bool = false
var mark: CombatantView.Mark = CombatantView.Mark.NONE
## Height of the head above the feet, in pixels of the stage.
var head_height: float = 380.0
## Height of the intents' row above the feet: every intent on one line (DD).
var intent_height: float = 470.0

var _intent_icon: TextureRect
var _intent_value: Label
var _intent_disc: Control
var _conditions: HBoxContainer
var _preview: Label


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_intent_disc = Control.new()
	_intent_disc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_intent_disc.size = Vector2(INTENT_DISC, INTENT_DISC)
	_intent_disc.draw.connect(_draw_disc)
	add_child(_intent_disc)
	_intent_icon = TextureRect.new()
	_intent_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_intent_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_intent_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_intent_icon.size = Vector2(INTENT_SIZE, INTENT_SIZE)
	_intent_icon.position = Vector2((INTENT_DISC - INTENT_SIZE) * 0.5, (INTENT_DISC - INTENT_SIZE) * 0.5)
	_intent_disc.add_child(_intent_icon)
	_intent_value = Label.new()
	_intent_value.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_intent_value.position = Vector2(INTENT_DISC * 0.62, INTENT_DISC * 0.6)
	_intent_value.add_theme_font_size_override("font_size", 36)
	_intent_value.add_theme_color_override("font_color", HudStyle.COLOR_TEXT)
	_intent_value.add_theme_color_override("font_outline_color", HudStyle.COLOR_DANGER_DARK)
	_intent_value.add_theme_constant_override("outline_size", 10)
	_intent_disc.add_child(_intent_value)
	_conditions = HBoxContainer.new()
	_conditions.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_conditions.add_theme_constant_override("separation", 4)
	add_child(_conditions)
	_preview = Label.new()
	_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_preview.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_preview.size = Vector2(PREVIEW_WIDTH, 80)
	_preview.add_theme_font_size_override("font_size", 26)
	_preview.add_theme_color_override("font_color", HudStyle.COLOR_SELECTED)
	add_child(_preview)
	_layout()


## Bars at the feet: `hp`/`max_hp`; `desolation` lights its share of the
## pips (saints only).
func set_bars(saint: bool, hp: int, max_hp: int, desolation: int, desolation_max: int, is_down: bool) -> void:
	is_saint = saint
	hp_share = clampf(float(hp) / maxf(float(max_hp), 1.0), 0.0, 1.0)
	desolation_pips = ceili(clampf(float(desolation) / maxf(float(desolation_max), 1.0), 0.0, 1.0) * PIPS) if desolation > 0 else 0
	down = is_down
	queue_redraw()


func set_hp_share(share: float) -> void:
	hp_share = clampf(share, 0.0, 1.0)
	queue_redraw()


func set_mark(p_mark: CombatantView.Mark) -> void:
	mark = p_mark
	queue_redraw()


func set_head_height(height: float, intent_row: float = -1.0) -> void:
	head_height = height
	if intent_row > 0.0:
		intent_height = intent_row
	_layout()


## The intent over an enemy's head: its icon, and the number when there is
## one (empty: no intent shown).
func set_intent(tex: Texture2D, value_text: String) -> void:
	_intent_icon.texture = tex
	_intent_value.text = value_text
	_intent_disc.visible = tex != null and not down
	_intent_disc.queue_redraw()


## Up to three conditions: an icon when one is drawn, else the name; then +N.
func set_conditions(entries: Array[Dictionary], more_text: String) -> void:
	for child: Node in _conditions.get_children():
		_conditions.remove_child(child)
		child.queue_free()
	for entry: Dictionary in entries:
		var tex: Texture2D = entry.get("icon")
		if tex != null:
			var rect := TextureRect.new()
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			rect.texture = tex
			rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			rect.custom_minimum_size = Vector2(CONDITION_SIZE, CONDITION_SIZE)
			_conditions.add_child(rect)
		else:
			_conditions.add_child(_small_label(String(entry.get("text", ""))))
	if not more_text.is_empty():
		_conditions.add_child(_small_label(more_text))
	_layout()


func show_preview(text: String) -> void:
	_preview.text = text


func intent_shown() -> bool:
	return _intent_disc.visible


func intent_texture() -> Texture2D:
	return _intent_icon.texture


func condition_count() -> int:
	return _conditions.get_child_count()


func preview_text() -> String:
	return _preview.text


func _small_label(text: String) -> Label:
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = text
	label.add_theme_font_size_override("font_size", 24)
	return label


## The badge's origin is the feet: the intent floats above the head, the
## conditions just over it.
func _layout() -> void:
	if _intent_disc == null:
		return
	_intent_disc.position = Vector2(-INTENT_DISC * 0.5, -intent_height - INTENT_DISC * 0.5)
	var width: float = _conditions.get_combined_minimum_size().x
	_conditions.position = Vector2(-width * 0.5, -head_height - CONDITION_SIZE - 14.0)
	_preview.position = Vector2(-PREVIEW_WIDTH * 0.5, -head_height * 0.55)


func _draw() -> void:
	var y: float = BAR_GAP
	var left: float = -BAR_WIDTH * 0.5
	draw_rect(Rect2(left - 2, y - 2, BAR_WIDTH + 4, BAR_HEIGHT + 4), HudStyle.COLOR_INK)
	if not down:
		draw_rect(Rect2(left, y, BAR_WIDTH * hp_share, BAR_HEIGHT), HudStyle.COLOR_DANGER)
	if is_saint:
		var py: float = y + BAR_HEIGHT + 5.0
		for i: int in PIPS:
			var px: float = left + i * (PIP_SIZE + PIP_GAP)
			draw_rect(Rect2(px - 1, py - 1, PIP_SIZE + 2, PIP_SIZE + 2), HudStyle.COLOR_INK)
			draw_rect(Rect2(px, py, PIP_SIZE, PIP_SIZE), HudStyle.COLOR_PIP_ON if i < desolation_pips else HudStyle.COLOR_PIP_OFF)
	_draw_mark()


## Dashed bracket on the ground (DD): gold for who acts, light for who can
## be chosen, white for the pending target, red for an intent's target.
func _draw_mark() -> void:
	var color: Color
	match mark:
		CombatantView.Mark.SELECTED:
			color = HudStyle.COLOR_SELECTED
		CombatantView.Mark.TARGETABLE:
			color = HudStyle.COLOR_TARGETABLE
		CombatantView.Mark.PENDING:
			color = Color.WHITE
		CombatantView.Mark.INTENT_TARGET:
			color = HudStyle.COLOR_DANGER.lightened(0.2)
		_:
			return
	var x: float = -MARK_HALF
	while x < MARK_HALF:
		draw_line(Vector2(x, 4), Vector2(minf(x + MARK_DASH, MARK_HALF), 4), color, 4.0)
		x += MARK_STEP
	draw_line(Vector2(-MARK_HALF, -8), Vector2(-MARK_HALF, 6), color, 4.0)
	draw_line(Vector2(MARK_HALF, -8), Vector2(MARK_HALF, 6), color, 4.0)


func _draw_disc() -> void:
	var c := Vector2(INTENT_DISC, INTENT_DISC) * 0.5
	var r: float = INTENT_DISC * 0.5
	for k: int in 4:
		_intent_disc.draw_circle(c, r + 14.0 - k * 3.0, Color(HudStyle.COLOR_DANGER, 0.08 + k * 0.05))
	_intent_disc.draw_circle(c, r, Color(0.09, 0.03, 0.03))
	_intent_disc.draw_arc(c, r - 2.0, 0.0, TAU, 48, HudStyle.COLOR_DANGER, 4.0)
