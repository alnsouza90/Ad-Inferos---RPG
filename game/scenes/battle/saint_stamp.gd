class_name SaintStamp
extends Control
## The stamp of a saint's ability (Art Bible §6.1, D-452, D-453): one flat
## drawing per saint and kind, moved by the engine (gesture → sign → mark).
## George's shield drops onto the body of the one he protects and slams with
## dust; Benedict's cross flares on the one he exorcises and wears off; his
## ring wraps the legs (its back half behind the figure) and rises; Therese's
## small red petals fall around the one she heals, with a glint of gold.
## Presentation only.

const PATH: String = "res://assets/pixel/vfx/stamp_%s.png"
const SHIELD: StringName = &"shield"
const CROSS: StringName = &"cross"
const RING: StringName = &"ring"
const PETALS: StringName = &"petals"
## Which drawing each saint shows for each kind of ability (AbilityIcon).
const SHAPES: Dictionary = {
	&"saint_george": {AbilityIcon.WARD: SHIELD},
	&"saint_benedict": {AbilityIcon.EXORCISM: CROSS, AbilityIcon.RELIEF: RING},
	&"saint_therese": {AbilityIcon.HEAL: PETALS},
}
## Seconds at speed 1 of each part of the motion.
const ARRIVE: float = 0.22
const HOLD: float = 0.35
const LEAVE: float = 0.35
## The shield lands on the body, this share of the way from the chest down
## to the feet (not on the face, D-453); it starts this high, at this size.
const BODY_SHARE: float = 0.4
const DROP_HEIGHT: float = 90.0
const START_SCALE: float = 0.5
## The ring rises this far from the feet while it narrows.
const RING_RISE: float = 60.0
const RING_END_SCALE: float = 0.55
## Clusters of petals around the target, their spread and fall, the red
## they keep and the glint of gold halfway (D-453).
const PETAL_CLUSTERS: Array[Vector2] = [Vector2(-34, -10), Vector2(0, -40), Vector2(30, 0), Vector2(-14, 26), Vector2(22, 44)]
const PETAL_FALL: float = 50.0
const PETAL_STAGGER: float = 0.06
const PETAL_RED := Color("8B1E1E")
## Dust and chips thrown where the shield slams.
const DUST_COUNT: int = 6
const DUST_SIZE := Vector2(3, 3)
const DUST_REACH: float = 26.0

var shape: StringName = &""
var _pieces: Array[Control] = []


## The drawing of `saint_def_id` for an ability of `kind`, or &"".
static func shape_for(saint_def_id: StringName, kind: StringName) -> StringName:
	return StringName((SHAPES.get(saint_def_id, {}) as Dictionary).get(kind, &""))


static func texture_of(stamp_shape: StringName) -> Texture2D:
	var path: String = PATH % stamp_shape
	return load(path) as Texture2D if stamp_shape != &"" and ResourceLoader.exists(path) else null


## Plays `stamp_shape` on the combatant whose chest and feet are given (in
## the parent's coordinates); `behind` holds what passes behind the figure
## (same coordinates). Returns how long it lasts; frees itself after.
func play(stamp_shape: StringName, chest: Vector2, feet: Vector2, factor: float, behind: Control = null) -> float:
	shape = stamp_shape
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex: Texture2D = texture_of(stamp_shape)
	if tex == null or factor <= 0.0:
		queue_free()
		return 0.0
	var arrive: float = ARRIVE / factor
	var hold: float = HOLD / factor
	var leave: float = LEAVE / factor
	match stamp_shape:
		SHIELD:
			_play_shield(tex, chest.lerp(feet, BODY_SHARE), feet, arrive, hold, leave)
		RING:
			_play_ring(tex, feet, behind, arrive, hold, leave)
		PETALS:
			_play_petals(tex, chest, arrive, hold, leave)
		_:
			_play_flare(tex, chest, arrive, hold, leave)
	var total: float = arrive + hold + leave
	create_tween().tween_callback(_finish).set_delay(total + (PETAL_STAGGER * PETAL_CLUSTERS.size()) / factor)
	return total


func _piece(tex: Texture2D, holder: Control = null) -> TextureRect:
	var picture := TextureRect.new()
	picture.texture = tex
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	picture.size = tex.get_size()
	picture.pivot_offset = picture.size * 0.5
	(holder if holder != null else self).add_child(picture)
	_pieces.append(picture)
	return picture


