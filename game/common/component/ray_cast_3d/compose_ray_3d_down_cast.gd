class_name compose_ray_3d_down_cast extends RayCast3D

var actor: RigidBody3D

var is_on_floor: bool = false
var collision: Dictionary = {}

## components
@onready var levitate: component_ray_3d_levitate = component_ray_3d_levitate.new()
@onready var ground_check: component_ray_3d_ground_check = component_ray_3d_ground_check.new()
@onready var ray_collision: component_ray_3d_collision_check = component_ray_3d_collision_check.new()

func _ready() -> void: 
	# dependency injection
	levitate.ray_parent = self
	ground_check.ray_parent = self
	ray_collision.ray_parent = self
	collision = ray_collision.ray_collision_check()

func _physics_process(delta: float) -> void:
	collision = ray_collision.ray_collision_check()
	levitate.levitate_actor(delta, actor)
	is_on_floor = ground_check.on_ground_check()
