class_name BattleLine
extends Control
## A short line an elite or the boss says during the battle (T43, D-466): a
## small iron plate over its head, for a moment; the battle does not wait for
## it. The texts live in ui_text.csv as `line_<enemy>_<moment>`. Presentation
## only.

const SHOW: float = 1.8
const FADE: float = 0.3
const WIDTH: float = 230.0
const PADDING := Vector2(14, 9)
## Below this share of life the "low" line is said once (Asmodeus waits for a
## quarter, the elites for half, as the texts say).
const LOW_SHARE: Dictionary = {&"boss_asmodeus": 0.25}
const LOW_SHARE_DEFAULT: float = 0.5

var text: String = ""


## The key of `moment` for `enemy_def_id`.
static func key(enemy_def_id: StringName, moment: String) -> StringName:
	return StringName("line_%s_%s" % [enemy_def_id, moment])


static func low_share(enemy_def_id: StringName) -> float:
	return float(LOW_SHARE.get(enemy_def_id, LOW_SHARE_DEFAULT))


## Shows `line` with its bottom centre at `at` (parent coordinates); returns
## how long it stays. Frees itself after.
func play(line: String, at: Vector2, factor: float) -> float:
	text = line
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if factor <= 0.0 or line.is_empty():
		queue_free()
		return 0.0
	var label := Label.new()
	label.text = line
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(WIDTH - PADDING.x * 2.0, 0)
	label.size = Vector2(WIDTH - PADDING.x * 2.0, 0)
	label.add_theme_font_override("font", PixelStyle.text_font())
	label.add_theme_font_size_override("font_size", PixelStyle.TEXT_SIZE)
	label.add_theme_color_override("font_color", PixelStyle.COLOR_BONE)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var lines: int = maxi(1, ceili(PixelStyle.text_font().get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, PixelStyle.TEXT_SIZE).x / label.size.x))
	var height: float = lines * (PixelStyle.TEXT_SIZE + 4) + PADDING.y * 2.0
	size = Vector2(WIDTH, height)
	position = (at - Vector2(WIDTH * 0.5, height)).round()
	add_child(PixelStyle.iron_plate(Rect2(Vector2.ZERO, size)))
	label.position = PADDING
	label.size.y = height - PADDING.y * 2.0
	add_child(label)
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE * 0.5 / factor)
	tween.tween_interval(SHOW / factor)
	tween.tween_property(self, "modulate:a", 0.0, FADE / factor)
	tween.tween_callback(queue_free)
	return (SHOW + FADE * 1.5) / factor
