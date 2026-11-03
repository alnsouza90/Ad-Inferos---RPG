class_name ProvisionDef
extends Resource
## An expedition provision (data-schemas §3.10).

@export var id: StringName = &""
@export var name_pt: String = ""
@export var price: int = 0
@export var usable_in_battle: bool = false
@export var targeting: StringName = &""
@export var effects: Array[EffectDef] = []
