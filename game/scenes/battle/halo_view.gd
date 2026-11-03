class_name HaloView
extends Control
## The halo behind a saint's head (architecture §8, ADR-0008): the disk
## always, the rays only in Consolation, both through shaders/halo.gdshader.

const SHADER_PATH: String = "res://shaders/halo.gdshader"

var _disk: TextureRect
var _rays: TextureRect
var _disk_material: ShaderMaterial
var _rays_material: ShaderMaterial
var _settings: HaloSettings


func setup(settings: HaloSettings, diameter: float) -> void:
	_settings = settings
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = Vector2(diameter, diameter)
	var shader: Shader = load(SHADER_PATH)
	var rays_side: float = diameter * settings.rays_scale
	_rays_material = ShaderMaterial.new()
	_rays_material.shader = shader
	_rays = _layer(settings.rays, _rays_material, Vector2(rays_side, rays_side), Vector2.ONE * (diameter - rays_side) * 0.5)
	_rays.visible = false
	_disk_material = ShaderMaterial.new()
	_disk_material.shader = shader
	_disk = _layer(settings.disk, _disk_material, size, Vector2.ZERO)


## Shows `look`; with `duration` > 0 the brightness glides to it.
func apply(look: HaloLook, duration: float) -> void:
	_rays.visible = look.rays
	_rays_material.set_shader_parameter("spin_speed", _settings.rays_spin_speed if look.rays else 0.0)
	for mat: ShaderMaterial in [_disk_material, _rays_material]:
		if duration > 0.0 and is_inside_tree():
			create_tween().tween_property(mat, "shader_parameter/brightness", look.brightness, duration)
		else:
			mat.set_shader_parameter("brightness", look.brightness)


func brightness() -> float:
	return float(_disk_material.get_shader_parameter("brightness"))


func rays_shown() -> bool:
	return _rays.visible


func _layer(texture: Texture2D, mat: ShaderMaterial, layer_size: Vector2, pos: Vector2) -> TextureRect:
	var rect := TextureRect.new()
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.texture = texture
	rect.material = mat
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.position = pos
	rect.size = layer_size
	mat.set_shader_parameter("brightness", 1.0)
	add_child(rect)
	return rect
