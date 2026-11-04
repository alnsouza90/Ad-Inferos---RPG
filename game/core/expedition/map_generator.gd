class_name MapGenerator
extends RefCounted
## Generates a leg map (expedition §2.1). An attempt builds the structure
## (2 or 3 nodes per layer, links to nearby nodes of the next layer, every
## node reachable), assigns the path roles so that EVERY path has the leg's
## composition, and draws the type of the variable nodes. If no attempt
## succeeds, the fixed reserve template is used. All randomness comes from the
## given `map` stream, so the same seed always gives the same leg.

## Leg composition (expedition §2.1 table). Structure of the rules, not
## balance numbers: layers per leg, roles every path must contain and layers
## that are a single fixed node (the soul meeting in leg 2, layer 3).
const LEG_RULES: Dictionary = {
	1: {"layers": 4, "roles": {&"battle": 2, &"temptation": 1, &"variable": 1}, "fixed": {}},
	2: {"layers": 4, "roles": {&"battle": 2, &"soul": 1, &"variable": 1}, "fixed": {3: &"soul"}},
	3: {"layers": 3, "roles": {&"battle": 2, &"variable": 1}, "fixed": {}},
}
const MIN_NODES: int = 2
const MAX_NODES: int = 3

var constants: ConstantsDef
var rng: RngStream
## Encounter ids for battle nodes (the circle's easy or hard pool, §3).
var battle_encounters: Array[StringName] = []
## Elite encounter ids; empty in the M1, which has no elites (D-124).
var elite_encounters: Array[StringName] = []
var allow_elite: bool = false


func _init(p_constants: ConstantsDef, p_rng: RngStream) -> void:
	constants = p_constants
	rng = p_rng


func generate(leg: int, reserve: MapTemplateDef) -> LegMap:
	var attempts: int = constants.get_int(&"map_generation_retries")
	for attempt: int in attempts:
		var map: LegMap = _attempt(leg)
		if map != null:
			_assign_encounters(map)
			return map
	var fallback: LegMap = LegMap.from_template(reserve)
	_assign_encounters(fallback)
	return fallback


## Checks every path of `map` against the leg composition (E01) and the
## "at most one elite per path" rule.
static func is_valid(map: LegMap) -> bool:
	var rules: Dictionary = LEG_RULES[map.leg]
	if map.layer_count() != int(rules["layers"]):
		return false
	for n: MapNode in map.all_nodes():
		if not _node_is_consistent(map, n):
			return false
	for path: Array in map.paths():
		var counts: Dictionary = {}
		var elites: int = 0
		for n: MapNode in path:
			counts[n.role] = int(counts.get(n.role, 0)) + 1
			if n.type == MapNode.TYPE_ELITE:
				elites += 1
		if elites > 1 or not _same_counts(counts, rules["roles"]):
			return false
	return true


## Links point inside the next layer (none from the last one), every node
## below layer 1 has an entry, and the visible type matches the role.
static func _node_is_consistent(map: LegMap, n: MapNode) -> bool:
	var last: bool = n.layer == map.layer_count()
	if last != n.links.is_empty():
		return false
	for j: int in n.links:
		if map.node(n.layer + 1, j) == null:
			return false
	if n.layer > 1 and map.predecessors(n).is_empty():
		return false
	if n.role == MapNode.ROLE_VARIABLE:
		return [MapNode.TYPE_ELITE, MapNode.TYPE_RELIC, MapNode.TYPE_BATTLE].has(n.type)
	return n.type == MapNode.type_for_role(n.role) and n.type != &""


func _attempt(leg: int) -> LegMap:
	var rules: Dictionary = LEG_RULES[leg]
	var map := LegMap.new()
	map.leg = leg
	_build_structure(map, int(rules["layers"]), rules["fixed"])
	var order: Array[MapNode] = map.all_nodes()
	var prefixes: Dictionary = {}
	if not _assign_roles(map, order, 0, rules, prefixes):
		return null
	_draw_variable_types(map)
	if not is_valid(map):
		return null
	return map


# --- structure ------------------------------------------------------------

func _build_structure(map: LegMap, layer_total: int, fixed: Dictionary) -> void:
	var three_chance: float = constants.get_float(&"map_three_nodes_chance")
	for layer: int in range(1, layer_total + 1):
		var size: int = MIN_NODES
		if fixed.has(layer):
			size = 1
		elif rng.chance(three_chance):
			size = MAX_NODES
		var layer_list: Array = []
		for i: int in size:
			var n := MapNode.make(layer, i)
			if fixed.has(layer):
				n.role = fixed[layer]
			layer_list.append(n)
		map.layers.append(layer_list)
	for layer: int in range(1, layer_total):
		_link_layers(map.layer_nodes(layer), map.layer_nodes(layer + 1))


