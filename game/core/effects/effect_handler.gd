class_name EffectHandler
extends RefCounted
## Base class: one subclass per effect type (combat §7.1).

## When false the handler runs once per effect instead of once per target
## (e.g. gaining Fervor or summoning).
func per_target() -> bool:
	return true


## Applies `effect` to one target (or once, with target = null).
func apply(_ctx: EffectContext, _effect: EffectDef, _target: Combatant) -> void:
	pass
