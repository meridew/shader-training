# Copilot Instructions for shader-training

## Project Overview

This is a **Godot 4.5** project focused on shader development and experimentation. Uses the **Forward Plus** renderer. The learning goal is to build toward an **ion cannon charging effect**.

## Architecture

- **Entry Scene**: [main.tscn](../main.tscn) - 3D scene with environment, lighting, ground plane, and ion beam
- **Shaders**: [shaders/](../shaders/) - Custom `.gdshader` files
- **Renderer**: Forward Plus (GPU-driven, clustered lighting)

## Current Effects

### Ion Beam ([shaders/ion_beam.gdshader](../shaders/ion_beam.gdshader))
A targeting laser effect using a `QuadMesh` billboard with `spatial` shader:
- `render_mode unshaded, cull_disabled, depth_draw_opaque`
- Uses UV coordinates for 2D-style effects on a 3D plane
- Full suite of visual effects for energy beam aesthetics

**Effect Parameters:**
| Category | Parameters |
|----------|------------|
| Charge System | `charge_level`, `use_charge_level` (master control for intensity/width/instability) |
| Appearance | `beam_color`, `core_color`, `intensity`, `beam_width`, `core_width`, `edge_softness` |
| Secondary Glow | `outer_glow_size`, `outer_glow_intensity`, `outer_glow_color` |
| Heat Distortion | `heat_distortion_amount`, `heat_distortion_speed`, `heat_distortion_scale` |
| Chromatic Aberration | `chromatic_amount`, `chromatic_speed` |
| Wobble | `wobble_amount`, `wobble_frequency`, `wobble_speed` |
| Pulse/Flicker | `pulse_amount`, `pulse_speed`, `flicker_amount`, `flicker_speed` |
| Scanlines | `scanline_density`, `scanline_speed`, `scanline_strength` |
| Digital FX | `pixel_size`, `breakup_amount`, `breakup_speed` |
| Taper | `taper_top`, `taper_bottom` |
| Energy Buildup | `energy_flow_speed`, `energy_flow_strength` |
| Instability | `jitter_amount`, `jitter_speed` |
| Endpoint Effects | `origin_glow_size`, `origin_glow_intensity`, `impact_glow_size`, `impact_glow_intensity` |
| Noise Texture | `noise_texture`, `use_noise_texture`, `noise_scale`, `noise_influence` |
| Animation | `initial_width_mult`, `final_width_mult`, `duration`, `loop_animation`, `ping_pong` |
| Easing | `tween_type` (0-8), `trans_type` (0-2) |

**Scene-Level VFX:**
- **ImpactLight** - OmniLight3D at beam bottom, animated color/intensity
- **OriginLight** - OmniLight3D at beam top, animated color/intensity  
- **ImpactSparks** - GPUParticles3D at impact point, emits upward sparks
- **DirectionalLight3D** - Scene-wide illumination during fire (simulates beam lighting environment)
- **WorldEnvironment** - Animated glow, volumetric fog emission, brightness/saturation adjustments
- **Camera3D** - With CameraAttributesPractical for auto-exposure adaptation
- **ScreenFlash** - CanvasLayer with ColorRect for white flash on fire animations

**Architecture Pattern:**
- [resources/ion_beam_config.gd](../resources/ion_beam_config.gd) - `@tool` Resource for live editor preview
- [scripts/ion_beam_controller.gd](../scripts/ion_beam_controller.gd) - `@tool` controller applies config to material only
- [resources/default_beam.tres](../resources/default_beam.tres) - Saved preset (duplicate for variants)

**Control Hierarchy:**
1. **Shader** - Visual rendering via uniforms (beam shape, color, effects)
2. **AnimationPlayer** - Animates config properties, lights, particles, environment, and camera
3. **Controller Script** - Applies config resource to shader material

Lights and particles are controlled explicitly via AnimationPlayer tracks (not reactively by script).

Applied to a vertical `QuadMesh` (1x10 units, orientation=2) positioned at Y=5.

## Godot-Specific Patterns

### File Formats
- `.tscn` - Text-based scene files (prefer for version control)
- `.gdshader` - Shader files (GLSL-like syntax)
- `.tres` - Text-based resource files
- `.gd` - GDScript files

### Shader Development
When creating shaders:
```gdshader
shader_type spatial;  // For 3D materials
// or: shader_type canvas_item;  // For 2D
// or: shader_type particles;  // For GPU particles

void fragment() {
    ALBEDO = vec3(1.0);
}
```

### Material Hierarchy
Current scene uses `StandardMaterial3D` with `NoiseTexture2D` for detail masking. For custom shaders, create `ShaderMaterial` and assign a `.gdshader` resource.

## Key Commands

```bash
# Run project from CLI (ensure Godot is in PATH)
godot --path . 

# Export debug build
godot --export-debug "Windows Desktop" build/game.exe
```

## Conventions

- Scene root nodes use PascalCase (e.g., `Main`, `Player`)
- Keep shaders in a `shaders/` directory as project grows
- Use `SubResource` for inline resources in `.tscn` files; extract to `.tres` for reuse
- UTF-8 encoding for all files (per `.editorconfig`)

## Environment Setup

The scene includes:
- **ProceduralSkyMaterial** with horizon color blending
- **ACES tonemapping** (`tonemap_mode = 2`)
- **Glow** post-processing enabled
- **DirectionalLight3D** with shadows at 45° elevation
