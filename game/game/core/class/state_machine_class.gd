extends NodePlus
class_name StateMachine

@export var initial_state: State
var current_state: State

var state_dictionary: Dictionary = {}

func _ready() -> void:
	root.get_module(self, state_dictionary)

func init_state(actor) -> void:
	for states in get_children():
		if states is State:
			states.actor = actor
			states.state_machine_parent = self
	change_state(initial_state)

func change_state(new_state:State) -> void:
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
