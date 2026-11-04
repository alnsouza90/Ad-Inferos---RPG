class_name ExpeditionCatalog
extends RefCounted
## Read-only definitions an expedition needs (built by the caller from
## game/data or, in tests, from the importer). Core never loads files.

var constants: ConstantsDef
var economy: ConstantsDef
var battle_catalog: BattleCatalog
## saint_id (StringName) -> SaintDef
var saints: Dictionary = {}
## encounter_id (StringName) -> EncounterDef
var encounters: Dictionary = {}
## leg number (int) -> MapTemplateDef used when the generator gives up.
var reserves: Dictionary = {}
## kit_id (StringName) -> StartingKitDef (M1: no village to buy from, D-123).
var starting_kits: Dictionary = {}
## event_id (StringName) -> EventDef
var events: Dictionary = {}


static func create(p_battle_catalog: BattleCatalog, p_economy: ConstantsDef, p_saints: Dictionary, p_encounters: Dictionary, p_reserves: Dictionary) -> ExpeditionCatalog:
	var c := ExpeditionCatalog.new()
	c.battle_catalog = p_battle_catalog
	c.constants = p_battle_catalog.constants
	c.economy = p_economy
	c.saints = p_saints
	c.encounters = p_encounters
	c.reserves = p_reserves
	return c


func kit_provisions(kit_id: StringName) -> Array[StringName]:
	var result: Array[StringName] = []
	var kit: StartingKitDef = starting_kits.get(kit_id)
	if kit != null:
		result = kit.provisions.duplicate()
	return result


## Events of a type and circle, sorted by id (stable draws).
func events_for(type: StringName, circle: int) -> Array[EventDef]:
	var result: Array[EventDef] = []
	var ids: Array = events.keys()
	ids.sort()
	for id: Variant in ids:
		var e: EventDef = events[id]
		if e.type == type and e.circle == circle:
			result.append(e)
	return result


func saint(id: StringName) -> SaintDef:
	return saints.get(id)


func encounter(id: StringName) -> EncounterDef:
	return encounters.get(id)


## Encounter ids of `circle` (EncounterDef.ARENA_CIRCLE for the M0 groups)
## in `pool`, sorted so the draw does not depend on dictionary order.
func encounter_pool(circle: int, pool: StringName) -> Array[StringName]:
	var result: Array[StringName] = []
	for id: StringName in encounters:
		var e: EncounterDef = encounters[id]
		if e.circle == circle and e.pool == pool:
			result.append(id)
	result.sort()
	return result
