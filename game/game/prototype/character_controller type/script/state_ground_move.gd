extends State



func physics_process_state(delta):
	
	ground_move(entity)
	entity.move_and_slide()
	super(delta)


@export var SPEED_WALKING = 10.0
@export var SPEED_RUNNING = 10.0

func get_run_input():
	pass

func ground_move(entity):
	var move_speed = SPEED_WALKING
	if get_run_input():
		move_speed = SPEED_RUNNING
	var dir = get_parent().get_dir()
	var direction = (entity.transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	if direction:
		entity.velocity.x = direction.x * move_speed
		entity.velocity.z = direction.z * move_speed
	else:
		entity.velocity.x = move_toward(entity.velocity.x, 0, move_speed)
		entity.velocity.z = move_toward(entity.velocity.z, 0, move_speed)

func state_transition_logic():
	if get_parent().get_dir() == Vector2.ZERO:
		transition_to_state.emit(self, &"idle")
