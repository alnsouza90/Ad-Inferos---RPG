class_name SaveMigrations
extends RefCounted
## Save format versions and migrations (save-load §7). Each step is a
## Callable(data: Dictionary) -> Dictionary that turns version n into n + 1,
## kept in default_steps() with its own test. Tests pass their own steps to
## check the mechanism (S05).
##   1 → 2 (T37, D-365): entering a node with corridor content no longer
##   starts it; EngageNode does. Old logs get an EngageNode after each such
##   ChoosePath, so they replay to the same place.
##   2 → 3 (T62, D-396): the rules chosen after T61 change what old commands
##   give (battle-end desolation by rounds, Fidelity, the prepared Faith
##   test), so an old log cannot reach its check. The save is marked
##   `rebuild`: loading replays it under the new rules, without the check,
##   and stops at the first command the new rules refuse (save-load §7).

##   3 → 4 (T42): the expedition goes on after the first camp (legs 2 and 3,
##   Vigil, boss) and saves the leg, the Domínio and the liver; old logs are
##   rebuilt the same way as in 2 → 3.

##   4 → 5 (T42, D-435): reaching a camp consecrates it in the flags
##   (`<circle>_camp_<leg>`), kept across expeditions and after a defeat;
##   old logs are rebuilt the same way.

##   5 → 6 (T46, save-load §3.3): the save keeps the whole campaign. The
##   expedition replays as before (nothing in it changes); the campaign is
##   born from the old save when it loads (ExpeditionSave.campaign_of),
##   because that needs the catalog, which a migration step does not have.

const CURRENT_VERSION: int = 6
const CONTENT_TYPES: Array[String] = ["node_battle", "node_elite", "node_temptation", "node_relic", "node_soul"]

## n -> Callable taking a version-n save and returning version n + 1.
var steps: Dictionary = {}
var current_version: int = CURRENT_VERSION


func _init(p_steps: Variant = null, p_current: int = CURRENT_VERSION) -> void:
	steps = p_steps if p_steps is Dictionary else default_steps()
	current_version = p_current


static func default_steps() -> Dictionary:
	return {1: SaveMigrations.migrate_v1_to_v2, 2: SaveMigrations.migrate_v2_to_v3, 3: SaveMigrations.migrate_v2_to_v3, 4: SaveMigrations.migrate_v2_to_v3, 5: SaveMigrations.migrate_v5_to_v6}


static func migrate_v5_to_v6(data: Dictionary) -> Dictionary:
	return data.duplicate(true)


static func migrate_v2_to_v3(data: Dictionary) -> Dictionary:
	var result: Dictionary = data.duplicate(true)
	var section: Variant = result.get("expedition")
	if section is Dictionary:
		(section as Dictionary)["rebuild"] = true
	return result


static func migrate_v1_to_v2(data: Dictionary) -> Dictionary:
	var result: Dictionary = data.duplicate(true)
	var section: Variant = result.get("expedition")
	if not section is Dictionary or not (section as Dictionary).get("commands") is Array:
		return result
	var types: Dictionary = _node_types(section as Dictionary)
	var commands: Array = []
	for entry: Variant in (section as Dictionary)["commands"]:
		commands.append(entry)
		if entry is Dictionary and str((entry as Dictionary).get("type", "")) == "ChoosePath":
			if CONTENT_TYPES.has(str(types.get(str((entry as Dictionary).get("node", "")), ""))):
				commands.append({"type": "EngageNode"})
	(section as Dictionary)["commands"] = commands
	return result


## node id → node type, from the map in the starting snapshot (the M1 has a
## single leg, so every entered node is there).
static func _node_types(section: Dictionary) -> Dictionary:
	var types: Dictionary = {}
	var initial: Variant = section.get("initial")
	if not initial is Dictionary:
		return types
	var map: Variant = ((initial as Dictionary).get("expedition", {}) as Dictionary).get("map", {})
	if not map is Dictionary:
		return types
	for layer: Variant in (map as Dictionary).get("layers", []):
		if layer is Array:
			for n: Variant in layer:
				if n is Dictionary:
					types[str((n as Dictionary).get("id", ""))] = str((n as Dictionary).get("type", ""))
	return types


## Applies every step from the save's version up to the current one.
## Returns {} if a step is missing (the save cannot be read).
func migrate(data: Dictionary) -> Dictionary:
	var result: Dictionary = data.duplicate(true)
	var version: int = int(result.get("save_version", 0))
	while version < current_version:
		if not steps.has(version):
			return {}
		result = (steps[version] as Callable).call(result)
		version += 1
		result["save_version"] = version
	return result
