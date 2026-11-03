class_name BattleCommand
extends RefCounted
## A player command (combat §4.1) as plain data. The controller validates and
## executes it; accepted commands are logged with to_dict() so a battle can be
## rebuilt from its seed and log (ADR-0005). Built with the static factories.

const USE_ABILITY: StringName = &"UseAbility"
const USE_MIRACLE: StringName = &"UseMiracle"
const SWAP_SLOTS: StringName = &"SwapSlots"
const PASS: StringName = &"Pass"
const USE_PROVISION: StringName = &"UseProvision"
const END_PARTY_TURN: StringName = &"EndPartyTurn"
const RETREAT_BATTLE: StringName = &"RetreatBattle"

var type: StringName
var actor_id: StringName = &""
var ability_id: StringName = &""
var provision_id: StringName = &""
## Chosen target slots: one for single targets, n for chosen_enemy_slots(n),
## none for self / group / all.
var target_slots: Array[int] = []
## SwapSlots only: -1 toward slot 1, +1 toward the back.
var direction: int = 0


static func use_ability(p_actor: StringName, p_ability: StringName, p_targets: Array[int] = []) -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = USE_ABILITY
	cmd.actor_id = p_actor
	cmd.ability_id = p_ability
	cmd.target_slots = p_targets.duplicate()
	return cmd


static func use_miracle(p_actor: StringName, p_targets: Array[int] = []) -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = USE_MIRACLE
	cmd.actor_id = p_actor
	cmd.target_slots = p_targets.duplicate()
	return cmd


static func swap_slots(p_actor: StringName, p_direction: int) -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = SWAP_SLOTS
	cmd.actor_id = p_actor
	cmd.direction = p_direction
	return cmd


static func pass_turn(p_actor: StringName) -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = PASS
	cmd.actor_id = p_actor
	return cmd


## `p_actor` is the saint who applies it; it does not spend that saint's action.
static func use_provision(p_provision: StringName, p_target_slot: int, p_actor: StringName) -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = USE_PROVISION
	cmd.provision_id = p_provision
	cmd.actor_id = p_actor
	cmd.target_slots = [p_target_slot] as Array[int]
	return cmd


static func end_party_turn() -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = END_PARTY_TURN
	return cmd


static func retreat() -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = RETREAT_BATTLE
	return cmd


func to_dict() -> Dictionary:
	var data: Dictionary = {"type": String(type)}
	if actor_id != &"":
		data["actor"] = String(actor_id)
	if ability_id != &"":
		data["ability"] = String(ability_id)
	if provision_id != &"":
		data["provision"] = String(provision_id)
	if not target_slots.is_empty():
		data["targets"] = Array(target_slots)
	if direction != 0:
		data["direction"] = direction
	return data


static func from_dict(data: Dictionary) -> BattleCommand:
	var cmd := BattleCommand.new()
	cmd.type = StringName(str(data["type"]))
	cmd.actor_id = StringName(str(data.get("actor", "")))
	cmd.ability_id = StringName(str(data.get("ability", "")))
	cmd.provision_id = StringName(str(data.get("provision", "")))
	for slot: Variant in data.get("targets", []):
		cmd.target_slots.append(int(slot))
	cmd.direction = int(data.get("direction", 0))
	return cmd
