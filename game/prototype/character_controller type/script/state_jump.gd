extends State

func process_state(delta):
	apply_jump(delta, entity)
	super(delta)

##====== JUMP
@export var SPEED_JUMPING = 2000

func apply_jump(delta, entity):
	if entity.is_on_floor():
		entity.velocity.y += SPEED_JUMPING * delta
		entity.move_and_slide()

func get_jump_input():
	pass

func state_transition_logic():
	if !entity.is_on_floor():
		transition_to_state.emit(self, &"fall")
	else:
		transition_to_state.emit(self, &"idle")		
