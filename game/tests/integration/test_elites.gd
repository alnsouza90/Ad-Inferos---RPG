extends GutTest
## T40: the elites of Circle 2 (bosses.md §3 and §4) with the real data:
## Minos and the Vertigem, the Enchanted condition (§2.3) and the elites in
## the variable node of the map (expedition §2.1). Cases B03 to B08.

const G: StringName = &"saint_george"
const B: StringName = &"saint_benedict"
const T: StringName = &"saint_therese"

var data: GameData
var cat: ExpeditionCatalog


func before_all() -> void:
	data = RealData.game_data()
	cat = RealData.expedition_catalog()


func _ctrl(encounter_id: StringName, seed: int = 7) -> BattleController:
	var c := BattleController.new(data.battle(encounter_id, seed))
	c.start()
	return c


func _enemy(c: BattleController, def_id: StringName) -> Combatant:
	for e: Combatant in c.state.enemies:
		if e.def_id == def_id:
			return e
	return null


func _intent(c: BattleController, enemy: Combatant) -> Intent:
	for i: Intent in c.state.intents:
		if i.enemy_id == enemy.id:
			return i
	return null


func _enchant(c: BattleController, id: StringName, rounds: int = 2) -> Combatant:
	var saint: Combatant = c.state.find(id)
	c.state.engine.apply(saint, &"enchanted", rounds)
	EnemyBrain.refresh_intents(c.state)
	return saint


# --- data ---------------------------------------------------------------------------

func test_the_elite_encounters_of_bosses_md() -> void:
	assert_eq(cat.encounter(&"c02_elite_minos").slots, [&"enemy_mud_devil", &"enemy_infernal_scarab", &"elite_minos"] as Array[StringName])
	assert_eq(cat.encounter(&"c02_elite_vertigo").slots, [&"enemy_shade_of_desire", &"elite_sin_vertigo", &"enemy_wandering_breath"] as Array[StringName])
	assert_eq(cat.encounter_pool(2, &"guardian"), [&"c02_elite_minos"] as Array[StringName], "Minos é o Guardião")
	# D-461: the Vertigem with three escorts (easy, medium, hard).
	assert_eq(cat.encounter_pool(2, &"elite"), [&"c02_elite_vertigo", &"c02_elite_vertigo_easy", &"c02_elite_vertigo_hard"] as Array[StringName], "a Vertigem é o Pecado, com três escoltas")
	for id: StringName in cat.encounter_pool(2, &"elite"):
		assert_true(cat.encounter(id).slots.has(&"elite_sin_vertigo"), String(id))
	for id: StringName in cat.encounter_pool(2, &"elite") + cat.encounter_pool(2, &"guardian"):
		assert_eq(cat.encounter(id).type, &"elite")
		assert_eq(cat.encounter(id).hazard, &"gale")
	var minos: EnemyDef = cat.battle_catalog.enemies[&"elite_minos"]
	assert_eq([minos.max_hp, minos.armor], [72, 2])
	var vertigo: EnemyDef = cat.battle_catalog.enemies[&"elite_sin_vertigo"]
	assert_eq([vertigo.max_hp, vertigo.armor, vertigo.nature], [80, 0, &"spiritual"], "80 de vida (D-405)")
	assert_true(vertigo.immune.has(&"stun"))


# --- Minos (B07) ---------------------------------------------------------------------

func test_B07_minos_lashes_the_healthiest_saint_behind_and_pulls_him_to_the_front() -> void:
	var c: BattleController = _ctrl(&"c02_elite_minos")
	# Without the Clausura: next to Benedict the pull is resisted (D-109).
	c.state.find(B).trait_def = null
	var minos: Combatant = _enemy(c, &"elite_minos")
	var intent: Intent = _intent(c, minos)
	assert_eq(intent.action_id, &"minos_tail_lash")
	assert_true(intent.target_slot >= 2, "posições 2 e 3")
	var target: Combatant = c.state.party_at(intent.target_slot)
	var hp: int = target.hp
	var targets: Array[Combatant] = EnemyBrain.execution_targets(c.state, minos, EnemyBrain.action_of(c.state, minos, &"minos_tail_lash"), intent)
	c.resolve_effects(minos, &"minos_tail_lash", EnemyBrain.action_of(c.state, minos, &"minos_tail_lash").effects, targets)
	assert_lt(target.hp, hp, "Rabo de serpente fere")
	assert_eq(c.state.party_slot_of(target), 1, "e puxa para a posição 1")


