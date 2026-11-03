class_name Intent
extends RefCounted
## An announced enemy action (enemy-ai §3.6). It aims at a party SLOT, not at
## a saint: whoever stands there when it executes receives it (combat §6.3).

const KIND_ACTION: StringName = &"action"
const KIND_STUNNED: StringName = &"stunned"
const KIND_WAIT: StringName = &"wait"

var enemy_id: StringName
var action_id: StringName = &""
var kind: StringName = KIND_ACTION
## 1..3 for single-target actions, 0 otherwise.
var target_slot: int = 0
## For actions that target another enemy (ally_enemy).
var target_enemy_id: StringName = &""
## Predicted damage on the current target with every current modifier.
var preview_value: int = 0
var intent_icon: StringName = &""


static func create(p_enemy_id: StringName, p_action_id: StringName, p_target_slot: int) -> Intent:
	var intent := Intent.new()
	intent.enemy_id = p_enemy_id
	intent.action_id = p_action_id
	intent.target_slot = p_target_slot
	return intent


static func idle(p_enemy_id: StringName, p_kind: StringName) -> Intent:
	var intent := Intent.new()
	intent.enemy_id = p_enemy_id
	intent.kind = p_kind
	return intent


func to_dict() -> Dictionary:
	return {"enemy": String(enemy_id), "action": String(action_id), "kind": String(kind), "slot": target_slot, "ally": String(target_enemy_id), "preview": preview_value}


func clone() -> Intent:
	var copy := Intent.new()
	for prop: Dictionary in get_property_list():
		if int(prop["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			copy.set(prop["name"], get(prop["name"]))
	return copy
