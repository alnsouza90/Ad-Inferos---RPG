class_name RelicDef
extends Resource
## A relic (data-schemas §3.11; modifiers in §4). It always points to the
## saint and to God, never acts as a power of its own (GDD §10).

@export var id: StringName = &""
@export var name_pt: String = ""
@export var category: StringName = &""
@export var relic_class: StringName = &""
@export var origin: StringName = &""
@export var to_confirm: bool = false
@export var rarity: StringName = &""
@export var source: String = ""
@export var modifier: StringName = &""
@export var params: Dictionary = {}
@export var desc_pt: String = ""
