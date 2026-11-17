class_name SceneryPlan
extends RefCounted
## Which scenery each place of a leg shows, and how one place passes into the
## next (D-445, D-446; `docs/design/cenarios-trechos-circulo-02.md`). Pure
## presentation, decided from the map alone (never from the rules' RNG), so a
## resumed game looks exactly the same.
##
## A look is {"back", "mid", "front", "crowd", "ground", "piece"}: file names
## of the layers ("" when absent). Two looks are the same place when the sky
## and the middle match. The way out of one screen and the way into the next
## are the same passage: OPEN keeps the place (the company walks off the right
## edge), while a door, a cave or a stair darkens the screen and may change it.

const OPEN: StringName = &"straight"
const DOOR: StringName = &"door"
const CAVE: StringName = &"cave"
const STAIRS: StringName = &"stairs"

const T1_BACK: String = "env_circle_02_t1_back"
const T3_BACK: String = "env_circle_02_t3_back"
const STORM: String = "env_circle_02_common_back_storm"
const STORM_EYE: String = "env_circle_02_common_back_storm_eye"
const PLAIN: String = "env_circle_02_common_mid_plain"
const ROCK_WALL: String = "env_circle_02_common_mid_rock_wall"
const T2_MID: String = "env_circle_02_t2_mid"
const T3_MID: String = "env_circle_02_t3_mid"
const JURY_HALL: String = "env_circle_02_jury_hall"
const JURY_FLOOR: String = "env_circle_02_jury_floor"
## The outer wall of the jury hall along the way to Minos, and its door set
## into the same masonry (D-448).
const JURY_WALL: String = "env_circle_02_jury_wall"
const JURY_DOOR: String = "env_circle_02_jury_door"
const TIGRIS: String = "env_circle_02_tigris"
const SOULS_CROWD: String = "env_circle_02_souls_crowd"
## The throne of Minos far away: a unique piece, drawn once, only at the
## arrival in the circle (D-445 rule 1).
const THRONE: String = "env_circle_02_t1_mid"
const FRONTS: Array[String] = ["env_circle_02_t1_front", "env_circle_02_t2_front", "env_circle_02_t3_front"]
const WALK_FRONT: String = "env_circle_02_t1_front"
## How far each middle sits below the bottom of the field so that its
## walkable ground lies under the feet (D-448, measured on the layers: the
## plain and the broken towers end in a dark cliff, the cloister and the
## rock wall end above the ground line).
const SINK: Dictionary = {
	PLAIN: 40.0,
	T2_MID: 36.0,
	T3_MID: 24.0,
	ROCK_WALL: 26.0,
	THRONE: 14.0,
}
## The generic places of each leg (proposal v2): {back, mid}.
const GENERIC: Array = [
	[[T1_BACK, PLAIN], [STORM, ROCK_WALL]],
	[[STORM, T2_MID], [STORM, PLAIN]],
	[[T3_BACK, T3_MID], [STORM, ROCK_WALL]],
]
## Loose pieces that may stand in a generic place, by leg.
const DECOR: Array = [
	["env_circle_02_slabs", "env_circle_02_pinnacle"],
	["env_circle_02_wall", "env_circle_02_pinnacle"],
	["env_circle_02_arcade", "env_circle_02_slabs"],
]
## Closed passages that stand anywhere (a cave only on the rock wall, a door
## on a wall drawn behind it: D-445 rule 2).
const CLOSED_ANYWHERE: Array[StringName] = [DOOR, STAIRS]
## The crowd of souls flies between the sky and the ground.
const CROWD_PARALLAX: float = 0.45
## Built wall drawn behind a door.
const WALL: String = "env_circle_02_wall"


## The look of the corridor of `n` in `map`; null `n` is the gate corridor.
static func look(map: LegMap, n: MapNode) -> Dictionary:
	var leg: int = clampi(map.leg, 1, 3)
	if n == null:
		var gate: Dictionary = _make(GENERIC[leg - 1][0], leg)
		if leg == 1:
			gate["piece"] = THRONE
		return gate
	if n.role == MapNode.ROLE_GUARDIAN:
		return {"back": "", "mid": JURY_HALL, "front": "", "crowd": "", "ground": JURY_FLOOR, "piece": ""}
	if n.content == MapGenerator.CONTENT_FISH:
		return _make([T3_BACK, TIGRIS], leg)
	var inherited: Dictionary = _inherited(map, n, leg)
	match n.type:
		MapNode.TYPE_RELIC:
			# A sheltered niche (proposal v2): against the rock, or among the
			# arcades of the cloister when the way already has them.
			if inherited["mid"] != T3_MID:
				inherited["mid"] = ROCK_WALL
		MapNode.TYPE_SOUL:
			# The souls fly over the place the way already is in (D-446).
			inherited["crowd"] = SOULS_CROWD
		MapNode.TYPE_ELITE:
			# Something bigger is there: the sky turns to the eye of the storm.
			inherited["back"] = STORM_EYE
	if leads_to_guardian(map, n):
		# The way to Minos runs along the outer wall of the jury hall and
		# ends at its door (D-448, option B).
		inherited["mid"] = JURY_WALL
		if inherited["back"] != STORM_EYE:
			inherited["back"] = STORM
	return inherited


