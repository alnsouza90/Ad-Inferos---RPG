class_name GoldenThread
extends Control
## Interceder (D-268, Art Bible §2.2 and §8): a thread of gold runs from the
## saint who intercedes to the one he helps, hangs a moment between the two
## circles of their halos, and goes. Gold, because what it moves does not run
## out. Presentation only.

## Only an instant (D-456): it runs, shows and goes in about half a second.
const RUN: float = 0.12
const HOLD: float = 0.2
const FADE: float = 0.15
## The thread sags a little, like a cord between two hands.
const SAG: float = 14.0
const WIDTH: float = 2.0
const STEPS: int = 24
## The small rings at each end, around where the halos are.
const RING_RADIUS: float = 6.0

var _from: Vector2
var _to: Vector2
var _shown: float = 0.0


## Plays from `from` to `to` (parent coordinates); returns how long it lasts.
func play(from: Vector2, to: Vector2, factor: float) -> float:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if factor <= 0.0:
		queue_free()
		return 0.0
	_from = from
	_to = to
	var tween := create_tween()
	tween.tween_method(_reveal, 0.0, 1.0, RUN / factor)
	tween.tween_interval(HOLD / factor)
	tween.tween_property(self, "modulate:a", 0.0, FADE / factor)
	tween.tween_callback(queue_free)
	return (RUN + HOLD + FADE) / factor


func _reveal(share: float) -> void:
	_shown = share
	queue_redraw()


func _point(t: float) -> Vector2:
	var straight: Vector2 = _from.lerp(_to, t)
	return (straight + Vector2(0, SAG * 4.0 * t * (1.0 - t))).round()


func _draw() -> void:
	var gold: Color = PixelStyle.COLOR_GOLD
	draw_arc(_from, RING_RADIUS, 0.0, TAU, 12, gold, WIDTH)
	var last: int = int(STEPS * _shown)
	for i: int in last:
		draw_line(_point(float(i) / STEPS), _point(float(i + 1) / STEPS), gold, WIDTH)
	if _shown >= 1.0:
		draw_arc(_to, RING_RADIUS, 0.0, TAU, 12, gold, WIDTH)
