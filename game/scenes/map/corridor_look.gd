class_name CorridorLook
extends RefCounted
## How the corridor shows a bifurcation (expedition §2.3 item 6). Pure
## presentation: which entrance is drawn as the straight path and which
## drawing each detour gets. Decided from the map and the node id only, never
## from the rules' RNG, so a resumed game looks exactly the same.

const STRAIGHT: StringName = &"straight"
## Detour drawings, picked by a hash of the node id.
const DETOURS: Array[StringName] = [&"door", &"cave", &"stairs"]


## The entrance drawn as "straight ahead": the nearest node of the next layer,
## the same link the generator makes first (expedition §2, D-132). From the
## gate, the middle of layer 1.
static func straight_entrance(map: LegMap, origin: MapNode, entrances: Array[MapNode]) -> StringName:
	if entrances.is_empty():
		return &""
	var next_layer: int = 1 if origin == null else origin.layer + 1
	var next_size: int = map.layer_nodes(next_layer).size()
	var target: int = floori(next_size / 2.0)
	if origin != null:
		target = MapGenerator.nearest_index(origin.index, map.layer_nodes(origin.layer).size(), next_size)
	for n: MapNode in entrances:
		if n.index == target:
			return n.id
	return entrances[0].id


## STRAIGHT, or the detour drawing of `node_id`.
static func path_kind(node_id: StringName, straight_id: StringName) -> StringName:
	if node_id == straight_id:
		return STRAIGHT
	return DETOURS[RngStream.fnv1a32(String(node_id)) % DETOURS.size()]
