class_name UiTextDef
extends Resource
## Interface texts shown to the player (buttons, prompts, refusal reasons),
## imported from docs/balance/ui_text.csv. Keys are stable ids; values are in
## Portuguese and may hold {named} placeholders (ADR-0009: no text in code).

@export var texts: Dictionary = {}


func has_text(key: StringName) -> bool:
	return texts.has(String(key))


## The text for `key` with `args` filled in. A missing key shows as [key], so
## a gap is visible on screen instead of an empty label.
func text(key: StringName, args: Dictionary = {}) -> String:
	if not has_text(key):
		return "[%s]" % key
	var raw: String = texts[String(key)]
	return raw.format(args) if not args.is_empty() else raw
