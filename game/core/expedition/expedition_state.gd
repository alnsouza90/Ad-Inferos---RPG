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
## Gate level (1 in the M1): pack slots and content visibility (§2.2, §5).
var gate_level: int = 1
## Nodes whose content Incense revealed; known until the end of the leg (D-137).
var revealed_nodes: Array[StringName] = []
## Camp of this leg reached (consecrated) and rest taken (§6).
var camp_reached: bool = false
var camp_rested: bool = false
## Starting Fervor of the next battle from Prayers, already capped (§6).
var next_battle_fervor: int = 0


## New expedition from the gate, with full Light.
static func create(constants: ConstantsDef, p_circle: StringName, p_map_seed: int, p_party: Array[StringName], p_provisions: Array[StringName] = []) -> ExpeditionState:
	var state := ExpeditionState.new()
	state.circle = p_circle
	state.map_seed = p_map_seed
	state.party = p_party.duplicate()
	for p: StringName in p_provisions:
		var added: bool = state.add_provision(p, constants)
		assert(added, "starting provisions exceed the pack: %s" % [p_provisions])
	state.light = ExpeditionLight.start_value(constants)
	return state


## One unit per slot (§5). Returns false, changing nothing, when full (E04).
func add_provision(provision_id: StringName, constants: ConstantsDef) -> bool:
	if provisions.size() >= FieldProvisions.capacity(gate_level, constants):
		return false
	provisions.append(provision_id)
	return true


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
		"gate_level": gate_level, "revealed_nodes": _to_strings(revealed_nodes),
		"camp_reached": camp_reached, "camp_rested": camp_rested, "next_battle_fervor": next_battle_fervor,
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
	state.gate_level = int(data.get("gate_level", 1))
	state.revealed_nodes = _to_names(data.get("revealed_nodes", []))
	state.camp_reached = bool(data.get("camp_reached", false))
	state.camp_rested = bool(data.get("camp_rested", false))
	state.next_battle_fervor = int(data.get("next_battle_fervor", 0))
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
