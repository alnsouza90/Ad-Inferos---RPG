class_name Padlock
extends Control
## A small iron padlock over a closed place (T49, D-503). Drawn by the engine
## for now; the PixelLab piece replaces it once Alan approves it.

const SIZE := Vector2(20, 24)


func _draw() -> void:
	var iron: Color = PixelStyle.COLOR_LEAD_LIGHT
	var dark: Color = PixelStyle.COLOR_PITCH
	# The shackle: two posts and a bar, thick pixels.
	draw_rect(Rect2(4, 2, 3, 10), iron)
	draw_rect(Rect2(13, 2, 3, 10), iron)
	draw_rect(Rect2(4, 0, 12, 3), iron)
	# The body, with its keyhole.
	draw_rect(Rect2(0, 10, 20, 14), dark)
	draw_rect(Rect2(1, 11, 18, 12), iron)
	draw_rect(Rect2(1, 11, 18, 2), PixelStyle.COLOR_GREY)
	draw_rect(Rect2(9, 15, 2, 5), dark)
