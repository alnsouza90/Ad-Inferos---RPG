class_name AbilityDef
extends Resource
## A saint ability (data-schemas §3.3). Effects are resolved in `order`.

@export var id: StringName = &""
@export var owner: StringName = &""
@export var name_pt: String = ""
@export var kind: StringName = &""
@export var cost: int = 0
@export var use_slots: Array[int] = []
@export var targeting: StringName = &""
## Number of slots chosen for `chosen_enemy_slots(n)`; 0 otherwise.
@export var target_count: int = 0
@export var target_slots: Array[int] = []
@export var allow_self: bool = false
@export var once_per_battle: bool = false
@export var origin: StringName = &""
## Raw upgrade exception string; empty means the general "+" rule.
@export var upgrade: String = ""
@export var desc_pt: String = ""
@export var effects: Array[EffectDef] = []
