class_name TrailDots
extends Control
## The dotted trail of a circle on the Map of Hell (T49, D-511): small square
## dots, `gap` apart, along the points in order.

var points: Array[Vector2] = []
var gap: float = 9.0
var dot: float = 2.0
var color: Color = Color.WHITE


func _draw() -> void:
	for k: int in range(1, points.size()):
		var from: Vector2 = points[k - 1]
		var to: Vector2 = points[k]
		var steps: int = maxi(1, int(from.distance_to(to) / gap))
		for s: int in range(1, steps):
			var p: Vector2 = from.lerp(to, float(s) / steps).round()
			draw_rect(Rect2(p - Vector2.ONE * dot * 0.5, Vector2.ONE * dot), color)
