class_name BalanceExporter
extends RefCounted
## Reads docs/balance/*.csv, runs BalanceImporter and writes (or checks) the
## generated Resources under res://data/. Files whose content did not change
## are left untouched, so regenerating does not create noise in git.

const DATA_ROOT: String = "res://data"
const CONSTANTS_PATH: String = "res://data/constants.tres"
const UI_TEXT_PATH: String = "res://data/ui_text.tres"
const ECONOMY_PATH: String = "res://data/economy.tres"
## Generated folders and the importer dictionary that fills each one.
const FOLDERS: Dictionary = {
	"saints": "saints",
	"abilities": "abilities",
	"conditions": "conditions",
	"enemies": "enemies",
	"encounters": "encounters",
	"provisions": "provisions",
	"map_templates": "map_templates",
}

var errors: Array[String] = []
var written: Array[String] = []
var removed: Array[String] = []
var unchanged: int = 0


static func default_source_dir() -> String:
	return ProjectSettings.globalize_path("res://").path_join("../docs/balance").simplify_path()


static func read_tables(source_dir: String) -> Dictionary:
	var texts: Dictionary = {}
	for table_name: String in BalanceImporter.TABLE_COLUMNS:
		var path: String = source_dir.path_join(table_name + ".csv")
		if FileAccess.file_exists(path):
			texts[table_name] = FileAccess.get_file_as_string(path)
	return texts


## Imports from `source_dir`. With `check_only`, nothing is written and every
## out-of-date or missing generated file becomes an error.
func run(source_dir: String, check_only: bool) -> bool:
	errors.clear()
	written.clear()
	removed.clear()
	unchanged = 0
	var importer := BalanceImporter.new()
	if not importer.import_tables(read_tables(source_dir)):
		errors.append_array(importer.errors)
		return false
	var wanted: Dictionary = {CONSTANTS_PATH: importer.constants, ECONOMY_PATH: importer.economy, UI_TEXT_PATH: importer.ui_text}
	for folder: String in FOLDERS:
		var defs: Dictionary = importer.get(FOLDERS[folder])
		for id: String in defs:
			wanted[DATA_ROOT.path_join(folder).path_join(id + ".tres")] = defs[id]
	for path: String in wanted:
		_sync(path, wanted[path], check_only)
	for folder: String in FOLDERS:
		for path: String in _existing_tres(DATA_ROOT.path_join(folder)):
			if not wanted.has(path):
				if check_only:
					errors.append("%s [stale_file]: não corresponde a nenhuma linha dos CSVs" % path)
				else:
					DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
					removed.append(path)
	return errors.is_empty()


func _sync(path: String, def: Resource, check_only: bool) -> void:
	if ResourceLoader.exists(path):
		var current: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if current != null and ResourceSnapshot.same(current, def):
			unchanged += 1
			return
	if check_only:
		errors.append("%s [out_of_date]: diferente dos CSVs; rode o importador" % path)
		return
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
	var result: Error = ResourceSaver.save(def, path)
	if result != OK:
		errors.append("%s [write_failed]: erro %d ao gravar" % [path, result])
	else:
		written.append(path)


func _existing_tres(dir_path: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return result
	for file: String in dir.get_files():
		if file.ends_with(".tres"):
			result.append(dir_path.path_join(file))
	return result
