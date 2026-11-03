class_name BattleTexts
extends RefCounted
## Turns battle state into the Portuguese strings of the battle screen. Every
## word comes from UiTextDef or from the definitions' name_pt / desc_pt.

## screens §3: at most 3 condition icons per combatant, then "+N".
const MAX_CONDITIONS_SHOWN: int = 3

var ui: UiTextDef
var data: GameData


func _init(p_data: GameData) -> void:
	data = p_data
	ui = p_data.ui


func t(key: StringName, args: Dictionary = {}) -> String:
	return ui.text(key, args)


func reason(code: StringName) -> String:
	return t(StringName("reason_%s" % code))


func name_of(c: Combatant) -> String:
	return data.display_name(c)


func hp(c: Combatant) -> String:
	return t(&"hp", {"hp": c.hp, "max": c.max_hp})


func desolation(c: Combatant) -> String:
	return t(&"desolation", {"value": c.desolation})


## Fallen, out of battle, remains, spiritual state, or "" when nothing to say.
func status(c: Combatant) -> String:
	if c.state == Combatant.State.FALLEN:
		return t(&"state_fallen")
	if c.state == Combatant.State.OUT:
		return t(&"state_out")
	if c.state == Combatant.State.REMAINS:
		return t(&"state_remains")
	if c.state == Combatant.State.DEAD:
		return t(&"state_dead")
	if c.is_saint() and c.spirit_state != Desolation.NORMAL:
		return t(StringName("spirit_%s" % c.spirit_state))
	return ""


## Condition ids on `c`, most important first (display_priority, then id).
func sorted_conditions(c: Combatant) -> Array[StringName]:
	var ids: Array[StringName] = []
	for id: StringName in c.conditions:
		if c.stacks(id) > 0:
			ids.append(id)
	ids.sort_custom(func(a: StringName, b: StringName) -> bool:
		var pa: int = _priority(a)
		var pb: int = _priority(b)
		return pa < pb if pa != pb else String(a) < String(b))
	return ids


func condition_label(c: Combatant, id: StringName) -> String:
	var stacks: int = c.stacks(id)
	var cond_name: String = condition_name(id)
	return t(&"condition_stacks", {"name": cond_name, "stacks": stacks}) if stacks > 1 else cond_name


## Short line under the combatant: up to 3 conditions, then "+N".
func conditions_summary(c: Combatant) -> String:
	var ids: Array[StringName] = sorted_conditions(c)
	var parts: Array[String] = []
	for i: int in mini(ids.size(), MAX_CONDITIONS_SHOWN):
		parts.append(condition_label(c, ids[i]))
	if ids.size() > MAX_CONDITIONS_SHOWN:
		parts.append(t(&"conditions_more", {"count": ids.size() - MAX_CONDITIONS_SHOWN}))
	return " · ".join(parts)


## Full list with descriptions, for the information panel.
func conditions_details(c: Combatant) -> String:
	var ids: Array[StringName] = sorted_conditions(c)
	if ids.is_empty():
		return t(&"no_conditions")
	var lines: Array[String] = []
	for id: StringName in ids:
		var def: ConditionDef = data.catalog.conditions.get(id)
		var desc: String = def.desc_pt if def != null else ""
		lines.append("%s: %s" % [condition_label(c, id), desc])
	return "\n".join(lines)


## The announced intent of an enemy: icon word, predicted number, target slot.
func intent(intent_obj: Intent) -> String:
	if intent_obj == null:
		return ""
	if intent_obj.kind == Intent.KIND_STUNNED:
		return t(&"intent_stunned")
	if intent_obj.kind == Intent.KIND_WAIT:
		return t(&"intent_wait")
	var icon: String = t(StringName("intent_%s" % intent_obj.intent_icon))
	var text: String = icon
	if intent_obj.preview_value > 0:
		text = t(&"intent_value", {"icon": icon, "value": intent_obj.preview_value})
	if intent_obj.target_slot > 0:
		text += " " + t(&"intent_slot", {"slot": intent_obj.target_slot})
	return text


## What a previewed command does to one combatant, as one short line.
func preview_line(entry: PreviewEntry) -> String:
	var parts: Array[String] = []
	if entry.damage > 0:
		parts.append(t(&"preview_damage", {"amount": entry.damage}))
	if entry.heal > 0:
		parts.append(t(&"preview_heal", {"amount": entry.heal}))
	if entry.desolation > 0:
		parts.append(t(&"preview_desolation_up", {"amount": entry.desolation}))
	elif entry.desolation < 0:
		parts.append(t(&"preview_desolation_down", {"amount": -entry.desolation}))
	for id: Variant in entry.applied:
		parts.append(t(&"preview_applied", {"stacks": entry.applied[id], "name": condition_name(StringName(str(id)))}))
	for id: Variant in entry.removed:
		parts.append(t(&"preview_removed", {"stacks": entry.removed[id], "name": condition_name(StringName(str(id)))}))
	if entry.moved_to != 0 and entry.moved_to != entry.moved_from:
		parts.append(t(&"preview_moved", {"slot": entry.moved_to}))
	if entry.falls:
		parts.append(t(&"preview_falls"))
	if entry.intent_cancelled:
		parts.append(t(&"preview_cancelled"))
	return ", ".join(parts)


func ability_name(id: StringName) -> String:
	var def: AbilityDef = data.catalog.ability(id)
	return def.name_pt if def != null else String(id)


func provision_name(id: StringName) -> String:
	var def: ProvisionDef = data.catalog.provision(id)
	return def.name_pt if def != null else String(id)


func condition_name(id: StringName) -> String:
	var def: ConditionDef = data.catalog.conditions.get(id)
	if def != null and def.name_pt != "":
		return def.name_pt
	# remove_condition by polarity previews as "negative" / "positive".
	var polarity_key := StringName("polarity_%s" % id)
	return t(polarity_key) if ui.has_text(polarity_key) else String(id)


func _priority(id: StringName) -> int:
	var def: ConditionDef = data.catalog.conditions.get(id)
	return def.display_priority if def != null else 9
