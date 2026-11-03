class_name Combatant
extends RefCounted
## A saint or enemy on the battlefield (architecture §2). Holds only mutable
## battle state; static data stays in SaintDef / EnemyDef.

enum Team { PARTY, ENEMY }
## STANDING: can act. FALLEN: saint at 0 hp, may still be revived.
## OUT: saint out of the battle (window expired or Prostration).
## DEAD: enemy removed from the queue. REMAINS: enemy corpse holding a slot.
enum State { STANDING, FALLEN, OUT, DEAD, REMAINS }

var id: StringName
var def_id: StringName
var team: Team
var max_hp: int
var hp: int
var armor: int
var faith: int
var will: int
var size: int = 1
var nature: StringName = &""
var desolation: int = 0
## condition_id -> stacks
var conditions: Dictionary = {}
var has_acted: bool = false
var state: State = State.STANDING
## Rounds counted since falling (combat §8); counting starts at that ROUND_END.
var fallen_rounds: int = 0
var revivable: bool = true
var leaves_remains: bool = false
var remains_rounds: int = 0
var remains_left: int = 0
var trait_counters: Dictionary = {}


static func from_saint(def: SaintDef) -> Combatant:
	var c := Combatant.new()
	c._setup_saint(def)
	return c


static func from_enemy(def: EnemyDef, instance_id: StringName) -> Combatant:
	var c := Combatant.new()
	c._setup_enemy(def, instance_id)
	return c


func _setup_saint(def: SaintDef) -> void:
	id = def.id
	def_id = def.id
	team = Team.PARTY
	max_hp = def.max_hp
	hp = def.max_hp
	armor = def.armor
	faith = def.faith
	will = def.will


func _setup_enemy(def: EnemyDef, instance_id: StringName) -> void:
	id = instance_id
	def_id = def.id
	team = Team.ENEMY
	max_hp = def.max_hp
	hp = def.max_hp
	armor = def.armor
	size = def.size
	nature = def.nature
	leaves_remains = def.leaves_remains
	remains_rounds = def.remains_rounds


func is_saint() -> bool:
	return team == Team.PARTY


func is_standing() -> bool:
	return state == State.STANDING


func is_fallen() -> bool:
	return state == State.FALLEN


func is_out() -> bool:
	return state == State.OUT


## Enemies only: alive and occupying the field as a fighter.
func is_alive_enemy() -> bool:
	return team == Team.ENEMY and state == State.STANDING


func stacks(condition_id: StringName) -> int:
	return int(conditions.get(condition_id, 0))


func has_condition(condition_id: StringName) -> bool:
	return stacks(condition_id) > 0
