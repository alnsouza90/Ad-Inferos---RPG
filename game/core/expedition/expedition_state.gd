class_name ExpeditionState
extends RefCounted
## State of one expedition in progress (expedition.md, save-load §3.1).
## Pure data plus the Light rules that change it; the flow (choosing paths,
## battles, camp) belongs to ExpeditionController (T21). The map structure
## is filled by the generator (T20).

var circle: StringName = &""
var map_seed: int = 0
var map: Dictionary = {}
## Node the party is in (or just left, while walking to the next layer);
## empty at the gate.
var current_node: StringName = &""
## Nodes already left behind, in order (current_node is not included).
var visited: Array[StringName] = []
var light: int = 0
## Provisions carried, one entry per unit (expedition §5).
var provisions: Array[StringName] = []
var alms_unbanked: int = 0
var alms_banked: int = 0
var party: Array[StringName] = []
var fallen_once: Array[StringName] = []


## New expedition from the gate, with full Light.
static func create(constants: ConstantsDef, p_circle: StringName, p_map_seed: int, p_party: Array[StringName], p_provisions: Array[StringName] = []) -> ExpeditionState:
	var state := ExpeditionState.new()
	state.circle = p_circle
	state.map_seed = p_map_seed
	state.party = p_party.duplicate()
	state.provisions = p_provisions.duplicate()
	state.light = ExpeditionLight.start_value(constants)
	return state


## Expedition that starts from a consecrated camp (expedition §1 and §4).
static func create_resumed(constants: ConstantsDef, p_circle: StringName, p_map_seed: int, p_party: Array[StringName], p_provisions: Array[StringName] = []) -> ExpeditionState:
	var state := create(constants, p_circle, p_map_seed, p_party, p_provisions)
	state.light = ExpeditionLight.resume_value(constants)
	return state


## Entering a node costs Light (§4). Walking the corridor does not (§2.3).
func enter_node(node_id: StringName, constants: ConstantsDef) -> void:
	if current_node != &"":
		visited.append(current_node)
	current_node = node_id
	light = ExpeditionLight.after_entering_node(light, constants)


func apply_candle(constants: ConstantsDef) -> void:
	light = ExpeditionLight.after_candle(light, constants)


func light_band(constants: ConstantsDef) -> StringName:
	return ExpeditionLight.band(light, constants)


func to_dict() -> Dictionary:
	return {
		"circle": String(circle), "map_seed": map_seed, "map": map.duplicate(true),
		"current_node": String(current_node), "visited": _to_strings(visited), "light": light,
		"provisions": _to_strings(provisions), "alms_unbanked": alms_unbanked, "alms_banked": alms_banked,
		"party": _to_strings(party), "fallen_once": _to_strings(fallen_once),
	}


static func from_dict(data: Dictionary) -> ExpeditionState:
	var state := ExpeditionState.new()
	state.circle = StringName(str(data.get("circle", "")))
	state.map_seed = int(data.get("map_seed", 0))
	var raw_map: Variant = data.get("map", {})
	if raw_map is Dictionary:
		state.map = (raw_map as Dictionary).duplicate(true)
	state.current_node = StringName(str(data.get("current_node", "")))
	state.visited = _to_names(data.get("visited", []))
	state.light = int(data.get("light", 0))
	state.provisions = _to_names(data.get("provisions", []))
	state.alms_unbanked = int(data.get("alms_unbanked", 0))
	state.alms_banked = int(data.get("alms_banked", 0))
	state.party = _to_names(data.get("party", []))
	state.fallen_once = _to_names(data.get("fallen_once", []))
	return state


static func _to_strings(names: Array[StringName]) -> Array[String]:
	var result: Array[String] = []
	for n: StringName in names:
		result.append(String(n))
	return result


static func _to_names(raw: Variant) -> Array[StringName]:
	var result: Array[StringName] = []
	if raw is Array:
		for v: Variant in raw:
			result.append(StringName(str(v)))
	return result
