extends Node
class_name CharMovementBase

var state_machine = StateMachine
var state_machine_node = Node
var character_parent = CharacterBody3D

func _ready():
	init_char_state_machine()
	state_machine = state_machine_node
	character_parent = get_parent()
	print(state_machine)
	#for i in self.get_children():
		#if i is StateMachine:
			#state_machine = i
	#call_deferred("state_machine._init_state", self)			
	state_machine._init_state(self)

func _physics_process(delta):
	state_machine._state_logic(delta)
	character_parent.move_and_slide()

##====== INIT STATE MACHINE
func init_char_state_machine():
	var state_machine_script = preload("res://game/prototype/character_controller type/script/character_controller/char_state_machine.gd")
	state_machine_node = Node.new()
	state_machine_node.set_script(state_machine_script)
	state_machine_node.name = "stateMachine"
	self.add_child(state_machine_node)

##====== FALL
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
func apply_gravity():
	if !character_parent.is_on_floor():
		character_parent.velocity.y -= GRAVITY

##====== GROUND MOVE
@export var SPEED_WALKING = 100.0
@export var SPEED_RUNNING = 10.0
func ground_move():
	var move_speed = SPEED_WALKING
	if get_run_input():
		move_speed = SPEED_RUNNING
	var dir = get_dir()
	var direction = (character_parent.transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	if direction:
		character_parent.velocity.x = direction.x * move_speed
		character_parent.velocity.z = direction.z * move_speed
	else:
		character_parent.velocity.x = move_toward(character_parent.velocity.x, 0, move_speed)
		character_parent.velocity.z = move_toward(character_parent.velocity.z, 0, move_speed)
func get_dir():
	pass	
func get_run_input():
	pass


##====== JUMP
@export var SPEED_JUMPING = 500
func apply_jump(delta):
	if get_jump_input():
		character_parent.velocity.y += SPEED_JUMPING * delta
func get_jump_input():
	pass
