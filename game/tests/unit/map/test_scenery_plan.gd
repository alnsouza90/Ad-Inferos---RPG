extends GutTest
## D-445, D-446: the scenery of each place of a leg and the passages between
## them (docs/design/cenarios-trechos-circulo-02.md, proposal v3).

const SEEDS: int = 60

var cat: ExpeditionCatalog


func before_all() -> void:
	cat = RealData.expedition_catalog()


## The three legs of a whole Circle 2 expedition for `seed`.
func _legs(seed: int) -> Array[LegMap]:
	var c := ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), 2)
	var maps: Array[LegMap] = []
	for leg: int in [1, 2, 3]:
		maps.append(c._generate_leg(leg))
	return maps


## Every corridor of a map: the gate (null) and each node, with its entrances.
func _corridors(map: LegMap) -> Array:
	var result: Array = [[null, map.layer_nodes(1)]]
	for n: MapNode in map.all_nodes():
		result.append([n, map.entrances_from(n)])
	return result


func test_the_same_map_always_looks_the_same() -> void:
	var a: Array[LegMap] = _legs(4)
	var b: Array[LegMap] = _legs(4)
	for i: int in a.size():
		for n: MapNode in a[i].all_nodes():
			assert_eq(SceneryPlan.look(a[i], n), SceneryPlan.look(b[i], b[i].find(n.id)))


func test_the_throne_shows_once_at_the_arrival_in_the_circle() -> void:
	for seed: int in SEEDS:
		var maps: Array[LegMap] = _legs(seed)
		assert_eq(SceneryPlan.look(maps[0], null)["piece"], SceneryPlan.THRONE)
		for map: LegMap in maps:
			if map.leg > 1:
				assert_eq(SceneryPlan.look(map, null)["piece"], "")
			for n: MapNode in map.all_nodes():
				var the_look: Dictionary = SceneryPlan.look(map, n)
				assert_eq(the_look["piece"], "", "o trono não se repete")
				assert_ne(the_look["mid"], SceneryPlan.THRONE)


func test_minos_waits_in_the_jury_hall_behind_a_door() -> void:
	var guardians: int = 0
	for seed: int in SEEDS:
		var map: LegMap = _legs(seed)[0]
		for n: MapNode in map.all_nodes():
			if n.role != MapNode.ROLE_GUARDIAN:
				assert_ne(SceneryPlan.look(map, n)["mid"], SceneryPlan.JURY_HALL)
				continue
			guardians += 1
			assert_eq(SceneryPlan.look(map, n)["mid"], SceneryPlan.JURY_HALL)
			assert_eq(SceneryPlan.look(map, n)["ground"], SceneryPlan.JURY_FLOOR, "piso B (D-446)")
			for p: MapNode in map.predecessors(n):
				assert_eq(SceneryPlan.passage(map, p, n), SceneryPlan.DOOR, "o nó antes de Minos acaba numa porta")
				assert_eq(SceneryPlan.look(map, p)["mid"], SceneryPlan.JURY_WALL, "e corre ao longo do muro do salão (D-448)")
	assert_gt(guardians, 0)


func test_the_tigris_bank_is_only_where_the_fish_is() -> void:
	var fish: int = 0
	for seed: int in SEEDS:
		for map: LegMap in _legs(seed):
			for n: MapNode in map.all_nodes():
				var is_fish: bool = n.content == MapGenerator.CONTENT_FISH
				fish += 1 if is_fish else 0
				assert_eq(SceneryPlan.look(map, n)["mid"] == SceneryPlan.TIGRIS, is_fish, "trecho %d, %s" % [map.leg, n.id])
	assert_gt(fish, 0)


