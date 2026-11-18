class_name AbilityRule
extends RefCounted
## The rule line of an ability, written from its data (D-475): what it does
## (damage and its kind, healing, desolation, tokens), on whom and from where.
## The card shows it under the name, before the line of the story, so its
## numbers are always the battle's own. Every word comes from `ui_text.csv`.

const SEPARATOR: String = " · "


## "6 de exorcismo · num inimigo nas posições 1 a 3 · usa das posições 1 a 3".
static func line(ability: AbilityDef, ui: UiTextDef, catalog: BattleCatalog) -> String:
	var parts: Array[String] = []
	var effects: Array[String] = []
	for effect: EffectDef in ability.effects:
		var text: String = _effect(effect, ui, catalog)
		if not text.is_empty():
			effects.append(text)
	parts.append(", ".join(effects))
	var target: String = _target(ability, ui)
	if not target.is_empty():
		parts.append(target)
	parts.append(_where(ability.use_slots, ui, &"rule_from_one", &"rule_from_many"))
	if ability.once_per_battle:
		parts.append(ui.text(&"rule_once"))
	return SEPARATOR.join(parts)


static func _effect(effect: EffectDef, ui: UiTextDef, catalog: BattleCatalog) -> String:
	var text: String = ""
	match effect.type:
		&"damage":
			text = ui.text(&"rule_damage", {"amount": _number(effect.amount), "kind": ui.text(StringName("rule_kind_%s" % effect.damage_type))})
			if effect.params.has("elite") or effect.params.has("boss"):
				text += " " + ui.text(&"rule_vs_elites", {"mult": _number(float(effect.params.get("elite", effect.params.get("boss", 1.0))))})
		&"heal":
			text = ui.text(&"rule_heal", {"amount": _number(effect.amount)})
		&"desolation":
			var key: StringName = &"rule_desolation_up" if effect.amount > 0.0 else &"rule_desolation_down"
			text = ui.text(key, {"amount": _number(absf(effect.amount))})
		&"apply_condition":
			text = _condition(effect, ui, catalog)
		&"remove_condition":
			text = ui.text(&"rule_remove", {"what": _condition(effect, ui, catalog)})
		&"strip_positive_tokens":
			text = ui.text(&"rule_strip")
		&"move":
			text = ui.text(StringName("rule_move_%s" % effect.move_kind), {"n": effect.n})
		&"revive":
			text = ui.text(&"rule_revive", {"percent": roundi(float(effect.params.get("hp_fraction", 0.0)) * 100.0)})
		_:
			return ""
	if effect.target_override == &"self":
		text = ui.text(&"rule_on_self", {"what": text})
	return text


## "Força" for one stack, "2 Força" for more.
static func _condition(effect: EffectDef, ui: UiTextDef, catalog: BattleCatalog) -> String:
	var condition: ConditionDef = catalog.conditions.get(effect.condition_id)
	var name: String = condition.name_pt if condition != null else String(effect.condition_id)
	return name if effect.stacks <= 1 else "%d %s" % [effect.stacks, name]


static func _target(ability: AbilityDef, ui: UiTextDef) -> String:
	match ability.targeting:
		&"enemy", &"enemy_group", &"ally":
			return ui.text(StringName("rule_target_%s" % ability.targeting), {"where": _where(ability.target_slots, ui, &"rule_where_one", &"rule_where_many")})
		&"all_enemies", &"all_allies", &"self", &"ally_fallen":
			return ui.text(StringName("rule_target_%s" % ability.targeting))
	return ""


## "na posição 1", "nas posições 1 e 2", "nas posições 1 a 4" (or "usa da
## posição 1"..., by the keys given).
static func _where(slots: Array[int], ui: UiTextDef, one_key: StringName, many_key: StringName) -> String:
	if slots.size() == 1:
		return ui.text(one_key, {"a": slots[0]})
	var sorted: Array[int] = slots.duplicate()
	sorted.sort()
	var list: String
	if sorted.size() == 2:
		list = ui.text(&"rule_pair", {"a": sorted[0], "b": sorted[1]})
	elif sorted.back() - sorted.front() == sorted.size() - 1:
		list = ui.text(&"rule_range", {"a": sorted.front(), "b": sorted.back()})
	else:
		list = ", ".join(sorted.map(func(s: int) -> String: return str(s)))
	return ui.text(many_key, {"list": list})


static func _number(value: float) -> String:
	return str(roundi(value)) if is_equal_approx(value, roundf(value)) else str(value)
