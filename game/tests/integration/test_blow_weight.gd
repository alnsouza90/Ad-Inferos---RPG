extends GutTest
## T59: the weight of the blow (D-353, docs/fable/03-animacao.md §2 and §3)
## — four weights, the phrase of the blow, and one switch per gesture on
## "Animações (teste)" (D-358): freeze, recoil past its place, camera with a
## side, shadow on the ground, anticipation and blur. Presentation only.

const FAST: float = 8.0
const FRAMES_DIR: String = "res://scenes/battle/combatants"

var data: GameData
var screen: AnimationTestScreen


func before_all() -> void:
	data = RealData.game_data()


func before_each() -> void:
	screen = AnimationTestScreen.new()
	screen.setup(data)
	screen.speed = FAST
	add_child_autofree(screen)


func _body(view: CombatantView) -> Panel:
	for child: Node in view.get_children():
		if child is Panel:
			return child as Panel
	return null


# --- weights -------------------------------------------------------------------------

func test_the_phrase_of_the_blow_follows_the_table() -> void:
	assert_almost_eq(BlowWeight.phrase_time(BlowWeight.LIGHT), 0.71, 0.001)
	assert_almost_eq(BlowWeight.phrase_time(BlowWeight.MEDIUM), 0.96, 0.001)
	assert_almost_eq(BlowWeight.phrase_time(BlowWeight.HEAVY), 1.34, 0.001)
	assert_gt(BlowWeight.phrase_time(BlowWeight.COLOSSAL), BlowWeight.phrase_time(BlowWeight.HEAVY))


func test_heavier_freezes_longer_and_recoils_less() -> void:
	for i: int in BlowWeight.ALL.size() - 1:
		var lighter: StringName = BlowWeight.ALL[i]
		var heavier: StringName = BlowWeight.ALL[i + 1]
		assert_gt(BlowWeight.value(heavier, "freeze"), BlowWeight.value(lighter, "freeze"))
		assert_lt(BlowWeight.value(heavier, "recoil"), BlowWeight.value(lighter, "recoil"))
		assert_gt(BlowWeight.value(heavier, "push"), BlowWeight.value(lighter, "push"))


func test_an_unknown_weight_counts_as_medium() -> void:
	assert_eq(BlowWeight.of(&"feather"), BlowWeight.of(BlowWeight.MEDIUM))


func test_every_animated_character_has_one_of_the_four_weights() -> void:
	var count: int = 0
	for file: String in ResourceLoader.list_directory(FRAMES_DIR):
		if not file.ends_with("_frames.tres"):
			continue
		var frames: CharacterFrames = load(FRAMES_DIR.path_join(file)) as CharacterFrames
		assert_true(BlowWeight.ALL.has(frames.weight), "%s: %s" % [file, frames.weight])
		count += 1
	assert_gt(count, 0)


func test_the_weights_proposed_for_the_saints_and_asmodeus() -> void:
	assert_eq(AnimationTestScreen.frames_of(&"saint_george").weight, BlowWeight.MEDIUM)
	assert_eq(AnimationTestScreen.frames_of(&"saint_benedict").weight, BlowWeight.HEAVY)
	assert_eq(AnimationTestScreen.frames_of(&"saint_therese").weight, BlowWeight.LIGHT)
	assert_eq(AnimationTestScreen.frames_of(&"boss_asmodeus").weight, BlowWeight.COLOSSAL)


# --- switches ------------------------------------------------------------------------

func test_one_switch_per_gesture_all_on_at_first() -> void:
	for gesture: StringName in BlowGestures.ALL:
		assert_true(screen.gestures.is_on(gesture), String(gesture))
		assert_true(data.ui.has_text(StringName("anim_gesture_%s" % gesture)), "ui_text.csv tem o nome de %s" % gesture)
	screen.toggle_gesture(BlowGestures.FREEZE)
	assert_false(screen.gestures.is_on(BlowGestures.FREEZE))
	screen.toggle_gesture(BlowGestures.FREEZE)
	assert_true(screen.gestures.is_on(BlowGestures.FREEZE))


func test_the_battle_has_every_gesture_on() -> void:
	var view := CombatantView.new()
	for gesture: StringName in BlowGestures.ALL:
		assert_true(view.gestures.is_on(gesture))
	view.free()


func test_freeze_makes_the_blow_longer_by_the_weight() -> void:
	screen.choose(&"saint_benedict")
	var with_freeze: float = screen.play(&"attack")
	assert_almost_eq(screen.actor.blow_freeze(), BlowWeight.value(BlowWeight.HEAVY, "freeze") / FAST, 0.0001)
	screen.toggle_gesture(BlowGestures.FREEZE)
	screen.choose(&"saint_benedict")
	var without: float = screen.play(&"attack")
	assert_eq(screen.actor.blow_freeze(), 0.0)
	assert_almost_eq(with_freeze - without, BlowWeight.value(BlowWeight.HEAVY, "freeze") / FAST, 0.0001)


