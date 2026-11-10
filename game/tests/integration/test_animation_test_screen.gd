extends GutTest
## T35: "Animações (teste)" in the arena and the frame animation of
## CombatantView (idle and walk loops, attack with slide and blow, defend,
## hit, fall).

const FAST: float = 8.0

var data: GameData
var screen: AnimationTestScreen


func before_all() -> void:
	data = RealData.game_data()


func before_each() -> void:
	screen = AnimationTestScreen.new()
	screen.setup(data)
	screen.speed = FAST
	add_child_autofree(screen)


func test_arena_opens_and_closes_the_animation_screen() -> void:
	var arena := ArenaScreen.new()
	arena.setup(data)
	add_child_autofree(arena)
	arena.open_animations()
	assert_not_null(arena.animations)
	assert_eq(arena.animations.character_ids.size(), 6)
	arena.animations.press_back()
	assert_null(arena.animations, "voltou à arena")


func test_every_text_of_the_screen_exists() -> void:
	var keys: Array[String] = ["arena_animations", "anim_test_title", "back_to_arena"]
	for move: StringName in AnimationTestScreen.MOVES:
		keys.append("anim_%s" % move)
	for id: StringName in screen.character_ids:
		keys.append("anim_name_%s" % id)
	for key: String in keys:
		assert_true(data.ui.has_text(StringName(key)), "ui_text.csv tem '%s'" % key)


func test_saints_stand_left_enemies_right_with_an_opponent() -> void:
	screen.choose(&"saint_george")
	assert_eq(screen.actor.combatant_id, &"saint_george")
	assert_eq(screen.opponent.combatant_id, &"elite_sin_vertigo")
	assert_lt(screen.actor.position.x, screen.opponent.position.x)
	screen.choose(&"boss_asmodeus")
	assert_eq(screen.opponent.combatant_id, &"saint_george")
	assert_gt(screen.actor.position.x, screen.opponent.position.x)


func test_idle_and_walk_loop() -> void:
	screen.choose(&"saint_therese")
	var player: FramePlayer = screen.actor.player()
	assert_eq(player.clip_id(), &"idle")
	screen.play(&"walk")
	assert_eq(player.clip_id(), &"walk")
	player.advance(10.0)
	assert_false(player.is_finished(), "o ciclo nunca termina")
	screen.play(&"idle")
	assert_eq(player.clip_id(), &"idle")


func test_an_enemy_without_walk_stays_idle() -> void:
	screen.choose(&"elite_minos")
	screen.play(&"walk")
	assert_eq(screen.actor.player().clip_id(), &"idle")


func test_attack_slides_to_the_target_lands_the_blow_and_comes_back() -> void:
	screen.choose(&"saint_george")
	var impacts: Array[Vector2] = []
	screen.actor.impact.connect(func(at: Vector2, _s: float) -> void: impacts.append(at))
	var home: Vector2 = screen.actor.position
	var t: float = screen.play(&"attack")
	assert_gt(t, 0.0)
	assert_eq(screen.actor.player().clip_id(), &"windup")
	var peak: Array[float] = [0.0]
	var watch := func() -> bool:
		peak[0] = maxf(peak[0], _body_offset(screen.actor))
		return impacts.size() > 0
	await wait_until(watch, t + 2.0)
	assert_gt(peak[0], CombatantView.STATIONARY_LEAN, "Jorge desliza até o alvo")
	await wait_seconds(t + 0.2)
	assert_eq(impacts.size(), 1, "um golpe")
	assert_eq(screen.opponent.player().clip_id(), &"idle", "o alvo reagiu e voltou ao parado")
	assert_eq(screen.actor.player().clip_id(), &"idle")
	assert_eq(screen.actor.position, home)
	assert_gt(impacts[0].x, home.x, "o golpe acontece à frente de Jorge")


func test_minos_attacks_from_the_throne() -> void:
	screen.choose(&"elite_minos")
	var seen: Dictionary = {"strike": false, "offset": 0.0}
	var t: float = screen.play(&"attack")
	assert_gt(t, 0.0)
	var watch := func() -> bool:
		var clip: StringName = screen.actor.player().clip_id()
		if clip == &"strike":
			seen["strike"] = true
		seen["offset"] = maxf(float(seen["offset"]), absf(_body_offset(screen.actor)))
		return bool(seen["strike"]) and clip == &"idle"
	await wait_until(watch, t + 2.0)
	assert_true(seen["strike"], "mostrou a chicotada")
	assert_lte(float(seen["offset"]), CombatantView.STATIONARY_LEAN + 0.1, "não sai do trono")


