class_name SpellEffect
extends Node2D
## Engine effects chosen by Alan from the models (D-237): light that adds to
## the picture (translucent, with a soft glow), drawn in code, no art.
## - "crosses": exorcism, four crosses of light orbit the enemy, close in and
##   burst (E1). Two nodes: the half behind the enemy and the half in front.
## - "ring": blessing of São Bento, a ring of light opens at the ally's feet,
##   with a soft column and rising points of light (B2).
## - "petals": blessing of Santa Teresinha, rose petals fall in soft light (B1).
## - "shield": blessing of São Jorge (Escudo Erguido), a translucent shield
##   of white light with a cross of light appears before the ally, shines
##   and dissolves into rising points of light (B3, version 2).
## - "splatter": the blow of a physical attack, dark blood flies (G1).
## - "smoke": Asmodeus' breath carried on to the target, past the edge where
##   the video cut it (D-240): dark violet puffs that roll and billow.
## Sizes are those of the models (figures 236 px tall); `scale` fits them to
## the figures on screen.
## - "orb": a light that flies to the target (spells with no style yet).
## Fixed patterns, no chance (ADR-0003).

signal arrived(at: Vector2)

const GOLD := Color(1.0, 0.84, 0.47)
const WHITE_GOLD := Color(1.0, 0.97, 0.88)
const BLOOD := Color(0.36, 0.05, 0.07)
const PETAL := Color(0.64, 0.15, 0.23)
const PETAL_LIGHT := Color(1.0, 0.67, 0.67, 0.5)
## Sizes in pixels of the parent (the battle field), times in seconds.
const CROSS_SIZE: float = 34.0
const CROSS_COUNT: int = 4
const ORBIT_RX: float = 95.0
const ORBIT_RY: float = 30.0
const ORBIT_SHRINK: float = 0.55
const ORBIT_SPIN: float = 2.0
const ORBIT_SPIN_GAIN: float = 6.0
const BURST_SHARE: float = 0.3
const BURST_RADIUS: float = 170.0
const RING_RADIUS: float = 105.0
const RING_SQUASH: float = 0.28
const RING_COLUMN_HEIGHT: float = 330.0
const MOTES: int = 12
const PETALS: int = 16
const PETAL_SPREAD: float = 170.0
const PETAL_FALL: float = 380.0
const DROPS: int = 14
const DROP_REACH: float = 120.0
const ORB_RADIUS: float = 22.0
const SHIELD_WHITE := Color(0.92, 0.94, 1.0)
const SHIELD_HALF: Vector2 = Vector2(50, 62)
const SHIELD_TIP: float = 78.0
## Where the shield stands from the ally's feet (toward the enemies).
const SHIELD_OFFSET: Vector2 = Vector2(55, -143)
const SHIELD_APPEAR: float = 0.18
const SHIELD_VANISH: float = 0.62
const SHIELD_SPARKS: int = 18
## Asmodeus' smoke, the dark violet of D-227 (seconds of travel share).
const SMOKE := Color(0.29, 0.23, 0.36)
const SMOKE_CORE := Color(0.17, 0.12, 0.22)
const SMOKE_PUFFS: int = 14
const SMOKE_TRAVEL: float = 0.55
const SMOKE_RADIUS: float = 34.0
## Height of the figures the sizes above were drawn for.
const REFERENCE_HEIGHT: float = 236.0

## A soft round light shared by every effect (white centre to transparent).
static var _glow: Texture2D

var color: Color = GOLD
var _kind: StringName = &""
var _from: Vector2
var _to: Vector2
var _time: float = 0.0
var _duration: float = 1.0
var _done: bool = false
var _front: bool = true


