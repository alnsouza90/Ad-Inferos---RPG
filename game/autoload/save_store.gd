class_name SaveStore
extends RefCounted
## Atomic save files with a backup and corruption handling (save-load §2,
## §5 and §6). Knows nothing of the game: it stores and checks a Dictionary.
## SaveService (autoload) uses it on user://saves; tests use a scratch folder.

const STATUS_OK: StringName = &"ok"
const STATUS_FROM_BACKUP: StringName = &"from_backup"
const STATUS_NONE: StringName = &"none"
const STATUS_CORRUPT: StringName = &"corrupt"
const STATUS_FUTURE: StringName = &"future_version"

## Fields every save must have (§6 step 1).
const REQUIRED: Array[String] = ["save_version", "game_version", "saved_at_unix", "campaign", "expedition", "scene"]

var dir: String
var slot: String = "slot_1"
var migrations: SaveMigrations
## Extra check run after parsing and migrating (e.g. the expedition replays
## exactly); returns true when the data is usable.
var validator: Callable = func(_data: Dictionary) -> bool: return true


func _init(p_dir: String = "user://saves", p_migrations: SaveMigrations = null) -> void:
	dir = p_dir
	migrations = p_migrations if p_migrations != null else SaveMigrations.new()


func path(ext: String) -> String:
	return dir.path_join("%s.%s" % [slot, ext])


func exists() -> bool:
	return FileAccess.file_exists(path("json")) or FileAccess.file_exists(path("bak"))


## §5: write .tmp, move .json to .bak, move .tmp to .json.
func write(data: Dictionary) -> bool:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var tmp := FileAccess.open(path("tmp"), FileAccess.WRITE)
	if tmp == null:
		return false
	tmp.store_string(JSON.stringify(data, "\t"))
	tmp.close()
	var d := DirAccess.open(dir)
	if d == null:
		return false
	if FileAccess.file_exists(path("json")):
		if FileAccess.file_exists(path("bak")):
			d.remove(path("bak").get_file())
		d.rename(path("json").get_file(), path("bak").get_file())
	return d.rename(path("tmp").get_file(), path("json").get_file()) == OK


## §6: the main file, else the backup; both bad → preserved as .corrupt and
## STATUS_CORRUPT; a newer version → STATUS_FUTURE (refused, files kept).
## Returns {"status": StringName, "data": Dictionary}.
func read() -> Dictionary:
	if not exists():
		return {"status": STATUS_NONE, "data": {}}
	var main: Dictionary = _load(path("json"))
	if main.get("status") == STATUS_OK or main.get("status") == STATUS_FUTURE:
		return main
	var backup: Dictionary = _load(path("bak"))
	if backup.get("status") == STATUS_OK:
		return {"status": STATUS_FROM_BACKUP, "data": backup["data"]}
	if backup.get("status") == STATUS_FUTURE:
		return backup
	_preserve_corrupt()
	return {"status": STATUS_CORRUPT, "data": {}}


func _load(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		return {"status": STATUS_CORRUPT}
	# JSON.new().parse() reports bad text through its return value, without
	# printing an engine error (a damaged save is an expected case, §6).
	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(file_path)) != OK or not json.data is Dictionary:
		return {"status": STATUS_CORRUPT}
	var data: Dictionary = json.data
	for key: String in REQUIRED:
		if not data.has(key):
			return {"status": STATUS_CORRUPT}
	if int(data["save_version"]) > migrations.current_version:
		return {"status": STATUS_FUTURE, "data": data}
	var migrated: Dictionary = migrations.migrate(data)
	if migrated.is_empty() or not validator.call(migrated):
		return {"status": STATUS_CORRUPT}
	return {"status": STATUS_OK, "data": migrated}


## Bad files are kept as slot_1.corrupt.<time>.json (and .bak) for later study.
func _preserve_corrupt() -> void:
	var d := DirAccess.open(dir)
	if d == null:
		return
	var stamp: String = str(int(Time.get_unix_time_from_system()))
	for ext: String in ["json", "bak"]:
		if FileAccess.file_exists(path(ext)):
			d.rename(path(ext).get_file(), "%s.corrupt.%s.%s" % [slot, stamp, ext])


func delete_all() -> void:
	var d := DirAccess.open(dir)
	if d == null:
		return
	for file: String in d.get_files():
		d.remove(file)
