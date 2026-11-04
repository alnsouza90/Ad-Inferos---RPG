class_name MapNode
extends RefCounted
## One node of a leg map (expedition §2 and §3). `role` is what the path
## rules count (battle, temptation, variable, soul); `type` is the node type
## the player sees (node_battle, node_relic...). A variable node keeps role
## `variable` and gets its type from the weighted draw.

const ROLE_BATTLE: StringName = &"battle"
const ROLE_TEMPTATION: StringName = &"temptation"
const ROLE_VARIABLE: StringName = &"variable"
const ROLE_SOUL: StringName = &"soul"

const TYPE_BATTLE: StringName = &"node_battle"
const TYPE_ELITE: StringName = &"node_elite"
const TYPE_TEMPTATION: StringName = &"node_temptation"
const TYPE_SOUL: StringName = &"node_soul"
const TYPE_RELIC: StringName = &"node_relic"

var id: StringName = &""
## 1-based layer inside the leg.
var layer: int = 1
## 0-based position inside the layer (top to bottom on the mini-map).
var index: int = 0
var role: StringName = &""
var type: StringName = &""
## Indexes of the linked nodes in the next layer.
var links: Array[int] = []
## Encounter of battle and elite nodes, chosen when the leg is generated so
## the content can be revealed in advance (§2.2).
var encounter_id: StringName = &""


static func make(p_layer: int, p_index: int) -> MapNode:
	var n := MapNode.new()
	n.layer = p_layer
	n.index = p_index
	n.id = StringName("l%d_n%d" % [p_layer, p_index])
	return n


## Role → type for every role except `variable`, which is drawn.
static func type_for_role(p_role: StringName) -> StringName:
	match p_role:
		ROLE_BATTLE:
			return TYPE_BATTLE
		ROLE_TEMPTATION:
			return TYPE_TEMPTATION
		ROLE_SOUL:
			return TYPE_SOUL
	return &""


func is_battle_like() -> bool:
	return type == TYPE_BATTLE or type == TYPE_ELITE


func to_dict() -> Dictionary:
	return {
		"id": String(id), "layer": layer, "index": index, "role": String(role), "type": String(type),
		"links": links.duplicate(), "encounter_id": String(encounter_id),
	}


static func from_dict(data: Dictionary) -> MapNode:
	var n := make(int(data.get("layer", 1)), int(data.get("index", 0)))
	n.id = StringName(str(data.get("id", n.id)))
	n.role = StringName(str(data.get("role", "")))
	n.type = StringName(str(data.get("type", "")))
	n.encounter_id = StringName(str(data.get("encounter_id", "")))
	var raw: Variant = data.get("links", [])
	if raw is Array:
		for v: Variant in raw:
			n.links.append(int(v))
	return n