static func glow_texture() -> Texture2D:
	if _glow == null:
		var gradient := Gradient.new()
		gradient.set_color(0, Color(1, 1, 1, 1))
		gradient.set_color(1, Color(1, 1, 1, 0))
		gradient.add_point(0.35, Color(1, 1, 1, 0.45))
		var tex := GradientTexture2D.new()
		tex.gradient = gradient
		tex.width = 128
		tex.height = 128
		tex.fill = GradientTexture2D.FILL_RADIAL
		tex.fill_from = Vector2(0.5, 0.5)
		tex.fill_to = Vector2(1.0, 0.5)
		_glow = tex
	return _glow


static func _make(parent: Node, kind: StringName, from: Vector2, to: Vector2, seconds: float, p_color: Color, additive: bool, size: float = 1.0) -> SpellEffect:
	var fx := SpellEffect.new()
	fx._kind = kind
	# The node stands on `from` and is scaled: drawing is relative to it.
	fx.position = from
	fx.scale = Vector2(size, size)
	fx._from = Vector2.ZERO
	fx._to = (to - from) / size
	fx._duration = maxf(seconds, 0.01)
	fx.color = p_color
	if additive:
		var mat := CanvasItemMaterial.new()
		mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		fx.material = mat
	parent.add_child(fx)
	return fx


## E1: crosses orbiting `center` (local to `parent`). `behind_of` is the
## node the back half is drawn behind (the enemy's view); without it both
## halves go on top. Returns the front node, which emits `arrived` at the
## burst.
static func crosses(parent: Node, center: Vector2, seconds: float, behind_of: Node = null, size: float = 1.0) -> SpellEffect:
	var back := _make(parent, &"crosses", center, center, seconds, GOLD, true, size)
	back._front = false
	if behind_of != null and behind_of.get_parent() == parent:
		parent.move_child(back, behind_of.get_index())
	var front := _make(parent, &"crosses", center, center, seconds, GOLD, true, size)
	return front


## B2: ring of light standing on `feet`.
static func ring(parent: Node, feet: Vector2, seconds: float, size: float = 1.0) -> SpellEffect:
	return _make(parent, &"ring", feet, feet, seconds, GOLD, true, size)


## B3: a shield of white light before the one standing on `feet`; `facing`
## is +1 when the enemies are to the right.
static func shield(parent: Node, feet: Vector2, seconds: float, facing: float = 1.0, size: float = 1.0) -> SpellEffect:
	return _make(parent, &"shield", feet, feet + Vector2(facing, 0), seconds, SHIELD_WHITE, true, size)


## B1: petals falling on the one standing on `feet`.
static func petals(parent: Node, feet: Vector2, seconds: float, size: float = 1.0) -> SpellEffect:
	# The light is additive; the petals are drawn by a second, normal node.
	_make(parent, &"petal_light", feet, feet, seconds, GOLD, true, size)
	return _make(parent, &"petals", feet, feet, seconds, PETAL, false, size)


## G1: dark blood flying from `at`, away from the attacker (`dir` = ±1).
static func splatter(parent: Node, at: Vector2, dir: float, seconds: float, size: float = 1.0) -> SpellEffect:
	return _make(parent, &"splatter", at, at + Vector2(dir * size, 0), seconds, BLOOD, false, size)


## Asmodeus' smoke from his mouth (`from`) to the target (`to`); `arrived`
## fires when it reaches the target.
static func smoke(parent: Node, from: Vector2, to: Vector2, seconds: float, size: float = 1.0) -> SpellEffect:
	return _make(parent, &"smoke", from, to, seconds, SMOKE, false, size)


## A light that flies from `from` to `to`; `arrived` fires on landing.
static func orb(parent: Node, from: Vector2, to: Vector2, seconds: float, p_color: Color, size: float = 1.0) -> SpellEffect:
	return _make(parent, &"orb", from, to, seconds, p_color, true, size)


func progress() -> float:
	return clampf(_time / _duration, 0.0, 1.0)


func kind() -> StringName:
	return _kind


