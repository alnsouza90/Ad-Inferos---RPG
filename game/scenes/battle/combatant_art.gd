class_name CombatantArt
extends Resource
## The art of one saint on the battle screen: one body image per spiritual
## state (ADR-0007: animation in the engine from one image per state) and the
## head point where the halo sits (ADR-0008). Head points are fractions of
## the body texture (0..1), measured by tools/art/process_art.py's output.

@export var body_normal: Texture2D
@export var body_dark_night: Texture2D
@export var body_consolation: Texture2D
@export var head_normal: Vector2 = Vector2(0.5, 0.2)
@export var head_dark_night: Vector2 = Vector2(0.5, 0.2)
@export var head_consolation: Vector2 = Vector2(0.5, 0.2)
## Halo disk diameter as a fraction of the body texture width.
@export var halo_diameter: float = 0.27


func body_for(spirit_state: StringName) -> Texture2D:
	if spirit_state == Desolation.DARK_NIGHT and body_dark_night != null:
		return body_dark_night
	if spirit_state == Desolation.CONSOLATION and body_consolation != null:
		return body_consolation
	return body_normal


func head_for(spirit_state: StringName) -> Vector2:
	if spirit_state == Desolation.DARK_NIGHT:
		return head_dark_night
	if spirit_state == Desolation.CONSOLATION:
		return head_consolation
	return head_normal
