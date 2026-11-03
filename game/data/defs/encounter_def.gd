class_name EncounterDef
extends Resource
## A group of enemies (data-schemas §3.9). `slots[i]` is the enemy id at
## position i + 1. `circle` is -1 for the M0 arena ("m0" in the CSV).

const ARENA_CIRCLE: int = -1

@export var id: StringName = &""
@export var circle: int = 0
@export var pool: StringName = &""
@export var slots: Array[StringName] = []
@export var type: StringName = &""
