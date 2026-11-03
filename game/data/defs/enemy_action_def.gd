class_name EnemyActionDef
extends Resource
## An enemy action (enemy-ai §2). `conditions` holds {name, param} entries,
## e.g. {"name": "self_hp_below", "param": 50}; param is null when absent.

@export var id: StringName = &""
@export var priority: int = 1
@export var use_slots: Array[int] = []
@export var target_slots: Array[int] = []
@export var targeting: StringName = &""
@export var target_rule: StringName = &""
@export var conditions: Array[Dictionary] = []
@export var cooldown: int = 0
@export var intent_icon: StringName = &""
@export var effects: Array[EffectDef] = []
