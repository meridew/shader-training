shader_type spatial;

// Ion Cannon Targeting Laser - A thin energy beam with visual effects
// Uses a QuadMesh with Y-axis billboard for best visual control
render_mode unshaded, cull_disabled, depth_draw_opaque;

// === BILLBOARD ===
uniform bool billboard_enabled = true; // Rotate to face camera around Y axis

varying vec3 world_vertex;

// === CHARGE SYSTEM (Master Control) ===
uniform float charge_level : hint_range(0.0, 1.0) = 1.0; // 0=off, 1=full power
uniform bool use_charge_level = false; // When true, charge_level controls intensity/width/instability

// === APPEARANCE ===
uniform vec3 beam_color : source_color = vec3(0.2, 0.6, 1.0);
uniform vec3 core_color : source_color = vec3(0.8, 0.95, 1.0);
uniform float intensity : hint_range(0.5, 10.0) = 3.0;
uniform float beam_width : hint_range(0.01, 1.0) = 0.08;
uniform float core_width : hint_range(0.0, 1.0) = 0.3; // Ratio of beam_width
uniform float edge_softness : hint_range(0.0, 1.0) = 0.5;

// === SECONDARY GLOW ===
uniform float outer_glow_size : hint_range(0.0, 5.0) = 2.0;
uniform float outer_glow_intensity : hint_range(0.0, 1.0) = 0.3;
uniform vec3 outer_glow_color : source_color = vec3(0.1, 0.3, 0.8);

// === CHROMATIC ABERRATION ===
uniform float chromatic_amount : hint_range(0.0, 0.1) = 0.0;
uniform float chromatic_speed : hint_range(0.0, 10.0) = 2.0;

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
uniform float taper_top : hint_range(0.0, 0.5) = 0.0;
uniform float taper_bottom : hint_range(0.0, 0.5) = 0.0;

// === ENERGY BUILDUP ===
uniform float energy_flow_speed : hint_range(0.0, 10.0) = 0.0; // 0=disabled, energy flows bottom to top
uniform float energy_flow_strength : hint_range(0.0, 1.0) = 0.5;

// === INSTABILITY / JITTER ===
uniform float jitter_amount : hint_range(0.0, 0.1) = 0.0;
uniform float jitter_speed : hint_range(0.0, 50.0) = 20.0;

// === ENDPOINT EFFECTS ===
uniform float origin_glow_size : hint_range(0.0, 0.3) = 0.0; // Glow at top (origin)
uniform float origin_glow_intensity : hint_range(0.0, 3.0) = 1.5;
uniform float impact_glow_size : hint_range(0.0, 0.3) = 0.0; // Glow at bottom (impact)
uniform float impact_glow_intensity : hint_range(0.0, 3.0) = 1.5;

// === NOISE TEXTURE ===
uniform sampler2D noise_texture : hint_default_white;
uniform bool use_noise_texture = false;
uniform float noise_scale : hint_range(0.1, 10.0) = 1.0;
uniform float noise_influence : hint_range(0.0, 1.0) = 0.5;

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

float hash2(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    return mix(hash(i), hash(i + 1.0), smoothstep(0.0, 1.0, f));
}

float noise2d(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash2(i), hash2(i + vec2(1.0, 0.0)), f.x),
        mix(hash2(i + vec2(0.0, 1.0)), hash2(i + vec2(1.0, 1.0)), f.x),
        f.y
    );
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

// Calculate beam shape for a given center offset (used for chromatic aberration)
float calc_beam(vec2 uv, float center, float current_width, float softness) {
    float dist = abs(uv.x - center);
    float half_w = current_width * 0.5;
    float edge = half_w * (1.0 - softness);
    return 1.0 - smoothstep(edge, half_w, dist);
}

