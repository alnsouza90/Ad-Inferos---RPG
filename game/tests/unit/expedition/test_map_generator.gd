extends GutTest
## T20: leg generator (expedition §2.1 and §2.2). Fixture constants: 50%
## chance of 3 nodes, 50% chance of a second link, 50 attempts, variable
## weights 40/35/25 (elite only when allowed).

const SEEDS: int = 1000

var k: ConstantsDef


func before_each() -> void:
	k = CombatFixture.constants()


static func reserve() -> MapTemplateDef:
	var d := MapTemplateDef.new()
	d.id = &"leg1_reserve"
	d.leg = 1
	d.layers = [
		[{"role": &"battle", "type": &"node_battle", "links": [0]}, {"role": &"battle", "type": &"node_battle", "links": [1]}],
		[{"role": &"temptation", "type": &"node_temptation", "links": [0, 1]}, {"role": &"temptation", "type": &"node_temptation", "links": [1, 2]}],
		[{"role": &"variable", "type": &"node_relic", "links": [0]}, {"role": &"variable", "type": &"node_battle", "links": [0, 1]}, {"role": &"variable", "type": &"node_relic", "links": [1]}],
		[{"role": &"battle", "type": &"node_battle", "links": []}, {"role": &"battle", "type": &"node_battle", "links": []}],
	]
	return d


func _generator(seed: int) -> MapGenerator:
	var g := MapGenerator.new(k, RngStream.new(seed, RngStreams.MAP))
	g.battle_encounters = [&"enc_a", &"enc_b"] as Array[StringName]
	return g


func _leg(seed: int, leg: int = 1) -> LegMap:
	return _generator(seed).generate(leg, reserve())


static func _crossing(map: LegMap) -> bool:
	for layer: int in range(1, map.layer_count()):
		var edges: Array = []
		for n: MapNode in map.layer_nodes(layer):
			for j: int in n.links:
				edges.append([n.index, j])
		for a: Array in edges:
			for b: Array in edges:
				if int(a[0]) < int(b[0]) and int(a[1]) > int(b[1]):
					return true
	return false


func test_E01_every_path_of_1000_generated_legs_follows_the_rules() -> void:
	var reserve_used: int = 0
	var bad: Array[int] = []
	for seed: int in SEEDS:
		var map: LegMap = _leg(seed)
		if not MapGenerator.is_valid(map):
			bad.append(seed)
		if map.from_reserve:
			reserve_used += 1
	assert_eq(bad, [] as Array[int], "sementes com caminho inválido")
	assert_lt(reserve_used, 50, "o gerador desistiu em muitas sementes")
	gut.p("Trecho de reserva usado em %d de %d sementes" % [reserve_used, SEEDS])


func test_generated_layers_have_2_or_3_nodes_and_links_never_cross() -> void:
	for seed: int in 200:
		var map: LegMap = _leg(seed)
		if map.from_reserve:
			continue
		assert_eq(map.layer_count(), 4)
		for layer: int in range(1, 5):
			var size: int = map.layer_nodes(layer).size()
			assert_true(size == 2 or size == 3, "semente %d camada %d com %d nós" % [seed, layer, size])
		assert_false(_crossing(map), "semente %d com ligações cruzadas" % seed)


func test_same_seed_gives_the_same_leg() -> void:
	assert_eq(JSON.stringify(_leg(42).to_dict()), JSON.stringify(_leg(42).to_dict()))


func test_different_seeds_give_different_legs() -> void:
	var seen: Dictionary = {}
	for seed: int in 20:
		seen[JSON.stringify(_leg(seed).to_dict())] = true
	assert_gt(seen.size(), 10)


