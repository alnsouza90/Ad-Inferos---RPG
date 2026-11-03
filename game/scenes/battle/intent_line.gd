class_name IntentLine
extends Control
## The line from an enemy to the party slot its intent aims at, drawn when the
## player taps the enemy (screens §3).

const COLOR := Color(1.0, 0.4, 0.3, 0.9)
const WIDTH: float = 5.0

var from_point: Vector2 = Vector2.ZERO
var to_point: Vector2 = Vector2.ZERO
var shown: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func show_line(p_from: Vector2, p_to: Vector2) -> void:
	from_point = p_from
	to_point = p_to
	shown = true
	queue_redraw()


func hide_line() -> void:
	shown = false
	queue_redraw()


func _draw() -> void:
	if shown:
		draw_line(from_point, to_point, COLOR, WIDTH, true)
		draw_circle(to_point, 12.0, COLOR)
