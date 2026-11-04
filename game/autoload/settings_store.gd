class_name SettingsStore
extends RefCounted
## Player preferences, kept apart from the save (save-load §2): user://settings.json.

var file_path: String
var values: Dictionary = {}


func _init(p_path: String = "user://settings.json") -> void:
	file_path = p_path
	if FileAccess.file_exists(file_path):
		var json := JSON.new()
		if json.parse(FileAccess.get_file_as_string(file_path)) == OK and json.data is Dictionary:
			values = json.data


func get_value(key: String, default: Variant) -> Variant:
	return values.get(key, default)


func set_value(key: String, value: Variant) -> void:
	values[key] = value
	var f := FileAccess.open(file_path, FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify(values, "\t"))
		f.close()
