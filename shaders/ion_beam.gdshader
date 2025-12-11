shader_type spatial;

// Ion Cannon Targeting Laser - A thin energy beam with visual effects
// Uses a QuadMesh billboard for best visual control
render_mode unshaded, cull_disabled, depth_draw_opaque;

// === APPEARANCE ===
uniform vec3 beam_color : source_color = vec3(0.2, 0.6, 1.0);
uniform vec3 core_color : source_color = vec3(0.8, 0.95, 1.0);
uniform float intensity : hint_range(0.5, 10.0) = 3.0;
uniform float beam_width : hint_range(0.01, 1.0) = 0.08;
uniform float core_width : hint_range(0.0, 1.0) = 0.3; // Ratio of beam_width
uniform float edge_softness : hint_range(0.0, 1.0) = 0.5;

// === EFFECTS ===
// Wobble - lateral displacement along the beam
uniform float wobble_amount : hint_range(0.0, 0.2) = 0.015;
uniform float wobble_frequency : hint_range(0.0, 50.0) = 12.0;
uniform float wobble_speed : hint_range(0.0, 20.0) = 8.0;

// Pulse - intensity variation over time
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.3;
uniform float pulse_speed : hint_range(0.0, 20.0) = 4.0;

// Flicker - random high-frequency intensity noise
uniform float flicker_amount : hint_range(0.0, 1.0) = 0.15;
uniform float flicker_speed : hint_range(0.0, 100.0) = 30.0;

// Scanlines - horizontal energy bands traveling along beam
uniform float scanline_density : hint_range(0.0, 100.0) = 25.0;
uniform float scanline_speed : hint_range(0.0, 20.0) = 5.0;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.25;

// Pixelation / Digital breakup
uniform float pixel_size : hint_range(0.0, 0.1) = 0.0; // 0 = disabled
uniform float breakup_amount : hint_range(0.0, 1.0) = 0.0;
uniform float breakup_speed : hint_range(0.0, 10.0) = 2.0;

// Taper - beam gets thinner at ends
uniform float taper_top : hint_range(0.0, 0.5) = 0.05;
uniform float taper_bottom : hint_range(0.0, 0.5) = 0.0;

// === ANIMATION (width collapse/expand) ===
uniform float initial_width_mult : hint_range(0.0, 5.0) = 1.0;
uniform float final_width_mult : hint_range(0.0, 5.0) = 1.0;
uniform float duration : hint_range(0.1, 10.0) = 2.0;
uniform bool loop_animation = false;
uniform bool ping_pong = false;
uniform int tween_type : hint_range(0, 8) = 0; // 0=Linear,1=Sine,2=Quad,3=Cubic,4=Quart,5=Expo,6=Elastic,7=Back,8=Bounce
uniform int trans_type : hint_range(0, 2) = 0;  // 0=In,1=Out,2=InOut

// === HELPER FUNCTIONS ===
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    return mix(hash(i), hash(i + 1.0), smoothstep(0.0, 1.0, f));
}

float bounce_out(float t) {
    if (t < 1.0 / 2.75) {
        return 7.5625 * t * t;
    } else if (t < 2.0 / 2.75) {
        float t2 = t - 1.5 / 2.75;
        return 7.5625 * t2 * t2 + 0.75;
    } else if (t < 2.5 / 2.75) {
        float t2 = t - 2.25 / 2.75;
        return 7.5625 * t2 * t2 + 0.9375;
    } else {
        float t2 = t - 2.625 / 2.75;
        return 7.5625 * t2 * t2 + 0.984375;
    }
}

float ease_in(float t, int type) {
    if (type == 0) return t;
    if (type == 1) return 1.0 - cos(t * PI * 0.5);
    if (type == 2) return t * t;
    if (type == 3) return t * t * t;
    if (type == 4) return t * t * t * t;
    if (type == 5) return t == 0.0 ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
    if (type == 6) return -pow(2.0, 10.0 * t - 10.0) * sin((t * 10.0 - 10.75) * (2.0 * PI) / 3.0);
    if (type == 7) return 2.70158 * t * t * t - 1.70158 * t * t;
    if (type == 8) return 1.0 - bounce_out(1.0 - t);
    return t;
}

