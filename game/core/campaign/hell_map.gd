class_name HellMap
extends RefCounted
## The Map of Hell (T49, D-208, D-276, D-511): the eleven bands from the Gate
## of Hell to the Cocytus, which of them are open, where the company's
## lantern hangs, where the pale light waits and where an expedition can
## start (the gate of the circle or a consecrated camp). Rules only; the
## screen draws them.

const LOCKED: StringName = &"locked"
const OPEN: StringName = &"open"
const COMPLETED: StringName = &"completed"
## The bands, top to bottom (glossary). The first three belong to Circle 1,
## in Dante's order (D-459).
const PLACES: Array[StringName] = [
	&"gate_of_hell", &"antehell", &"circle_01", &"circle_02", &"circle_03", &"circle_04",
	&"circle_05", &"circle_06", &"circle_07", &"circle_08", &"circle_09",
]
const CIRCLE_ONE_PLACES: Array[StringName] = [&"gate_of_hell", &"antehell", &"circle_01"]


## The circle number of a band (the Gate of Hell and the Antehell are Circle 1).
static func circle_of(place: StringName) -> int:
	if CIRCLE_ONE_PLACES.has(place):
		return 1
	return int(String(place).trim_prefix("circle_"))


## Locked, open, or completed (its boss has fallen once).
static func state(c: CampaignState, catalog: ExpeditionCatalog, place: StringName) -> StringName:
	var n: int = circle_of(place)
	var open_circles: Array[float] = catalog.constants.get_list(&"map_open_circles")
	if not open_circles.has(float(n)):
		return LOCKED
	if c.flags.has(StringName("circle_%02d_completed" % n)):
		return COMPLETED
	return OPEN


## The band where the company's lantern hangs: the deepest open band.
static func lantern_band(c: CampaignState, catalog: ExpeditionCatalog) -> int:
	var band: int = 0
	for i: int in PLACES.size():
		if state(c, catalog, PLACES[i]) != LOCKED:
			band = i
	return band


## The pale light waits one circle ahead of the lantern (D-276).
static func pale_light_band(c: CampaignState, catalog: ExpeditionCatalog) -> int:
	return mini(lantern_band(c, catalog) + 1, PLACES.size() - 1)


## Where an expedition to `place` can start: 0 is the gate of the circle,
## then each consecrated camp (expedition §1, D-435). Empty when locked.
static func start_points(c: CampaignState, catalog: ExpeditionCatalog, place: StringName) -> Array[int]:
	var points: Array[int] = []
	if state(c, catalog, place) == LOCKED:
		return points
	points.append(0)
	for leg: int in range(1, ExpeditionController.LAST_LEG):
		if c.flags.has(ExpeditionController.consecrated_flag(place, leg)):
			points.append(leg)
	return points


## The camps of a circle (consecrated or not), for the trail.
static func camps() -> Array[int]:
	var legs: Array[int] = []
	for leg: int in range(1, ExpeditionController.LAST_LEG):
		legs.append(leg)
	return legs