func test_the_clausura_resists_the_pull_of_minos() -> void:
	var c: BattleController = _ctrl(&"c02_elite_minos")
	var minos: Combatant = _enemy(c, &"elite_minos")
	var action: EnemyActionDef = EnemyBrain.action_of(c.state, minos, &"minos_tail_lash")
	var therese: Combatant = c.state.find(T)
	var slot: int = c.state.party_slot_of(therese)
	c.resolve_effects(minos, &"minos_tail_lash", action.effects, [therese] as Array[Combatant])
	assert_eq(c.state.party_slot_of(therese), slot, "ao lado de Bento, ninguém é puxado")


func test_B07_minos_coils_below_half_hp_and_summons_at_most_one_shade() -> void:
	var c: BattleController = _ctrl(&"c02_elite_minos")
	var minos: Combatant = _enemy(c, &"elite_minos")
	minos.hp = minos.max_hp / 2 - 1
	assert_eq(EnemyBrain.choose(c.state, minos).action_id, &"minos_coil", "Rabo enrolado abaixo de 50%")
	minos.hp = minos.max_hp
	c.state.round_number = 3
	assert_eq(EnemyBrain.choose(c.state, minos).action_id, &"minos_summon", "Invocação a cada 3 rodadas")
	var summon: EnemyActionDef = EnemyBrain.action_of(c.state, minos, &"minos_summon")
	c.resolve_effects(minos, &"minos_summon", summon.effects, [minos] as Array[Combatant])
	c.resolve_effects(minos, &"minos_summon", summon.effects, [minos] as Array[Combatant])
	var shades: int = c.state.enemies.filter(func(e: Combatant) -> bool: return e.def_id == &"enemy_shade_of_desire" and e.is_alive_enemy()).size()
	assert_eq(shades, 1, "no máximo 1 Sombra viva")


# --- the Encanto (B03 to B06, B08) ------------------------------------------------------

func test_B03_single_target_enemy_actions_that_can_reach_the_enchanted_saint_aim_at_him() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	var saint: Combatant = _enchant(c, B)
	var slot: int = c.state.party_slot_of(saint)
	for intent: Intent in c.state.intents:
		var enemy: Combatant = c.state.find(intent.enemy_id)
		var action: EnemyActionDef = EnemyBrain.action_of(c.state, enemy, intent.action_id)
		if intent.kind != Intent.KIND_ACTION or action == null:
			continue
		if action.targeting == &"single" and action.target_slots.has(slot):
			assert_eq(intent.target_slot, slot, "%s mira o Encantado" % intent.action_id)


func test_B04_taunt_wins_over_the_encanto() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	_enchant(c, B)
	var george: Combatant = c.state.find(G)
	c.state.engine.apply(george, &"taunt", 1)
	EnemyBrain.refresh_intents(c.state)
	var george_slot: int = c.state.party_slot_of(george)
	for intent: Intent in c.state.intents:
		var enemy: Combatant = c.state.find(intent.enemy_id)
		var action: EnemyActionDef = EnemyBrain.action_of(c.state, enemy, intent.action_id)
		if intent.kind == Intent.KIND_ACTION and action != null and action.targeting == &"single" and action.target_slots.has(george_slot):
			assert_eq(intent.target_slot, george_slot, "%s mira a Provocação" % intent.action_id)


func test_B05_an_allys_blessing_breaks_the_encanto_and_gives_firmness() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	var benedict: Combatant = _enchant(c, B)
	var result: CommandResult = c.execute(BattleCommand.use_ability(G, &"george_raised_shield", [c.state.party_slot_of(benedict)] as Array[int]))
	assert_true(result.ok)
	assert_false(benedict.has_condition(&"enchanted"), "o Amparo de Jorge quebra o Encanto")
	assert_eq(c.state.firmness_pending, 1, "Firmeza")
	assert_true(result.events.any(func(e: BattleEvent) -> bool: return e.type == &"enchantment_broken"))


func test_B05_the_saints_own_blessing_does_not_break_it() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	var george: Combatant = _enchant(c, G)
	assert_true(c.execute(BattleCommand.use_ability(G, &"george_raised_shield", [c.state.party_slot_of(george)] as Array[int])).ok)
	assert_true(george.has_condition(&"enchanted"))
	assert_eq(c.state.firmness_pending, 0)


func test_B05_breaking_the_encanto_previews_like_it_runs() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	var benedict: Combatant = _enchant(c, B)
	var cmd: BattleCommand = BattleCommand.use_ability(G, &"george_raised_shield", [c.state.party_slot_of(benedict)] as Array[int])
	var preview: Array[PreviewEntry] = c.preview(cmd)
	var entry: PreviewEntry = preview.filter(func(e: PreviewEntry) -> bool: return e.target_id == B)[0]
	assert_eq(entry.removed.get(&"enchanted", 0), 1, "a prévia mostra o Encanto saindo")