func _process(delta: float) -> void:
	_time += delta
	var lands_at: float = _duration
	if _kind == &"crosses":
		lands_at = _duration * (1.0 - BURST_SHARE)
	elif _kind == &"smoke":
		lands_at = _duration * SMOKE_TRAVEL
	if (_kind == &"orb" or _kind == &"crosses" or _kind == &"smoke") and _front and not _done and _time >= lands_at:
		_done = true
		arrived.emit(_to)
	queue_redraw()
	if _time >= _duration:
		queue_free()


func _draw() -> void:
	match _kind:
		&"crosses":
			_draw_crosses()
		&"ring":
			_draw_ring()
		&"petal_light":
			_draw_petal_light()
		&"petals":
			_draw_petals()
		&"splatter":
			_draw_splatter()
		&"shield":
			_draw_shield()
		&"smoke":
			_draw_smoke()
		&"orb":
			_draw_orb()


func _light(at: Vector2, radius: float, c: Color, alpha: float, squash: float = 1.0) -> void:
	if alpha <= 0.0 or radius <= 0.0:
		return
	var size := Vector2(radius * 2.0, radius * 2.0 * squash)
	draw_texture_rect(glow_texture(), Rect2(at - size * 0.5, size), false, Color(c, alpha))


static func _bell(t: float) -> float:
	return sin(clampf(t, 0.0, 1.0) * PI)


static func _ease(t: float) -> float:
	return 1.0 - pow(1.0 - clampf(t, 0.0, 1.0), 3.0)


func _draw_cross(at: Vector2, s: float, alpha: float) -> void:
	_light(at, s * 1.3, color, 0.55 * alpha)
	draw_set_transform(at)
	var outer := Color(color, 0.5 * alpha)
	draw_rect(Rect2(-s * 0.13, -s * 0.5, s * 0.26, s), outer)
	draw_rect(Rect2(-s * 0.36, -s * 0.24, s * 0.72, s * 0.24), outer)
	var inner := Color(WHITE_GOLD, 0.75 * alpha)
	var k: float = 0.62
	draw_rect(Rect2(-s * 0.13 * k, -s * 0.5 * k, s * 0.26 * k, s * k), inner)
	draw_rect(Rect2(-s * 0.36 * k, -s * 0.24 * k, s * 0.72 * k, s * 0.24 * k), inner)
	draw_set_transform(Vector2.ZERO)


func _draw_crosses() -> void:
	var orbit_end: float = 1.0 - BURST_SHARE
	var k: float = clampf(progress() / orbit_end, 0.0, 1.0)
	var t: float = _time
	if progress() < orbit_end:
		var rx: float = ORBIT_RX * (1.0 - ORBIT_SHRINK * _ease(k))
		var ry: float = ORBIT_RY * (1.0 - 0.4 * k)
		var spin: float = t * (ORBIT_SPIN + ORBIT_SPIN_GAIN * k)
		var fade: float = clampf(k * 4.0, 0.0, 1.0)
		for i: int in CROSS_COUNT:
			var a: float = spin + i * TAU / CROSS_COUNT
			var in_front: bool = sin(a) > 0.0
			if in_front != _front:
				continue
			var p := _from + Vector2(cos(a) * rx, sin(a) * ry)
			_draw_cross(p, CROSS_SIZE + sin(a) * 6.0, fade * (1.0 if in_front else 0.75))
	elif _front:
		var b: float = (progress() - orbit_end) / BURST_SHARE
		_light(_from, BURST_RADIUS * _ease(b), color, 0.9 * (1.0 - b))


