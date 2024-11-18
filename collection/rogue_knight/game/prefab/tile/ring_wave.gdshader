shader_type spatial;
render_mode unshaded;

/*
RING SHADER
*/


uniform vec3 ring_color: source_color = vec3(1.0);
uniform float ring_frequency = 50.0;
/** Portion of the visible rings. Negative values give wider rings, positive values give narrower rings*/
uniform float ring_portion: hint_range(-0.9, 0.9, 0.1) = 0.0;
/** Negative values move the rings outwards, positive value move the rings inwards */
uniform float move_speed = -10.0;
uniform bool smooth_edge = false;

void fragment() {
	float dist = distance(UV, vec2(0.5,0.5));
	float rings = sin(dist * ring_frequency + (TIME * move_speed));
	rings = step(ring_portion, rings);
	float blend_alpha = smoothstep(0.5, 0.4, dist);
	if (dist > 0.5 || rings < 1.0){
		ALPHA = 0.0;
	}
	else if (rings > 0.0){
		ALBEDO = ring_color;
		ALPHA = smooth_edge ? blend_alpha : 1.0;
	}
}