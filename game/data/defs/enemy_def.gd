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
## Bosses (enemy-ai §6, bosses.md §5). Phase thresholds as fractions of the
## maximum hp (empty: one phase); with the Domínio's extra-phase claw the
## second list is used.
@export var phase_thresholds: Array[float] = []
@export var dominion_phase_thresholds: Array[float] = []
@export var actions_per_round: int = 1
## Actions added by the Domínio's extra-action claw.
@export var dominion_extra_actions: int = 0
## Enemies that start the battle with the boss while the escort claw holds.
@export var dominion_escort: Array[StringName] = []
