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
	var h := hash(config.billboard_enabled)
	h ^= hash(config.charge_level)
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
	
	# Sync child lights with beam config
	_sync_lights()

func _sync_lights() -> void:
	if not config:
		return
	
	# Calculate effective intensity based on charge level
	var effective_intensity := config.intensity
	if config.use_charge_level:
		effective_intensity *= config.charge_level
	
	# Impact light (bottom of beam)
	var impact_light := get_node_or_null("ImpactLight") as OmniLight3D
	if impact_light:
		impact_light.light_color = config.beam_color
		# Scale light energy with beam intensity and impact glow
		var impact_energy := effective_intensity * 0.5
		if config.impact_glow_size > 0:
			impact_energy += config.impact_glow_intensity * config.impact_glow_size * 10.0
		impact_light.light_energy = impact_energy
		impact_light.omni_range = 2.0 + effective_intensity * 0.5
		impact_light.visible = effective_intensity > 0.1
	
	# Origin light (top of beam)
	var origin_light := get_node_or_null("OriginLight") as OmniLight3D
	if origin_light:
		origin_light.light_color = config.beam_color
		# Scale light energy with beam intensity and origin glow
		var origin_energy := effective_intensity * 0.3
		if config.origin_glow_size > 0:
			origin_energy += config.origin_glow_intensity * config.origin_glow_size * 8.0
		origin_light.light_energy = origin_energy
		origin_light.omni_range = 1.5 + effective_intensity * 0.3
		origin_light.visible = effective_intensity > 0.1