float ease_out(float t, int type) {
    if (type == 0) return t;
    if (type == 1) return sin(t * PI * 0.5);
    if (type == 2) return 1.0 - (1.0 - t) * (1.0 - t);
    if (type == 3) return 1.0 - pow(1.0 - t, 3.0);
    if (type == 4) return 1.0 - pow(1.0 - t, 4.0);
    if (type == 5) return t == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * t);
    if (type == 6) return pow(2.0, -10.0 * t) * sin((t * 10.0 - 0.75) * (2.0 * PI) / 3.0) + 1.0;
    if (type == 7) return 1.0 + 2.70158 * pow(t - 1.0, 3.0) + 1.70158 * pow(t - 1.0, 2.0);
    if (type == 8) return bounce_out(t);
    return t;
}

float apply_easing(float t, int tween, int trans) {
    if (trans == 0) return ease_in(t, tween);
    if (trans == 1) return ease_out(t, tween);
    if (trans == 2) {
        if (t < 0.5) return ease_in(t * 2.0, tween) * 0.5;
        return ease_out((t - 0.5) * 2.0, tween) * 0.5 + 0.5;
    }
    return t;
}

void fragment() {
    // UV: x = horizontal (across beam width), y = vertical (along beam length, 0=bottom, 1=top)
    vec2 uv = UV;
    
    // === ANIMATION PROGRESS ===
    float raw_time = TIME / duration;
    float progress = 0.0;
    if (loop_animation) {
        if (ping_pong) {
            progress = abs(mod(raw_time, 2.0) - 1.0);
        } else {
            progress = fract(raw_time);
        }
    } else {
        progress = clamp(raw_time, 0.0, 1.0);
    }
    float eased = apply_easing(progress, tween_type, trans_type);
    float width_mult = mix(initial_width_mult, final_width_mult, eased);
    
    // === PIXELATION ===
    vec2 working_uv = uv;
    if (pixel_size > 0.0) {
        working_uv = floor(uv / pixel_size) * pixel_size + pixel_size * 0.5;
    }
    
    // === WOBBLE ===
    float wobble = sin(working_uv.y * wobble_frequency + TIME * wobble_speed) * wobble_amount;
    wobble += sin(working_uv.y * wobble_frequency * 2.3 + TIME * wobble_speed * 1.7) * wobble_amount * 0.5;
    
    // === DIGITAL BREAKUP ===
    float breakup_offset = 0.0;
    if (breakup_amount > 0.0) {
        float break_noise = noise(working_uv.y * 50.0 + TIME * breakup_speed);
        if (break_noise > (1.0 - breakup_amount)) {
            breakup_offset = (noise(working_uv.y * 100.0 + TIME * 10.0) - 0.5) * 0.15;
        }
    }
    
    // === TAPER ===
    float taper = 1.0;
    if (taper_top > 0.0) {
        taper *= smoothstep(0.0, taper_top, 1.0 - working_uv.y);
    }
    if (taper_bottom > 0.0) {
        taper *= smoothstep(0.0, taper_bottom, working_uv.y);
    }
    
    // === BEAM SHAPE ===
    float current_width = beam_width * width_mult * taper;
    float center = 0.5 + wobble + breakup_offset;
    float dist_from_center = abs(working_uv.x - center);
    
    // Soft edge falloff
    float half_width = current_width * 0.5;
    float edge = half_width * (1.0 - edge_softness);
    float beam = 1.0 - smoothstep(edge, half_width, dist_from_center);
    
    // Core (brighter center line)
    float core = 1.0 - smoothstep(0.0, half_width * core_width, dist_from_center);
    
    // === SCANLINES ===
    float scanline = 1.0;
    if (scanline_strength > 0.0) {
        float scan = sin((working_uv.y * scanline_density - TIME * scanline_speed) * PI * 2.0);
        scanline = 1.0 - scanline_strength * 0.5 * (1.0 - scan);
    }
    
    // === PULSE ===
    float pulse = 1.0 + pulse_amount * sin(TIME * pulse_speed);
    
    // === FLICKER ===
    float flicker = 1.0 - flicker_amount * noise(TIME * flicker_speed);
    
    // === COMBINE ===
    float final_intensity = intensity * pulse * flicker * scanline;
    
    // Mix core color and beam color based on distance from center
    vec3 color = mix(beam_color, core_color, core * core);
    
    // Add slight glow halo beyond the main beam
    float halo = exp(-dist_from_center * 15.0 / max(current_width, 0.001)) * 0.3;
    
    float final_alpha = max(beam, halo) * smoothstep(0.0, 0.1, width_mult);
    
    ALBEDO = color * final_intensity;
    ALPHA = final_alpha;
}
