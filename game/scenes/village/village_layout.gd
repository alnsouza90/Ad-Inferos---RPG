class_name VillageLayout
extends RefCounted
## Where each building stands on the village picture (D-492): the picture of
## Alan at 960 x 540, and the outline of every building that can be touched,
## in the picture's pixels. Building 7 of the picture (the small house with
## barrels) is scenery only, no touch.

const PICTURE_PATH: String = "res://assets/pixel/environments/village/village_hub.png"
## The same village at night, by Alan (D-494): shown in Advent and Lent.
const NIGHT_PATH: String = "res://assets/pixel/environments/village/village_hub_night.png"
const PICTURE_SIZE := Vector2(960, 540)

## Building id -> outline (PackedVector2Array in picture pixels). The ids are
## those of the facilities (Campaign.M2_FACILITIES and village-economy §3);
## the cathedral is the Chapel's building (D-488).
const OUTLINES: Dictionary = {
	&"library": [Vector2(287, 57), Vector2(290, 74), Vector2(296, 79), Vector2(306, 82), Vector2(306, 195), Vector2(313, 200), Vector2(313, 223), Vector2(270, 223), Vector2(268, 205), Vector2(266, 82), Vector2(278, 79), Vector2(284, 74)],
	&"chapel": [Vector2(382, 15), Vector2(386, 45), Vector2(395, 72), Vector2(394, 92), Vector2(410, 90), Vector2(437, 108), Vector2(442, 92), Vector2(447, 108), Vector2(463, 108), Vector2(465, 70), Vector2(474, 52), Vector2(477, 23), Vector2(481, 52), Vector2(489, 70), Vector2(491, 140), Vector2(496, 160), Vector2(503, 195), Vector2(510, 180), Vector2(515, 170), Vector2(520, 190), Vector2(522, 273), Vector2(336, 273), Vector2(333, 240), Vector2(319, 190), Vector2(323, 160), Vector2(328, 185), Vector2(340, 165), Vector2(345, 120), Vector2(350, 140), Vector2(365, 135), Vector2(370, 77), Vector2(377, 70)],
	&"carmel": [Vector2(557, 136), Vector2(567, 145), Vector2(568, 160), Vector2(618, 160), Vector2(637, 192), Vector2(636, 232), Vector2(590, 238), Vector2(520, 230), Vector2(520, 218), Vector2(534, 218), Vector2(533, 193), Vector2(550, 160), Vector2(550, 145)],
	&"garden": [Vector2(183, 258), Vector2(200, 240), Vector2(313, 240), Vector2(333, 258), Vector2(332, 322), Vector2(257, 335), Vector2(183, 306)],
	&"infirmary": [Vector2(110, 400), Vector2(112, 390), Vector2(130, 360), Vector2(255, 338), Vector2(285, 370), Vector2(287, 412), Vector2(233, 428), Vector2(152, 436), Vector2(110, 410)],
	&"retreat_house": [Vector2(158, 458), Vector2(200, 452), Vector2(215, 440), Vector2(240, 452), Vector2(260, 440), Vector2(310, 458), Vector2(313, 478), Vector2(237, 512), Vector2(160, 490)],
	&"forge": [Vector2(476, 287), Vector2(511, 290), Vector2(534, 316), Vector2(536, 342), Vector2(508, 356), Vector2(462, 348), Vector2(459, 314)],
	&"pantry": [Vector2(578, 291), Vector2(588, 300), Vector2(630, 281), Vector2(665, 318), Vector2(660, 345), Vector2(650, 392), Vector2(600, 392), Vector2(542, 388), Vector2(545, 350), Vector2(552, 328), Vector2(562, 310)],
	&"gate": [Vector2(703, 262), Vector2(743, 262), Vector2(744, 290), Vector2(757, 272), Vector2(800, 272), Vector2(799, 362), Vector2(760, 362), Vector2(745, 350), Vector2(707, 354)],
	&"reliquary": [Vector2(673, 357), Vector2(678, 372), Vector2(700, 392), Vector2(704, 420), Vector2(704, 450), Vector2(642, 450), Vector2(642, 410), Vector2(648, 392), Vector2(668, 372)],
}


static func outline(building: StringName) -> PackedVector2Array:
	return PackedVector2Array(OUTLINES.get(building, []))


## The building under `point` (picture pixels), or &"".
static func building_at(point: Vector2) -> StringName:
	for id: StringName in OUTLINES:
		if Geometry2D.is_point_in_polygon(point, outline(id)):
			return id
	return &""
