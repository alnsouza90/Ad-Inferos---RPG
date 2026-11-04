class_name StartingKitDef
extends Resource
## Provisions an expedition starts with when there is no village to buy them
## (M1, D-123; starting_kits.csv, data-schemas §3.16). One entry per unit.

@export var id: StringName = &""
@export var provisions: Array[StringName] = []
