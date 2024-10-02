extends Node

'''
code for instant jump by manipulating rigidbody velocity directly
'''

var parent: RigidBody3D
var jump_velocity:float = 0.0
var forward_velocity: float = 0.0
var jump_dampen:float = 0.005
var is_jumping:bool = false
var JUMP_SPEED:float = 3.0

func assert_parent(parent_node: RigidBody3D):
	parent = parent_node

func jump(should_jump:bool, delta)->void:
	if should_jump and parent.move_levitate.is_on_floor:
		is_jumping = true
		
		jump_velocity = JUMP_SPEED	
		
		forward_velocity = parent.linear_velocity.x
		parent.freeze = true

	
	if is_jumping:
		
		var body_position: Vector3 = parent.global_position
		if jump_velocity != 0:
			body_position.y += jump_velocity /2
			body_position.x += forward_velocity / 50
			jump_velocity -= jump_dampen
			if jump_velocity <= 0.01:
				parent.freeze = false	
		parent.global_position = body_position
		pass
		
