class_name CampaignState
extends RefCounted
## The campaign between expeditions (village-economy §1 and §13, save-load
## §3.3): the week, the Retreat, the company's Alms, the open buildings, the
## saints and who is resting or in a bed this week. Pure data; the rules that
## change it are in Campaign.

var seed: int = 0
var week: int = 1
## A Retreat was made since the last expedition (V01).
var retreat_used: bool = false
var alms: int = 0
## facility id -> level (only the open ones).
var facilities: Dictionary = {}
## Provisions bought and not yet taken (T48).
var pantry_stock: Array[StringName] = []
## Relics found and kept in the village, not carried by a saint.
var relic_stock: Array[StringName] = []
var unlocked_saints: Array[StringName] = []
## Saints unlocked that São Cristóvão still has to announce (D-458).
var pending_arrivals: Array[StringName] = []
## This week's designations: in a paid bed, resting in the Garden.
var infirmary_beds: Array[StringName] = []
var garden_saints: Array[StringName] = []
var village_intro_done: bool = false
var flags: Array[StringName] = []
var virtues: Virtues
## saint id -> CampaignSaint
var saints: Dictionary = {}
## The band where the Map of Hell last showed the lantern (-1: never
## opened). When the lantern's band is deeper, the map shows it descending
## (D-515). Presentation memory, kept with the campaign so it plays once.
var map_lantern_band: int = -1
## Draws made from the campaign stream (RngStreams.CAMPAIGN).
var rng_counter: int = 0


func saint(id: StringName) -> CampaignSaint:
	return saints.get(id)


func to_dict() -> Dictionary:
	var saint_dicts: Dictionary = {}
	for id: StringName in saints:
		saint_dicts[String(id)] = (saints[id] as CampaignSaint).to_dict()
	var levels: Dictionary = {}
	for f: StringName in facilities:
		levels[String(f)] = int(facilities[f])
	return {
		"seed": seed, "week": week, "retreat_used": retreat_used, "alms": alms, "facilities": levels,
		"pantry_stock": _strings(pantry_stock), "relic_stock": _strings(relic_stock),
		"unlocked_saints": _strings(unlocked_saints), "pending_arrivals": _strings(pending_arrivals),
		"infirmary_beds": _strings(infirmary_beds), "garden_saints": _strings(garden_saints),
		"village_intro_done": village_intro_done, "flags": _strings(flags), "virtues": virtues.to_dict(),
		"saints": saint_dicts, "rng_counter": rng_counter, "map_lantern_band": map_lantern_band,
	}


static func from_dict(data: Dictionary) -> CampaignState:
	var c := CampaignState.new()
	c.seed = int(data.get("seed", 0))
	c.week = int(data.get("week", 1))
	c.retreat_used = bool(data.get("retreat_used", false))
	c.alms = int(data.get("alms", 0))
	var levels: Dictionary = data.get("facilities", {})
	for f: Variant in levels:
		c.facilities[StringName(str(f))] = int(levels[f])
	c.pantry_stock = _names(data.get("pantry_stock", []))
	c.relic_stock = _names(data.get("relic_stock", []))
	c.unlocked_saints = _names(data.get("unlocked_saints", []))
	c.pending_arrivals = _names(data.get("pending_arrivals", []))
	c.infirmary_beds = _names(data.get("infirmary_beds", []))
	c.garden_saints = _names(data.get("garden_saints", []))
	c.village_intro_done = bool(data.get("village_intro_done", false))
	c.flags = _names(data.get("flags", []))
	c.virtues = Virtues.from_dict(data.get("virtues", {}))
	var raw: Dictionary = data.get("saints", {})
	for id: Variant in raw:
		c.saints[StringName(str(id))] = CampaignSaint.from_dict(raw[id])
	c.rng_counter = int(data.get("rng_counter", 0))
	c.map_lantern_band = int(data.get("map_lantern_band", -1))
	return c


static func _strings(list: Array[StringName]) -> Array[String]:
	var out: Array[String] = []
	for s: StringName in list:
		out.append(String(s))
	return out


static func _names(list: Variant) -> Array[StringName]:
	var out: Array[StringName] = []
	if list is Array:
		for s: Variant in list:
			out.append(StringName(str(s)))
	return out
