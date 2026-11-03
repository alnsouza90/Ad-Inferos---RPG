class_name ConstantsDef
extends Resource
## Global numbers from constants.csv (data-schemas §3.1). Specs cite them as
## [key]. Values are float, or Array[float] for list values ("0|40|100").

@export var values: Dictionary = {}
@export var descriptions: Dictionary = {}


func has_key(key: StringName) -> bool:
	return values.has(String(key))


func get_float(key: StringName) -> float:
	assert(has_key(key), "Unknown constant: %s" % key)
	return float(values[String(key)])


func get_int(key: StringName) -> int:
	return int(round(get_float(key)))


func get_list(key: StringName) -> Array[float]:
	assert(has_key(key), "Unknown constant: %s" % key)
	var result: Array[float] = []
	var raw: Variant = values[String(key)]
	if raw is Array:
		for v: Variant in raw:
			result.append(float(v))
	else:
		result.append(float(raw))
	return result
