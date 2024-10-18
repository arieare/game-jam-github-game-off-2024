class_name class_state_machine extends Node

@export var initial_state: class_state
var current_state: class_state

var state_list: Dictionary = {}

func init_state(actor) -> void:
	for states in get_children():
		if states is class_state:
			states.actor = actor
			states.state_machine_parent = self
			var state_name = states.name
			state_list[state_name] = states
	print(state_list)
	change_state(initial_state)

func change_state(new_state:class_state) -> void:
	if current_state:
		current_state.exit_state()
	current_state = new_state
	current_state.enter_state()

func process_physics(delta:float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state: change_state(new_state)

func process_input(event:InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state: change_state(new_state)

func process_frame(delta:float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state: change_state(new_state)
