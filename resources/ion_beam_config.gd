@tool
class_name IonBeamConfig
extends Resource

## Configuration resource for ion beam shader with live preview in editor.
## Assign to a node with an IonBeamController script.

signal config_changed

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

@export_group("Wobble")
@export_range(0.0, 0.2) var wobble_amount: float = 0.015:
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

@export_group("Taper")
@export_range(0.0, 0.5) var taper_top: float = 0.05:
	set(value):
		taper_top = value
		emit_changed()
		config_changed.emit()

@export_range(0.0, 0.5) var taper_bottom: float = 0.0:
	set(value):
		taper_bottom = value
		emit_changed()
		config_changed.emit()

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
	material.set_shader_parameter("beam_color", Vector3(beam_color.r, beam_color.g, beam_color.b))
	material.set_shader_parameter("core_color", Vector3(core_color.r, core_color.g, core_color.b))
	material.set_shader_parameter("intensity", intensity)
	material.set_shader_parameter("beam_width", beam_width)
	material.set_shader_parameter("core_width", core_width)
	material.set_shader_parameter("edge_softness", edge_softness)
	material.set_shader_parameter("wobble_amount", wobble_amount)
	material.set_shader_parameter("wobble_frequency", wobble_frequency)
	material.set_shader_parameter("wobble_speed", wobble_speed)
	material.set_shader_parameter("pulse_amount", pulse_amount)
	material.set_shader_parameter("pulse_speed", pulse_speed)
	material.set_shader_parameter("flicker_amount", flicker_amount)
	material.set_shader_parameter("flicker_speed", flicker_speed)
	material.set_shader_parameter("scanline_density", scanline_density)
	material.set_shader_parameter("scanline_speed", scanline_speed)
	material.set_shader_parameter("scanline_strength", scanline_strength)
	material.set_shader_parameter("pixel_size", pixel_size)
	material.set_shader_parameter("breakup_amount", breakup_amount)
	material.set_shader_parameter("breakup_speed", breakup_speed)
	material.set_shader_parameter("taper_top", taper_top)
	material.set_shader_parameter("taper_bottom", taper_bottom)
	material.set_shader_parameter("initial_width_mult", initial_width_mult)
	material.set_shader_parameter("final_width_mult", final_width_mult)
	material.set_shader_parameter("duration", duration)
	material.set_shader_parameter("loop_animation", loop_animation)
	material.set_shader_parameter("ping_pong", ping_pong)
	material.set_shader_parameter("tween_type", tween_type)
	material.set_shader_parameter("trans_type", trans_type)