func _draw_ring() -> void:
	var k: float = progress()
	var a: float = _bell(k)
	var r: float = RING_RADIUS * (0.48 + 0.52 * _ease(k * 1.5))
	# Soft column of light over the ally.
	_light(_from + Vector2(0, -RING_COLUMN_HEIGHT * 0.38), RING_RADIUS * 0.6, color, 0.32 * a, 2.6)
	# Glow on the ground and the ring itself.
	_light(_from, r * 1.3, color, 0.5 * a, RING_SQUASH)
	draw_set_transform(_from, 0.0, Vector2(1.0, RING_SQUASH))
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, Color(color, 0.25 * a), 18.0)
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, Color(color, 0.7 * a), 7.0)
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, Color(WHITE_GOLD, 0.8 * a), 2.0)
	draw_set_transform(Vector2.ZERO)
	for i: int in MOTES:
		var rise: float = fmod(k * 1.6 + _seed(i), 1.0)
		var x: float = (_seed(i + 9) - 0.5) * 1.6 * r
		_light(_from + Vector2(x, -10.0 - rise * RING_COLUMN_HEIGHT * 0.8), 9.0, color, 0.9 * a * (1.0 - rise))


func _draw_petal_light() -> void:
	var a: float = _bell(progress())
	_light(_from + Vector2(0, -130), 130.0, color, 0.35 * a)
	_light(_from + Vector2(0, -180), 90.0, color, 0.25 * a)


func _draw_petals() -> void:
	var k: float = progress()
	var a: float = _bell(k)
	for i: int in PETALS:
		var fall: float = fmod(k * 1.25 + _seed(i + 5), 1.0)
		var p := _from + Vector2((_seed(i) - 0.5) * PETAL_SPREAD + sin(_time * 2.0 + i) * 12.0, -PETAL_FALL + fall * PETAL_FALL)
		draw_set_transform(p, _time * 2.0 + i)
		_ellipse(Vector2.ZERO, Vector2(6, 9), Color(color, a))
		_ellipse(Vector2(-1.5, -2), Vector2(2.5, 4), Color(PETAL_LIGHT, PETAL_LIGHT.a * a))
	draw_set_transform(Vector2.ZERO)


func _draw_shield() -> void:
	var k: float = progress()
	var appear: float = _ease(k / SHIELD_APPEAR)
	var vanish: float = clampf((k - SHIELD_VANISH) / (1.0 - SHIELD_VANISH), 0.0, 1.0)
	var a: float = appear * (1.0 - vanish)
	var facing: float = signf(_to.x) if _to.x != 0.0 else 1.0
	var c := _from + Vector2(SHIELD_OFFSET.x * facing, SHIELD_OFFSET.y - vanish * 18.0)
	_light(c, 120.0, color, 0.16 * a)
	var sc: float = 0.85 + 0.15 * appear
	draw_set_transform(c, 0.0, Vector2(sc, sc))
	var outline := PackedVector2Array([Vector2(-SHIELD_HALF.x, -SHIELD_HALF.y), Vector2(SHIELD_HALF.x, -SHIELD_HALF.y), Vector2(SHIELD_HALF.x, 0)])
	for i: int in range(1, 9):
		var u: float = i / 8.0
		outline.append(Vector2(SHIELD_HALF.x * (1.0 - u * u), SHIELD_TIP * sin(u * PI * 0.5)))
	for i: int in range(7, 0, -1):
		var u: float = i / 8.0
		outline.append(Vector2(-SHIELD_HALF.x * (1.0 - u * u), SHIELD_TIP * sin(u * PI * 0.5)))
	outline.append(Vector2(-SHIELD_HALF.x, 0))
	draw_colored_polygon(outline, Color(color, 0.05 * a))
	var closed := outline.duplicate()
	closed.append(outline[0])
	draw_polyline(closed, Color(color, 0.25 * a), 10.0)
	draw_polyline(closed, Color(color, 0.7 * a), 3.0)
	# Cross of light inside the shield.
	_light(Vector2(0, -2), 60.0, color, 0.35 * a, 1.4)
	draw_rect(Rect2(-7, -48, 14, 108), Color(color, 0.5 * a))
	draw_rect(Rect2(-36, -16, 72, 14), Color(color, 0.5 * a))
	draw_rect(Rect2(-3, -44, 6, 100), Color(1, 1, 1, 0.8 * a))
	draw_rect(Rect2(-32, -12, 64, 6), Color(1, 1, 1, 0.8 * a))
	# A soft sheen crossing it while it holds.
	var sweep: float = clampf((k - 0.15) / 0.45, 0.0, 1.0)
	if sweep > 0.0 and sweep < 1.0:
		_light(Vector2(-SHIELD_HALF.x + sweep * SHIELD_HALF.x * 2.0, sweep * 30.0 - 15.0), 30.0, Color.WHITE, 0.35 * a, 2.0)
	draw_set_transform(Vector2.ZERO)
	# Dissolving into rising points of light.
	if vanish > 0.0:
		for i: int in SHIELD_SPARKS:
			var p := c + Vector2((_seed(i) - 0.5) * 100.0, (_seed(i + 3) - 0.5) * 130.0 - vanish * (40.0 + 80.0 * _seed(i + 6)))
			_light(p, 7.0, color, 0.9 * (1.0 - vanish) * minf(1.0, vanish * 3.0))


