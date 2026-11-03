class_name SimReport
extends RefCounted
## Turns simulator results into the testing.md §5.2 metrics, a CSV and a
## readable summary. The targets are copied from testing.md §5.2.

## [metric key, description, min, max]; null = no bound.
const TARGETS: Array = [
	["rounds_easy", "Rodadas por combate fácil (heurística)", 3.0, 4.0],
	["rounds_hard", "Rodadas por combate difícil (heurística)", 5.0, 7.0],
	["win_easy", "Vitória da heurística em combate fácil", 0.95, null],
	["win_hard", "Vitória da heurística em combate difícil", 0.75, 0.90],
	["random_win_hard", "Vitória da política random em combate difícil", null, 0.40],
	["hp_left_easy", "Vida restante média após combate fácil (heurística)", 0.70, 0.85],
	["no_useful_turns", "Turnos de santo sem nenhuma ação útil (todas as políticas)", null, 0.05],
	["top_ability_share", "Maior participação de uma habilidade nas ações da heurística", null, 0.40],
	["dark_night_saints", "Santos em Noite Escura numa expedição longa simulada", 0.5, 1.5],
]

var metrics: Dictionary = {}
var ability_shares: Dictionary = {}
var per_encounter: Array[Dictionary] = []


static func build(sim: BattleSimulator) -> SimReport:
	var r := SimReport.new()
	var heuristic: Array = sim.battles.filter(func(b: Dictionary) -> bool: return b["policy"] == SimPolicy.HEURISTIC)
	var easy: Array = heuristic.filter(func(b: Dictionary) -> bool: return b["pool"] == &"easy")
	var hard: Array = heuristic.filter(func(b: Dictionary) -> bool: return b["pool"] == &"hard")
	var random_hard: Array = sim.battles.filter(func(b: Dictionary) -> bool: return b["policy"] == SimPolicy.RANDOM and b["pool"] == &"hard")
	r.metrics["rounds_easy"] = _mean(easy.filter(func(b: Dictionary) -> bool: return b["won"]), "rounds")
	r.metrics["rounds_hard"] = _mean(hard.filter(func(b: Dictionary) -> bool: return b["won"]), "rounds")
	r.metrics["win_easy"] = _rate(easy)
	r.metrics["win_hard"] = _rate(hard)
	r.metrics["random_win_hard"] = _rate(random_hard)
	r.metrics["hp_left_easy"] = _mean(easy.filter(func(b: Dictionary) -> bool: return b["won"]), "hp_left")
	var turns := 0
	var empty := 0
	for b: Dictionary in sim.battles:
		turns += int(b["saint_turns"])
		empty += int(b["no_useful"])
	r.metrics["no_useful_turns"] = float(empty) / float(maxi(turns, 1))
	var total := 0
	for b: Dictionary in heuristic:
		for ability_id: Variant in b["usage"]:
			r.ability_shares[ability_id] = int(r.ability_shares.get(ability_id, 0)) + int(b["usage"][ability_id])
			total += int(b["usage"][ability_id])
	# Shares are over every heuristic action (miracles included); the target
	# concerns equipped abilities, so miracles are not candidates for "top".
	var top := 0.0
	for ability_id: Variant in r.ability_shares:
		r.ability_shares[ability_id] = float(r.ability_shares[ability_id]) / float(maxi(total, 1))
		var def: AbilityDef = sim.data.catalog.ability(StringName(str(ability_id)))
		if def == null or def.kind != &"miracle":
			top = maxf(top, r.ability_shares[ability_id])
	r.metrics["top_ability_share"] = top
	r.metrics["dark_night_saints"] = _mean(sim.expeditions, "dark_night_saints") if not sim.expeditions.is_empty() else NAN
	var keys: Dictionary = {}
	for b: Dictionary in sim.battles:
		keys["%s|%s" % [b["policy"], b["encounter"]]] = true
	for key: String in keys:
		var parts: PackedStringArray = key.split("|")
		var rows: Array = sim.battles.filter(func(b: Dictionary) -> bool: return String(b["policy"]) == parts[0] and b["encounter"] == parts[1])
		var won: Array = rows.filter(func(b: Dictionary) -> bool: return b["won"])
		r.per_encounter.append({"policy": parts[0], "encounter": parts[1], "runs": rows.size(), "win_rate": _rate(rows), "rounds_won": _mean(won, "rounds"), "hp_left_won": _mean(won, "hp_left"), "errors": rows.reduce(func(acc: int, b: Dictionary) -> int: return acc + int(b["errors"]), 0)})
	r.per_encounter.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["policy"] + a["encounter"] < b["policy"] + b["encounter"])
	return r


