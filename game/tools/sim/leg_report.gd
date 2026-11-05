class_name LegReport
extends RefCounted
## The M1 leg metrics of testing.md §5.3 from LegSimulator results: battles
## inside legs (the hard ones are the camp ambushes), Dark Night per leg,
## how legs end, and a CSV with one line per leg.

## [metric key, description, min, max]; null = no bound (testing.md §5.3).
const TARGETS: Array = [
	["win_hard", "Vitória da heurística em combate difícil (dentro de trechos)", 0.75, 0.90],
	["dark_night_per_leg", "Santos em Noite Escura por trecho (heurística)", null, null],
	["win_easy", "Vitória da heurística em combate fácil (dentro de trechos)", 0.95, null],
]

var metrics: Dictionary = {}
var counts: Dictionary = {}
var legs: Array[Dictionary] = []


static func build(sim: LegSimulator) -> LegReport:
	var r := LegReport.new()
	r.legs = sim.legs
	var heuristic_legs: Array = sim.legs.filter(func(l: Dictionary) -> bool: return l["policy"] == SimPolicy.HEURISTIC)
	var hb: Array = sim.battles.filter(func(b: Dictionary) -> bool: return b["policy"] == SimPolicy.HEURISTIC)
	var easy: Array = hb.filter(func(b: Dictionary) -> bool: return b["pool"] == &"easy")
	var hard: Array = hb.filter(func(b: Dictionary) -> bool: return b["pool"] == &"hard")
	r.counts["legs"] = heuristic_legs.size()
	r.counts["easy_battles"] = easy.size()
	r.counts["hard_battles"] = hard.size()
	r.metrics["win_hard"] = _rate(hard, "won")
	r.metrics["win_easy"] = _rate(easy, "won")
	r.metrics["rounds_easy"] = _mean(easy.filter(func(b: Dictionary) -> bool: return b["won"]), "rounds")
	r.metrics["rounds_hard"] = _mean(hard.filter(func(b: Dictionary) -> bool: return b["won"]), "rounds")
	r.metrics["hp_left_easy"] = _mean(easy.filter(func(b: Dictionary) -> bool: return b["won"]), "hp_left")
	r.metrics["dark_night_per_leg"] = _mean(heuristic_legs, "dark_night_saints")
	r.metrics["legs_with_dark_night"] = _rate(heuristic_legs.map(func(l: Dictionary) -> Dictionary: return {"x": int(l["dark_night_saints"]) > 0}), "x")
	r.metrics["leg_complete"] = _rate(heuristic_legs.map(func(l: Dictionary) -> Dictionary: return {"x": l["end"] == ExpeditionController.END_LEG_COMPLETE}), "x")
	r.metrics["defeated"] = _rate(heuristic_legs.map(func(l: Dictionary) -> Dictionary: return {"x": l["end"] == ExpeditionController.END_DEFEATED}), "x")
	r.metrics["ambush_rate"] = _rate(heuristic_legs, "ambush")
	r.metrics["relic_rate"] = _rate(heuristic_legs, "relic")
	r.metrics["hp_left_leg"] = _mean(heuristic_legs, "hp_left")
	r.metrics["desolation_end"] = _mean(heuristic_legs, "desolation_end")
	r.metrics["peak_desolation"] = _mean(heuristic_legs, "peak_desolation")
	r.metrics["peak_desolation_max"] = heuristic_legs.reduce(func(acc: float, l: Dictionary) -> float: return maxf(acc, float(l["peak_desolation"])), 0.0)
	r.metrics["alms"] = _mean(heuristic_legs, "alms")
	r.metrics["battles_per_leg"] = _mean(heuristic_legs, "battles")
	r.metrics["rounds_per_leg"] = _mean(heuristic_legs, "rounds")
	r.metrics["commands_per_leg"] = _mean(heuristic_legs, "commands")
	var random_legs: Array = sim.legs.filter(func(l: Dictionary) -> bool: return l["policy"] == SimPolicy.RANDOM)
	if not random_legs.is_empty():
		r.metrics["random_leg_complete"] = _rate(random_legs.map(func(l: Dictionary) -> Dictionary: return {"x": l["end"] == ExpeditionController.END_LEG_COMPLETE}), "x")
		var rb: Array = sim.battles.filter(func(b: Dictionary) -> bool: return b["policy"] == SimPolicy.RANDOM and b["pool"] == &"hard")
		r.metrics["random_win_hard"] = _rate(rb, "won")
	var options: Dictionary = {}
	for l: Dictionary in heuristic_legs:
		var key: String = "%s/%s" % [l["event_option"], "ok" if l["event_success"] else "falha"]
		options[key] = int(options.get(key, 0)) + 1
	r.counts["event_options"] = options
	return r


func summary() -> String:
	var lines: Array[String] = ["== Simulador do trecho (M1) ==", "Trechos (heurística): %d · combates fáceis: %d · difíceis (emboscadas): %d" % [counts["legs"], counts["easy_battles"], counts["hard_battles"]]]
	for t: Array in TARGETS:
		var v: float = metrics.get(t[0], NAN)
		var mark: String = "  "
		if t[2] != null or t[3] != null:
			mark = "OK" if (t[2] == null or v >= float(t[2])) and (t[3] == null or v <= float(t[3])) else "XX"
		lines.append("%s %s: %.3f" % [mark, t[1], v])
	for key: String in ["rounds_easy", "rounds_hard", "hp_left_easy", "legs_with_dark_night", "leg_complete", "defeated", "ambush_rate", "relic_rate", "hp_left_leg", "desolation_end", "peak_desolation", "peak_desolation_max", "alms", "battles_per_leg", "rounds_per_leg", "commands_per_leg", "random_leg_complete", "random_win_hard"]:
		if metrics.has(key):
			lines.append("   %s: %.3f" % [key, metrics[key]])
	lines.append("   opções da Tentação: %s" % [counts["event_options"]])
	return "\n".join(lines)


func to_csv() -> String:
	var cols: Array[String] = ["policy", "seed", "end", "battles", "rounds", "ambush", "relic", "event_option", "event_success", "dark_night_saints", "hp_left", "desolation_end", "light_end", "alms", "virtues", "commands", "peak_desolation"]
	var out: Array[String] = [",".join(cols)]
	for l: Dictionary in legs:
		var row: Array[String] = []
		for c: String in cols:
			row.append(str(l.get(c, "")))
		out.append(",".join(row))
	return "\n".join(out) + "\n"


static func _mean(rows: Array, key: String) -> float:
	if rows.is_empty():
		return NAN
	var total := 0.0
	for r: Dictionary in rows:
		total += float(r[key])
	return total / rows.size()


static func _rate(rows: Array, key: String) -> float:
	if rows.is_empty():
		return NAN
	return float(rows.filter(func(r: Dictionary) -> bool: return bool(r[key])).size()) / rows.size()
