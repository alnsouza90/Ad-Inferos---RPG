class_name EventRules
extends RefCounted
## Requirements and visible chances of event options (narrative-system §3
## and §4.1). Options are the plain dictionaries of EventDef. No hidden
## rolls: whatever affects a chance is shown with it.


## Requirements of the option that the context does not meet (N01). An
## option with any is shown disabled, with the requirement written.
static func unmet_requirements(option: Dictionary, ctx: EventContext) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for r: Dictionary in option.get("requires", []):
		if not requirement_met(r, ctx):
			result.append(r)
	return result


static func requirement_met(r: Dictionary, ctx: EventContext) -> bool:
	var id := StringName(str(r.get("id", "")))
	var value: int = int(r.get("value", 0))
	match str(r.get("type", "")):
		"virtue_at_least":
			return ctx.virtues.get_value(id) >= value
		"saint_in_party":
			return ctx.party.has(id)
		"provision":
			return ctx.provisions.has(id)
		"alms_at_least":
			return ctx.alms >= value
		"flag_set":
			return ctx.flags.has(id)
	return false


static func has_chance(option: Dictionary) -> bool:
	return not (option.get("chance", {}) as Dictionary).is_empty()


## Base plus every modifier that applies, between 0 and 1 (N03: 0.5 with
## Benedict in the party +0.2 shows 70%).
static func chance(option: Dictionary, ctx: EventContext) -> float:
	var c: Dictionary = option.get("chance", {})
	if c.is_empty():
		return 1.0
	var value: float = float(c.get("base", 0.0))
	for m: Dictionary in applying_modifiers(option, ctx):
		value += float(m.get("add", 0.0))
	return clampf(value, 0.0, 1.0)


static func applying_modifiers(option: Dictionary, ctx: EventContext) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var c: Dictionary = option.get("chance", {})
	for m: Dictionary in c.get("modifiers", []):
		var id := StringName(str(m.get("id", "")))
		var applies := false
		match str(m.get("if", "")):
			"saint_in_party":
				applies = ctx.party.has(id)
			"provision":
				applies = ctx.provisions.has(id)
			"relic":
				applies = ctx.relics.has(id)
		if applies:
			result.append(m)
	return result
