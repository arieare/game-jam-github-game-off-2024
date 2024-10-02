extends RigidBody3D
class_name PhysicsBasedPlayer

## List of node
@onready var root = get_tree().get_root().get_child(0)

## References to its children
@export var collider:CollisionShape3D
@export var ray:RayCast3D

# View
@export var skin:Node3D
@export var body:Node3D
@export var body_head:Node3D
@export var body_torso:MeshInstance3D
@export var body_right_arm:MeshInstance3D
@export var body_left_arm:MeshInstance3D
@export var body_right_feet:MeshInstance3D
@export var body_left_feet:MeshInstance3D
@export var target_default_right_arm : Marker3D
@export var target_default_left_arm : Marker3D

@export var look_aim: MeshInstance3D

## List of movement node
@export var move_bobbing:Node3D

# Control
#@export var player_input:Node
@export var movement_state_machine:StateMachine
@export var position_state_machine:StateMachine
@export var skill_state_machine:StateMachine


# VFX
@export var slash_vfx : GPUParticles3D
@export var running_dust_vfx:GPUParticles3D
@export var warp_start_vfx:GPUParticles3D

func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)
	position_state_machine.process_input(event)
	skill_state_machine.process_input(event)

func _ready() -> void:
	movement_state_machine.init_state(self)
	position_state_machine.init_state(self)
	skill_state_machine.init_state(self)
	ray.actor = self
	
	register_self_to_root()
	move_bobbing.assert_parent(self)

func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)
	position_state_machine.process_frame(delta)
	skill_state_machine.process_frame(delta)
	look_at_cursor()


func _physics_process(delta: float) -> void:
	ray.ray_module["levitate"].levitate_actor(delta,self)
	
	movement_state_machine.process_physics(delta)
	position_state_machine.process_physics(delta)
	skill_state_machine.process_physics(delta)
	
	maintain_upright(delta)
	#if move_bobbing :move_bobbing.walk_bobbing(delta)
	
func register_self_to_root():
	root.player = self
	root.cam_target = self

func look_at_cursor():
	root.common["look_at_target"].look_at_target(look_aim, body_head, 0.2)
	root.common["look_at_target"].look_at_target(look_aim, body, 0.03)	

func maintain_upright(delta):
	if root.common["input_map"].get_direction() == Vector3.ZERO or self.angular_velocity.x > 15 or self.angular_velocity.x < -15 or self.angular_velocity.y > 5 or self.angular_velocity.y < -5 or self.angular_velocity.z > 15 or self.angular_velocity.z < -15:	
		var target_upright: float = 0.0
		self.rotation.x = root.common["pid_controller"].update_angle(self.rotation.x, target_upright, delta)
		self.rotation.z = root.common["pid_controller"].update_angle(self.rotation.z, target_upright, delta)
		self.rotation.y = root.common["pid_controller"].update_angle(self.rotation.z, target_upright, delta)
		
		self.angular_velocity.y = root.common["pid_controller"].update(self.angular_velocity.y, target_upright, delta)
		self.angular_velocity.x = root.common["pid_controller"].update(self.angular_velocity.x, target_upright, delta)
		self.angular_velocity.z = root.common["pid_controller"].update(self.angular_velocity.z, target_upright, delta)
