class_name MapTemplateDef
extends Resource
## Fixed leg used when the generator fails (expedition §2.1, map_templates.csv,
## data-schemas §3.15). `layers[i]` is layer i + 1: an Array of Dictionaries
## {"role": StringName, "type": StringName, "links": Array of int}, where
## links are indexes in the next layer.

@export var id: StringName = &""
@export var leg: int = 1
@export var layers: Array = []
