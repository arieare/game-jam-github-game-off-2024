shader_type spatial;

uniform vec4 aura_color : source_color = vec4(2.0, 1.0, 0.0, 0.09);
uniform float aura_thickness : hint_range(0.01, 0.1) = 0.01;
uniform bool apply_to_mesh = true;
uniform float pulse_speed : hint_range(0.1, 5.0) = 1.0;
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.2;

void vertex() {
    if (apply_to_mesh) {
        VERTEX = VERTEX + NORMAL * aura_thickness;
    }
}

void fragment() {
    float time = TIME * pulse_speed;
    float pulse_factor = sin(time) * 0.5 + 0.5;

    vec4 dynamic_aura_color = aura_color * (1.0 + pulse_strength * pulse_factor);

    ALBEDO = dynamic_aura_color.rgb;
    ALPHA = dynamic_aura_color.a;

    EMISSION = dynamic_aura_color.rgb * 2.0;
}