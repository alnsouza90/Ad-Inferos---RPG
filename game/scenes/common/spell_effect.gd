class_name SpellEffect
extends Node2D
## Engine effects of spiritual actions (Alan, D-233): a glowing orb that
## flies from the caster to the target, and the aura of a blessing (a ring
## that opens, a column of light and rising sparks). Drawn in code, no art;
## the sparks follow a fixed pattern (no chance, ADR-0003).

signal arrived(at: Vector2)

const ORB_RADIUS: float = 26.0
const TRAIL_STEPS: int = 6
const TRAIL_GAP: float = 0.035
const AURA_RADIUS: float = 150.0
const AURA_HEIGHT: float = 420.0
const SPARKS: Array[Vector2] = [Vector2(-0.8, 0.1), Vector2(-0.35, 0.45), Vector2(0.1, 0.0), Vector2(0.5, 0.3), Vector2(0.85, 0.15), Vector2(-0.6, 0.7), Vector2(0.3, 0.75)]

var color: Color = Color(1.0, 0.86, 0.45)
var _kind: StringName = &""
var _from: Vector2
var _to: Vector2
var _time: float = 0.0
var _duration: float = 1.0
var _done: bool = false


## An orb from `from` to `to` (local to the parent) in `seconds`.
static func orb(parent: Node, from: Vector2, to: Vector2, seconds: float, p_color: Color) -> SpellEffect:
	var fx := SpellEffect.new()
	fx._kind = &"orb"
	fx._from = from
	fx._to = to
	fx._duration = maxf(seconds, 0.01)
	fx.color = p_color
	parent.add_child(fx)
	return fx


## A blessing aura standing on `feet` (local to the parent), `seconds` long.
static func aura(parent: Node, feet: Vector2, seconds: float, p_color: Color) -> SpellEffect:
	var fx := SpellEffect.new()
	fx._kind = &"aura"
	fx._from = feet
	fx._duration = maxf(seconds, 0.01)
	fx.color = p_color
	parent.add_child(fx)
	return fx


func progress() -> float:
	return clampf(_time / _duration, 0.0, 1.0)


func _process(delta: float) -> void:
	_time += delta
	if _kind == &"orb" and not _done and _time >= _duration:
		_done = true
		arrived.emit(_to)
	queue_redraw()
	if _time >= _duration + (TRAIL_STEPS * TRAIL_GAP if _kind == &"orb" else 0.0):
		queue_free()


func _draw() -> void:
	if _kind == &"orb":
		_draw_orb()
	else:
		_draw_aura()


func _draw_orb() -> void:
	for i: int in range(TRAIL_STEPS, -1, -1):
		var t: float = clampf((_time - i * TRAIL_GAP) / _duration, 0.0, 1.0)
		if _time - i * TRAIL_GAP < 0.0 or (i == 0 and _done):
			continue
		var p: Vector2 = _from.lerp(_to, t) + Vector2(0, -sin(t * PI) * 60.0)
		var fade: float = 1.0 - float(i) / (TRAIL_STEPS + 1)
		var r: float = ORB_RADIUS * (0.45 + 0.55 * fade)
		_glow(p, r, fade)


func _draw_aura() -> void:
	var t: float = progress()
	var fade: float = sin(t * PI)
	# Ring opening on the ground.
	var ring := Color(color, 0.8 * fade)
	draw_arc(_from, AURA_RADIUS * (0.4 + 0.6 * t), 0.0, TAU, 48, ring, 6.0)
	# Column of light.
	var col := Color(color, 0.22 * fade)
	draw_rect(Rect2(_from + Vector2(-AURA_RADIUS * 0.55, -AURA_HEIGHT), Vector2(AURA_RADIUS * 1.1, AURA_HEIGHT)), col)
	# Rising sparks.
	for s: Vector2 in SPARKS:
		var y: float = fmod(t + s.y, 1.0)
		var p: Vector2 = _from + Vector2(s.x * AURA_RADIUS * 0.6, -y * AURA_HEIGHT)
		_glow(p, 9.0, fade * (1.0 - y))


func _glow(p: Vector2, r: float, alpha: float) -> void:
	draw_circle(p, r * 2.0, Color(color, 0.15 * alpha))
	draw_circle(p, r * 1.3, Color(color, 0.35 * alpha))
	draw_circle(p, r * 0.7, Color(1, 1, 1, 0.9 * alpha))
