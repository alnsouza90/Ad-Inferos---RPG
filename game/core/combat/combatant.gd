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
## Enemies: &"common", &"elite" or &"boss" (for multiplier_vs). Saints: &"".
var category: StringName = &""
var desolation: int = 0
## condition_id -> stacks
var conditions: Dictionary = {}
## condition_id -> id of whoever applied it (needed for Duel).
var condition_sources: Dictionary = {}
## condition_id -> round at whose end it expires (decay expire_round_end).
var condition_expiry: Dictionary = {}
## Cannot be stunned again while round_number <= this value.
var stun_immune_until: int = 0
## Enemies: conditions they are immune to (data).
var immune: Array[StringName] = []
var has_acted: bool = false
var state: State = State.STANDING
## Rounds counted since falling (combat §8); counting starts at that ROUND_END.
var fallen_rounds: int = 0
var revivable: bool = true
var leaves_remains: bool = false
var remains_rounds: int = 0
var remains_left: int = 0
var trait_counters: Dictionary = {}
## Saints only: the 4 equipped abilities and the signature miracle.
var equipped: Array[StringName] = []
var miracle: StringName = &""
## &"normal", &"consolation" or &"dark_night" (desolation §1).
var spirit_state: StringName = &"normal"
## Purification happened this expedition: +experience (desolation §4.3).
var purified: bool = false
## Injury to apply when the battle ends (e.g. &"major" from Prostration).
var pending_injury: StringName = &""
## Enemies: action_id -> first round in which the action may be used again.
var cooldowns: Dictionary = {}
## Abilities marked once_per_battle already used.
var used_once: Array[StringName] = []


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
	equipped = def.default_equipped.duplicate()
	miracle = def.miracle


func _setup_enemy(def: EnemyDef, instance_id: StringName) -> void:
	id = instance_id
	def_id = def.id
	team = Team.ENEMY
	max_hp = def.max_hp
	hp = def.max_hp
	armor = def.armor
	size = def.size
	nature = def.nature
	category = def.family if def.family == &"elite" or def.family == &"boss" else &"common"
	immune = def.immune.duplicate()
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


func is_dark_night() -> bool:
	return spirit_state == &"dark_night"


## Plain snapshot of the mutable state (determinism and save tests).
func to_dict() -> Dictionary:
	var conds: Dictionary = {}
	for key: StringName in conditions:
		conds[String(key)] = conditions[key]
	var used: Array[String] = []
	for ability_id: StringName in used_once:
		used.append(String(ability_id))
	return {
		"id": String(id), "def_id": String(def_id), "team": team, "state": state,
		"hp": hp, "max_hp": max_hp, "desolation": desolation, "spirit_state": String(spirit_state),
		"conditions": conds, "has_acted": has_acted, "fallen_rounds": fallen_rounds,
		"revivable": revivable, "stun_immune_until": stun_immune_until,
		"purified": purified, "pending_injury": String(pending_injury), "remains_left": remains_left, "used_once": used,
		"trait_counters": trait_counters.duplicate(true),
	}
