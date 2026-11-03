class_name TraitDef
extends Resource
## A saint's passive trait (data-schemas §3.5). Behaviour lives in code under `hook`.

@export var id: StringName = &""
@export var owner: StringName = &""
@export var name_pt: String = ""
@export var desc_pt: String = ""
@export var trigger: StringName = &""
@export var hook: StringName = &""
@export var params: Dictionary = {}