## Each node links straight ahead (the nearest node of the next layer) and,
## by chance, to the neighbour of that node; links never cross, so the
## mini-map stays readable. Nodes left without an entry get one from the
## nearest node of the previous layer.
func _link_layers(current: Array[MapNode], next: Array[MapNode]) -> void:
	var second_chance: float = constants.get_float(&"map_second_link_chance")
	for n: MapNode in current:
		n.links.append(_nearest(n.index, current.size(), next.size()))
	for n: MapNode in current:
		if not rng.chance(second_chance):
			continue
		var straight: int = n.links[0]
		var candidates: Array[int] = []
		for j: int in [straight - 1, straight + 1]:
			if j >= 0 and j < next.size() and not _crosses(current, n.index, j):
				candidates.append(j)
		if candidates.is_empty():
			continue
		var extra: int = candidates[rng.pick_index(candidates.size())]
		n.links.append(extra)
		n.links.sort()
	for target: MapNode in next:
		if _has_entry(current, target.index):
			continue
		var from_index: int = _nearest(target.index, next.size(), current.size())
		current[from_index].links.append(target.index)
		current[from_index].links.sort()


static func _nearest(index: int, size: int, other_size: int) -> int:
	if size <= 1 or other_size <= 1:
		return 0 if other_size <= 1 else floori(other_size / 2.0)
	return clampi(roundi(float(index) * float(other_size - 1) / float(size - 1)), 0, other_size - 1)


static func _crosses(current: Array[MapNode], from_index: int, to_index: int) -> bool:
	for other: MapNode in current:
		if other.index == from_index:
			continue
		for j: int in other.links:
			if (other.index < from_index and j > to_index) or (other.index > from_index and j < to_index):
				return true
	return false


static func _has_entry(current: Array[MapNode], target_index: int) -> bool:
	for n: MapNode in current:
		if n.links.has(target_index):
			return true
	return false


# --- roles ----------------------------------------------------------------

## Backtracking over the nodes, layer by layer. `prefixes[node_id]` holds the
## role counts of every partial path that ends in that node; a role is only
## accepted if no partial path goes over the composition, and in the last
## layer every path must match it exactly. Role order is shuffled by the
## stream, so different seeds give different legs.
func _assign_roles(map: LegMap, order: Array[MapNode], k: int, rules: Dictionary, prefixes: Dictionary) -> bool:
	if k == order.size():
		return true
	var n: MapNode = order[k]
	var target: Dictionary = rules["roles"]
	var candidates: Array[StringName] = []
	if n.role != &"":
		candidates.append(n.role)
	else:
		for r: StringName in target:
			if not (rules["fixed"] as Dictionary).values().has(r):
				candidates.append(r)
		_shuffle(candidates)
	var incoming: Array = [{}]
	if n.layer > 1:
		incoming = []
		for p: MapNode in map.predecessors(n):
			incoming.append_array(prefixes[p.id])
	var last: bool = n.layer == map.layer_count()
	var fixed_role: StringName = n.role
	for r: StringName in candidates:
		var mine: Array = []
		var ok: bool = true
		for prefix: Dictionary in incoming:
			var counts: Dictionary = prefix.duplicate()
			counts[r] = int(counts.get(r, 0)) + 1
			if int(counts[r]) > int(target.get(r, 0)) or (last and not _same_counts(counts, target)):
				ok = false
				break
			mine.append(counts)
		if not ok:
			continue
		n.role = r
		prefixes[n.id] = mine
		if _assign_roles(map, order, k + 1, rules, prefixes):
			return true
	n.role = fixed_role
	prefixes.erase(n.id)
	return false


func _shuffle(list: Array[StringName]) -> void:
	for i: int in range(list.size() - 1, 0, -1):
		var j: int = rng.next_int_range(0, i)
		var tmp: StringName = list[i]
		list[i] = list[j]
		list[j] = tmp


static func _same_counts(counts: Dictionary, target: Dictionary) -> bool:
	for r: Variant in target:
		if int(counts.get(r, 0)) != int(target[r]):
			return false
	for r: Variant in counts:
		if int(counts[r]) > 0 and not target.has(r):
			return false
	return true


# --- types and content ----------------------------------------------------

## Variable node: elite, hidden relic or battle, by the weights in
## constants.csv; the elite weight counts only when elites are allowed.
func _draw_variable_types(map: LegMap) -> void:
	var weights: Array[float] = [
		constants.get_float(&"node_weight_elite") if allow_elite else 0.0,
		constants.get_float(&"node_weight_relic"),
		constants.get_float(&"node_weight_battle"),
	]
	var types: Array[StringName] = [MapNode.TYPE_ELITE, MapNode.TYPE_RELIC, MapNode.TYPE_BATTLE]
	var total: float = 0.0
	for w: float in weights:
		total += w
	for n: MapNode in map.all_nodes():
		if n.role != MapNode.ROLE_VARIABLE:
			n.type = MapNode.type_for_role(n.role)
			continue
		var roll: float = rng.next_float() * total
		n.type = types[types.size() - 1]
		for i: int in weights.size():
			if roll < weights[i]:
				n.type = types[i]
				break
			roll -= weights[i]


func _assign_encounters(map: LegMap) -> void:
	for n: MapNode in map.all_nodes():
		if n.type == MapNode.TYPE_BATTLE and not battle_encounters.is_empty():
			n.encounter_id = battle_encounters[rng.pick_index(battle_encounters.size())]
		elif n.type == MapNode.TYPE_ELITE and not elite_encounters.is_empty():
			n.encounter_id = elite_encounters[rng.pick_index(elite_encounters.size())]
