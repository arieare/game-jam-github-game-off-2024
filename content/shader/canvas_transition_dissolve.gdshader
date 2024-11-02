shader_type canvas_item;

uniform float time:hint_range(0.0, 1.57, 0.001) = 1.0;
uniform vec2 custom_resolution = vec2(100,100);
uniform vec4 screen_color:source_color;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,96.233))) * 43758.5453);
}

void fragment()
{
	vec2 within_texture_pixel=vec2(floor(UV * custom_resolution));
	//vec4 color= texture(TEXTURE,UV); // enable this to take the image texture as pixelation
	vec4 color= screen_color;

	if(sin(time) > rand(within_texture_pixel))
		COLOR = color;
	else
		COLOR = vec4(0.0,0.0,0.0,0.0);
}