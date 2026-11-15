extends GutTest
## T65 (ADR-0013): the inner screen of 960 × 540 with whole-number zoom, the
## battle and the walk on the pixel grid (figures at their natural size,
## scenery in layers with parallax and the filter of the circle, the panel
## with the cathedral pieces and the two pixel fonts), and the old screens
## drawn at half size until each one is redone.

const SEED: int = 4242

var data: GameData


func before_all() -> void:
	data = RealData.game_data()


func _battle(encounter_id: StringName = &"m0_easy_01") -> BattleScreen:
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	screen.setup(data, BattleController.new(data.battle(encounter_id, SEED)))
	add_child_autofree(screen)
	return screen


func test_project_draws_on_the_960_by_540_grid() -> void:
	assert_eq(int(ProjectSettings.get_setting("display/window/size/viewport_width")), 960)
	assert_eq(int(ProjectSettings.get_setting("display/window/size/viewport_height")), 540)
	assert_eq(str(ProjectSettings.get_setting("display/window/stretch/mode")), "viewport")
	assert_eq(str(ProjectSettings.get_setting("display/window/stretch/aspect")), "expand")
	assert_eq(str(ProjectSettings.get_setting("display/window/stretch/scale_mode")), "integer")
	assert_eq(int(ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter")), 0, "filtro mais próximo")
	assert_true(bool(ProjectSettings.get_setting("rendering/2d/snap/snap_2d_transforms_to_pixel")), "posições em pixel inteiro")


func test_battle_layout_follows_the_grid() -> void:
	assert_eq(BattleScreen.STAGE_SIZE, Vector2(960, 540))
	assert_eq(BattleScreen.FIELD_HEIGHT, 360.0, "campo nos 360 de cima")
	assert_eq(BattleScreen.GROUND_Y, 338.0, "chão em y = 338")
	var screen: BattleScreen = _battle()
	for c: Combatant in screen.ctrl.state.party + screen.ctrl.state.enemies:
		var view: CombatantView = screen.view_of(c.id)
		assert_eq(view.scale, Vector2.ONE, "%s sem escala" % c.id)
		assert_eq(view.position, view.position.round(), "%s em pixel inteiro" % c.id)
		if BattleScreen.is_pixel_art(view.player().frames):
			assert_almost_eq(view.player().pixel_scale(), view.player().frames.display_scale, 0.0001, "%s: um pixel do desenho, um pixel da tela" % c.id)


func test_saints_and_pixel_enemies_use_the_pixel_frames() -> void:
	var screen: BattleScreen = _battle()
	for c: Combatant in screen.ctrl.state.party:
		assert_true(BattleScreen.is_pixel_art(screen.view_of(c.id).player().frames), "%s em pixel" % c.id)
	var devil: Combatant = null
	for c: Combatant in screen.ctrl.state.enemies:
		if c.def_id == &"enemy_mud_devil":
			devil = c
	assert_not_null(devil, "o encontro fácil tem o Diabo de Lodo")
	assert_true(BattleScreen.is_pixel_art(screen.view_of(devil.id).player().frames), "Diabo de Lodo em pixel")


func test_scenery_has_layers_and_the_filter_of_the_circle() -> void:
	var screen: BattleScreen = _battle()
	assert_eq(screen.scenery_layer_count(), 3, "fundo, meio e frente do trecho 1")
	var mat := screen.scenery_material() as ShaderMaterial
	assert_not_null(mat, "o cenário tem o filtro do círculo")
	assert_almost_eq(float(mat.get_shader_parameter("strength")), CircleLook.CIRCLE_02_STRENGTH, 0.0001)
	assert_eq(CircleLook.CIRCLE_02_STRENGTH, 0.55, "força do modelo B (D-379)")
	assert_eq(CircleLook.CIRCLE_02_RAMP.size(), 6, "rampa do Círculo 2 (D-379)")
	for c: Combatant in screen.ctrl.state.party:
		assert_ne(screen.view_of(c.id).player().material, mat, "%s sem o filtro do cenário" % c.id)


func test_boss_battle_uses_the_boss_arena() -> void:
	var paths: Array[Dictionary] = CircleLook.back_layers(CircleLook.SET_BOSS)
	for layer: Dictionary in paths + CircleLook.front_layers(CircleLook.SET_BOSS):
		assert_true(ResourceLoader.exists(str(layer["path"])), str(layer["path"]))


func test_parallax_moves_the_far_layers_less() -> void:
	var scenery := ParallaxScenery.new()
	scenery.size = Vector2(960, 360)
	scenery.setup(CircleLook.back_layers(CircleLook.SET_LEG_1) + CircleLook.front_layers(CircleLook.SET_LEG_1))
	add_child_autofree(scenery)
	scenery.set_camera_x(100.0)
	assert_eq(scenery.layer_offset(0), -20.0, "fundo a 20%")
	assert_eq(scenery.layer_offset(1), -100.0, "meio a 100%")
	assert_eq(scenery.layer_offset(2), -130.0, "frente a 130%")
	scenery.set_camera_x(0.0)
	scenery.set_shift(10.0)
	assert_lt(scenery.layer_offset(0), 0.0, "no empurrão da câmera o fundo fica para trás")
	assert_eq(scenery.layer_offset(1), 0.0)


func test_panel_has_the_cathedral_pieces() -> void:
	var screen: BattleScreen = _battle()
	for i: int in BattleScreen.ABILITY_SLOTS:
		var lancet := screen._ability_buttons[i] as PieceButton
		assert_not_null(lancet, "habilidade %d numa lanceta" % i)
		assert_eq(lancet.size, Vector2(lancet.piece().get_size()), "lanceta em tamanho natural")
	var rose := screen._miracle_button as PieceButton
	assert_not_null(rose, "milagre na rosácea")
	assert_eq(rose.piece_disabled, PixelStyle.piece("ui_rose_off"), "rosácea apagada quando não dá")
	assert_eq(screen.fervor_flames(), mini(screen.ctrl.fervor.amount, BattleScreen.CANDLE_FLAMES.size()), "uma chama por Fervor no porta-velas")
	assert_eq(screen._portrait_frame.texture, PixelStyle.piece("ui_portrait_arch"), "retrato no arco")


func test_provisions_hang_on_hooks() -> void:
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	var provisions: Array[StringName] = [&"bread", &"bread", &"candle"]
	screen.setup(data, BattleController.new(data.battle(&"m0_easy_01", SEED, provisions)))
	add_child_autofree(screen)
	assert_eq(screen.provision_hook_count(), 2, "um gancho por tipo de provisão")
	var hook := screen._hooks.get_child(0) as PieceButton
	assert_eq(hook.text, "2", "com a quantidade")


func test_lancet_states() -> void:
	var lancet := PieceButton.new()
	lancet.setup(PixelStyle.piece("ui_lancet_on"), PixelStyle.piece("ui_lancet_chosen"), PixelStyle.piece("ui_lancet_off"), BattleScreen.LANCET_TEXT)
	add_child_autofree(lancet)
	assert_eq(lancet.piece(), PixelStyle.piece("ui_lancet_on"))
	lancet.chosen = true
	assert_eq(lancet.piece(), PixelStyle.piece("ui_lancet_chosen"), "escolhida acende em âmbar")
	lancet.disabled = true
	assert_eq(lancet.piece(), PixelStyle.piece("ui_lancet_off"), "indisponível fica escura")


func test_pixel_fonts_have_no_smoothing() -> void:
	for font: Font in [PixelStyle.title_font(), PixelStyle.text_font()]:
		var file := font as FontFile
		assert_not_null(file)
		assert_eq(file.antialiasing, TextServer.FONT_ANTIALIASING_NONE)
		assert_eq(file.hinting, TextServer.HINTING_NONE)
	var screen: BattleScreen = _battle()
	assert_eq(screen._round_label.get_theme_font(&"font"), PixelStyle.title_font(), "títulos em Jacquard 12")
	assert_eq(screen.theme.default_font, PixelStyle.text_font(), "texto em Jersey 10")


func test_wide_phone_widens_the_field_not_the_panel() -> void:
	var holder := Control.new()
	holder.size = Vector2(1230, 540)
	add_child_autofree(holder)
	var screen := BattleScreen.new()
	screen.speed_index = BattleScreen.SPEED_INSTANT
	screen.setup(data, BattleController.new(data.battle(&"m0_easy_01", SEED)))
	holder.add_child(screen)
	await wait_physics_frames(2)
	assert_eq(screen.stage_position(), Vector2(135, 0), "painel centralizado")
	assert_eq(screen._field_clip.size.x, 1230.0, "o campo ocupa a largura toda")


func test_old_screens_draw_at_half_size() -> void:
	var stage := Control.new()
	add_child_autofree(stage)
	LegacyStage.place(stage, Vector2(1920, 1080), Vector2(1230, 540))
	assert_eq(stage.scale, Vector2(0.5, 0.5))
	assert_eq(stage.position, Vector2(135, 0))
	assert_eq(stage.texture_filter, CanvasItem.TEXTURE_FILTER_LINEAR, "arte pintada com filtro suave")


## D-384: the figures are shrunk so each one stands apart and the two sides
## have a wider gap between them; the portraits keep the full-size bust.
func test_figures_are_spaced_and_portraits_use_the_bust() -> void:
	var screen: BattleScreen = _battle(&"m0_hard_02")
	for c: Combatant in screen.ctrl.state.party:
		var frames: CharacterFrames = screen.view_of(c.id).player().frames
		assert_almost_eq(frames.figure_height, BattleScreen.FIGURE_HEIGHT, 6.0, "%s na altura reduzida" % c.id)
	var saint_front: float = screen.feet_of(screen.ctrl.state.party_at(1).id).x
	var enemy_front: float = screen.feet_of(screen.ctrl.state.enemy_at(1).id).x
	assert_gt(enemy_front - saint_front, BattleScreen.SLOT_STEP, "vão maior entre os dois times")
	for c: Combatant in screen.ctrl.state.party + screen.ctrl.state.enemies:
		var feet: Vector2 = screen.feet_of(c.id)
		assert_between(feet.x, 0.0, BattleScreen.STAGE_SIZE.x, "%s dentro dos 960" % c.id)
	var portrait: Texture2D = screen.portrait_texture()
	assert_not_null(portrait)
	assert_true(portrait.resource_path.ends_with("_bust.png"), "retrato pelo busto em tamanho cheio")
