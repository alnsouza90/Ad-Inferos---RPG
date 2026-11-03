class_name SaintDef
extends Resource
## A playable saint (data-schemas §3.2). Abilities are referenced by id;
## the trait and camp skill are embedded.

@export var id: StringName = &""
@export var name_pt: String = ""
@export var roles: Array[StringName] = []
@export var preferred_slots: Array[int] = []
@export var max_hp: int = 1
@export var armor: int = 0
@export var faith: int = 0
@export var will: int = 0
@export var hp_per_level: int = 0
@export var faith_per_level: int = 0
@export var abilities: Array[StringName] = []
@export var default_equipped: Array[StringName] = []
@export var miracle: StringName = &""
@export var trait_def: TraitDef
@export var camp_skill: CampSkillDef
@export var affinities: Array[StringName] = []
@export var unlock: String = ""
@export var m0: bool = false