func test_the_freeze_stops_the_frames_on_the_impact() -> void:
	screen.speed = 1.0
	screen.choose(&"saint_benedict")
	var frozen: Array[bool] = [false]
	var on_impact := func(_at: Vector2, _s: float, _k: StringName) -> void:
		frozen[0] = true
	screen.actor.impact.connect(on_impact)
	var t: float = screen.play(&"attack")
	await wait_until(func() -> bool: return frozen[0], t + 1.0)
	await wait_frames(2)
	assert_eq(screen.actor.player().speed, 0.0, "a figura para no impacto")
	await wait_seconds(BlowWeight.value(BlowWeight.HEAVY, "freeze") + 0.1)
	assert_eq(screen.actor.player().speed, 1.0, "e volta a andar")


func test_anticipation_crouches_and_widens_before_the_blow() -> void:
	screen.speed = 1.0
	screen.choose(&"saint_benedict")
	screen.play(&"attack")
	await wait_seconds(BlowWeight.value(BlowWeight.HEAVY, "anticipation") * 0.8)
	var body: Panel = _body(screen.actor)
	assert_gt(body.scale.x, 1.0, "alarga")
	assert_lt(body.scale.y, 1.0, "abaixa")


func test_without_anticipation_the_figure_keeps_its_shape() -> void:
	screen.speed = 1.0
	screen.toggle_gesture(BlowGestures.ANTICIPATION)
	screen.toggle_gesture(BlowGestures.BLUR)
	screen.choose(&"saint_benedict")
	screen.play(&"attack")
	await wait_seconds(0.1)
	assert_eq(_body(screen.actor).scale, Vector2.ONE)


func test_blur_takes_the_place_of_the_ghost_trail() -> void:
	screen.speed = 1.0
	screen.choose(&"saint_george")
	var t: float = screen.play(&"attack")
	var ghosts: Array[int] = [0]
	var count := func() -> bool:
		for child: Node in screen.actor.get_children():
			if child is TextureRect:
				ghosts[0] += 1
		return false
	await wait_until(count, t)
	assert_eq(ghosts[0], 0, "com o borrão, sem cópias fantasmas")
	screen.toggle_gesture(BlowGestures.BLUR)
	screen.choose(&"saint_george")
	t = screen.play(&"attack")
	await wait_until(count, t)
	assert_gt(ghosts[0], 0, "sem o borrão, o rastro de antes")


func test_recoil_swings_past_its_place_and_settles() -> void:
	screen.speed = 1.0
	screen.choose(&"saint_therese")
	var home: float = _body(screen.actor).position.x
	var t: float = screen.actor.play_hit()
	var seen: Dictionary = {"back": 0.0, "past": 0.0}
	var watch := func() -> bool:
		var offset: float = _body(screen.actor).position.x - home
		seen["back"] = minf(float(seen["back"]), offset)
		seen["past"] = maxf(float(seen["past"]), offset)
		return false
	await wait_until(watch, t + 0.05)
	assert_almost_eq(float(seen["back"]), -BlowWeight.value(BlowWeight.LIGHT, "recoil"), 2.0, "recua pelo peso")
	assert_gt(float(seen["past"]), 1.0, "passa do ponto")
	assert_almost_eq(_body(screen.actor).position.x, home, 0.01, "assenta")


func test_without_recoil_it_never_passes_its_place() -> void:
	screen.speed = 1.0
	screen.toggle_gesture(BlowGestures.RECOIL)
	screen.choose(&"saint_therese")
	var home: float = _body(screen.actor).position.x
	var t: float = screen.actor.play_hit()
	var past: Array[float] = [0.0]
	var watch := func() -> bool:
		past[0] = maxf(past[0], _body(screen.actor).position.x - home)
		return false
	await wait_until(watch, t + 0.05)
	assert_lte(past[0], 0.01)


func test_the_camera_is_pushed_toward_the_side_of_the_blow() -> void:
	screen.choose(&"saint_george")
	assert_eq(screen.actor.blow_push(), Vector2(BlowWeight.value(BlowWeight.MEDIUM, "push"), 0))
	screen.choose(&"boss_asmodeus")
	assert_eq(screen.actor.blow_push(), Vector2(-BlowWeight.value(BlowWeight.COLOSSAL, "push"), 0), "o inimigo bate para a esquerda")
	assert_eq(screen.actor.blow_shake(), BlowWeight.value(BlowWeight.COLOSSAL, "shake"))
	screen.toggle_gesture(BlowGestures.CAMERA_PUSH)
	assert_eq(screen.actor.blow_push(), Vector2.ZERO)
	assert_eq(screen.actor.blow_shake(), 1.0)


func test_the_shadow_stands_under_the_feet_and_can_be_turned_off() -> void:
	screen.choose(&"saint_george")
	await wait_frames(2)
	assert_true(screen.actor.shadow_visible())
	screen.toggle_gesture(BlowGestures.SHADOW)
	await wait_frames(2)
	assert_false(screen.actor.shadow_visible())


func test_a_blow_still_ends_back_home_with_every_gesture() -> void:
	screen.choose(&"saint_george")
	var home: Vector2 = screen.actor.position
	var t: float = screen.play(&"attack")
	await wait_seconds(t + 0.3)
	assert_eq(screen.actor.player().clip_id(), &"idle")
	assert_eq(_body(screen.actor).scale, Vector2.ONE)
	assert_almost_eq(_body(screen.actor).rotation, 0.0, 0.0001)
	assert_eq(screen.actor.position, home)
