extends Node

"""
Easy set up for 3D pixelart viewport, camera, and environment properties
Load this as autoload under alias of "world"
"""

var top_down_cam: Camera3D
var world_env: WorldEnvironment
var env_profile: Environment
var world_light: DirectionalLight3D
var root_node: Node

func _ready():
	root_node = get_tree().get_root().get_node("Root")
	init_top_down_cam(root_node,5,10,-25)
	init_world_lighting(root_node)
	init_env_setting(root_node)

func init_top_down_cam(root:Node,y_pos:float,z_pos:float,cam_rot:float):
	## Camera Setting
	top_down_cam = Camera3D.new()
	top_down_cam.name = "WorldCamera"
	top_down_cam.position.y = y_pos;
	top_down_cam.position.z = z_pos;
	top_down_cam.rotation.x = deg_to_rad(cam_rot);
	root.add_child(top_down_cam)

func init_world_lighting(root:Node):
	## Lighting Setting
	world_light = DirectionalLight3D.new()
	world_light.name = "WorldLight"
	world_light.rotation.x = -15
	world_light.shadow_enabled = true
	world_light.light_color = Color("#FFFFFF")
	root.add_child(world_light)

func init_env_setting(root:Node):
	##Environment Setting
	world_env = WorldEnvironment.new()
	env_profile = Environment.new()
	env_profile.background_mode = Environment.BG_COLOR # Set background_mode to custom color
	env_profile.background_color = Color("#18BFF3") # Set background solid color
	env_profile.tonemap_mode = Environment.TONE_MAPPER_ACES # Set tonemap_mode to ACES
	env_profile.ssao_enabled = true
	env_profile.ssil_enabled = true
	env_profile.sdfgi_enabled = true
	env_profile.sdfgi_use_occlusion = true
	#env_profile.fog_enabled = true
	world_env.name = "WorldEnv"
	world_env.environment = env_profile
	root.add_child(world_env)	
