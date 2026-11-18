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
## Relics this saint carries (one slot until level 4, GDD §3).
var relics: Array[StringName] = []
## Faith added by carried relics (stat_add), applied to every battle.
var faith_bonus: int = 0
## Battles ended standing in the current Dark Night (Fidelity, D-271).
var fidelity_marks: int = 0
## Experience earned (expedition §8, T42); levels come with the village.
var xp: int = 0
## Penalties of the injury the saint carried in from the village
## (village-economy §8, T46): fractions taken off max_hp and faith in every
## battle of this expedition. An injury taken during the expedition only
## counts from the next one.
var hp_penalty: float = 0.0
var faith_penalty: float = 0.0
## From the village (T47): the saint's level, the Faith its levels added,
## the abilities improved to their "+" version and the four it takes into
## battle (empty: the default ones).
var level: int = 1
var level_faith: int = 0
var upgrades: Array[StringName] = []
var equipped: Array[StringName] = []


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
	c.max_hp = maxi(1, Damage.round_half_up(max_hp * (1.0 - hp_penalty)))
	c.hp = clampi(hp, 0, c.max_hp)
	c.desolation = desolation
	c.spirit_state = spirit_state
	c.purified = purified
	c.faith = Damage.round_half_up((c.faith + level_faith) * (1.0 - faith_penalty)) + faith_bonus
	c.upgraded = upgrades.duplicate()
	if not equipped.is_empty():
		c.equipped = equipped.duplicate()


func to_dict() -> Dictionary:
	var data: Dictionary = {
		"id": String(id), "max_hp": max_hp, "hp": hp, "desolation": desolation,
		"spirit_state": String(spirit_state), "purified": purified, "injury": String(injury),
		"relics": relics.map(func(r: StringName) -> String: return String(r)), "faith_bonus": faith_bonus,
		"fidelity_marks": fidelity_marks, "xp": xp,
	}
	# Only when present, so the saves of before T46 keep their exact check.
	if hp_penalty > 0.0:
		data["hp_penalty"] = hp_penalty
	if faith_penalty > 0.0:
		data["faith_penalty"] = faith_penalty
	if level > 1:
		data["level"] = level
	if level_faith > 0:
		data["level_faith"] = level_faith
	if not upgrades.is_empty():
		data["upgrades"] = upgrades.map(func(a: StringName) -> String: return String(a))
	if not equipped.is_empty():
		data["equipped"] = equipped.map(func(a: StringName) -> String: return String(a))
	return data


static func from_dict(data: Dictionary) -> SaintStatus:
	var s := SaintStatus.new()
	s.id = StringName(str(data.get("id", "")))
	s.max_hp = int(data.get("max_hp", 0))
	s.hp = int(data.get("hp", 0))
	s.desolation = int(data.get("desolation", 0))
	s.spirit_state = StringName(str(data.get("spirit_state", "normal")))
	s.purified = bool(data.get("purified", false))
	s.injury = StringName(str(data.get("injury", "")))
	for r: Variant in data.get("relics", []):
		s.relics.append(StringName(str(r)))
	s.faith_bonus = int(data.get("faith_bonus", 0))
	s.fidelity_marks = int(data.get("fidelity_marks", 0))
	s.xp = int(data.get("xp", 0))
	s.hp_penalty = float(data.get("hp_penalty", 0.0))
	s.faith_penalty = float(data.get("faith_penalty", 0.0))
	s.level = int(data.get("level", 1))
	s.level_faith = int(data.get("level_faith", 0))
	for a: Variant in data.get("upgrades", []):
		s.upgrades.append(StringName(str(a)))
	for a: Variant in data.get("equipped", []):
		s.equipped.append(StringName(str(a)))
	return s


func duplicate_status() -> SaintStatus:
	return SaintStatus.from_dict(to_dict())
