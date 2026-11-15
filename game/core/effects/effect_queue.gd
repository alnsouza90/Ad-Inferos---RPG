class_name EffectQueue
extends RefCounted
## Resolves effects in order (combat §7.2). Each entry is one effect with its
## targets. Triggered effects (counter-attacks, trait triggers) go to the end.
## Safety limit per command ([effect_queue_limit]): beyond it the queue is
## aborted and the error recorded (protection against infinite loops).

const EV_OVERFLOW: StringName = &"effect_queue_overflow"

var handlers: Dictionary = {}
## Errors recorded while processing (e.g. overflow), for the log.
var errors: Array[String] = []

var _entries: Array[Dictionary] = []
var _limit: int


func _init(limit: int) -> void:
	_limit = limit
	register(&"damage", DamageEffect.new())
	register(&"heal", HealEffect.new())
	register(&"revive", ReviveEffect.new())
	register(&"apply_condition", ApplyConditionEffect.new())
	register(&"remove_condition", RemoveConditionEffect.new())
	register(&"strip_positive_tokens", StripPositiveTokensEffect.new())
	register(&"move", MoveEffect.new())
	register(&"gain_fervor", GainFervorEffect.new())
	register(&"desolation", DesolationEffect.new())
	register(&"summon", SummonEffect.new())
	register(&"self_damage", SelfDamageEffect.new())


func register(type: StringName, handler: EffectHandler) -> void:
	handlers[type] = handler


## Queues `effect` for `ctx`, resolving target_override against the
## ability's own targets.
func enqueue(ctx: EffectContext, effect: EffectDef) -> void:
	_entries.append({"ctx": ctx, "effect": effect, "targets": resolve_targets(ctx, effect)})


## Processes until the queue is empty or the limit is hit. Returns false on overflow.
func process() -> bool:
	var processed := 0
	while not _entries.is_empty():
		if processed >= _limit:
			var ctx: EffectContext = _entries[0]["ctx"]
			var message: String = "fila de efeitos abortada: mais de %d efeitos em '%s'" % [_limit, ctx.source_id]
			errors.append(message)
			ctx.emit.call(EV_OVERFLOW, {"source": ctx.source_id, "limit": _limit, "dropped": _entries.size()})
			_entries.clear()
			return false
		var entry: Dictionary = _entries.pop_front()
		processed += 1
		_run(entry)
	return true


func _run(entry: Dictionary) -> void:
	var ctx: EffectContext = entry["ctx"]
	var effect: EffectDef = entry["effect"]
	var handler: EffectHandler = handlers.get(effect.type)
	if handler == null:
		errors.append("efeito sem tratamento: '%s'" % effect.type)
		return
	if not handler.per_target():
		handler.apply(ctx, effect, null)
		return
	for target: Combatant in entry["targets"]:
		handler.apply(ctx, effect, target)
		_break_enchantment(ctx, effect, target)


## bosses.md §2.3: another saint's ability that heals or blesses an Enchanted
## saint (heal, Ward, Strength, cleansing) breaks the Encanto at once, and the
## company earns a Firmeza.
static func _break_enchantment(ctx: EffectContext, effect: EffectDef, target: Combatant) -> void:
	if ctx.actor == null or not ctx.actor.is_saint() or target == ctx.actor or not target.is_saint():
		return
	if not target.has_condition(&"enchanted") or ctx.state.catalog.ability(ctx.source_id) == null:
		return
	if not _is_blessing(ctx, effect):
		return
	ctx.state.engine.remove_all(target, &"enchanted")
	ctx.emit.call(&"condition_removed", {"target": target.id, "condition": &"enchanted", "stacks": 1})
	ctx.emit.call(&"enchantment_broken", {"actor": ctx.actor.id, "target": target.id})
	if ctx.state.earn_firmness():
		ctx.emit.call(&"firmness_gained", {"actor": ctx.actor.id, "pending": ctx.state.firmness_pending})


static func _is_blessing(ctx: EffectContext, effect: EffectDef) -> bool:
	match effect.type:
		&"heal", &"revive":
			return true
		&"apply_condition":
			var def: ConditionDef = ctx.state.condition_defs.get(effect.condition_id)
			return def != null and def.polarity == &"positive"
		&"remove_condition":
			if effect.polarity == &"negative":
				return true
			var removed: ConditionDef = ctx.state.condition_defs.get(effect.condition_id)
			return removed != null and removed.polarity == &"negative"
	return false


## target_override (combat §7.1): self, all_allies (optionally excluding the
## user) or all_enemies; otherwise the ability's own targets. Group targets
## are in slot order, 1 to 4.
static func resolve_targets(ctx: EffectContext, effect: EffectDef) -> Array[Combatant]:
	var result: Array[Combatant] = []
	match effect.target_override:
		&"self":
			result.append(ctx.actor)
		&"all_allies":
			var exclude_self: bool = float(effect.params.get("exclude_self", 0.0)) > 0.0
			for c: Combatant in _allies_of(ctx):
				if c.is_standing() and not (exclude_self and c == ctx.actor):
					result.append(c)
		&"all_enemies":
			for c: Combatant in _foes_of(ctx):
				if c.is_standing():
					result.append(c)
		_:
			result = ctx.targets.duplicate()
	return result


static func _allies_of(ctx: EffectContext) -> Array[Combatant]:
	return ctx.state.party if ctx.actor == null or ctx.actor.is_saint() else ctx.state.enemies


static func _foes_of(ctx: EffectContext) -> Array[Combatant]:
	return ctx.state.enemies if ctx.actor == null or ctx.actor.is_saint() else ctx.state.party
