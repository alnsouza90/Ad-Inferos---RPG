class_name FirstValidPolicy
extends RefCounted
## Fixed, fully deterministic policy for integration tests (T12): each saint,
## in slot order, uses the first valid ability in equipped order (then the
## miracle); if none, passes. Then the party turn ends. No provisions, no swaps.


## Plays the whole battle. Returns the number of commands sent.
static func play(ctrl: BattleController, max_rounds: int) -> int:
	var sent := 0
	while not ctrl.is_over() and ctrl.state.round_number <= max_rounds:
		var cmd: BattleCommand = choose(ctrl)
		var result: CommandResult = ctrl.execute(cmd)
		assert(result.ok, "policy chose an invalid command: %s (%s)" % [cmd.to_dict(), result.reason])
		sent += 1
	return sent


static func choose(ctrl: BattleController) -> BattleCommand:
	for saint: Combatant in ctrl.state.party:
		if not saint.is_standing() or saint.has_acted:
			continue
		for cmd: BattleCommand in CommandCandidates.for_saint(ctrl, saint, false):
			if cmd.type == BattleCommand.USE_ABILITY or cmd.type == BattleCommand.USE_MIRACLE:
				return cmd
		return BattleCommand.pass_turn(saint.id)
	return BattleCommand.end_party_turn()
