extends Node
## Autoload: the expedition in memory and when it is saved (save-load §4).
## Screens send every command through execute(), which saves after each
## accepted one; the app saves again when Android pauses or closes it.

var catalog: ExpeditionCatalog
var expedition: ExpeditionController
var campaign_seed: int = 0
## Where the party stands in the corridor: {"node": id, "x": 0..1}
## (save-load §3.1). Presentation only: outside the command log.
var corridor_place: Dictionary = {}


func start_expedition(p_catalog: ExpeditionCatalog, ctrl: ExpeditionController, p_seed: int) -> void:
	catalog = p_catalog
	expedition = ctrl
	campaign_seed = p_seed
	corridor_place = {}
	save_now()


## Loads the saved expedition; returns the SaveStore status.
func continue_saved(p_catalog: ExpeditionCatalog) -> StringName:
	catalog = p_catalog
	var result: Dictionary = _service().call("load_expedition", p_catalog)
	expedition = result["controller"]
	if expedition != null:
		var data: Dictionary = result["data"]
		campaign_seed = int(data.get("campaign", {}).get("seed", 0))
		corridor_place = ExpeditionSave.corridor_place(data)
	return result["status"]


## Runs a command and saves when it is accepted (after each battle command,
## node, event and camp step: §4).
func execute(cmd: ExpeditionCommand) -> StringName:
	if expedition == null:
		return ExpeditionController.REJECT_WRONG_PHASE
	var reason: StringName = expedition.execute(cmd)
	if reason == &"":
		save_now()
	return reason


func save_now() -> void:
	if expedition != null:
		_service().call("save_expedition", expedition, campaign_seed, corridor_place)


## The party stopped walking: keep the place and save it (§3.1, §4).
func keep_corridor_place(place: Dictionary) -> void:
	corridor_place = place.duplicate()
	save_now()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_now()


## The SaveService autoload, found by path (see save_service.gd).
func _service() -> Node:
	return get_node("/root/SaveService")
