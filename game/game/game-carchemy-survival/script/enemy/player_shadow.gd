extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_vec:PackedVector2Array = []
@export var player:CharacterBody2D
var target_position: Vector2

var friction = -0.9
var drag = -0.0015
var acceleration = Vector2.ZERO

#func _physics_process(delta: float) -> void:
	#target_position = (player.position - position).normalized()
	#velocity = target_position * SPEED
	#look_at(player.position)
	#move_and_slide()
		##apply_friction()	
		##velocity += accel * delta
		###self.velocity = movement
		##move_and_slide()
#
#
#func apply_friction():
	#if velocity.length() < 5:
		#velocity = Vector2.ZERO
	#var friction_force = velocity * friction
	#var drag_force = velocity * velocity.length() * drag
	#if velocity.length() < 100:
		#friction_force *= 3
	#acceleration += drag_force + friction_force	
	#