func _play_shield(tex: Texture2D, body: Vector2, feet: Vector2, arrive: float, hold: float, leave: float) -> void:
	var picture: TextureRect = _piece(tex)
	var landing: Vector2 = (body - picture.size * 0.5).round()
	picture.position = landing - Vector2(0, DROP_HEIGHT)
	picture.scale = Vector2.ONE * START_SCALE
	picture.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(picture, "position", landing, arrive).set_ease(Tween.EASE_IN)
	tween.tween_property(picture, "scale", Vector2.ONE, arrive)
	tween.tween_property(picture, "modulate:a", 1.0, arrive * 0.5)
	tween.chain().tween_callback(_throw_dust.bind(Vector2(body.x, feet.y), leave + hold))
	_wear_off(tween.chain(), picture, hold, leave)


func _play_flare(tex: Texture2D, chest: Vector2, arrive: float, hold: float, leave: float) -> void:
	var picture: TextureRect = _piece(tex)
	picture.position = (chest - picture.size * 0.5).round()
	picture.scale = Vector2.ONE * START_SCALE
	picture.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(picture, "scale", Vector2.ONE, arrive).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(picture, "modulate:a", 1.0, arrive * 0.5)
	_wear_off(tween.chain(), picture, hold, leave)


## The ring is cut in two: its far half behind the figure, its near half in
## front, so it wraps the legs as it rises (D-453).
func _play_ring(tex: Texture2D, feet: Vector2, behind: Control, arrive: float, hold: float, leave: float) -> void:
	var half: float = floorf(tex.get_height() * 0.5)
	var centre := Vector2(tex.get_width() * 0.5, tex.get_height() * 0.5)
	for near: bool in [false, true]:
		var region := Rect2(0, half if near else 0.0, tex.get_width(), tex.get_height() - half if near else half)
		var atlas := AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = region
		var picture: TextureRect = _piece(atlas, self if near or behind == null else behind)
		picture.pivot_offset = centre - region.position
		picture.position = (feet - centre + region.position).round()
		picture.modulate.a = 0.0
		var tween := create_tween()
		tween.tween_property(picture, "modulate:a", 1.0, arrive)
		tween.tween_property(picture, "position:y", picture.position.y - RING_RISE, hold + leave)
		tween.parallel().tween_property(picture, "scale", Vector2.ONE * RING_END_SCALE, hold + leave)
		tween.parallel().tween_property(picture, "modulate:a", 0.0, leave).set_delay(hold)


func _play_petals(tex: Texture2D, chest: Vector2, arrive: float, hold: float, leave: float) -> void:
	for i: int in PETAL_CLUSTERS.size():
		var picture: TextureRect = _piece(tex)
		var start: Vector2 = (chest + PETAL_CLUSTERS[i] - picture.size * 0.5 - Vector2(0, PETAL_FALL)).round()
		picture.position = start
		picture.modulate = Color(PETAL_RED, 0.0)
		var delay: float = PETAL_STAGGER * i * (arrive / ARRIVE)
		var tween := create_tween()
		tween.tween_interval(delay)
		tween.tween_property(picture, "modulate:a", 1.0, arrive * 0.5)
		tween.parallel().tween_property(picture, "position:y", start.y + PETAL_FALL, arrive + hold + leave)
		# A glint of gold as they fall, then the red again.
		tween.parallel().tween_property(picture, "modulate", Color(PixelStyle.COLOR_GOLD, 1.0), hold * 0.3).set_delay(arrive)
		tween.parallel().tween_property(picture, "modulate", Color(PETAL_RED, 1.0), hold * 0.3).set_delay(arrive + hold * 0.3)
		tween.parallel().tween_property(picture, "modulate:a", 0.0, leave).set_delay(arrive + hold)


## It fades with gaps, like a print wearing off.
func _wear_off(tween: Tween, picture: TextureRect, hold: float, leave: float) -> void:
	tween.set_parallel(false)
	tween.tween_interval(hold)
	tween.tween_property(picture, "modulate:a", 0.3, leave * 0.4)
	tween.tween_property(picture, "modulate:a", 0.7, leave * 0.2)
	tween.tween_property(picture, "modulate:a", 0.0, leave * 0.4)


func _finish() -> void:
	for piece: Control in _pieces:
		if is_instance_valid(piece) and piece.get_parent() != self:
			piece.queue_free()
	queue_free()


## Bone dust and grey chips fly from where the shield lands.
func _throw_dust(at: Vector2, life: float) -> void:
	for i: int in DUST_COUNT:
		var chip := ColorRect.new()
		chip.color = PixelStyle.COLOR_BONE if i % 2 == 0 else PixelStyle.COLOR_GREY
		chip.size = DUST_SIZE
		chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		chip.position = at
		add_child(chip)
		var angle: float = PI + PI * float(i) / float(DUST_COUNT - 1)
		var tween := chip.create_tween().set_parallel(true)
		tween.tween_property(chip, "position", (at + Vector2(cos(angle), sin(angle)) * DUST_REACH).round(), life * 0.6)
		tween.tween_property(chip, "modulate:a", 0.0, life)
