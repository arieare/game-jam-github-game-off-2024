extends RigidBody3D
class_name class_car_physics_2d

## List of node
@onready var root = get_tree().get_root().get_child(0)

@export var input_node: InputHandler

#@export var interaction:InteractionAreaModule

func _interact_drive():
	root.common.event_bus.emit_signal("car_drive_state", root.DRIVE_STATE.DRIVE)

@export var car_collision: CollisionShape3D
var raycast_array = ["fl","fr","bl","br"]
#var wheel_script = load("res://game/core/car/car_wheel.gd")
var wheel_mesh = preload("res://game/core/block/wheel.tscn")
var wheel_offset:Vector2 = Vector2(0.02, 0.2)

## Car Properties
@export var car_mass = 10.0
@export var car_center_of_mass = -0.6 # set it lower to avoid flipping
var spring_strength = 500.0
var spring_damper = 20.0
var wheel_radius = 0.17
@onready var suspension_rest_distance : float = wheel_radius * 2

@export var engine_power = 70.0
var accel_input

@export var steering_angle = 25.0
@export var front_tire_grip = 0.5
@export var rear_tire_grip = 0.2
var steering_input

@export var slip_speed = 9.0
@export var traction_slow = 0.75
@export var traction_fast = 0.02

var bool_is_drifting = false
var drifting_input: bool

func register_self_to_root():
	root.car = self

func _ready() -> void:
	#register_self_to_root()
	#interaction.interact = Callable(self, "_interact_drive")
	self.mass = car_mass
	self.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	self.center_of_mass.y = car_center_of_mass
	
	set_up_ray_cast_position()

func _process(delta):
	pass
	#match root.current_drive_state:
			#root.DRIVE_STATE.PARK:
				#pass
			#root.DRIVE_STATE.DRIVE:
				#root.cam_target = root.car
				#accel_input = input_node.get_input_accel()
				#steering_input = input_node.get_input_steer()
				#drifting_input = input_node.get_input_drift()


func set_up_ray_cast_position():
	var wheel_group = Node3D.new()
	wheel_group.name = "wheel_group"
	self.add_child(wheel_group)
	
	var wheel_mesh_group = Node3D.new()
	wheel_mesh_group.name = "wheel_mesh_group"
	self.add_child(wheel_mesh_group)	
	
	for ray_wheel in raycast_array:
		var rays = class_car_3d_wheel.new()
		rays.name = ray_wheel
		#rays.set_script(wheel_script)
		if ray_wheel == "bl" or ray_wheel == "br":
			rays.is_motor_wheel = true
		wheel_group.add_child(rays)
		
		var wheel_mesh_instance = wheel_mesh.instantiate()
		wheel_mesh_instance.name = ray_wheel
		wheel_mesh_group.add_child(wheel_mesh_instance)
		
		rays.wheel_mesh = wheel_mesh_group

	for ray_cast in wheel_group.get_children():
		ray_cast.position.y =  -0.15
		if ray_cast.name == "fl" or ray_cast.name == "bl":
			ray_cast.position.x = car_collision.shape.size.x / 2 * -1 + wheel_offset.x
		if ray_cast.name == "fr" or ray_cast.name == "br":
			ray_cast.position.x = car_collision.shape.size.x / 2 - wheel_offset.x
		if ray_cast.name == "fl" or ray_cast.name == "fr":
			ray_cast.position.z = car_collision.shape.size.z / 2 * -1 + wheel_offset.y
		if ray_cast.name == "bl" or ray_cast.name == "br":
			ray_cast.position.z = car_collision.shape.size.z / 2 - wheel_offset.y
	
