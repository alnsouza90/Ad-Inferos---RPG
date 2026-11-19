class_name ExpeditionSave
extends RefCounted
## Turns an expedition in progress into the save Dictionary and back
## (save-load §3, ADR-0005). The expedition is kept as its starting
## snapshot plus the command log, battle commands included, so loading
## replays it and lands exactly where it was, even in the middle of the
## party turn (S02). The current snapshot is stored as a check: a save whose
## replay does not reach it is treated as corrupt (D-320).

const GAME_VERSION_SETTING: String = "application/config/version"


static func build(ctrl: ExpeditionController, campaign_seed: int, scene_kind: StringName = &"expedition", corridor_place: Dictionary = {}, campaign: CampaignState = null) -> Dictionary:
	var snap: Dictionary = ctrl.snapshot()
	# Version 6 (T46, save-load §3.3): the whole campaign when there is one.
	var campaign_section: Dictionary = {"seed": campaign_seed, "virtues": snap["virtues"], "flags": snap["flags"]}
	if campaign != null:
		campaign_section = campaign.to_dict()
	return {
		"save_version": SaveMigrations.CURRENT_VERSION,
		"game_version": str(ProjectSettings.get_setting(GAME_VERSION_SETTING, "0.0.0")),
		"saved_at_unix": int(Time.get_unix_time_from_system()),
		"campaign": campaign_section,
		"saints": snap["saints"],
		"expedition": {
			"initial": ctrl.initial_snapshot(),
			"commands": ctrl.command_log.duplicate(true),
			"check": _plain(snap),
		},
		"battle": {"in_progress": ctrl.phase == ExpeditionController.Phase.IN_BATTLE},
		"scene": {"kind": String(scene_kind), "id": String(ctrl.state.current_node)},
		# Presentation (save-load §3.1): outside the log and the check.
		"presentation": {"corridor_node": str(corridor_place.get("node", "")), "corridor_x": float(corridor_place.get("x", 0.0))},
	}


## The village between expeditions (T49, save-load §3): the campaign alone,
## no expedition, the scene "village".
static func build_village(campaign: CampaignState) -> Dictionary:
	return {
		"save_version": SaveMigrations.CURRENT_VERSION,
		"game_version": str(ProjectSettings.get_setting(GAME_VERSION_SETTING, "0.0.0")),
		"saved_at_unix": int(Time.get_unix_time_from_system()),
		"campaign": campaign.to_dict(),
		"saints": {},
		"expedition": null,
		"battle": null,
		"scene": {"kind": "village", "id": ""},
	}


## A village save: no expedition and a whole campaign.
static func is_village(data: Dictionary) -> bool:
	var section: Variant = data.get("campaign")
	return data.get("expedition") == null and section is Dictionary and (section as Dictionary).has("week")


## The corridor place kept in a save, or {} when missing or invalid (then
## the party appears at the start or before pending content, §3.1).
static func corridor_place(data: Dictionary) -> Dictionary:
	var p: Variant = data.get("presentation")
	if not p is Dictionary:
		return {}
	var x: Variant = (p as Dictionary).get("corridor_x")
	if not (x is float or x is int) or float(x) < 0.0 or float(x) > 1.0:
		return {}
	return {"node": str((p as Dictionary).get("corridor_node", "")), "x": float(x)}


## The campaign of a save: read as it is from version 6 on; born from the
## expedition for an older one (save-load §3.3, Campaign.adopt).
static func campaign_of(catalog: ExpeditionCatalog, data: Dictionary) -> CampaignState:
	var section: Variant = data.get("campaign")
	var c: Dictionary = section if section is Dictionary else {}
	if c.has("week"):
		return CampaignState.from_dict(c)
	var saints: Variant = data.get("saints")
	var flags: Variant = c.get("flags")
	var virtues: Variant = c.get("virtues")
	return Campaign.adopt(catalog, int(c.get("seed", 0)), virtues if virtues is Dictionary else {}, flags if flags is Array else [], saints if saints is Dictionary else {})


## Rebuilds the controller, or null if the save does not replay exactly.
static func restore(catalog: ExpeditionCatalog, data: Dictionary) -> ExpeditionController:
	var section: Variant = data.get("expedition")
	if not section is Dictionary:
		return null
	var e: Dictionary = section
	if not e.get("initial") is Dictionary or not e.get("commands") is Array:
		return null
	if bool(e.get("rebuild", false)):
		# A save from before a change of rules (save-load §7): replayed under
		# the new rules as far as they accept it; its old check cannot match.
		return ExpeditionController.replay_accepted(catalog, e["initial"], e["commands"])
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
