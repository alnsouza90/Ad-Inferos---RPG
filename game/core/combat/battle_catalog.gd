class_name BattleCatalog
extends RefCounted
## Read-only definitions a battle consults (constants, conditions, abilities,
## provisions, enemies for summons). Built from game/data at runtime or by
## hand in tests. Keys are StringName ids.

var constants: ConstantsDef
var conditions: Dictionary = {}
var abilities: Dictionary = {}
var provisions: Dictionary = {}
var enemies: Dictionary = {}


static func create(p_constants: ConstantsDef, p_conditions: Dictionary = {}, p_abilities: Dictionary = {}, p_provisions: Dictionary = {}, p_enemies: Dictionary = {}) -> BattleCatalog:
	var catalog := BattleCatalog.new()
	catalog.constants = p_constants
	catalog.conditions = p_conditions
	catalog.abilities = p_abilities
	catalog.provisions = p_provisions
	catalog.enemies = p_enemies
	return catalog


func ability(id: StringName) -> AbilityDef:
	return abilities.get(id)


func provision(id: StringName) -> ProvisionDef:
	return provisions.get(id)
