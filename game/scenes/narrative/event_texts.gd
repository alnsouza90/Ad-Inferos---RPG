class_name EventTexts
extends RefCounted
## Portuguese strings of the event screen (screens §6). The event's own
## text comes from EventDef (text_pt); every label comes from UiTextDef.

## The narrator has no name tab: its lines are shown in italics (D-151).
const NARRATOR: StringName = &"narrator"

var ui: UiTextDef
var data: GameData


func _init(p_data: GameData) -> void:
	data = p_data
	ui = p_data.ui


func t(key: StringName, args: Dictionary = {}) -> String:
	return ui.text(key, args)


## Name shown in the tab, "" for the narrator.
func speaker(speaker_id: StringName) -> String:
	if speaker_id == NARRATOR or speaker_id == &"":
		return ""
	return t(StringName("speaker_%s" % speaker_id))


## "Inspirado em Dante", "Criação do jogo"... (narrative-system §6).
func origin(origin_id: StringName) -> String:
	return t(StringName("origin_%s" % origin_id))


## The line under the option's text: its requirements ("Exige Fé 3") and
## its chance with what is helping it ("Chance 70%: Bento na equipe").
func option_detail(option: Dictionary, ctx: EventContext) -> String:
	var parts: Array[String] = []
	for r: Dictionary in option.get("requires", []):
		parts.append(requirement(r))
	if EventRules.has_chance(option):
		var helping: Array[String] = []
		for m: Dictionary in EventRules.applying_modifiers(option, ctx):
			helping.append(modifier(m))
		var pct: int = roundi(EventRules.chance(option, ctx) * 100.0)
		if helping.is_empty():
			parts.append(t(&"event_chance", {"pct": pct}))
		else:
			parts.append(t(&"event_chance_with", {"pct": pct, "helping": ", ".join(helping)}))
	return " · ".join(parts)


func requirement(r: Dictionary) -> String:
	var id := StringName(str(r.get("id", "")))
	var value: int = int(r.get("value", 0))
	match str(r.get("type", "")):
		"virtue_at_least":
			return t(&"event_requires_virtue", {"virtue": t(id), "value": value})
		"saint_in_party":
			return t(&"event_requires_saint", {"saint": saint_name(id)})
		"provision":
			return t(&"event_requires_provision", {"provision": provision_name(id)})
		"alms_at_least":
			return t(&"event_requires_alms", {"value": value})
	return t(&"event_requires_flag")


func modifier(m: Dictionary) -> String:
	var id := StringName(str(m.get("id", "")))
	match str(m.get("if", "")):
		"saint_in_party":
			return t(&"event_helps_saint", {"saint": saint_name(id)})
		"provision":
			if m.get("consume", false):
				return t(&"event_helps_provision_spent", {"provision": provision_name(id)})
			return t(&"event_helps_provision", {"provision": provision_name(id)})
	return t(&"event_helps_relic")


## "+5" or "−5" (with the minus sign, not a hyphen).
static func signed(value: int) -> String:
	return "+%d" % value if value > 0 else "−%d" % absi(value)


func saint_name(id: StringName) -> String:
	var def: SaintDef = data.saints.get(id)
	return def.name_pt if def != null else String(id)


func provision_name(id: StringName) -> String:
	var def: ProvisionDef = data.catalog.provision(id)
	return def.name_pt if def != null else String(id)