func test_the_open_way_keeps_the_place_and_closed_ones_fit_the_scenery() -> void:
	var corridors: int = 0
	var with_open: int = 0
	for seed: int in SEEDS:
		for map: LegMap in _legs(seed):
			for pair: Array in _corridors(map):
				var from: MapNode = pair[0]
				var entrances: Array[MapNode] = []
				entrances.assign(pair[1])
				if entrances.is_empty():
					continue
				corridors += 1
				var here: Dictionary = SceneryPlan.look(map, from)
				var open: int = 0
				for to: MapNode in entrances:
					var kind: StringName = SceneryPlan.passage(map, from, to)
					if kind == SceneryPlan.OPEN:
						open += 1
						assert_true(SceneryPlan.same_place(here, SceneryPlan.look(map, to)), "aberto só no mesmo lugar")
						assert_eq(CorridorLook.straight_entrance(map, from, entrances), to.id, "aberto só no caminho reto")
					elif kind == SceneryPlan.CAVE:
						assert_eq(here["mid"], SceneryPlan.ROCK_WALL, "caverna só na parede de rocha")
					else:
						assert_true(SceneryPlan.CLOSED_ANYWHERE.has(kind), String(kind))
				assert_lte(open, 1)
				with_open += open
	# Most screens go on along an open way; the place changes now and then
	# (the way to Minos along the jury wall is a place of its own, D-448).
	gut.p("%d de %d corredores com caminho aberto" % [with_open, corridors])
	assert_gt(float(with_open) / corridors, 0.6, "%d de %d corredores com caminho aberto" % [with_open, corridors])


func test_battles_stand_in_a_common_place_of_the_way() -> void:
	var unique: Array[String] = [SceneryPlan.JURY_HALL, SceneryPlan.TIGRIS, SceneryPlan.THRONE]
	for seed: int in SEEDS:
		for map: LegMap in _legs(seed):
			for n: MapNode in map.all_nodes():
				if n.type != MapNode.TYPE_BATTLE:
					continue
				var the_look: Dictionary = SceneryPlan.look(map, n)
				assert_false(unique.has(the_look["mid"]), "trecho %d, %s: lutas comuns em cenário genérico" % [map.leg, n.id])
				assert_eq(the_look["crowd"], "")


func test_every_layer_of_every_look_exists() -> void:
	for seed: int in 10:
		for map: LegMap in _legs(seed):
			var looks: Array[Dictionary] = [SceneryPlan.look(map, null)]
			for n: MapNode in map.all_nodes():
				looks.append(SceneryPlan.look(map, n))
			for the_look: Dictionary in looks:
				for layer: Dictionary in SceneryPlan.back_layers(the_look) + SceneryPlan.front_layers(the_look):
					assert_true(ResourceLoader.exists(str(layer["path"])), str(layer["path"]))


func test_without_an_open_way_the_corridor_ends_in_its_passage() -> void:
	var one := CorridorWalk.make(false, false, [&"l2_n0"] as Array[StringName], &"")
	assert_eq(float(one.entrance_at[&"l2_n0"]), CorridorWalk.STRAIGHT_AT, "a porta no fim, onde o caminho seguiria")
	var two := CorridorWalk.make(false, false, [&"l2_n0", &"l2_n1"] as Array[StringName], &"")
	assert_eq(float(two.entrance_at[two.entrance_order().back()]), CorridorWalk.STRAIGHT_AT)
	var open := CorridorWalk.make(false, false, [&"l2_n0", &"l2_n1"] as Array[StringName], &"l2_n1")
	assert_eq(float(open.entrance_at[&"l2_n0"]), lerpf(CorridorWalk.DETOURS_FROM, CorridorWalk.DETOURS_TO, 0.5))


func test_every_middle_sinks_until_its_ground_is_under_the_feet() -> void:
	var the_look: Dictionary = SceneryPlan.look(_legs(1)[0], null)
	for layer: Dictionary in SceneryPlan.back_layers(the_look):
		var file: String = str(layer["path"]).get_file().get_basename()
		assert_eq(float(layer["sink"]), float(SceneryPlan.SINK.get(file, 0.0)), file)
	assert_gt(float(SceneryPlan.SINK[SceneryPlan.PLAIN]), 0.0, "a planície acaba num barranco escuro: desce")


func test_the_souls_are_never_hidden_behind_the_rock_wall() -> void:
	for seed: int in SEEDS:
		for map: LegMap in _legs(seed):
			for n: MapNode in map.all_nodes():
				if n.type == MapNode.TYPE_SOUL:
					assert_ne(SceneryPlan.look(map, n)["mid"], SceneryPlan.ROCK_WALL, "a multidão de almas fica à vista")
