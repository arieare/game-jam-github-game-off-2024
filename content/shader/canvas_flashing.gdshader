shader_type canvas_item;
uniform vec3 palette: source_color = vec3(1,1,1);
uniform float flashingModifier: hint_range(0.0,1.0);

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	color.rgb = mix(color.rgb, palette, flashingModifier);
	COLOR = color;
}
