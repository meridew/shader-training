@tool
class_name IonBeamConfig
extends Resource

## Configuration resource for ion beam shader with live preview in editor.
## Assign to a node with an IonBeamController script.

signal config_changed

# === BILLBOARD ===
@export_group("Billboard")
@export var billboard_enabled: bool = true:
	set(value):
		billboard_enabled = value
		emit_changed()
		config_changed.emit()

# === FRESNEL (Cylindrical Depth) ===
@export_group("Fresnel")
@export_range(0.0, 5.0) var fresnel_power: float = 2.0:
	set(value):
		fresnel_power = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 2.0) var fresnel_intensity: float = 0.5:
	set(value):
		fresnel_intensity = value
		emit_changed()
		config_changed.emit()

@export var fresnel_enabled: bool = true:
	set(value):
		fresnel_enabled = value
		emit_changed()
		config_changed.emit()

# === CHARGE SYSTEM (Master Control) ===
@export_group("Charge System")
@export_range(0.0, 1.0) var charge_level: float = 1.0:
	set(value):
		charge_level = value
		emit_changed()
		config_changed.emit()

@export var use_charge_level: bool = false:
	set(value):
		use_charge_level = value
		emit_changed()
		config_changed.emit()

# === APPEARANCE ===
@export_group("Appearance")
@export var beam_color: Color = Color(0.2, 0.6, 1.0):
	set(value):
		beam_color = value
		emit_changed()
		config_changed.emit()

@export var core_color: Color = Color(0.8, 0.95, 1.0):
	set(value):
		core_color = value
		emit_changed()
		config_changed.emit()

@export_range(0.5, 10.0) var intensity: float = 3.0:
	set(value):
		intensity = value
		emit_changed()
		config_changed.emit()

@export_range(0.01, 1.0) var beam_width: float = 0.08:
	set(value):
		beam_width = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var core_width: float = 0.3:
	set(value):
		core_width = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var edge_softness: float = 0.5:
	set(value):
		edge_softness = value
		emit_changed()
		config_changed.emit()

# === SECONDARY GLOW ===
@export_group("Secondary Glow")
@export_range(0.0, 5.0) var outer_glow_size: float = 2.0:
	set(value):
		outer_glow_size = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var outer_glow_intensity: float = 0.3:
	set(value):
		outer_glow_intensity = value
		emit_changed()
		config_changed.emit()

@export var outer_glow_color: Color = Color(0.1, 0.3, 0.8):
	set(value):
		outer_glow_color = value
		emit_changed()
		config_changed.emit()

# === HEAT DISTORTION ===
@export_group("Heat Distortion")
@export_range(0.0, 0.1) var heat_distortion_amount: float = 0.0:
	set(value):
		heat_distortion_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 10.0) var heat_distortion_speed: float = 3.0:
	set(value):
		heat_distortion_speed = value
		emit_changed()
		config_changed.emit()

@export_range(1.0, 50.0) var heat_distortion_scale: float = 15.0:
	set(value):
		heat_distortion_scale = value
		emit_changed()
		config_changed.emit()

# === CHROMATIC ABERRATION ===
@export_group("Chromatic Aberration")
@export_range(0.0, 0.1) var chromatic_amount: float = 0.0:
	set(value):
		chromatic_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 10.0) var chromatic_speed: float = 2.0:
	set(value):
		chromatic_speed = value
		emit_changed()
		config_changed.emit()

# === WOBBLE ===
@export_group("Wobble")
@export_range(0.0, 0.5) var wobble_amount: float = 0.0:
	set(value):
		wobble_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 50.0) var wobble_frequency: float = 12.0:
	set(value):
		wobble_frequency = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 20.0) var wobble_speed: float = 8.0:
	set(value):
		wobble_speed = value
		emit_changed()
		config_changed.emit()

# === PULSE & FLICKER ===
@export_group("Pulse & Flicker")
@export_range(0.0, 1.0) var pulse_amount: float = 0.3:
	set(value):
		pulse_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 20.0) var pulse_speed: float = 4.0:
	set(value):
		pulse_speed = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var flicker_amount: float = 0.15:
	set(value):
		flicker_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 100.0) var flicker_speed: float = 30.0:
	set(value):
		flicker_speed = value
		emit_changed()
		config_changed.emit()

