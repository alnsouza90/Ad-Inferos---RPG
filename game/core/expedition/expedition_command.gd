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
## Chooses an option of the event in progress; the option id travels in node_id.
const CHOOSE_OPTION: StringName = &"ChooseOption"
## Rests at camp (§6): one activity per saint, in `activities`.
const REST: StringName = &"Rest"
## Leaves the camp: `mode` is MODE_CONTINUE or MODE_RETREAT (planned retreat).
const LEAVE_CAMP: StringName = &"LeaveCamp"
## Gives the found relic to a saint (target_id) or keeps it in the pack (empty).
const PLACE_RELIC: StringName = &"PlaceRelic"
## Starts the content the party reached in the corridor (expedition §2.3
## item 4): the battle, Entrar in the tent, Abrir the relic, Falar to the soul.
const ENGAGE_NODE: StringName = &"EngageNode"
## Passar ao largo of the tent: applies the first `safe: true` option of the
## Temptation without opening the event (narrative-system §4.1).
const PASS_BY: StringName = &"PassBy"
const MODE_CONTINUE: StringName = &"continue"
const MODE_RETREAT: StringName = &"retreat"

var type: StringName = &""
var node_id: StringName = &""
var battle_command: BattleCommand
var provision_id: StringName = &""
## Saint who receives the provision (Holy Water); empty for Candle and Incense.
var target_id: StringName = &""
## REST: [{"saint": id, "activity": vigil|share|prayer|own, "target": id}]
var activities: Array[Dictionary] = []
var mode: StringName = &""


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


static func choose_option(p_option: StringName) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = CHOOSE_OPTION
	cmd.node_id = p_option
	return cmd


static func rest(p_activities: Array[Dictionary]) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = REST
	cmd.activities = p_activities.duplicate(true)
	return cmd


static func leave_camp(p_mode: StringName) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = LEAVE_CAMP
	cmd.mode = p_mode
	return cmd


static func place_relic(p_saint: StringName = &"") -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = PLACE_RELIC
	cmd.target_id = p_saint
	return cmd


static func engage_node() -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = ENGAGE_NODE
	return cmd


static func pass_by() -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = PASS_BY
	return cmd


static func complete_node() -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = COMPLETE_NODE
	return cmd


func to_dict() -> Dictionary:
	var d: Dictionary = {"type": String(type)}
	if type == CHOOSE_PATH or type == CHOOSE_OPTION:
		d["node"] = String(node_id)
	elif type == BATTLE:
		d["command"] = battle_command.to_dict()
	elif type == USE_PROVISION:
		d["provision"] = String(provision_id)
		d["target"] = String(target_id)
	elif type == REST:
		var list: Array = []
		for a: Dictionary in activities:
			list.append({"saint": str(a.get("saint", "")), "activity": str(a.get("activity", "")), "target": str(a.get("target", ""))})
		d["activities"] = list
	elif type == LEAVE_CAMP:
		d["mode"] = String(mode)
	elif type == PLACE_RELIC:
		d["target"] = String(target_id)
	return d


static func from_dict(data: Dictionary) -> ExpeditionCommand:
	var cmd := ExpeditionCommand.new()
	cmd.type = StringName(str(data.get("type", "")))
	cmd.node_id = StringName(str(data.get("node", "")))
	cmd.provision_id = StringName(str(data.get("provision", "")))
	cmd.target_id = StringName(str(data.get("target", "")))
	for a: Variant in data.get("activities", []):
		if a is Dictionary:
			cmd.activities.append({"saint": StringName(str(a.get("saint", ""))), "activity": StringName(str(a.get("activity", ""))), "target": StringName(str(a.get("target", "")))})
	cmd.mode = StringName(str(data.get("mode", "")))
	if data.has("command"):
		cmd.battle_command = BattleCommand.from_dict(data["command"])
	return cmd
