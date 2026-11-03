class_name ConditionDef
extends Resource
## A condition record (conditions §2). The engine is generic; `hook` names
## special behaviour implemented once in code.

@export var id: StringName = &""
@export var kind: StringName = &""
@export var polarity: StringName = &""
@export var max_stacks: int = 1
@export var stacking: StringName = &""
@export var decay: StringName = &""
@export var tick: StringName = &""
@export var consume_on: StringName = &""
@export var resisted_by_will: bool = false
@export var hook: StringName = &""
@export var icon: String = ""
@export var display_priority: int = 9
@export var name_pt: String = ""
@export var desc_pt: String = ""
