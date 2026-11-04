class_name LegMap
extends RefCounted
## The node map of one leg (expedition §2). Layer 1 is reached from the gate
## (or the previous camp): every node of layer 1 is an entrance from there.

var leg: int = 1
## layers[i] is layer i + 1: an Array of MapNode.
var layers: Array = []
## True when the generator gave up and used the fixed template (§2.1).
var from_reserve: bool = false


func layer_count() -> int:
	return layers.size()


func layer_nodes(layer: int) -> Array[MapNode]:
	var result: Array[MapNode] = []
	if layer >= 1 and layer <= layers.size():
		for n: MapNode in layers[layer - 1]:
			result.append(n)
	return result


func node(layer: int, index: int) -> MapNode:
	var nodes: Array[MapNode] = layer_nodes(layer)
	if index < 0 or index >= nodes.size():
		return null
	return nodes[index]


func find(node_id: StringName) -> MapNode:
	for layer_list: Array in layers:
		for n: MapNode in layer_list:
			if n.id == node_id:
				return n
	return null


func all_nodes() -> Array[MapNode]:
	var result: Array[MapNode] = []
	for layer_list: Array in layers:
		for n: MapNode in layer_list:
			result.append(n)
	return result


## The entrances of the next bifurcation (§2.3): from the gate (null) every
## node of layer 1; from a node, the nodes it links to.
func entrances_from(origin: MapNode) -> Array[MapNode]:
	if origin == null:
		return layer_nodes(1)
	var result: Array[MapNode] = []
	for i: int in origin.links:
		var n: MapNode = node(origin.layer + 1, i)
		if n != null:
			result.append(n)
	return result


## Nodes of the previous layer that link to `n` (the gate is not a node).
func predecessors(n: MapNode) -> Array[MapNode]:
	var result: Array[MapNode] = []
	for p: MapNode in layer_nodes(n.layer - 1):
		if p.links.has(n.index):
			result.append(p)
	return result


## Every path from the gate to the last layer, as lists of nodes.
func paths() -> Array:
	var result: Array = []
	for start: MapNode in layer_nodes(1):
		_collect(start, [] as Array[MapNode], result)
	return result


func _collect(n: MapNode, prefix: Array[MapNode], out: Array) -> void:
	var path: Array[MapNode] = prefix.duplicate()
	path.append(n)
	if n.layer == layers.size():
		out.append(path)
		return
	for next: MapNode in entrances_from(n):
		_collect(next, path, out)


## Content visibility (§2.2): the type is always visible; the content of a
## layer is visible when it is within the gate's reach from where the party
## stands (`current_layer` 0 = at the gate). Gate level 1 reveals the next
## layer, level 2 the next two and level 3 the whole leg. `extra_layers` is
## added by Incense (D-129, T22).
static func content_visible(target_layer: int, current_layer: int, gate_level: int, extra_layers: int = 0) -> bool:
	if target_layer <= current_layer:
		return true
	if gate_level >= 3:
		return true
	return target_layer <= current_layer + gate_level + extra_layers


static func from_template(template: MapTemplateDef) -> LegMap:
	var map := LegMap.new()
	map.leg = template.leg
	map.from_reserve = true
	for li: int in template.layers.size():
		var layer_list: Array = []
		var raw_layer: Array = template.layers[li]
		for ni: int in raw_layer.size():
			var raw: Dictionary = raw_layer[ni]
			var n := MapNode.make(li + 1, ni)
			n.role = StringName(str(raw.get("role", "")))
			n.type = StringName(str(raw.get("type", "")))
			for v: Variant in raw.get("links", []):
				n.links.append(int(v))
			layer_list.append(n)
		map.layers.append(layer_list)
	return map


func to_dict() -> Dictionary:
	var layer_dicts: Array = []
	for layer_list: Array in layers:
		var nodes: Array = []
		for n: MapNode in layer_list:
			nodes.append(n.to_dict())
		layer_dicts.append(nodes)
	return {"leg": leg, "from_reserve": from_reserve, "layers": layer_dicts}


static func from_dict(data: Dictionary) -> LegMap:
	var map := LegMap.new()
	map.leg = int(data.get("leg", 1))
	map.from_reserve = bool(data.get("from_reserve", false))
	var raw_layers: Variant = data.get("layers", [])
	if raw_layers is Array:
		for raw_layer: Variant in raw_layers:
			var layer_list: Array = []
			if raw_layer is Array:
				for raw_node: Variant in raw_layer:
					if raw_node is Dictionary:
						layer_list.append(MapNode.from_dict(raw_node))
			map.layers.append(layer_list)
	return map
