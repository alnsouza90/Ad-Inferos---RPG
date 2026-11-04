extends Node
## Autoload: the expedition in memory and when it is saved (save-load §4).
## Screens send every command through execute(), which saves after each
## accepted one; the app saves again when Android pauses or closes it.

var catalog: ExpeditionCatalog
var expedition: ExpeditionController
var campaign_seed: int = 0


func start_expedition(p_catalog: ExpeditionCatalog, ctrl: ExpeditionController, p_seed: int) -> void:
	catalog = p_catalog
	expedition = ctrl
	campaign_seed = p_seed
	save_now()


## Loads the saved expedition; returns the SaveStore status.
func continue_saved(p_catalog: ExpeditionCatalog) -> StringName:
	catalog = p_catalog
	var result: Dictionary = SaveService.load_expedition(p_catalog)
	expedition = result["controller"]
	if expedition != null:
		campaign_seed = int((result["data"] as Dictionary).get("campaign", {}).get("seed", 0))
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
		SaveService.save_expedition(expedition, campaign_seed)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_now()
