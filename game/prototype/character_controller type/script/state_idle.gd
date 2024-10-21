extends State
class_name StateIdle

static func _component() -> String:
	return "add idle state"

func get_jump_input():
	if Input.is_action_just_pressed("jump"):
		return true
func process_state(delta):
	entity.velocity.y = 0
	super(delta)


func state_transition_logic():
	if get_parent().get_dir() != Vector2.ZERO:
		transition_to_state.emit(self, &"groundmove")
	if entity.is_on_floor() and get_jump_input():
		transition_to_state.emit(self, &"jump")
