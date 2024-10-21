extends Node

"""
Easy set up for 3D pixelart viewport, camera, and environment properties
Load this as autoload under alias of "world"
"""

var toggle_pixelart_style = true
var toggle_pixelart_outline = true
#var pixel_art_post_processor = preload("res://material/pixel_outline.tres")
var pixel_art_post_processor

var toon_post_processor = preload("res://material/toon.tres")
var target_resolution = Vector2i(1920,1080)
var pixel_size = 3
 # The amount of pixelation set here. The bigger the number, more pixelated the look.

var world_cam: Camera3D
@export var cam_pos_y = 20.0 #15
@export var cam_pos_z = 3.0 #10
@export var cam_rot_x = -85.0
var world_env: WorldEnvironment
var env_profile: Environment
@export var sky_color = "#ffd6b3"
#var sky_shader_morning = preload("res://shader/sky_morning.tres")
#var sky_shader_afternoon = preload("res://shader/sky_afternoon.tres")
var sky_profile: Sky
@export var fog_color = "#5864a6"
var world_light: DirectionalLight3D
@export var light_color = "#F4DEC7"
@export var light_rotation := -170
var root_node: Node

func _ready():

	root_node = get_tree().get_root().get_node("root/main")
	DisplayServer.window_set_size(target_resolution) ## Set Window Size
	init_world_cam(root_node,cam_pos_y,cam_pos_z,cam_rot_x)
	init_world_lighting(root_node)
	init_env_setting(root_node)
	init_pixelart_outline(root_node, toggle_pixelart_outline, world_cam, pixel_art_post_processor)	
	init_pixelart_style(root_node, toggle_pixelart_style, pixel_size)
	
func init_world_cam(root:Node,y_pos:float,z_pos:float,cam_rot:float):
	## Camera Setting
	world_cam = Camera3D.new()
	world_cam.name = "WorldCamera"
	world_cam.position.y = y_pos;
	world_cam.position.z = z_pos;
	world_cam.rotation.x = deg_to_rad(cam_rot);
	world_cam.projection = Camera3D.PROJECTION_PERSPECTIVE
	world_cam.fov = 85.0
	world_cam.size = 25.0
	root.add_child(world_cam)

func init_world_lighting(root:Node):
	## Lighting Setting
	world_light = DirectionalLight3D.new()
	world_light.name = "WorldLight"
	world_light.rotation.x = deg_to_rad(light_rotation)
	world_light.shadow_enabled = true
	world_light.light_color = Color(light_color)
	world_light.light_energy = 0.9
	world_light.directional_shadow_fade_start = 0.0
	world_light.shadow_blur = 0.1
	root.add_child(world_light)

func init_env_setting(root:Node):
	##Environment Setting
	world_env = WorldEnvironment.new()
	env_profile = Environment.new()
	env_profile.background_mode = Environment.BG_SKY # Set background_mode to custom color
	sky_profile = Sky.new()
	env_profile.sky = sky_profile
	#sky_profile.sky_material = sky_shader_morning
	env_profile.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env_profile.ambient_light_sky_contribution = 0.5
	env_profile.ambient_light_energy = 3.2
	env_profile.background_color = Color(sky_color) # Set background solid color
	env_profile.tonemap_mode = Environment.TONE_MAPPER_FILMIC # Set tonemap_mode to FILMIC
	env_profile.tonemap_exposure = 0.6
	env_profile.tonemap_white = 0.5
	#env_profile.ssao_enabled = true
	#env_profile.ssil_enabled = true
	env_profile.sdfgi_enabled = true
	env_profile.sdfgi_use_occlusion = true
	env_profile.volumetric_fog_enabled = true
	env_profile.volumetric_fog_anisotropy = 0.9
	env_profile.volumetric_fog_ambient_inject = 0.4
	#env_profile.fog_light_color = fog_color
	#env_profile.fog_light_energy = 1.0
	env_profile.volumetric_fog_density = 0.0075
	#env_profile.fog_sky_affect = 0.3
	
	env_profile.glow_enabled = true
	env_profile.glow_normalized = true
	env_profile.glow_intensity = 0.75
	env_profile.glow_strength = 0.5
	env_profile.glow_bloom = 0.75
	env_profile.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	
	env_profile.adjustment_enabled = true
	env_profile.adjustment_brightness = 1
	env_profile.adjustment_contrast = 0.85
	env_profile.adjustment_saturation = 0.75
	
	world_env.name = "WorldEnv"
	world_env.environment = env_profile
	root.add_child(world_env)	

func init_pixelart_outline(root:Node, outline_toggle: bool, world_cam_node:Camera3D, pixel_outline_material:Resource):
	## Mesh Renderer
	if outline_toggle:
		var pixel_outline_renderer = MeshInstance3D.new()
		var plane_mesh = QuadMesh.new()
		plane_mesh.resource_name = "Plane"
		plane_mesh.size = Vector2(2,2)
		plane_mesh.flip_faces = true
		pixel_outline_renderer.mesh = plane_mesh
		pixel_outline_renderer.extra_cull_margin = 16300 # Extra big number
		pixel_outline_renderer.set_surface_override_material(0,pixel_outline_material)
		pixel_outline_renderer.name = "OutlineRenderer"
		world_cam_node.add_child(pixel_outline_renderer)

func init_pixelart_style(root:Node, pixel_style_toggle: bool, pixel_size:int):
	## Add Subviewport setting only if PixelArt display is enabled
	if pixel_style_toggle:
		var pixel_viewport = SubViewportContainer.new()
		pixel_viewport.name = "PixelViewport"
		pixel_viewport.stretch = true
		pixel_viewport.stretch_shrink = pixel_size
		pixel_viewport.layout_direction = Control.LAYOUT_DIRECTION_LOCALE
		pixel_viewport.size = target_resolution
		pixel_viewport.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		pixel_viewport.anchors_preset = Control.PRESET_FULL_RECT
		pixel_viewport.size_flags_horizontal = Control.SIZE_FILL
		pixel_viewport.size_flags_vertical = Control.SIZE_FILL
		pixel_viewport.material = toon_post_processor
		root.add_child(pixel_viewport)
		
		var pixel_subviewport = SubViewport.new()
		pixel_subviewport.name = "PixelSubViewport"
		pixel_subviewport.handle_input_locally = false
		pixel_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		pixel_viewport.add_child(pixel_subviewport)
		
		# Reparent to pixel filter
		for child in root.get_children():
			if child is SubViewportContainer:
				pass
			else: child.reparent(pixel_subviewport)

#func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#if sky_profile.sky_material == sky_shader_morning:
			#sky_profile.sky_material = sky_shader_afternoon
		#else:
			#sky_profile.sky_material = sky_shader_morning