## True when the Guardian's hall is the next place after `n`.
static func leads_to_guardian(map: LegMap, n: MapNode) -> bool:
	if n == null:
		return false
	for e: MapNode in map.entrances_from(n):
		if e.role == MapNode.ROLE_GUARDIAN:
			return true
	return false


## How the company goes from the corridor of `from` (null: the gate) into
## `to`: OPEN only along the straight way and when the place stays the same.
static func passage(map: LegMap, from: MapNode, to: MapNode) -> StringName:
	var entrances: Array[MapNode] = map.entrances_from(from) if from != null else map.layer_nodes(1)
	var here: Dictionary = look(map, from)
	if CorridorLook.straight_entrance(map, from, entrances) == to.id and same_place(here, look(map, to)):
		return OPEN
	if to.role == MapNode.ROLE_GUARDIAN:
		return DOOR
	if here["mid"] == ROCK_WALL:
		return CAVE
	return CLOSED_ANYWHERE[RngStream.fnv1a32("%d:%s" % [map.leg, to.id]) % CLOSED_ANYWHERE.size()]


## The same place: the same middle under the same sky. The eye of the
## storm closes over a place and opens again without leaving it (rule 2:
## the sky may change slowly along the way).
static func same_place(a: Dictionary, b: Dictionary) -> bool:
	if a["mid"] != b["mid"]:
		return false
	return a["back"] == b["back"] or a["back"] == STORM_EYE or b["back"] == STORM_EYE


## A loose piece for a generic place (a slab, a pinnacle...), or "".
static func decor(map: LegMap, n: MapNode) -> String:
	if n == null or n.role == MapNode.ROLE_GUARDIAN or n.content == MapGenerator.CONTENT_FISH:
		return ""
	if n.type != MapNode.TYPE_BATTLE and n.type != MapNode.TYPE_ELITE:
		return ""
	var pieces: Array = DECOR[clampi(map.leg, 1, 3) - 1]
	return str(pieces[RngStream.fnv1a32("decor:%d:%s" % [map.leg, n.id]) % pieces.size()])


## A generic place follows the place it is reached from along the straight
## way (one place between two closed passages); else one of its leg's places.
static func _inherited(map: LegMap, n: MapNode, leg: int) -> Dictionary:
	if n.layer == 1:
		if CorridorLook.straight_entrance(map, null, map.layer_nodes(1)) == n.id:
			return _generic_of(look(map, null), leg)
	for p: MapNode in map.predecessors(n):
		if CorridorLook.straight_entrance(map, p, map.entrances_from(p)) == n.id:
			return _generic_of(look(map, p), leg)
	var places: Array = GENERIC[leg - 1]
	return _make(places[RngStream.fnv1a32("place:%d:%s" % [leg, n.id]) % places.size()], leg)


## The look a generic node takes from the one before it: its sky and middle,
## without the unique pieces (throne, jury hall, river) nor the crowd.
static func _generic_of(before: Dictionary, leg: int) -> Dictionary:
	var mid: String = before["mid"]
	var back: String = before["back"]
	if mid == JURY_HALL or mid == TIGRIS or mid == JURY_WALL or back == "":
		return _make(GENERIC[leg - 1][0], leg)
	if back == STORM_EYE:
		# Past the elite the eye opens back into the storm.
		back = STORM
	return _make([back, mid], leg)


static func _make(place: Array, leg: int) -> Dictionary:
	return {"back": place[0], "mid": place[1], "front": FRONTS[leg - 1], "crowd": "", "ground": "", "piece": ""}


## Layers behind the characters, back to front, for ParallaxScenery.
static func back_layers(the_look: Dictionary) -> Array[Dictionary]:
	var layers: Array[Dictionary] = []
	_add(layers, the_look["back"], CircleLook.PARALLAX_BACK)
	_add(layers, the_look["crowd"], CROWD_PARALLAX)
	_add(layers, the_look["mid"], CircleLook.PARALLAX_MID)
	_add(layers, the_look["piece"], CircleLook.PARALLAX_MID, true)
	_add(layers, the_look["ground"], CircleLook.PARALLAX_MID)
	return layers


## Layers in front of the characters. The battle shows the front of its leg
## in the corners; the walk passes the whole width, so it takes the low rocks
## (the fronts of legs 2 and 3 rise high and would hide the company).
static func front_layers(the_look: Dictionary, walking: bool = false) -> Array[Dictionary]:
	var layers: Array[Dictionary] = []
	var front: String = the_look["front"]
	if walking and not front.is_empty():
		front = WALK_FRONT
	_add(layers, front, CircleLook.PARALLAX_FRONT)
	return layers


static func path(file_name: String) -> String:
	return "%s/circle_02/%s.png" % [CircleLook.SCENERY_DIR, file_name]


static func _add(layers: Array[Dictionary], file_name: String, parallax: float, once: bool = false) -> void:
	if file_name.is_empty():
		return
	layers.append({"path": path(file_name), "parallax": parallax, "once": once, "sink": float(SINK.get(file_name, 0.0))})
