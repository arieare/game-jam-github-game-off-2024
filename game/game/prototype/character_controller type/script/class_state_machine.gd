extends Node
class_name StateMachine

var controller
var state_list:Array[StringName]

var state:StringName
var prev_state = null
var states: Dictionary = {}

func _ready():
	_assign_states()
	for state in state_list:
		add_state(state)
	call_deferred("_set_state", state_list[0])
	_get_ready()

func _get_ready():
	pass

func _assign_states():
	pass

func _init_state(state_owner):
	controller = state_owner
	
func _physics_process(delta:float):
	if state != null and controller:
		var transition = _get_transition(delta)
		if transition != null:
			_set_state(transition)

func _state_logic(_delta:float):
	pass

func _get_transition(_delta):	
	return null

func _enter_state(_new_state, _old_state):
	# Usually to define a unique situation in a state, like playing animation
	pass

func _exit_state(_old_state, _new_state):
	# Usually to define a unique situation in a state, like ending animation
	pass	

	
func _set_state(new_state):
	prev_state = state
	state = new_state
	if prev_state != null:
		_exit_state(prev_state,new_state)
	if new_state != null:
		_enter_state(new_state,prev_state)

func add_state(state_name):
	states[state_name] = state_name