func test_the_encanto_lasts_two_rounds_after_the_vertigem_casts_it() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	c.state.in_enemy_phase = true
	var saint: Combatant = c.state.find(T)
	c.state.engine.apply(saint, &"enchanted", 2)
	c.state.in_enemy_phase = false
	var cast_round: int = c.state.round_number
	assert_eq(int(saint.condition_expiry[&"enchanted"]), cast_round + 2, "vale nas intenções das 2 rodadas seguintes")


func test_B08_the_vertigem_does_not_enchant_while_a_saint_is_enchanted() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	var vertigo: Combatant = _enemy(c, &"elite_sin_vertigo")
	assert_eq(EnemyBrain.choose(c.state, vertigo).action_id, &"vertigo_enchant", "Encanto primeiro")
	_enchant(c, B)
	assert_ne(EnemyBrain.choose(c.state, vertigo).action_id, &"vertigo_enchant")


func test_the_vertigem_whirls_every_second_round() -> void:
	var c: BattleController = _ctrl(&"c02_elite_vertigo")
	var vertigo: Combatant = _enemy(c, &"elite_sin_vertigo")
	_enchant(c, B)
	c.state.round_number = 2
	assert_eq(EnemyBrain.choose(c.state, vertigo).action_id, &"vertigo_whirl", "Rodopio a cada 2 rodadas")
	c.state.round_number = 3
	assert_eq(EnemyBrain.choose(c.state, vertigo).action_id, &"vertigo_veils", "Véus nas outras")


# --- the map (expedition §2.1, E01) ------------------------------------------------------

func test_E01_elites_appear_in_the_variable_node_at_most_one_per_path() -> void:
	var elites := 0
	for seed: int in 300:
		var ctrl := ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)
		assert_true(MapGenerator.is_valid(ctrl.map), "semente %d" % seed)
		for layer: Array in ctrl.map.layers:
			for n: MapNode in layer:
				if n.type == MapNode.TYPE_ELITE and n.role == MapNode.ROLE_VARIABLE:
					elites += 1
					assert_true(cat.encounter(n.encounter_id).slots.has(&"elite_sin_vertigo"), "no nó variável, só o Pecado Encarnado (D-406, D-461)")
	assert_gt(elites, 0, "o nó variável sorteia elites")


func test_D407_leg_1_always_ends_with_minos_before_the_camp() -> void:
	for seed: int in 200:
		var ctrl := ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)
		assert_true(MapGenerator.has_guardian(ctrl.map), "semente %d" % seed)
		var last: Array[MapNode] = ctrl.map.layer_nodes(ctrl.map.layer_count())
		assert_eq(last[0].encounter_id, &"c02_elite_minos")
		for path: Array in ctrl.map.paths():
			assert_eq((path.back() as MapNode).role, MapNode.ROLE_GUARDIAN, "todo caminho passa por Minos")


func test_D407_the_party_reaches_the_camp_only_after_minos() -> void:
	var ctrl := ExpeditionController.start_new(cat, &"circle_02", 21, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), GameData.EXPEDITION_ENCOUNTER_CIRCLE)
	var fought_minos := false
	for i: int in 3000:
		if ctrl.phase == ExpeditionController.Phase.AT_CAMP or ctrl.is_over():
			break
		match ctrl.phase:
			ExpeditionController.Phase.AT_FORK:
				ctrl.execute(ExpeditionCommand.choose_path(ctrl.entrances()[0].id))
			ExpeditionController.Phase.PENDING:
				ctrl.execute(ExpeditionCommand.engage_node())
			ExpeditionController.Phase.IN_NODE:
				ctrl.execute(ExpeditionCommand.complete_node())
			ExpeditionController.Phase.IN_EVENT:
				ctrl.execute(ExpeditionCommand.choose_option(&"follow_tracks"))
			ExpeditionController.Phase.IN_RELIC:
				ctrl.execute(ExpeditionCommand.place_relic())
			ExpeditionController.Phase.IN_BATTLE:
				if ctrl.battle.state.enemies.any(func(e: Combatant) -> bool: return e.def_id == &"elite_minos"):
					fought_minos = true
				# Win at once: this test is about the path, not the fight.
				for e: Combatant in ctrl.battle.state.enemies:
					e.hp = 0
					e.state = Combatant.State.DEAD
				ctrl.battle.phase = BattleController.Phase.VICTORY
				ctrl._resolve_battle()
	assert_eq(ctrl.phase, ExpeditionController.Phase.AT_CAMP)
	assert_true(fought_minos, "Minos antes do Pouso")


func test_the_arena_legs_still_have_no_elites() -> void:
	for seed: int in 50:
		var ctrl := ExpeditionController.start_new(cat, &"circle_02", seed, RealData.m0_party_ids(), cat.kit_provisions(&"m1_kit"), EncounterDef.ARENA_CIRCLE)
		for layer: Array in ctrl.map.layers:
			for n: MapNode in layer:
				assert_ne(n.type, MapNode.TYPE_ELITE)
