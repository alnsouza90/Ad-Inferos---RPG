class_name Intent
extends RefCounted
## An announced enemy action (enemy-ai §3.6). It aims at a party SLOT, not at
## a saint: whoever stands there when it executes receives it (combat §6.3).

var enemy_id: StringName
var action_id: StringName
## 1..3, or 0 when the action has no single party target.
var target_slot: int = 0
var preview_value: int = 0


static func create(p_enemy_id: StringName, p_action_id: StringName, p_target_slot: int) -> Intent:
	var intent := Intent.new()
	intent.enemy_id = p_enemy_id
	intent.action_id = p_action_id
	intent.target_slot = p_target_slot
	return intent
