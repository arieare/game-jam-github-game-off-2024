extends Node

@export var root_node: Node
var world_light: DirectionalLight3D
@export var light_color = Color.YELLOW
@export var light_rotation := -170

func _ready() -> void:
	init_world_lighting(root_node)

func init_world_lighting(_root:Node):
	## Lighting Setting
	world_light = DirectionalLight3D.new()
	world_light.name = "world_light"
	world_light.rotation.x = deg_to_rad(light_rotation)
	world_light.shadow_enabled = true
	world_light.light_color = Color(light_color)
	world_light.light_energy = 0.9
	world_light.directional_shadow_fade_start = 0.0
	world_light.shadow_blur = 0.1
	self.add_child.call_deferred(world_light)
	# Emit world light to game manager

func set_light_rotation(degree, rate):
	world_light.rotation.x = lerpf(world_light.rotation.x, degree, rate)

func set_light_energy(energy):
	world_light.light_energy = lerpf(world_light.light_energy, energy, 0.1)
