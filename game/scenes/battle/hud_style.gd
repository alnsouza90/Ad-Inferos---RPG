class_name HudStyle
extends RefCounted
## The look of the battle and walk interface (T36, D-257, D-258): Darkest
## Dungeon mood, black and grey, wrought iron frames, red only for danger and
## gold only for what is special, Pirata One for every text. Presentation
## only: colours, art paths and the theme, never a rule.

const FONT_PATH: String = "res://assets/fonts/PirataOne-Regular.ttf"
const HUD_DIR: String = "res://assets/ui/hud"
const ICON_DIR: String = "res://assets/ui/icons"

const COLOR_INK := Color(0.04, 0.035, 0.035)
const COLOR_PANEL := Color(0.075, 0.075, 0.08)
const COLOR_PANEL_EDGE := Color(0.25, 0.25, 0.26)
const COLOR_TEXT := Color(0.83, 0.82, 0.8)
const COLOR_TEXT_DIM := Color(0.52, 0.51, 0.5)
const COLOR_DANGER := Color(0.67, 0.09, 0.09)
const COLOR_DANGER_DARK := Color(0.2, 0.03, 0.03)
const COLOR_GOLD := Color(0.81, 0.64, 0.32)
const COLOR_SELECTED := Color(0.9, 0.77, 0.35)
const COLOR_TARGETABLE := Color(0.86, 0.86, 0.84)
const COLOR_PIP_ON := Color(0.88, 0.84, 0.75)
const COLOR_PIP_OFF := Color(0.14, 0.13, 0.13)
const COLOR_FERVOR := Color(0.94, 0.74, 0.31)
## Portrait frame tint by desolation (D-258): grey when calm, red near the
## top, gold in Consolation, near black in the Dark Night.
const COLOR_FRAME_CALM := Color(0.72, 0.72, 0.72)
const COLOR_FRAME_TROUBLED := Color(0.62, 0.16, 0.14)
const COLOR_FRAME_CONSOLATION := Color(0.95, 0.78, 0.4)
const COLOR_FRAME_DARK_NIGHT := Color(0.3, 0.26, 0.34)

## Intent icon of the data (`intent_icon`) -> icon file.
const INTENT_ICONS: Dictionary = {
	&"attack": "icon_intent_attack",
	&"corrupt": "icon_intent_corruption",
	&"displace": "icon_intent_displace",
	&"defend": "icon_intent_defend",
	&"summon": "icon_intent_summon",
	&"special": "icon_state_desolation",
}
const STUNNED_ICON: String = "icon_condition_stun"
## Conditions with a drawn icon; the others show their name (from the data).
const CONDITION_ICONS: Dictionary = {
	&"stun": "icon_condition_stun",
	&"bleed": "icon_condition_wound",
	&"corruption": "icon_condition_corruption",
}

static var _font: Font
static var _textures: Dictionary = {}


static func font() -> Font:
	if _font == null:
		_font = load(FONT_PATH) as Font
	return _font


static func hud_texture(file_name: String) -> Texture2D:
	return _load("%s/%s.png" % [HUD_DIR, file_name])


static func icon(file_name: String) -> Texture2D:
	if file_name.is_empty():
		return null
	return _load("%s/%s.png" % [ICON_DIR, file_name])


static func intent_icon(intent: Intent) -> Texture2D:
	if intent == null or intent.kind == Intent.KIND_WAIT:
		return null
	if intent.kind == Intent.KIND_STUNNED:
		return icon(STUNNED_ICON)
	return icon(INTENT_ICONS.get(intent.intent_icon, ""))


static func condition_icon(condition_id: StringName) -> Texture2D:
	return icon(CONDITION_ICONS.get(condition_id, ""))


## Tint of the saint's portrait frame for its spiritual state (D-258).
static func frame_tint(spirit_state: StringName, desolation: int, desolation_max: int) -> Color:
	if spirit_state == Desolation.CONSOLATION:
		return COLOR_FRAME_CONSOLATION
	if spirit_state == Desolation.DARK_NIGHT:
		return COLOR_FRAME_DARK_NIGHT
	var share: float = clampf(float(desolation) / maxf(float(desolation_max), 1.0), 0.0, 1.0)
	return COLOR_FRAME_CALM.lerp(COLOR_FRAME_TROUBLED, share)


static func theme(font_size: int) -> Theme:
	var t := Theme.new()
	t.default_font = font()
	t.default_font_size = font_size
	t.set_color(&"font_color", &"Label", COLOR_TEXT)
	t.set_color(&"font_outline_color", &"Label", COLOR_INK)
	t.set_constant(&"outline_size", &"Label", 4)
	for state: StringName in [&"normal", &"hover", &"pressed", &"disabled", &"focus"]:
		t.set_stylebox(state, &"Button", button_box(state))
	t.set_color(&"font_color", &"Button", COLOR_TEXT)
	t.set_color(&"font_hover_color", &"Button", Color.WHITE)
	t.set_color(&"font_pressed_color", &"Button", COLOR_GOLD)
	t.set_color(&"font_focus_color", &"Button", COLOR_TEXT)
	t.set_color(&"font_disabled_color", &"Button", Color(COLOR_TEXT_DIM, 0.7))
	t.set_color(&"font_outline_color", &"Button", COLOR_INK)
	t.set_constant(&"outline_size", &"Button", 4)
	return t


## Dark iron button: a dark face with a grey bevel (the drawn button frame
## is still to come, D-346).
static func button_box(state: StringName) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.1, 0.1, 0.105) if state != &"pressed" else Color(0.16, 0.15, 0.13)
	box.border_color = COLOR_PANEL_EDGE.lightened(0.25) if state == &"hover" else COLOR_PANEL_EDGE
	if state == &"disabled":
		box.bg_color = Color(0.07, 0.07, 0.075)
		box.border_color = Color(0.17, 0.17, 0.18)
	if state == &"focus":
		box.draw_center = false
		box.border_color = Color(0, 0, 0, 0)
	box.set_border_width_all(4)
	box.set_corner_radius_all(2)
	box.shadow_color = Color(0, 0, 0, 0.6)
	box.shadow_size = 3
	box.content_margin_left = 8
	box.content_margin_right = 8
	return box


## A panel of the bottom bar: dark fill inside the wrought iron frame.
static func iron_panel(rect: Rect2) -> Control:
	var holder := Control.new()
	holder.position = rect.position
	holder.size = rect.size
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := ColorRect.new()
	fill.color = COLOR_PANEL
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fill.position = Vector2(20, 20)
	fill.size = rect.size - Vector2(40, 40)
	holder.add_child(fill)
	var frame := NinePatchRect.new()
	frame.texture = hud_texture("ui_panel_frame")
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.size = rect.size
	var margin: int = 64
	frame.patch_margin_left = margin
	frame.patch_margin_right = margin
	frame.patch_margin_top = margin
	frame.patch_margin_bottom = margin
	frame.draw_center = false
	holder.add_child(frame)
	return holder


static func _load(path: String) -> Texture2D:
	if _textures.has(path):
		return _textures[path]
	var tex: Texture2D = load(path) as Texture2D if ResourceLoader.exists(path) else null
	_textures[path] = tex
	return tex