func test_m1_has_no_elite_and_variable_weights_follow_35_to_25() -> void:
	var relics: int = 0
	var battles: int = 0
	for seed: int in SEEDS:
		var map: LegMap = _leg(seed)
		for n: MapNode in map.all_nodes():
			assert_ne(n.type, MapNode.TYPE_ELITE)
			if n.role == MapNode.ROLE_VARIABLE and not map.from_reserve:
				if n.type == MapNode.TYPE_RELIC:
					relics += 1
				elif n.type == MapNode.TYPE_BATTLE:
					battles += 1
	var share: float = float(relics) / float(relics + battles)
	assert_almost_eq(share, 35.0 / 60.0, 0.05, "fração de relíquias nos nós variáveis")


func test_elites_appear_when_allowed_and_never_twice_on_a_path() -> void:
	var elites: int = 0
	for seed: int in 300:
		var g := _generator(seed)
		g.allow_elite = true
		var map: LegMap = g.generate(1, reserve())
		assert_true(MapGenerator.is_valid(map))
		for n: MapNode in map.all_nodes():
			if n.type == MapNode.TYPE_ELITE:
				elites += 1
	assert_gt(elites, 0)


func test_reserve_template_is_used_when_no_attempt_is_allowed() -> void:
	k.values["map_generation_retries"] = 0.0
	var map: LegMap = _leg(7)
	assert_true(map.from_reserve)
	assert_true(MapGenerator.is_valid(map))
	assert_eq(map.layer_nodes(3).size(), 3)


func test_battle_nodes_get_an_encounter_from_the_pool() -> void:
	for n: MapNode in _leg(3).all_nodes():
		if n.type == MapNode.TYPE_BATTLE:
			assert_true([&"enc_a", &"enc_b"].has(n.encounter_id), "nó %s" % n.id)
		else:
			assert_eq(n.encounter_id, &"")


func test_legs_2_and_3_follow_their_own_rules() -> void:
	for seed: int in 200:
		var leg2: LegMap = _generator(seed).generate(2, reserve())
		if not leg2.from_reserve:
			assert_true(MapGenerator.is_valid(leg2), "trecho 2, semente %d" % seed)
			assert_eq(leg2.layer_nodes(3).size(), 1)
			assert_eq(leg2.node(3, 0).type, MapNode.TYPE_SOUL)
		var leg3: LegMap = _generator(seed).generate(3, reserve())
		if not leg3.from_reserve:
			assert_true(MapGenerator.is_valid(leg3), "trecho 3, semente %d" % seed)
			assert_eq(leg3.layer_count(), 3)


func test_entrances_from_the_gate_are_layer_1_and_from_a_node_its_links() -> void:
	var map: LegMap = _leg(11)
	assert_eq(map.entrances_from(null).size(), map.layer_nodes(1).size())
	var first: MapNode = map.node(1, 0)
	var entrances: Array[MapNode] = map.entrances_from(first)
	assert_eq(entrances.size(), first.links.size())
	for e: MapNode in entrances:
		assert_eq(e.layer, 2)
		assert_true(first.links.has(e.index))


func test_gate_level_1_reveals_only_the_next_layer() -> void:
	assert_true(LegMap.content_visible(1, 0, 1))
	assert_false(LegMap.content_visible(2, 0, 1))
	assert_true(LegMap.content_visible(3, 2, 1))
	assert_false(LegMap.content_visible(4, 2, 1))


func test_gate_level_2_reveals_two_layers_and_level_3_the_whole_leg() -> void:
	assert_true(LegMap.content_visible(2, 0, 2))
	assert_false(LegMap.content_visible(3, 0, 2))
	assert_true(LegMap.content_visible(4, 0, 3))


func test_extra_layer_reveals_one_more() -> void:
	assert_true(LegMap.content_visible(2, 0, 1, 1))
	assert_false(LegMap.content_visible(3, 0, 1, 1))


func test_map_survives_a_json_round_trip() -> void:
	var map: LegMap = _leg(5)
	var text: String = JSON.stringify(map.to_dict())
	var back := LegMap.from_dict(JSON.parse_string(text))
	assert_eq(JSON.stringify(back.to_dict()), text)
	assert_true(MapGenerator.is_valid(back))
