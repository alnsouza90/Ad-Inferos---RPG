extends GutTest
## T16: halo look per spiritual state (asset-pipeline §6 table).

var settings: HaloSettings


func before_each() -> void:
	settings = HaloSettings.new()
	settings.normal_brightness = 1.0
	settings.normal_saturation = 1.0
	settings.fade_start = 75
	settings.fade_end = 99
	settings.faded_brightness = 0.6
	settings.faded_saturation = 0.8
	settings.dark_night_brightness = 0.25
	settings.dark_night_saturation = 0.45
	settings.consolation_brightness = 1.3
	settings.consolation_saturation = 1.05


func test_normal_below_the_band_is_full() -> void:
	var look := HaloLook.of(settings, Desolation.NORMAL, 74)
	assert_almost_eq(look.brightness, 1.0, 0.001)
	assert_almost_eq(look.saturation, 1.0, 0.001)
	assert_false(look.rays)


func test_normal_fades_linearly_across_75_to_99() -> void:
	assert_almost_eq(HaloLook.of(settings, Desolation.NORMAL, 75).brightness, 1.0, 0.001)
	var middle := HaloLook.of(settings, Desolation.NORMAL, 87)
	assert_almost_eq(middle.brightness, 0.8, 0.001)
	assert_almost_eq(middle.saturation, 0.9, 0.001)
	assert_almost_eq(HaloLook.of(settings, Desolation.NORMAL, 99).brightness, 0.6, 0.001)
	assert_almost_eq(HaloLook.of(settings, Desolation.NORMAL, 150).brightness, 0.6, 0.001, "não passa do fim da faixa")


func test_dark_night_is_dim_and_grey() -> void:
	var look := HaloLook.of(settings, Desolation.DARK_NIGHT, 120)
	assert_almost_eq(look.brightness, 0.25, 0.001)
	assert_almost_eq(look.saturation, 0.45, 0.001)
	assert_false(look.rays)


func test_consolation_is_bright_with_rays() -> void:
	var look := HaloLook.of(settings, Desolation.CONSOLATION, 50)
	assert_almost_eq(look.brightness, 1.3, 0.001)
	assert_almost_eq(look.saturation, 1.05, 0.001)
	assert_true(look.rays)
