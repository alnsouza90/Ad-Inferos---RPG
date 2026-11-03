class_name CommandResult
extends RefCounted
## Answer to BattleController.execute(): accepted with its events, or rejected
## with a stable reason code (the screen maps codes to Portuguese text from data).

const NOT_PARTY_TURN: StringName = &"not_party_turn"
const UNKNOWN_COMMAND: StringName = &"unknown_command"
const UNKNOWN_ACTOR: StringName = &"unknown_actor"
const NOT_STANDING: StringName = &"not_standing"
const STUNNED: StringName = &"stunned"
const ALREADY_ACTED: StringName = &"already_acted"
const NOT_EQUIPPED: StringName = &"not_equipped"
const UNKNOWN_ABILITY: StringName = &"unknown_ability"
const WRONG_SLOT: StringName = &"wrong_slot"
const NOT_ENOUGH_FERVOR: StringName = &"not_enough_fervor"
const DARK_NIGHT: StringName = &"dark_night"
const INVALID_TARGET: StringName = &"invalid_target"
const ALREADY_USED: StringName = &"already_used"
const NO_PROVISION: StringName = &"no_provision"
const NOT_USABLE_IN_BATTLE: StringName = &"not_usable_in_battle"
const PROVISION_LIMIT: StringName = &"provision_limit"
const RETREAT_NOT_ALLOWED: StringName = &"retreat_not_allowed"

var ok: bool = false
var reason: StringName = &""
var events: Array[BattleEvent] = []


static func accepted(p_events: Array[BattleEvent]) -> CommandResult:
	var result := CommandResult.new()
	result.ok = true
	result.events = p_events
	return result


static func rejected(p_reason: StringName) -> CommandResult:
	var result := CommandResult.new()
	result.reason = p_reason
	return result