func test_defend_and_hit_go_back_to_idle() -> void:
	screen.choose(&"saint_benedict")
	var t: float = screen.play(&"defend")
	assert_eq(screen.actor.player().clip_id(), &"defend")
	await wait_seconds(t + 0.1)
	assert_eq(screen.actor.player().clip_id(), &"idle")
	t = screen.play(&"hit")
	assert_eq(screen.actor.player().clip_id(), &"hit")
	await wait_seconds(t + 0.1)
	assert_eq(screen.actor.player().clip_id(), &"idle")


func test_fall_holds_and_the_next_move_stands_up_again() -> void:
	screen.choose(&"saint_therese")
	screen.play(&"fall")
	var player: FramePlayer = screen.actor.player()
	player.advance(10.0)
	assert_eq(player.clip_id(), &"fall")
	assert_eq(player.frame(), player.frames.clip(&"fall").count - 1, "fica no último quadro")
	screen.play(&"idle")
	assert_eq(screen.actor.player().clip_id(), &"idle", "levantou para o próximo movimento")


func test_every_character_plays_every_move() -> void:
	for id: StringName in screen.character_ids:
		screen.choose(id)
		for move: StringName in AnimationTestScreen.MOVES:
			assert_gte(screen.play(move), 0.0, "%s %s" % [id, move])
		assert_eq(screen.actor.player().clip_id(), &"fall", String(id))


func test_asmodeus_attacks_from_afar_and_hits_the_target() -> void:
	screen.choose(&"boss_asmodeus")
	var impacts: Array[Vector2] = []
	screen.actor.impact.connect(func(at: Vector2, _s: float) -> void: impacts.append(at))
	var seen: Dictionary = {"offset": 0.0}
	# Where the target stands before it recoils from the blow.
	var target: Vector2 = screen.opponent.chest_global()
	var t: float = screen.play(&"attack")
	var watch := func() -> bool:
		seen["offset"] = maxf(float(seen["offset"]), absf(_body_offset(screen.actor)))
		return impacts.size() > 0
	await wait_until(watch, t + 2.0)
	assert_lte(float(seen["offset"]), CombatantView.STATIONARY_LEAN + 0.1, "ataca de longe, com a fumaça")
	assert_eq(impacts[0], target, "o golpe cai sobre o alvo")
	await wait_seconds(t)


func test_a_spell_is_cast_in_place_and_lands_lighter_on_the_target() -> void:
	screen.choose(&"saint_therese")
	var hits: Array[float] = []
	screen.actor.impact.connect(func(_at: Vector2, strength: float) -> void: hits.append(strength))
	var seen: Dictionary = {"offset": 0.0}
	var t: float = screen.play(&"spell")
	assert_gt(t, 0.0)
	var watch := func() -> bool:
		seen["offset"] = maxf(float(seen["offset"]), absf(_body_offset(screen.actor)))
		return hits.size() > 0
	await wait_until(watch, t + 2.0)
	assert_eq(float(seen["offset"]), 0.0, "magia não desliza (D-233)")
	assert_eq(hits.size(), 1)
	assert_lt(hits[0], 1.0, "mais leve que um golpe físico")
	await wait_seconds(t)


func test_a_blessing_shows_its_light_and_goes_back_to_idle() -> void:
	screen.choose(&"saint_benedict")
	var t: float = screen.play(&"blessing")
	assert_gt(t, 0.0)
	var field: Node = screen.actor.get_parent()
	var has_light := func() -> bool:
		for child: Node in field.get_children():
			if child is SpellEffect:
				return true
		return false
	await wait_until(has_light, t + 2.0)
	assert_true(has_light.call(), "a luz da bênção aparece")
	await wait_until(func() -> bool: return screen.actor.player().clip_id() == &"idle", t + 2.0)
	assert_eq(screen.actor.player().clip_id(), &"idle")


func _body_offset(view: CombatantView) -> float:
	for child: Node in view.get_children():
		var panel := child as Panel
		if panel != null:
			return panel.position.x
	return 0.0
