class_name VillageLayout
extends RefCounted
## Where each building stands on the village picture (D-492): the picture of
## Alan at 960 x 540, and the outline of every building that can be touched,
## in the picture's pixels. Building 7 of the picture (the small house with
## barrels) is scenery only, no touch.

const PICTURE_PATH: String = "res://assets/pixel/environments/village/village_hub.png"
const LIGHTS_PATH: String = "res://assets/pixel/environments/village/village_hub_lights.png"
const PICTURE_SIZE := Vector2(960, 540)

## Building id -> outline (PackedVector2Array in picture pixels). The ids are
## those of the facilities (Campaign.M2_FACILITIES and village-economy §3);
## the cathedral is the Chapel's building (D-488).
const OUTLINES: Dictionary = {
	&"library": [Vector2(283, 57), Vector2(287, 84), Vector2(305, 84), Vector2(305, 200), Vector2(313, 205), Vector2(313, 222), Vector2(267, 222), Vector2(266, 84), Vector2(279, 84)],
	&"chapel": [Vector2(378, 18), Vector2(388, 70), Vector2(392, 95), Vector2(415, 85), Vector2(440, 100), Vector2(470, 92), Vector2(466, 70), Vector2(476, 20), Vector2(484, 70), Vector2(492, 140), Vector2(510, 175), Vector2(518, 200), Vector2(520, 278), Vector2(336, 278), Vector2(333, 240), Vector2(320, 200), Vector2(336, 160), Vector2(345, 120), Vector2(358, 110), Vector2(368, 70)],
	&"carmel": [Vector2(556, 136), Vector2(566, 155), Vector2(632, 158), Vector2(640, 185), Vector2(640, 232), Vector2(530, 232), Vector2(522, 222), Vector2(530, 195), Vector2(535, 165), Vector2(548, 158)],
	&"garden": [Vector2(180, 262), Vector2(210, 242), Vector2(330, 242), Vector2(332, 262), Vector2(332, 320), Vector2(320, 335), Vector2(180, 315)],
	&"infirmary": [Vector2(110, 375), Vector2(130, 340), Vector2(255, 337), Vector2(282, 375), Vector2(282, 420), Vector2(240, 440), Vector2(115, 420)],
	&"retreat_house": [Vector2(160, 440), Vector2(205, 420), Vector2(250, 420), Vector2(312, 445), Vector2(312, 500), Vector2(250, 515), Vector2(165, 505)],
	&"forge": [Vector2(460, 302), Vector2(478, 287), Vector2(520, 290), Vector2(535, 305), Vector2(535, 355), Vector2(462, 355)],
	&"pantry": [Vector2(578, 285), Vector2(560, 320), Vector2(552, 330), Vector2(552, 370), Vector2(560, 392), Vector2(660, 392), Vector2(662, 340), Vector2(655, 290), Vector2(605, 282)],
	&"gate": [Vector2(705, 262), Vector2(745, 262), Vector2(745, 290), Vector2(800, 282), Vector2(802, 360), Vector2(760, 368), Vector2(702, 350)],
	&"reliquary": [Vector2(672, 357), Vector2(700, 400), Vector2(702, 445), Vector2(690, 452), Vector2(642, 452), Vector2(640, 405)],
}


static func outline(building: StringName) -> PackedVector2Array:
	return PackedVector2Array(OUTLINES.get(building, []))


## The building under `point` (picture pixels), or &"".
static func building_at(point: Vector2) -> StringName:
	for id: StringName in OUTLINES:
		if Geometry2D.is_point_in_polygon(point, outline(id)):
			return id
	return &""
