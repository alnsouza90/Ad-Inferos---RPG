class_name HaloLook
extends RefCounted
## The halo brightness, figure saturation and rays for one spiritual state
## and desolation (asset-pipeline §6 table). Pure: tested without a screen.

var brightness: float = 1.0
var saturation: float = 1.0
var rays: bool = false


static func of(settings: HaloSettings, spirit_state: StringName, desolation: int) -> HaloLook:
	var look := HaloLook.new()
	if spirit_state == Desolation.DARK_NIGHT:
		look.brightness = settings.dark_night_brightness
		look.saturation = settings.dark_night_saturation
	elif spirit_state == Desolation.CONSOLATION:
		look.brightness = settings.consolation_brightness
		look.saturation = settings.consolation_saturation
		look.rays = true
	else:
		# Linear fade across the band, full fade from its end on.
		var span: float = maxf(1.0, float(settings.fade_end - settings.fade_start))
		var t: float = clampf(float(desolation - settings.fade_start) / span, 0.0, 1.0)
		look.brightness = lerpf(settings.normal_brightness, settings.faded_brightness, t)
		look.saturation = lerpf(settings.normal_saturation, settings.faded_saturation, t)
	return look