# === SCANLINES ===
@export_group("Scanlines")
@export_range(0.0, 100.0) var scanline_density: float = 25.0:
	set(value):
		scanline_density = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 20.0) var scanline_speed: float = 5.0:
	set(value):
		scanline_speed = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var scanline_strength: float = 0.25:
	set(value):
		scanline_strength = value
		emit_changed()
		config_changed.emit()

# === DIGITAL EFFECTS ===
@export_group("Digital Effects")
@export_range(0.0, 0.1) var pixel_size: float = 0.0:
	set(value):
		pixel_size = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var breakup_amount: float = 0.0:
	set(value):
		breakup_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 10.0) var breakup_speed: float = 2.0:
	set(value):
		breakup_speed = value
		emit_changed()
		config_changed.emit()

# === TAPER ===
@export_group("Taper")
@export_range(0.0, 0.5) var taper_top: float = 0.0:
	set(value):
		taper_top = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 0.5) var taper_bottom: float = 0.0:
	set(value):
		taper_bottom = value
		emit_changed()
		config_changed.emit()

# === ENERGY BUILDUP ===
@export_group("Energy Buildup")
@export_range(0.0, 10.0) var energy_flow_speed: float = 0.0:
	set(value):
		energy_flow_speed = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var energy_flow_strength: float = 0.5:
	set(value):
		energy_flow_strength = value
		emit_changed()
		config_changed.emit()

# === INSTABILITY / JITTER ===
@export_group("Instability")
@export_range(0.0, 0.1) var jitter_amount: float = 0.0:
	set(value):
		jitter_amount = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 50.0) var jitter_speed: float = 20.0:
	set(value):
		jitter_speed = value
		emit_changed()
		config_changed.emit()

# === ENDPOINT EFFECTS ===
@export_group("Endpoint Effects")
@export_range(0.0, 0.3) var origin_glow_size: float = 0.0:
	set(value):
		origin_glow_size = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 3.0) var origin_glow_intensity: float = 1.5:
	set(value):
		origin_glow_intensity = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 0.3) var impact_glow_size: float = 0.0:
	set(value):
		impact_glow_size = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 3.0) var impact_glow_intensity: float = 1.5:
	set(value):
		impact_glow_intensity = value
		emit_changed()
		config_changed.emit()

# === NOISE TEXTURE ===
@export_group("Noise Texture")
@export var noise_texture: Texture2D:
	set(value):
		noise_texture = value
		emit_changed()
		config_changed.emit()

@export var use_noise_texture: bool = false:
	set(value):
		use_noise_texture = value
		emit_changed()
		config_changed.emit()

@export_range(0.1, 10.0) var noise_scale: float = 1.0:
	set(value):
		noise_scale = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 1.0) var noise_influence: float = 0.5:
	set(value):
		noise_influence = value
		emit_changed()
		config_changed.emit()

# === WIDTH ANIMATION ===
@export_group("Width Animation")
@export_range(0.0, 5.0) var initial_width_mult: float = 1.0:
	set(value):
		initial_width_mult = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 5.0) var final_width_mult: float = 1.0:
	set(value):
		final_width_mult = value
		emit_changed()
		config_changed.emit()

@export_range(0.1, 10.0) var duration: float = 2.0:
	set(value):
		duration = value
		emit_changed()
		config_changed.emit()

@export var loop_animation: bool = false:
	set(value):
		loop_animation = value
		emit_changed()
		config_changed.emit()

@export var ping_pong: bool = false:
	set(value):
		ping_pong = value
		emit_changed()
		config_changed.emit()

# === EASING ===
@export_group("Easing")
@export_enum("Linear", "Sine", "Quad", "Cubic", "Quart", "Expo", "Elastic", "Back", "Bounce")
var tween_type: int = 0:
	set(value):
		tween_type = value
		emit_changed()
		config_changed.emit()

@export_enum("In", "Out", "InOut")
var trans_type: int = 0:
	set(value):
		trans_type = value
		emit_changed()
		config_changed.emit()


