extends GutTest
## T16: a saint view with art swaps the body image and drives the halo from
## the spiritual state and desolation, live. In-memory textures only.

var art: CombatantArt
var settings: HaloSettings
var view: CombatantView
var saint: Combatant


func _texture() -> Texture2D:
	return ImageTexture.create_from_image(Image.create(4, 6, false, Image.FORMAT_RGBA8))


func before_each() -> void:
	settings = HaloSettings.new()
	settings.disk = _texture()
	settings.rays = _texture()
	art = CombatantArt.new()
	art.body_normal = _texture()
	art.body_dark_night = _texture()
	art.body_consolation = _texture()
	art.head_dark_night = Vector2(0.6, 0.2)
	art.body_attack = _texture()
	art.body_hit = _texture()
	art.body_fall = _texture()
	art.head_fall = Vector2(0.75, 0.45)
	saint = Combatant.from_saint(CombatFixture.saint(&"saint_a"))
	view = CombatantView.new()
	view.speed = 0.0
	view.setup(saint.id, true, 220.0, art, settings)
	add_child_autofree(view)
	_show()


func _show() -> void:
	view.show_state(saint, "Santo", "1", "", "30/30", "0", "", "")


func test_normal_state_shows_the_default_body_and_full_halo() -> void:
	assert_true(view.has_art())
	assert_eq(view.figure_texture(), art.body_normal)
	assert_almost_eq(view.halo().brightness(), settings.normal_brightness, 0.001)
	assert_false(view.halo().rays_shown())


func test_dark_night_swaps_body_dims_halo_and_moves_it_to_the_head() -> void:
	var before: Vector2 = view.halo().position
	saint.spirit_state = Desolation.DARK_NIGHT
	_show()
	assert_eq(view.figure_texture(), art.body_dark_night)
	assert_almost_eq(view.halo().brightness(), settings.dark_night_brightness, 0.001)
	assert_almost_eq(view.figure_saturation(), settings.dark_night_saturation, 0.001)
	assert_ne(view.halo().position, before, "a cabeça inclinada muda o ponto da auréola")


func test_consolation_shows_the_rays() -> void:
	view.set_spirit_state(Desolation.CONSOLATION)
	assert_eq(view.figure_texture(), art.body_consolation)
	assert_true(view.halo().rays_shown())
	assert_almost_eq(view.halo().brightness(), settings.consolation_brightness, 0.001)


func test_halo_follows_desolation_live() -> void:
	view.set_desolation(settings.fade_end)
	assert_almost_eq(view.halo().brightness(), settings.faded_brightness, 0.001)
	view.set_desolation(0)
	assert_almost_eq(view.halo().brightness(), settings.normal_brightness, 0.001)


func test_fallen_saint_loses_the_halo() -> void:
	view.play_fall()
	assert_false(view.halo().visible)


func test_view_without_art_stays_a_rectangle() -> void:
	var plain := CombatantView.new()
	plain.setup(&"enemy_1", false, 190.0)
	add_child_autofree(plain)
	assert_false(plain.has_art())
	assert_null(plain.figure_texture())


func test_fallen_saint_shows_the_fall_pose_and_rises_back() -> void:
	view.play_fall()
	assert_eq(view.figure_texture(), art.body_fall)
	assert_eq(view.pose(), &"fall")
	saint.state = Combatant.State.FALLEN
	_show()
	assert_eq(view.figure_texture(), art.body_fall, "continua ajoelhado enquanto caído")
	saint.state = Combatant.State.STANDING
	_show()
	assert_eq(view.figure_texture(), art.body_normal, "levantado, volta à pose normal")
	assert_eq(view.pose(), &"")


func test_attack_and_hit_poses_are_skipped_at_instant_speed() -> void:
	view.play_action()
	view.play_hit()
	assert_eq(view.figure_texture(), art.body_normal, "sem animação, nada fica preso numa pose")


func test_attack_pose_shows_during_the_animation() -> void:
	view.speed = 1.0
	view.play_action()
	assert_eq(view.figure_texture(), art.body_attack)
	assert_eq(view.pose(), &"attack")