func _draw_smoke() -> void:
	var k: float = progress()
	for i: int in SMOKE_PUFFS:
		# Each puff leaves the mouth a little after the one before, rolls to
		# the target and billows there before thinning out.
		var start: float = float(i) / SMOKE_PUFFS * SMOKE_TRAVEL * 0.6
		var u: float = clampf((k - start) / SMOKE_TRAVEL, 0.0, 1.0)
		if u <= 0.0:
			continue
		var after: float = clampf((k - start - SMOKE_TRAVEL) / (1.0 - SMOKE_TRAVEL), 0.0, 1.0)
		var e: float = _ease(u)
		var wobble := Vector2(sin(i * 2.0 + e * 5.0) * 14.0, cos(i + e * 4.0) * 18.0)
		var swirl := Vector2(cos(i * 1.7 + after * 3.0), sin(i * 1.3 + after * 3.0)) * 40.0 * after
		var p := _from.lerp(_to, e) + wobble + swirl
		var r: float = SMOKE_RADIUS * (0.5 + 0.9 * e + 0.6 * after)
		var a: float = minf(1.0, u * 4.0) * (1.0 - after)
		_light(p, r * 1.6, color, 0.55 * a)
		_light(p + Vector2(r * 0.2, r * 0.15), r, SMOKE_CORE, 0.5 * a)


func _draw_splatter() -> void:
	var k: float = progress()
	var dir: float = signf(_to.x - _from.x)
	for i: int in DROPS:
		var ang: float = -0.9 + _seed(i) * 1.8
		var d: float = 20.0 + DROP_REACH * _ease(k) * (0.4 + _seed(i + 3))
		var p := _from + Vector2(dir * (cos(ang) * d * 0.9 + 20.0), sin(ang) * d * 0.6 + k * 30.0)
		draw_circle(p, (3.0 + _seed(i + 7) * 6.0) * (1.0 - k * 0.6), Color(color, 1.0 - k))


func _draw_orb() -> void:
	var k: float = _ease(progress())
	var p := _from.lerp(_to, k) + Vector2(0, -sin(k * PI) * 60.0)
	_light(p, ORB_RADIUS * 2.2, color, 0.6)
	_light(p, ORB_RADIUS, WHITE_GOLD, 0.9)


func _ellipse(at: Vector2, radii: Vector2, c: Color) -> void:
	var points := PackedVector2Array()
	for i: int in 12:
		var a: float = i * TAU / 12.0
		points.append(at + Vector2(cos(a) * radii.x, sin(a) * radii.y))
	draw_colored_polygon(points, c)


## Fixed pseudo-random value in 0..1 for the i-th particle (same every play).
static func _seed(i: int) -> float:
	var x: float = sin(i * 127.1 + 311.7) * 43758.5453
	return x - floor(x)
