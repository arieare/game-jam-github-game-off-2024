class_name ModularStateMachine
extends Node

var initial_state: State
var current_state: State
var states: Dictionary = {}

@onready var entity = get_parent()


func _ready():
	for child_states in get_children():
		if child_states is State:
			states[child_states.name.to_lower()] = child_states
			child_states.transition_to_state.connect(on_state_child_transition)
	
	initial_state = get_child(0)
	if initial_state:
		print(initial_state.name)
		current_state = initial_state
		current_state.enter_state()

func _process(delta):
	if current_state:
		current_state.process_state(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.physics_process_state(delta)
		

func on_state_child_transition(state:State, new_state_name: StringName):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	
	if !new_state:
		return
	
	if current_state:
		current_state.exit_state()

	new_state.enter_state()
	current_state = new_state
	print(current_state.name)

func get_entity():
	entity = get_parent()
	return entity
