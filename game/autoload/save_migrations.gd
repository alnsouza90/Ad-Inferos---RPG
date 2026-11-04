class_name SaveMigrations
extends RefCounted
## Save format versions and migrations (save-load §7). Each step is a
## Callable(data: Dictionary) -> Dictionary that turns version n into n + 1,
## kept in STEPS with its own test. Version 1 is the first; there is no step
## yet. Tests pass their own steps to check the mechanism (S05).

const CURRENT_VERSION: int = 1

## n -> Callable taking a version-n save and returning version n + 1.
var steps: Dictionary = {}
var current_version: int = CURRENT_VERSION


func _init(p_steps: Dictionary = {}, p_current: int = CURRENT_VERSION) -> void:
	steps = p_steps
	current_version = p_current


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
