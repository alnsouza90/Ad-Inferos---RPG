class_name ResourceSnapshot
extends RefCounted
## Converts a Resource (and nested Resources/Arrays) into plain Variants so two
## definitions can be compared by content, ignoring file paths and UIDs.


static func of(value: Variant) -> Variant:
	if value is Resource:
		var res: Resource = value
		var result: Dictionary = {}
		for prop: Dictionary in res.get_property_list():
			var usage: int = prop["usage"]
			var prop_name: String = prop["name"]
			if usage & PROPERTY_USAGE_SCRIPT_VARIABLE == 0 or usage & PROPERTY_USAGE_STORAGE == 0:
				continue
			result[prop_name] = of(res.get(prop_name))
		return result
	if value is Array:
		var list: Array = []
		for item: Variant in value:
			list.append(of(item))
		return list
	if value is Dictionary:
		var dict: Dictionary = {}
		for key: Variant in value:
			dict[str(key)] = of(value[key])
		return dict
	if value is StringName:
		return String(value)
	if value is int:
		return float(value)
	return value


static func same(a: Variant, b: Variant) -> bool:
	return JSON.stringify(of(a), "", true) == JSON.stringify(of(b), "", true)
