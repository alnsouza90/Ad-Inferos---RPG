class_name SaintStamp
extends Control
## The stamp of a saint's ability (Art Bible §6.1, D-452): one flat drawing
## per saint and kind, moved by the engine (gesture → sign → mark). George's
## shield drops onto the one he protects and slams with dust; Benedict's
## cross flares on the one he exorcises and breaks; his ring lies on the
## ground and rises; Therese's petals fall, dark red turning to gold.
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
## The shield starts this high above where it lands, at this size.
const DROP_HEIGHT: float = 90.0
const START_SCALE: float = 0.5
## The ring (drawn lying on the ground) rises this far while it narrows.
const RING_RISE: float = 70.0
const RING_END_SCALE: float = 0.4
const PETAL_FALL: float = 60.0
const PETAL_RED := Color("8B1E1E")
## Dust and chips thrown where the shield slams.
const DUST_COUNT: int = 6
const DUST_SIZE := Vector2(3, 3)
const DUST_REACH: float = 26.0

var _picture: TextureRect
var shape: StringName = &""


## The drawing of `saint_def_id` for an ability of `kind`, or &"".
static func shape_for(saint_def_id: StringName, kind: StringName) -> StringName:
	return StringName((SHAPES.get(saint_def_id, {}) as Dictionary).get(kind, &""))


static func texture_of(stamp_shape: StringName) -> Texture2D:
	var path: String = PATH % stamp_shape
	return load(path) as Texture2D if stamp_shape != &"" and ResourceLoader.exists(path) else null


## Plays `stamp_shape` centred on `chest` with the feet at `feet` (both in
## the parent's coordinates); returns how long it lasts. Frees itself after.
func play(stamp_shape: StringName, chest: Vector2, feet: Vector2, factor: float) -> float:
	shape = stamp_shape
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex: Texture2D = texture_of(stamp_shape)
	if tex == null or factor <= 0.0:
		queue_free()
		return 0.0
	_picture = TextureRect.new()
	_picture.texture = tex
	_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_picture.size = tex.get_size()
	_picture.pivot_offset = _picture.size * 0.5
	add_child(_picture)
	var arrive: float = ARRIVE / factor
	var hold: float = HOLD / factor
	var leave: float = LEAVE / factor
	var tween := create_tween()
	match stamp_shape:
		SHIELD:
			var landing: Vector2 = (chest - _picture.size * 0.5).round()
			_picture.position = landing - Vector2(0, DROP_HEIGHT)
			_picture.scale = Vector2.ONE * START_SCALE
			_picture.modulate.a = 0.0
			tween.set_parallel(true)
			tween.tween_property(_picture, "position", landing, arrive).set_ease(Tween.EASE_IN)
			tween.tween_property(_picture, "scale", Vector2.ONE, arrive)
			tween.tween_property(_picture, "modulate:a", 1.0, arrive * 0.5)
			tween.chain().tween_callback(_throw_dust.bind(Vector2(chest.x, feet.y), leave + hold))
		RING:
			_picture.position = (feet - _picture.size * 0.5).round()
			_picture.modulate.a = 0.0
			tween.tween_property(_picture, "modulate:a", 1.0, arrive)
			tween.tween_property(_picture, "position:y", _picture.position.y - RING_RISE, hold + leave)
			tween.parallel().tween_property(_picture, "scale", Vector2.ONE * RING_END_SCALE, hold + leave)
		PETALS:
			_picture.position = (chest - _picture.size * 0.5 - Vector2(0, PETAL_FALL)).round()
			_picture.modulate = Color(PETAL_RED, 0.0)
			tween.set_parallel(true)
			tween.tween_property(_picture, "position:y", _picture.position.y + PETAL_FALL, arrive + hold)
			tween.tween_property(_picture, "modulate", Color(PixelStyle.COLOR_GOLD, 1.0), arrive + hold)
			tween.chain()
		_:
			_picture.position = (chest - _picture.size * 0.5).round()
			_picture.scale = Vector2.ONE * START_SCALE
			_picture.modulate.a = 0.0
			tween.set_parallel(true)
			tween.tween_property(_picture, "scale", Vector2.ONE, arrive).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(_picture, "modulate:a", 1.0, arrive * 0.5)
			tween.chain()
	if stamp_shape != RING:
		tween.tween_interval(hold)
		# It fades with gaps, like a print wearing off.
		tween.tween_property(_picture, "modulate:a", 0.3, leave * 0.4)
		tween.tween_property(_picture, "modulate:a", 0.7, leave * 0.2)
		tween.tween_property(_picture, "modulate:a", 0.0, leave * 0.4)
	else:
		tween.parallel().tween_property(_picture, "modulate:a", 0.0, leave).set_delay(hold)
	tween.tween_callback(queue_free)
	return arrive + hold + leave


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
