extends CharacterBody3D


var velocity = Vector3.ZERO
var look_direction = Vector3.ZERO
@onready var look_mouse_module = $look_at_mouse

var playerInput: Vector2
var speed : float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready():
	world.emit_signal("player_enter", self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	playerInput = Input.get_vector(
		"player_move_left",
		"player_move_right",
		"player_move_up",
		"player_move_down"
		)
	
	#if self.is_on_floor():
	set_velocity(Vector3(playerInput.x * speed,0,playerInput.y * speed))
	set_up_direction(Vector3.UP)
	move_and_slide()
	apply_gravity(delta)
	rotate_look()
	

func apply_gravity(delta):
	
	if self.is_on_floor():
		return
	else:
		velocity.y = -10
		velocity.y += 10 * delta
		set_velocity(velocity)
		move_and_slide()

func rotate_look():
	if look_mouse_module:
		look_direction = look_mouse_module.get_look_direction()
		if look_direction != null and look_direction != Vector3.UP and look_direction != Vector3.ZERO and look_direction != self.global_transform.origin:
			self.look_at(look_direction, Vector3.UP)