void vertex() {
    // Y-axis billboard: rotate quad to face camera while keeping vertical orientation
    if (billboard_enabled) {
        // Get camera position in model space
        vec3 cam_pos = (inverse(MODEL_MATRIX) * vec4(INV_VIEW_MATRIX[3].xyz, 1.0)).xyz;
        
        // Calculate direction to camera on XZ plane only (ignore Y)
        vec3 to_camera = cam_pos - vec3(0.0);
        to_camera.y = 0.0;
        to_camera = normalize(to_camera);
        
        // Calculate rotation angle around Y axis
        float angle = atan(to_camera.x, to_camera.z);
        
        // Rotate vertex around Y axis
        float cos_a = cos(angle);
        float sin_a = sin(angle);
        vec3 rotated = vec3(
            VERTEX.x * cos_a + VERTEX.z * sin_a,
            VERTEX.y,
            -VERTEX.x * sin_a + VERTEX.z * cos_a
        );
        VERTEX = rotated;
    }
    
    world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    // UV: x = horizontal (across beam width), y = vertical (along beam length, 0=bottom, 1=top)
    vec2 uv = UV;
    
    // === CHARGE LEVEL INFLUENCE ===
    float effective_charge = use_charge_level ? charge_level : 1.0;
    float charge_intensity_mult = mix(0.3, 1.0, effective_charge);
    float charge_width_mult = mix(0.5, 1.0, effective_charge);
    float charge_instability = use_charge_level ? (1.0 - effective_charge) * 0.5 : 0.0;
    
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
    
    // === JITTER ===
    float jitter = 0.0;
    float total_jitter = jitter_amount + charge_instability;
    if (total_jitter > 0.0) {
        jitter = (noise(TIME * jitter_speed) - 0.5) * total_jitter * 2.0;
        jitter += (noise(TIME * jitter_speed * 3.7 + 100.0) - 0.5) * total_jitter;
    }
    
    // === PIXELATION ===
    vec2 working_uv = uv;
    if (pixel_size > 0.0) {
        working_uv = floor(uv / pixel_size) * pixel_size + pixel_size * 0.5;
    }
    
    // === NOISE TEXTURE SAMPLING ===
    float tex_noise = 1.0;
    if (use_noise_texture) {
        vec2 noise_uv = working_uv * noise_scale + vec2(TIME * 0.1, TIME * 0.2);
        tex_noise = texture(noise_texture, noise_uv).r;
        tex_noise = mix(1.0, tex_noise, noise_influence);
    }
    
    // === WOBBLE ===
    float wobble = sin(working_uv.y * wobble_frequency + TIME * wobble_speed) * wobble_amount;
    wobble += sin(working_uv.y * wobble_frequency * 2.3 + TIME * wobble_speed * 1.7) * wobble_amount * 0.5;
    
    // === DIGITAL BREAKUP ===
    float breakup_offset = 0.0;
    float total_breakup = breakup_amount + charge_instability * 0.3;
    if (total_breakup > 0.0) {
        float break_noise = noise(working_uv.y * 50.0 + TIME * breakup_speed);
        if (break_noise > (1.0 - total_breakup)) {
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
    
    // === ENERGY FLOW (bottom to top buildup) ===
    float energy_flow = 1.0;
    if (energy_flow_speed > 0.0) {
        float flow_wave = fract(working_uv.y - TIME * energy_flow_speed);
        energy_flow = 1.0 + energy_flow_strength * smoothstep(0.0, 0.3, flow_wave) * smoothstep(0.6, 0.3, flow_wave);
    }
    
    // === BEAM SHAPE ===
    float current_width = beam_width * width_mult * taper * charge_width_mult;
    float center = 0.5 + wobble + breakup_offset + jitter;
    float dist_from_center = abs(working_uv.x - center);
    
    // Soft edge falloff
    float half_width = current_width * 0.5;
    float edge = half_width * (1.0 - edge_softness);
    float beam = 1.0 - smoothstep(edge, half_width, dist_from_center);
    
    // Core (brighter center line)
    float core = 1.0 - smoothstep(0.0, half_width * core_width, dist_from_center);
    
    // === CHROMATIC ABERRATION ===
    vec3 chroma_color = vec3(0.0);
    float chroma_beam = beam;
    if (chromatic_amount > 0.0) {
        float chroma_offset = chromatic_amount * sin(TIME * chromatic_speed);
        float beam_r = calc_beam(working_uv, center - chroma_offset, current_width, edge_softness);
        float beam_g = calc_beam(working_uv, center, current_width, edge_softness);
        float beam_b = calc_beam(working_uv, center + chroma_offset, current_width, edge_softness);
        chroma_beam = max(max(beam_r, beam_g), beam_b);
        chroma_color = vec3(beam_r, beam_g, beam_b);
    }
    
    // === OUTER GLOW ===
    float outer_glow = 0.0;
    if (outer_glow_size > 0.0) {
        float glow_width = half_width * outer_glow_size;
        outer_glow = exp(-dist_from_center * 3.0 / max(glow_width, 0.001)) * outer_glow_intensity;
    }
    
    // === ENDPOINT EFFECTS ===
    float origin_effect = 0.0;
    if (origin_glow_size > 0.0) {
        float origin_dist = 1.0 - working_uv.y; // Distance from top
        origin_effect = smoothstep(origin_glow_size, 0.0, origin_dist) * origin_glow_intensity;
    }
    
    float impact_effect = 0.0;
    if (impact_glow_size > 0.0) {
        float impact_dist = working_uv.y; // Distance from bottom
        impact_effect = smoothstep(impact_glow_size, 0.0, impact_dist) * impact_glow_intensity;
    }
    
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
    flicker *= tex_noise; // Apply noise texture
    
    // === COMBINE ===
    float final_intensity = intensity * pulse * flicker * scanline * energy_flow * charge_intensity_mult;
    
    // Mix core color and beam color based on distance from center
    vec3 color = mix(beam_color, core_color, core * core);
    
    // Apply chromatic aberration
    if (chromatic_amount > 0.0) {
        color *= chroma_color;
    }
    
    // Add endpoint effects to color
    color += core_color * (origin_effect + impact_effect) * 0.5;
    
    // Add outer glow
    vec3 final_color = color * final_intensity;
    final_color += outer_glow_color * outer_glow * final_intensity * 0.5;
    
    // Calculate final alpha
    float main_beam = chromatic_amount > 0.0 ? chroma_beam : beam;
    float halo = exp(-dist_from_center * 15.0 / max(current_width, 0.001)) * 0.3;
    float final_alpha = max(main_beam, max(halo, outer_glow)) * smoothstep(0.0, 0.1, width_mult);
    final_alpha = max(final_alpha, (origin_effect + impact_effect) * 0.5);
    final_alpha *= effective_charge; // Fade with charge
    
    ALBEDO = final_color;
    ALPHA = final_alpha;
}
