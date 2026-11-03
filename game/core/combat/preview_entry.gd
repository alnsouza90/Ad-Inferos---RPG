class_name PreviewEntry
extends RefCounted
## What a command would do to one combatant (combat §15). Built from the
## events of the command run on a copy of the battle, so the preview uses the
## exact same rules as the real execution.

var target_id: StringName
var damage: int = 0
var heal: int = 0
## condition_id -> stacks applied / removed by the command.
var applied: Dictionary = {}
var removed: Dictionary = {}
var moved_from: int = 0
var moved_to: int = 0
var falls: bool = false
var intent_cancelled: bool = false


func to_dict() -> Dictionary:
	return {
		"target": String(target_id), "damage": damage, "heal": heal,
		"applied": _plain(applied), "removed": _plain(removed),
		"moved_from": moved_from, "moved_to": moved_to,
		"falls": falls, "intent_cancelled": intent_cancelled,
	}


func _plain(d: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for key: Variant in d:
		result[str(key)] = d[key]
	return result


## Turns a command's events into one entry per affected combatant, in the order
## they were first affected. `cancelled` lists enemies whose intent was
## cancelled by the command.
static func from_events(events: Array[BattleEvent], cancelled: Array[StringName]) -> Array[PreviewEntry]:
	var by_id: Dictionary = {}
	var order: Array[PreviewEntry] = []
	var entry := func(id: Variant) -> PreviewEntry:
		var key := StringName(str(id))
		if not by_id.has(key):
			var e := PreviewEntry.new()
			e.target_id = key
			by_id[key] = e
			order.append(e)
		return by_id[key]
	for ev: BattleEvent in events:
		var d: Dictionary = ev.data
		match ev.type:
			&"damage_dealt", &"bleed_tick", &"self_damaged":
				(entry.call(d["target"]) as PreviewEntry).damage += int(d["amount"])
			&"healed", &"revived":
				(entry.call(d["target"]) as PreviewEntry).heal += int(d["amount"])
			&"condition_applied":
				var e: PreviewEntry = entry.call(d["target"])
				e.applied[d["condition"]] = int(e.applied.get(d["condition"], 0)) + int(d["stacks"])
			&"condition_removed", &"condition_consumed", &"tokens_stripped":
				var e: PreviewEntry = entry.call(d["target"])
				if ev.type == &"tokens_stripped":
					for cond: Variant in d["conditions"]:
						e.removed[cond] = int(e.removed.get(cond, 0)) + 1
				else:
					var cond_id: Variant = d["condition"] if d["condition"] != &"" else d.get("polarity", &"")
					e.removed[cond_id] = int(e.removed.get(cond_id, 0)) + int(d.get("stacks", 1))
			&"moved":
				var e: PreviewEntry = entry.call(d["target"])
				if e.moved_from == 0:
					e.moved_from = int(d["from"])
				e.moved_to = int(d["to"])
			&"fell", &"enemy_died":
				(entry.call(d["target"]) as PreviewEntry).falls = true
	for enemy_id: StringName in cancelled:
		(entry.call(enemy_id) as PreviewEntry).intent_cancelled = true
	return order
