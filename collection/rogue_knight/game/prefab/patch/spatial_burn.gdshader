shader_type spatial;

uniform vec4 noise_color : source_color;
uniform sampler2D noise_texture : source_color, filter_nearest;
uniform float tolerance : hint_range(0,1.0);
uniform float noise_scale : hint_range(0.0,10.0);

void fragment() {
	vec2 uv = vec2(0.0);

	uv = UV;

	ALBEDO = noise_color.rgb;
	vec4 noise = texture(noise_texture, uv * noise_scale);
	float avg = (noise.r+noise.g+noise.b)/3.0; //get average value of pixel from noise
	if (avg < tolerance) 
		ALPHA = noise_color.a; //if average value is within tolerance, show the noise
	else
		ALPHA = 0.0; //otherwise dont
}