// NOTE: Shader automatically converted from Godot Engine 4.4.dev3's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_schlick_ggx, depth_prepass_alpha;

uniform vec3 top_color: source_color;
uniform vec3 bottom_color: source_color;
uniform sampler2D color_noise;
uniform float noise_scale = 20.0;
varying vec3 world_pos;

uniform vec3 wind_direction; // Use a negative y component to give it an extra touch (For displacement effect and noise scroll direction)
uniform float wind_strength: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform sampler2D wind_noise; // Periln FBM Noise looks Best
uniform float wind_noise_size: hint_range(0.0, 1.0, 0.001) = 0.05; // high values dont work well
uniform float wind_noise_speed: hint_range(0.0, 1.0, 0.001) = 0.1;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;

	// Billboard Mode: Enabled
	//MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			//MAIN_CAM_INV_VIEW_MATRIX[0],
			//MAIN_CAM_INV_VIEW_MATRIX[1],
			//MAIN_CAM_INV_VIEW_MATRIX[2],
			//MODEL_MATRIX[3]);
	//MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);

	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec3 wind_texture = texture(wind_noise, world_position.xz * wind_noise_size + normalize(-wind_direction.xz) * (TIME + UV.y / 2.5) * wind_noise_speed).rgb;
	vec3 wind_vector = (vec4(wind_texture * normalize(wind_direction) * wind_strength, 0.0) * MODEL_MATRIX).xyz;

	// Apply Wind displacement linearly
	VERTEX += wind_vector * (1.0 - UV.y) * (1.0 - 1.0 * 0.7);

	// A new normal correction, which aligns the normals of the mesh facing upwards no matter the original direction.
	NORMAL = vec3(0.0, 1.0, 0.0);
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness * 0.0;
	ALPHA *= albedo.a * albedo_tex.a;

	vec3 noise_level = texture(color_noise, world_pos.xz / noise_scale).rgb;
	ALBEDO = mix(top_color, bottom_color, UV.y) * mix(top_color, bottom_color, noise_level.r);
	//ALBEDO = mix(top_color, bottom_color, UV.y) * mix(bottom_color, noise_level, UV.y);
	ALPHA *= albedo_tex.a;

	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}
