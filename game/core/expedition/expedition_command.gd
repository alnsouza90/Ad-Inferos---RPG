class_name ExpeditionCommand
extends RefCounted
## A player command outside battle (expedition §2.3), as plain data. Battle
## commands travel wrapped in BATTLE so one log rebuilds the whole expedition.

const CHOOSE_PATH: StringName = &"ChoosePath"
const BATTLE: StringName = &"Battle"
## Leaves a node whose content is not a battle (Temptation, relic). In the
## M1 these nodes are pass-through until T23 and T25 fill them.
const COMPLETE_NODE: StringName = &"CompleteNode"
## Uses a provision at a bifurcation (expedition §2.3 item 8, §5).
const USE_PROVISION: StringName = &"UseProvisionField"

var type: StringName = &""
var node_id: StringName = &""
var battle_command: BattleCommand
var provision_id: StringName = &""
## Saint who receives the provision (Holy Water); empty for Candle and Incense.
var target_id: StringName = &""


static func choose_path(p_node: StringName) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = CHOOSE_PATH
	cmd.node_id = p_node
	return cmd


static func battle(p_cmd: BattleCommand) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = BATTLE
	cmd.battle_command = p_cmd
	return cmd


static func use_provision(p_provision: StringName, p_target: StringName = &"") -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = USE_PROVISION
	cmd.provision_id = p_provision
	cmd.target_id = p_target
	return cmd


static func complete_node() -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = COMPLETE_NODE
	return cmd


func to_dict() -> Dictionary:
	var d: Dictionary = {"type": String(type)}
	if type == CHOOSE_PATH:
		d["node"] = String(node_id)
	elif type == BATTLE:
		d["command"] = battle_command.to_dict()
	elif type == USE_PROVISION:
		d["provision"] = String(provision_id)
		d["target"] = String(target_id)
	return d


static func from_dict(data: Dictionary) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = StringName(str(data.get("type", "")))
	cmd.node_id = StringName(str(data.get("node", "")))
	cmd.provision_id = StringName(str(data.get("provision", "")))
	cmd.target_id = StringName(str(data.get("target", "")))
	if data.has("command"):
		cmd.battle_command = BattleCommand.from_dict(data["command"])
	return cmd
