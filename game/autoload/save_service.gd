extends Node
## Autoload: the player's save slot and preferences on disk (save-load).
## The logic lives in SaveStore, SaveMigrations and ExpeditionSave, which
## the tests use directly.

var store: SaveStore = SaveStore.new("user://saves")
var settings: SettingsStore = SettingsStore.new("user://settings.json")


func save_expedition(ctrl: ExpeditionController, campaign_seed: int) -> bool:
	var ok: bool = store.write(ExpeditionSave.build(ctrl, campaign_seed))
	EventBus.save_completed.emit(ok)
	return ok


## {"status": SaveStore.STATUS_*, "controller": ExpeditionController or null}.
## A save that does not replay exactly counts as corrupt (falls back to .bak).
func load_expedition(catalog: ExpeditionCatalog) -> Dictionary:
	store.validator = func(data: Dictionary) -> bool: return ExpeditionSave.restore(catalog, data) != null
	var result: Dictionary = store.read()
	var ctrl: ExpeditionController = null
	if result["status"] == SaveStore.STATUS_OK or result["status"] == SaveStore.STATUS_FROM_BACKUP:
		ctrl = ExpeditionSave.restore(catalog, result["data"])
	return {"status": result["status"], "controller": ctrl, "data": result["data"]}
