class_name ExpeditionSave
extends RefCounted
## Turns an expedition in progress into the save Dictionary and back
## (save-load §3, ADR-0005). The expedition is kept as its starting
## snapshot plus the command log, battle commands included, so loading
## replays it and lands exactly where it was, even in the middle of the
## party turn (S02). The current snapshot is stored as a check: a save whose
## replay does not reach it is treated as corrupt (D-320).

const GAME_VERSION_SETTING: String = "application/config/version"


static func build(ctrl: ExpeditionController, campaign_seed: int, scene_kind: StringName = &"expedition") -> Dictionary:
	var snap: Dictionary = ctrl.snapshot()
	return {
		"save_version": SaveMigrations.CURRENT_VERSION,
		"game_version": str(ProjectSettings.get_setting(GAME_VERSION_SETTING, "0.0.0")),
		"saved_at_unix": int(Time.get_unix_time_from_system()),
		"campaign": {"seed": campaign_seed, "virtues": snap["virtues"], "flags": snap["flags"]},
		"saints": snap["saints"],
		"expedition": {
			"initial": ctrl.initial_snapshot(),
			"commands": ctrl.command_log.duplicate(true),
			"check": _plain(snap),
		},
		"battle": {"in_progress": ctrl.phase == ExpeditionController.Phase.IN_BATTLE},
		"scene": {"kind": String(scene_kind), "id": String(ctrl.state.current_node)},
	}


## Rebuilds the controller, or null if the save does not replay exactly.
static func restore(catalog: ExpeditionCatalog, data: Dictionary) -> ExpeditionController:
	var section: Variant = data.get("expedition")
	if not section is Dictionary:
		return null
	var e: Dictionary = section
	if not e.get("initial") is Dictionary or not e.get("commands") is Array:
		return null
	var ctrl := ExpeditionController.try_replay(catalog, e["initial"], e["commands"])
	if ctrl == null:
		return null
	if JSON.stringify(_plain(ctrl.snapshot()), "", true) != JSON.stringify(_plain(e.get("check", {})), "", true):
		return null
	return ctrl


## The snapshot as it reads back from JSON (all numbers as floats), so the
## saved check and a fresh snapshot compare equal.
static func _plain(value: Variant) -> Variant:
	return JSON.parse_string(JSON.stringify(value))
