class_name EnemyDef
extends Resource
## An enemy (data-schemas §3.7). Its actions are embedded, in priority order.

@export var id: StringName = &""
@export var name_pt: String = ""
@export var family: StringName = &""
@export var circles: Array[int] = []
@export var nature: StringName = &""
@export var role: StringName = &""
@export var size: int = 1
@export var max_hp: int = 1
@export var armor: int = 0
@export var immune: Array[StringName] = []
@export var leaves_remains: bool = false
@export var remains_rounds: int = 0
@export var actions: Array[EnemyActionDef] = []
@export var art_id: String = ""
