class_name DesolationContext
extends RefCounted
## Everything a desolation change depends on besides the saint (desolation §2).
## Multipliers owned by later tasks default to 1.0: affinity Carmel (T10),
## relics, liturgical season (village), Faith check bonuses (relics, John of
## the Cross, Mansions).

var constants: ConstantsDef
## Stream used for the Faith check (`faith`).
var rng: RngStream
## Current Light, or -1 outside expeditions.
var light: int = -1
var affinity_mult: float = 1.0
var relic_mult: float = 1.0
var season_mult: float = 1.0
var faith_bonus: float = 0.0
## Set during a battle: Prostration makes the saint fall in it.
var battle: BattleState
var emit: Callable = func(_type: StringName, _data: Dictionary) -> void: pass
