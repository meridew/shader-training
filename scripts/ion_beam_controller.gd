@tool
extends MeshInstance3D

## Controller for ion beam with live editor preview.
## Attach to a MeshInstance3D with the ion beam shader material.

@export var config: IonBeamConfig:
	set(value):
		# Disconnect old config
		if config and config.config_changed.is_connected(_on_config_changed):
			config.config_changed.disconnect(_on_config_changed)
		config = value
		# Connect new config
		if config:
			if not config.config_changed.is_connected(_on_config_changed):
				config.config_changed.connect(_on_config_changed)
			_apply_config()

var _last_config_hash: int = 0

func _ready() -> void:
	if config:
		if not config.config_changed.is_connected(_on_config_changed):
			config.config_changed.connect(_on_config_changed)
		_apply_config()

func _process(_delta: float) -> void:
	# Poll for changes in editor since signal may not always fire
	if Engine.is_editor_hint() and config:
		var current_hash := _compute_config_hash()
		if current_hash != _last_config_hash:
			_last_config_hash = current_hash
			_apply_config()

func _compute_config_hash() -> int:
	if not config:
		return 0
	# Simple hash of all config values
	var h := hash(config.charge_level)
	h ^= hash(config.use_charge_level)
	h ^= hash(config.beam_color)
	h ^= hash(config.core_color)
	h ^= hash(config.intensity)
	h ^= hash(config.beam_width)
	h ^= hash(config.core_width)
	h ^= hash(config.edge_softness)
	h ^= hash(config.outer_glow_size)
	h ^= hash(config.outer_glow_intensity)
	h ^= hash(config.outer_glow_color)
	h ^= hash(config.chromatic_amount)
	h ^= hash(config.chromatic_speed)
	h ^= hash(config.wobble_amount)
	h ^= hash(config.wobble_frequency)
	h ^= hash(config.wobble_speed)
	h ^= hash(config.pulse_amount)
	h ^= hash(config.pulse_speed)
	h ^= hash(config.flicker_amount)
	h ^= hash(config.flicker_speed)
	h ^= hash(config.scanline_density)
	h ^= hash(config.scanline_speed)
	h ^= hash(config.scanline_strength)
	h ^= hash(config.pixel_size)
	h ^= hash(config.breakup_amount)
	h ^= hash(config.breakup_speed)
	h ^= hash(config.taper_top)
	h ^= hash(config.taper_bottom)
	h ^= hash(config.energy_flow_speed)
	h ^= hash(config.energy_flow_strength)
	h ^= hash(config.jitter_amount)
	h ^= hash(config.jitter_speed)
	h ^= hash(config.origin_glow_size)
	h ^= hash(config.origin_glow_intensity)
	h ^= hash(config.impact_glow_size)
	h ^= hash(config.impact_glow_intensity)
	h ^= hash(config.noise_texture)
	h ^= hash(config.use_noise_texture)
	h ^= hash(config.noise_scale)
	h ^= hash(config.noise_influence)
	h ^= hash(config.initial_width_mult)
	h ^= hash(config.final_width_mult)
	h ^= hash(config.duration)
	h ^= hash(config.loop_animation)
	h ^= hash(config.ping_pong)
	h ^= hash(config.tween_type)
	h ^= hash(config.trans_type)
	return h

func _on_config_changed() -> void:
	_apply_config()

func _apply_config() -> void:
	if not config:
		return
	var mat := get_surface_override_material(0) as ShaderMaterial
	if not mat:
		mat = mesh.surface_get_material(0) as ShaderMaterial
	if mat:
		config.apply_to_material(mat)
