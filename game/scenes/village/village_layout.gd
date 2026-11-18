class_name VillageLayout
extends RefCounted
## Where each building stands on the village picture (D-495): Alan's village
## at 960 x 540 with a transparent sky, the outline of each building drawn by
## Alan and separated into its own picture, and the area each one answers to
## a touch, in the picture's pixels.

const DIR: String = "res://assets/pixel/environments/village/"
const PICTURE_PATH: String = DIR + "village.png"
## The sky behind it: wraps sideways, moved by the engine.
const SKY_PATH: String = DIR + "village_sky.png"
const OUTLINE_PATH: String = DIR + "village_outline_%s.png"
const PICTURE_SIZE := Vector2(960, 540)

## Building id -> touch area (picture pixels). The ids are those of the
## facilities (Campaign.M2_FACILITIES and village-economy §3); the cathedral
## is the Chapel's building (D-488).
const AREAS: Dictionary = {
	&"gate": [Vector2(0, 255), Vector2(197, 255), Vector2(197, 492), Vector2(0, 492)],
	&"reliquary": [Vector2(186, 285), Vector2(292, 285), Vector2(292, 440), Vector2(186, 440)],
	&"retreat_house": [Vector2(292, 300), Vector2(336, 300), Vector2(345, 330), Vector2(432, 330), Vector2(432, 425), Vector2(292, 425)],
	&"library": [Vector2(268, 22), Vector2(338, 22), Vector2(338, 300), Vector2(268, 300)],
	&"chapel": [Vector2(338, 18), Vector2(612, 18), Vector2(612, 240), Vector2(535, 245), Vector2(535, 355), Vector2(400, 362), Vector2(345, 330), Vector2(338, 300)],
	&"carmel": [Vector2(535, 245), Vector2(645, 245), Vector2(645, 420), Vector2(510, 420), Vector2(510, 365), Vector2(535, 355)],
	&"garden": [Vector2(612, 205), Vector2(955, 205), Vector2(955, 278), Vector2(805, 278), Vector2(790, 290), Vector2(650, 290), Vector2(612, 250)],
	&"infirmary": [Vector2(645, 290), Vector2(790, 290), Vector2(745, 330), Vector2(745, 445), Vector2(690, 445), Vector2(645, 425)],
	&"forge": [Vector2(745, 330), Vector2(790, 290), Vector2(805, 290), Vector2(808, 470), Vector2(745, 470)],
	&"pantry": [Vector2(808, 278), Vector2(960, 278), Vector2(960, 510), Vector2(808, 510)],
}


static func area(building: StringName) -> PackedVector2Array:
	return PackedVector2Array(AREAS.get(building, []))


## The building under `point` (picture pixels), or &"".
static func building_at(point: Vector2) -> StringName:
	for id: StringName in AREAS:
		if Geometry2D.is_point_in_polygon(point, area(id)):
			return id
	return &""