## Apply this configuration to a ShaderMaterial
func apply_to_material(material: ShaderMaterial) -> void:
	if not material:
		return
	# Billboard
	material.set_shader_parameter("billboard_enabled", billboard_enabled)
	# Fresnel
	material.set_shader_parameter("fresnel_power", fresnel_power)
	material.set_shader_parameter("fresnel_intensity", fresnel_intensity)
	material.set_shader_parameter("fresnel_enabled", fresnel_enabled)
	# Charge System
	material.set_shader_parameter("charge_level", charge_level)
	material.set_shader_parameter("use_charge_level", use_charge_level)
	# Appearance
	material.set_shader_parameter("beam_color", Vector3(beam_color.r, beam_color.g, beam_color.b))
	material.set_shader_parameter("core_color", Vector3(core_color.r, core_color.g, core_color.b))
	material.set_shader_parameter("intensity", intensity)
	material.set_shader_parameter("beam_width", beam_width)
	material.set_shader_parameter("core_width", core_width)
	material.set_shader_parameter("edge_softness", edge_softness)
	# Secondary Glow
	material.set_shader_parameter("outer_glow_size", outer_glow_size)
	material.set_shader_parameter("outer_glow_intensity", outer_glow_intensity)
	material.set_shader_parameter("outer_glow_color", Vector3(outer_glow_color.r, outer_glow_color.g, outer_glow_color.b))
	# Heat Distortion
	material.set_shader_parameter("heat_distortion_amount", heat_distortion_amount)
	material.set_shader_parameter("heat_distortion_speed", heat_distortion_speed)
	material.set_shader_parameter("heat_distortion_scale", heat_distortion_scale)
	# Chromatic Aberration
	material.set_shader_parameter("chromatic_amount", chromatic_amount)
	material.set_shader_parameter("chromatic_speed", chromatic_speed)
	# Wobble
	material.set_shader_parameter("wobble_amount", wobble_amount)
	material.set_shader_parameter("wobble_frequency", wobble_frequency)
	material.set_shader_parameter("wobble_speed", wobble_speed)
	# Pulse & Flicker
	material.set_shader_parameter("pulse_amount", pulse_amount)
	material.set_shader_parameter("pulse_speed", pulse_speed)
	material.set_shader_parameter("flicker_amount", flicker_amount)
	material.set_shader_parameter("flicker_speed", flicker_speed)
	# Scanlines
	material.set_shader_parameter("scanline_density", scanline_density)
	material.set_shader_parameter("scanline_speed", scanline_speed)
	material.set_shader_parameter("scanline_strength", scanline_strength)
	# Digital Effects
	material.set_shader_parameter("pixel_size", pixel_size)
	material.set_shader_parameter("breakup_amount", breakup_amount)
	material.set_shader_parameter("breakup_speed", breakup_speed)
	# Taper
	material.set_shader_parameter("taper_top", taper_top)
	material.set_shader_parameter("taper_bottom", taper_bottom)
	# Energy Buildup
	material.set_shader_parameter("energy_flow_speed", energy_flow_speed)
	material.set_shader_parameter("energy_flow_strength", energy_flow_strength)
	# Instability
	material.set_shader_parameter("jitter_amount", jitter_amount)
	material.set_shader_parameter("jitter_speed", jitter_speed)
	# Endpoint Effects
	material.set_shader_parameter("origin_glow_size", origin_glow_size)
	material.set_shader_parameter("origin_glow_intensity", origin_glow_intensity)
	material.set_shader_parameter("impact_glow_size", impact_glow_size)
	material.set_shader_parameter("impact_glow_intensity", impact_glow_intensity)
	# Noise Texture
	if noise_texture:
		material.set_shader_parameter("noise_texture", noise_texture)
	material.set_shader_parameter("use_noise_texture", use_noise_texture)
	material.set_shader_parameter("noise_scale", noise_scale)
	material.set_shader_parameter("noise_influence", noise_influence)
	# Width Animation
	material.set_shader_parameter("initial_width_mult", initial_width_mult)
	material.set_shader_parameter("final_width_mult", final_width_mult)
	material.set_shader_parameter("duration", duration)
	material.set_shader_parameter("loop_animation", loop_animation)
	material.set_shader_parameter("ping_pong", ping_pong)
	# Easing
	material.set_shader_parameter("tween_type", tween_type)
	material.set_shader_parameter("trans_type", trans_type)
