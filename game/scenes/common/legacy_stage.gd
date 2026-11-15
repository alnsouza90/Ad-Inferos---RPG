class_name LegacyStage
extends RefCounted
## The screens still laid out on the old 1920 × 1080 stage (title, arena,
## Pouso, event, leg map, animation test) are drawn at half size on the
## 960 × 540 screen until each one is redone in pixel art (ADR-0013, T65).
## They keep the smooth filter: their painted art is not pixel art.

const SCALE: float = 0.5


## Shrinks `stage` (built with `stage_size`) and centres it on `screen_size`.
static func place(stage: Control, stage_size: Vector2, screen_size: Vector2) -> void:
	if stage == null:
		return
	stage.scale = Vector2(SCALE, SCALE)
	stage.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	stage.position = position_for(stage_size, screen_size)


static func position_for(stage_size: Vector2, screen_size: Vector2) -> Vector2:
	return ((screen_size - stage_size * SCALE) * 0.5).floor()


## For a container that fills its parent (a centred menu): it becomes twice
## as big and is drawn at half size, so its old sizes and fonts still fit.
static func fill(node: Control) -> void:
	node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	node.anchor_right = 1.0 / SCALE
	node.anchor_bottom = 1.0 / SCALE
	node.offset_right = 0.0
	node.offset_bottom = 0.0
	node.scale = Vector2(SCALE, SCALE)
	node.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
