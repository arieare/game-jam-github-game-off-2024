extends Node

@export var root_node: Node
var world_env: WorldEnvironment
var env_profile: Environment
@export var sky_color = Color.DARK_BLUE
#var sky_shader_morning = preload("res://shader/sky_morning.tres")
#var sky_shader_afternoon = preload("res://shader/sky_afternoon.tres")
#var sky_profile: Sky
@export var fog_color = Color.INDIGO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_env_setting(root_node)

func init_env_setting(_root:Node):
	## Environment Setting
	world_env = WorldEnvironment.new()
	env_profile = Environment.new()
	env_profile.background_mode = Environment.BG_COLOR # Set background_mode to custom color
	
	## Sky Setting
	#sky_profile = Sky.new()
	#env_profile.sky = sky_profile
	#sky_profile.sky_material = sky_shader_morning
	#env_profile.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	#env_profile.ambient_light_sky_contribution = 0.5
	#env_profile.ambient_light_energy = 3.2
	env_profile.background_color = Color(sky_color) # Set background solid color
	
	
	
	## Fog Setting
	env_profile.volumetric_fog_enabled = true
	env_profile.volumetric_fog_anisotropy = 0.9
	env_profile.volumetric_fog_ambient_inject = 0.4
	#env_profile.fog_light_color = fog_color
	#env_profile.fog_light_energy = 1.0
	env_profile.volumetric_fog_density = 0.0075
	env_profile.fog_sky_affect = 0.3
	
	## Glow Setting
	env_profile.glow_enabled = true
	env_profile.glow_normalized = true
	env_profile.glow_intensity = 0.75
	env_profile.glow_strength = 0.5
	env_profile.glow_bloom = 0.75
	env_profile.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	
	## Cinematic Setting
	env_profile.tonemap_mode = Environment.TONE_MAPPER_FILMIC # Set tonemap_mode to FILMIC
	env_profile.tonemap_exposure = 0.6
	env_profile.tonemap_white = 0.5
	env_profile.ssao_enabled = true
	env_profile.ssil_enabled = true
	env_profile.sdfgi_enabled = true
	env_profile.sdfgi_use_occlusion = true
	env_profile.adjustment_enabled = true
	env_profile.adjustment_brightness = 1
	env_profile.adjustment_contrast = 0.85
	env_profile.adjustment_saturation = 0.75

	world_env.name = "world_env"
	world_env.environment = env_profile
	self.add_child.call_deferred(world_env)	

func set_bg_energy(energy:float):
	env_profile.background_energy_multiplier = energy
