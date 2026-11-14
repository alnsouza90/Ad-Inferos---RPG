class_name CorridorWalk
extends RefCounted
## Where the party stands in one corridor (expedition §2.3), as a fraction
## from 0 (start) to 1 (end), and where the node's content and the
## entrances of the next layer stand. Pure presentation: walking has no rule
## (item 2), so nothing here touches the expedition state. The screen moves
## it while the finger is held; tests move it directly.

## Where the node's content stands (tent, chest, soul, enemies).
const CONTENT_AT: float = 0.42
## Detours stand along the final stretch; the straight way at the very end.
const DETOURS_FROM: float = 0.68
const DETOURS_TO: float = 0.88
const STRAIGHT_AT: float = 1.0
## Half the width, in corridor fraction, in which the party "stands before"
## an entrance.
const REACH: float = 0.045

var position: float = 0.0
## Fraction of the content, or -1 when the corridor has none (the one that
## leaves the gate).
var content_at: float = -1.0
## True while the content waits: the party cannot walk past it (item 4).
var content_pending: bool = false
## node id → fraction, in corridor order (detours first, straight last).
var entrance_at: Dictionary = {}


static func make(has_content: bool, pending: bool, entrance_ids: Array[StringName], straight_id: StringName) -> CorridorWalk:
	var w := CorridorWalk.new()
	w.content_at = CONTENT_AT if has_content else -1.0
	w.content_pending = has_content and pending
	var detours: Array[StringName] = []
	for id: StringName in entrance_ids:
		if id != straight_id:
			detours.append(id)
	for i: int in detours.size():
		var t: float = 0.5 if detours.size() == 1 else float(i) / float(detours.size() - 1)
		w.entrance_at[detours[i]] = lerpf(DETOURS_FROM, DETOURS_TO, t)
	if straight_id != &"":
		w.entrance_at[straight_id] = STRAIGHT_AT
	return w


## The furthest point the party can reach now.
func limit_ahead() -> float:
	return content_at if content_pending else 1.0


## Moves by `delta` (negative walks back) and returns the new position.
## Never behind the start (item 3) nor past content still waiting (item 4).
func move(delta: float) -> float:
	position = clampf(position + delta, 0.0, limit_ahead())
	return position


## Places the party, with the same limits as walking.
func place(fraction: float) -> void:
	position = clampf(fraction, 0.0, limit_ahead())


func has_content() -> bool:
	return content_at >= 0.0


## True when the party stands at content that still waits.
func at_pending_content() -> bool:
	return content_pending and position >= content_at - 0.0001


## The entrance the party stands before, else &"".
func entrance_here() -> StringName:
	var best: StringName = &""
	var best_gap: float = REACH
	for id: StringName in entrance_at:
		var gap: float = absf(position - float(entrance_at[id]))
		if gap <= best_gap:
			best = id
			best_gap = gap
	return best


## Entrances ordered as they stand in the corridor.
func entrance_order() -> Array[StringName]:
	var ids: Array[StringName] = []
	for id: StringName in entrance_at:
		ids.append(id)
	ids.sort_custom(func(a: StringName, b: StringName) -> bool: return float(entrance_at[a]) < float(entrance_at[b]))
	return ids
