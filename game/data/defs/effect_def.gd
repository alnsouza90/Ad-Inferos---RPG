class_name EffectDef
extends Resource
## One unit of result inside an ability, enemy action or provision
## (data-schemas §3.4, combat §7.1). Immutable at runtime.

@export var order: int = 1
@export var type: StringName = &""
@export var amount: float = 0.0
@export var damage_type: StringName = &""
@export var condition_id: StringName = &""
@export var stacks: int = 0
@export var polarity: StringName = &""
@export var move_kind: StringName = &""
@export var n: int = 0
@export var summon_id: StringName = &""
@export var max_alive: int = 0
@export var target_override: StringName = &""
@export var params: Dictionary = {}
