class_name Virtues
extends RefCounted
## The Pilgrim's virtues (narrative-system §2): Faith, Hope and Charity,
## integers from 0 to [virtue_max], starting at [virtue_start].

const FAITH: StringName = &"virtue_faith"
const HOPE: StringName = &"virtue_hope"
const CHARITY: StringName = &"virtue_charity"
const ALL: Array[StringName] = [FAITH, HOPE, CHARITY]

var values: Dictionary = {}


static func start(constants: ConstantsDef) -> Virtues:
	var v := Virtues.new()
	for id: StringName in ALL:
		v.values[id] = constants.get_int(&"virtue_start")
	return v


func get_value(id: StringName) -> int:
	return int(values.get(id, 0))


## N04: a virtue never goes above the maximum nor below 0.
func change(id: StringName, amount: int, constants: ConstantsDef) -> void:
	values[id] = clampi(get_value(id) + amount, 0, constants.get_int(&"virtue_max"))


func total() -> int:
	var sum: int = 0
	for id: StringName in ALL:
		sum += get_value(id)
	return sum


func to_dict() -> Dictionary:
	var d: Dictionary = {}
	for id: StringName in ALL:
		d[String(id)] = get_value(id)
	return d


static func from_dict(data: Dictionary) -> Virtues:
	var v := Virtues.new()
	for id: StringName in ALL:
		v.values[id] = int(data.get(String(id), 0))
	return v