## Metrics outside their target, as readable lines.
func out_of_target() -> Array[String]:
	var lines: Array[String] = []
	for t: Array in TARGETS:
		var value: float = metrics.get(t[0], NAN)
		if is_nan(value):
			continue
		if (t[2] != null and value < t[2]) or (t[3] != null and value > t[3]):
			lines.append("%s: %s (meta %s)" % [t[1], _fmt(t[0], value), _range(t)])
	return lines


func summary() -> String:
	var lines: Array[String] = ["=== Simulador · metas do M0 (testing.md §5.2) ==="]
	for t: Array in TARGETS:
		var value: float = metrics.get(t[0], NAN)
		var mark: String = "—" if is_nan(value) else ("✘" if ((t[2] != null and value < t[2]) or (t[3] != null and value > t[3])) else "✔")
		lines.append("%s %s: %s (meta %s)" % [mark, t[1], "n/d" if is_nan(value) else _fmt(t[0], value), _range(t)])
	lines.append("")
	lines.append("--- Por encontro ---")
	for row: Dictionary in per_encounter:
		lines.append("%-9s %-11s vitória %5.1f%%  rodadas %.2f  vida %5.1f%%  erros %d" % [row["policy"], row["encounter"], 100.0 * row["win_rate"], row["rounds_won"], 100.0 * row["hp_left_won"], row["errors"]])
	lines.append("")
	lines.append("--- Habilidades mais usadas pela heurística ---")
	var ids: Array = ability_shares.keys()
	ids.sort_custom(func(a: Variant, b: Variant) -> bool: return ability_shares[a] > ability_shares[b])
	for ability_id: Variant in ids:
		lines.append("%-28s %5.1f%%" % [ability_id, 100.0 * ability_shares[ability_id]])
	lines.append("(milagres entram no total de ações, mas não na meta de habilidade dominante)")
	var off: Array[String] = out_of_target()
	lines.append("")
	lines.append("Fora da meta: %d" % off.size())
	for line: String in off:
		lines.append("  ✘ " + line)
	return "\n".join(lines)


## Long-format CSV: section,policy,encounter,key,value.
func to_csv() -> String:
	var lines: Array[String] = ["section,policy,encounter,key,value"]
	for t: Array in TARGETS:
		lines.append("metric,,,%s,%s" % [t[0], str(metrics.get(t[0], ""))])
	for row: Dictionary in per_encounter:
		for key: String in ["runs", "win_rate", "rounds_won", "hp_left_won", "errors"]:
			lines.append("encounter,%s,%s,%s,%s" % [row["policy"], row["encounter"], key, str(row[key])])
	for ability_id: Variant in ability_shares:
		lines.append("ability,heuristic,,%s,%s" % [ability_id, str(ability_shares[ability_id])])
	return "\n".join(lines) + "\n"


static func _mean(rows: Array, key: String) -> float:
	if rows.is_empty():
		return NAN
	var total := 0.0
	for row: Dictionary in rows:
		total += float(row[key])
	return total / rows.size()


static func _rate(rows: Array) -> float:
	if rows.is_empty():
		return NAN
	return float(rows.filter(func(b: Dictionary) -> bool: return b["won"]).size()) / rows.size()


static func _fmt(key: String, value: float) -> String:
	if key.begins_with("rounds") or key == "dark_night_saints":
		return "%.2f" % value
	return "%.1f%%" % (100.0 * value)


static func _range(t: Array) -> String:
	var pct: bool = not (String(t[0]).begins_with("rounds") or t[0] == "dark_night_saints")
	var f := func(v: Variant) -> String: return ("%.0f%%" % (100.0 * float(v))) if pct else ("%.1f" % float(v))
	if t[2] != null and t[3] != null:
		return "%s a %s" % [f.call(t[2]), f.call(t[3])]
	if t[2] != null:
		return "≥ %s" % f.call(t[2])
	return "≤ %s" % f.call(t[3])
