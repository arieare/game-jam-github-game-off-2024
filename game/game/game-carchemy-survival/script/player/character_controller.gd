extends CharacterBody2D


const SPEED = 350.0
const ACCEL: float = 2000.0
var friction: float = ACCEL/SPEED

const JUMP_VELOCITY = -400.0

func _process(delta: float) -> void:
	apply_traction(delta)
	apply_friction(delta)
	look_at_mouse()
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	
func apply_traction(delta:float):
	var traction: Vector2
	if Input.is_action_pressed("move_up"):
		traction.y -= 1
	if Input.is_action_pressed("move_down"):
		traction.y += 1	
	if Input.is_action_pressed("move_left"):
		traction.x -= 1
	if Input.is_action_pressed("move_right"):
		traction.x += 1			
	traction = traction.normalized()
	self.velocity += traction * ACCEL * delta

func apply_friction(delta:float):
	self.velocity -= self.velocity * friction * delta
	
func look_at_mouse():
	self.look_at(get_global_mouse_position())
