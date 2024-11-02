extends Node3D
class_name class_car_arcade_2d

# Extend this to node3D

# Node references
# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -2, 0)
@export var rigid_body_sphere: RigidBody3D
@export var car_mesh: MeshInstance3D
var ball_radius = 4.0

# Engine power
@export var acceleration = 40
# Turn amount, in degrees
@export var steering = 21.0
# How quickly the car turns
@export var turn_speed = 20
# Below this speed, the car doesn't turn
@export var turn_stop_limit = 1.75

# Variables for input values
var speed_input = 0
var rotate_input = 0

func get_input(): # Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("move_forward")
	speed_input -= Input.get_action_strength("move_backward")
	speed_input *= acceleration
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg_to_rad(steering)

# Called when the node enters the scene tree for the first time.
func _ready():
	util.input_map.input_setting()
	sphere_offset = Vector3(0, ball_radius * -1, 0)
	
	## Add RigidBody Sphere
	#rigid_body_sphere = RigidBody3D.new()
	rigid_body_sphere.name = "CarRigidBody"
	
	var rigid_body_physics = PhysicsMaterial.new()
	rigid_body_physics.friction = 1
	rigid_body_physics.bounce = 0.1
	rigid_body_physics.rough = true
	
	rigid_body_sphere.physics_material_override = rigid_body_physics
	rigid_body_sphere.gravity_scale = 10
	rigid_body_sphere.angular_damp = 5
	
	var rigid_body_collision:CollisionShape3D = rigid_body_sphere.get_child(0)
	rigid_body_collision.name = "CarCollision"
	#var rigid_body_collision_shape = SphereShape3D.new()
	rigid_body_collision.shape.radius = ball_radius
	#rigid_body_collision.shape = rigid_body_collision_shape
	
	#rigid_body_sphere.add_child(rigid_body_collision)
	#self.add_child(rigid_body_sphere)	



func _physics_process(delta):
	car_mesh.transform.origin = rigid_body_sphere.transform.origin + sphere_offset
	self.transform.origin = rigid_body_sphere.transform.origin
	rigid_body_sphere.apply_central_force(-car_mesh.global_transform.basis.z * speed_input)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()	
	# rotate car mesh
	if rigid_body_sphere.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
