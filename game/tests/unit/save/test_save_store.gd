extends GutTest
## T26: atomic save files, backup, corruption and versions (save-load §5 to
## §8: S03, S04, S05, S06). Uses a scratch folder, never the player's save.

const DIR: String = "user://test_save_store"

var store: SaveStore


func before_each() -> void:
	store = SaveStore.new(DIR)
	store.delete_all()


func after_all() -> void:
	SaveStore.new(DIR).delete_all()


static func _save(marker: int, version: int = 1) -> Dictionary:
	return {"save_version": version, "game_version": "0.0.1", "saved_at_unix": 0, "campaign": {"marker": marker}, "expedition": {}, "scene": {"kind": "expedition"}}


func _files() -> PackedStringArray:
	var d := DirAccess.open(DIR)
	return d.get_files() if d != null else PackedStringArray()


func test_write_then_read_gives_the_same_data_and_keeps_a_backup() -> void:
	assert_true(store.write(_save(1)))
	assert_true(store.write(_save(2)))
	var result: Dictionary = store.read()
	assert_eq(result["status"], SaveStore.STATUS_OK)
	assert_eq(int(result["data"]["campaign"]["marker"]), 2)
	assert_true(FileAccess.file_exists(store.path("bak")), "o save anterior vira .bak")
	assert_false(FileAccess.file_exists(store.path("tmp")), "o .tmp não sobra")


func test_no_save_reads_as_none() -> void:
	assert_eq(store.read()["status"], SaveStore.STATUS_NONE)


func test_S03_truncated_main_file_loads_the_backup() -> void:
	store.write(_save(1))
	store.write(_save(2))
	var f := FileAccess.open(store.path("json"), FileAccess.WRITE)
	f.store_string('{"save_version": 1, "campa')
	f.close()
	var result: Dictionary = store.read()
	assert_eq(result["status"], SaveStore.STATUS_FROM_BACKUP)
	assert_eq(int(result["data"]["campaign"]["marker"]), 1)


func test_S04_both_corrupt_offers_a_new_game_and_keeps_the_files() -> void:
	store.write(_save(1))
	store.write(_save(2))
	for ext: String in ["json", "bak"]:
		var f := FileAccess.open(store.path(ext), FileAccess.WRITE)
		f.store_string("lixo")
		f.close()
	assert_eq(store.read()["status"], SaveStore.STATUS_CORRUPT)
	var corrupt: Array = Array(_files()).filter(func(n: String) -> bool: return n.contains(".corrupt."))
	assert_eq(corrupt.size(), 2, "os dois arquivos ruins preservados: %s" % [_files()])
	assert_false(store.exists())


func test_missing_required_field_counts_as_corrupt() -> void:
	var bad: Dictionary = _save(1)
	bad.erase("campaign")
	store.write(bad)
	assert_eq(store.read()["status"], SaveStore.STATUS_CORRUPT)


func test_S05_version_1_save_is_migrated_by_version_2_code() -> void:
	store.write(_save(7, 1))
	var to_v2 := func(data: Dictionary) -> Dictionary:
		data["campaign"]["migrated"] = true
		return data
	var v2 := SaveStore.new(DIR, SaveMigrations.new({1: to_v2}, 2))
	var result: Dictionary = v2.read()
	assert_eq(result["status"], SaveStore.STATUS_OK)
	assert_eq(int(result["data"]["save_version"]), 2)
	assert_true(result["data"]["campaign"]["migrated"])
	assert_eq(int(result["data"]["campaign"]["marker"]), 7)


func test_missing_migration_step_cannot_be_read() -> void:
	store.write(_save(7, 1))
	var v3 := SaveStore.new(DIR, SaveMigrations.new({}, 3))
	assert_ne(v3.read()["status"], SaveStore.STATUS_OK)


func test_S06_save_from_a_newer_version_is_refused_and_kept() -> void:
	store.write(_save(1, SaveMigrations.CURRENT_VERSION + 1))
	assert_eq(store.read()["status"], SaveStore.STATUS_FUTURE)
	assert_true(FileAccess.file_exists(store.path("json")))


func test_failed_validation_falls_back_to_the_backup() -> void:
	store.write(_save(1))
	store.write(_save(2))
	store.validator = func(data: Dictionary) -> bool: return int(data["campaign"]["marker"]) != 2
	var result: Dictionary = store.read()
	assert_eq(result["status"], SaveStore.STATUS_FROM_BACKUP)
	assert_eq(int(result["data"]["campaign"]["marker"]), 1)


func test_settings_are_kept_apart_in_their_own_file() -> void:
	var path: String = DIR.path_join("settings_test.json")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR))
	SettingsStore.new(path).set_value("animation_speed", 2)
	assert_eq(int(SettingsStore.new(path).get_value("animation_speed", 0)), 2)
