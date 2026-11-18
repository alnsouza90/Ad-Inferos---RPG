class_name LiturgicalCalendar
extends RefCounted
## The liturgical season of a campaign week (village-economy §6): the
## 20-week year starts in Advent. In the M2 only the village's day and night
## follow it (D-492, Bíblia de Arte §10A); the season rules come in the M3.

const SEASONS: Array[StringName] = [&"advent", &"christmas", &"ordinary_1", &"lent", &"easter", &"ordinary_2"]
## Night in Advent and Lent, day in the other seasons (decision of Alan,
## 12/11/2026, Bíblia de Arte §10A).
const NIGHT_SEASONS: Array[StringName] = [&"advent", &"lent"]


static func season(week: int, economy: ConstantsDef) -> StringName:
	var starts: Array[float] = economy.get_list(&"season_start_weeks")
	var result: StringName = SEASONS[0]
	for i: int in mini(starts.size(), SEASONS.size()):
		if week >= int(starts[i]):
			result = SEASONS[i]
	return result


static func is_night(week: int, economy: ConstantsDef) -> bool:
	return NIGHT_SEASONS.has(season(week, economy))
