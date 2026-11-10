class_name FrameClip
extends Resource
## One animation clip of a character (D-194, T35): a grid of frames in one
## sheet, made by tools/art/process_frames.py from Alan's videos and poses.
## Presentation only: no rule of the game depends on it.

## &"idle", &"walk", &"windup", &"strike", &"defend", &"hit" or &"fall".
@export var id: StringName
## Loaded only when the clip first plays, so a battle does not keep every
## sheet of every character in memory.
@export var sheet_path: String
@export var frame_size: Vector2i = Vector2i.ONE
@export var columns: int = 1
@export var count: int = 1
## Frames per second; 0 for a single drawn pose, which holds for `pose_time`.
@export var fps: float = 0.0
@export var looping: bool = false
## The feet of the character inside a frame, in pixels: every clip of one
## character puts its feet on the same point of the screen.
@export var anchor: Vector2 = Vector2.ZERO
## Frame where the blow lands (strike clips), or -1.
@export var impact_frame: int = -1
## Seconds a single pose is held (presentation timing, not a game number).
@export var pose_time: float = 0.4


## Seconds of one pass through the clip at normal speed.
func duration() -> float:
	if fps <= 0.0:
		return pose_time
	return count / fps


## Seconds from the start of the clip to the blow (0 when there is none).
func impact_time() -> float:
	if impact_frame < 0 or fps <= 0.0:
		return 0.0
	return impact_frame / fps


## Which frame shows `time` seconds after the clip started. A clip that
## does not loop stops on its last frame.
func frame_at(time: float) -> int:
	if count <= 1 or fps <= 0.0:
		return 0
	var index: int = int(floor(maxf(time, 0.0) * fps))
	if looping:
		return index % count
	return mini(index, count - 1)


## The area of `frame` inside the sheet.
func region(frame: int) -> Rect2:
	var i: int = clampi(frame, 0, count - 1)
	var cell := Vector2((i % columns) * frame_size.x, (i / columns) * frame_size.y)
	return Rect2(cell, Vector2(frame_size))
