class_name CampaignSaint
extends RefCounted
## A saint of the company between expeditions (village-economy §8 and §9,
## save-load §3.3): what the expedition carries (`status`), plus the level,
## the abilities taken into battle and the weeks its injury still needs.

var status: SaintStatus
var level: int = 1
var equipped: Array[StringName] = []
var injury_weeks_left: int = 0


static func from_def(def: SaintDef) -> CampaignSaint:
	var s := CampaignSaint.new()
	s.status = SaintStatus.from_def(def)
	s.equipped = def.default_equipped.duplicate()
	return s


var id: StringName:
	get:
		return status.id


func to_dict() -> Dictionary:
	return {
		"status": status.to_dict(), "level": level,
		"equipped": equipped.map(func(a: StringName) -> String: return String(a)),
		"injury_weeks_left": injury_weeks_left,
	}


static func from_dict(data: Dictionary) -> CampaignSaint:
	var s := CampaignSaint.new()
	s.status = SaintStatus.from_dict(data.get("status", {}))
	s.level = int(data.get("level", 1))
	for a: Variant in data.get("equipped", []):
		s.equipped.append(StringName(str(a)))
	s.injury_weeks_left = int(data.get("injury_weeks_left", 0))
	return s
