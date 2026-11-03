class_name HaloSettings
extends Resource
## How the halo and the saint figure look in each spiritual state
## (asset-pipeline §6). Presentation only: these values change no rule, so
## they live here (scenes/battle/halo_settings.tres), not in docs/balance.

@export var disk: Texture2D
@export var rays: Texture2D
## Rays diameter relative to the disk.
@export var rays_scale: float = 1.6
@export var normal_brightness: float = 1.0
@export var normal_saturation: float = 1.0
## Desolation band where a Normal saint fades (75–99 in §6).
@export var fade_start: int = 75
@export var fade_end: int = 99
@export var faded_brightness: float = 0.6
@export var faded_saturation: float = 0.8
@export var dark_night_brightness: float = 0.25
@export var dark_night_saturation: float = 0.45
@export var consolation_brightness: float = 1.3
@export var consolation_saturation: float = 1.05
## "Rotação lenta" of the Consolation rays, in radians per second.
@export var rays_spin_speed: float = 0.3
## Seconds a change takes at speed 1 (live update on screen).
@export var transition_time: float = 0.4
