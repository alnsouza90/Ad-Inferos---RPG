class_name SaintStatus
extends RefCounted
## What a saint carries from one battle to the next (save-load §3, `saints`):
## hit points, desolation, spiritual state and injury. Conditions and Fervor
## never carry over (combat §11).

const INJURY_NONE: StringName = &""
const INJURY_MINOR: StringName = &"minor"
const INJURY_MAJOR: StringName = &"major"

var id: StringName = &""
var max_hp: int = 0
var hp: int = 0
var desolation: int = 0
var spirit_state: StringName = &"normal"
var purified: bool = false
## Recorded only in the M1; its effect comes with the village (M2).
var injury: StringName = INJURY_NONE


static func from_def(def: SaintDef) -> SaintStatus:
	var s := SaintStatus.new()
	s.id = def.id
	s.max_hp = def.max_hp
	s.hp = def.max_hp
	return s


## A major injury is never downgraded by a later minor one.
func add_injury(kind: StringName) -> void:
	if kind == INJURY_MAJOR or injury == INJURY_NONE:
		injury = kind


## Puts the carried values on a fresh battle combatant.
func apply_to(c: Combatant) -> void:
	c.max_hp = max_hp
	c.hp = clampi(hp, 0, max_hp)
	c.desolation = desolation
	c.spirit_state = spirit_state
	c.purified = purified


func to_dict() -> Dictionary:
	return {
		"id": String(id), "max_hp": max_hp, "hp": hp, "desolation": desolation,
		"spirit_state": String(spirit_state), "purified": purified, "injury": String(injury),
	}


static func from_dict(data: Dictionary) -> SaintStatus:
	var s := SaintStatus.new()
	s.id = StringName(str(data.get("id", "")))
	s.max_hp = int(data.get("max_hp", 0))
	s.hp = int(data.get("hp", 0))
	s.desolation = int(data.get("desolation", 0))
	s.spirit_state = StringName(str(data.get("spirit_state", "normal")))
	s.purified = bool(data.get("purified", false))
	s.injury = StringName(str(data.get("injury", "")))
	return s
