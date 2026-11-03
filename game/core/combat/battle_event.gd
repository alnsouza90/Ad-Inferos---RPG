class_name BattleEvent
extends RefCounted
## One thing that happened in battle, in order. The screen animates these and
## the log records them (architecture §3.2 and §7). `data` holds plain values.

var type: StringName
var data: Dictionary


static func create(p_type: StringName, p_data: Dictionary = {}) -> BattleEvent:
	var event := BattleEvent.new()
	event.type = p_type
	event.data = p_data
	return event


func to_dict() -> Dictionary:
	return {"type": String(type), "data": data}
