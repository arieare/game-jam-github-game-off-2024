# On Ground State
extends State

func enter_state() -> void:
	super()
	print("on ground")
	

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if !actor.ray.ray_module["ground_check"].on_ground_check():
		return state_machine_parent.state_dictionary["on_air"]
	return null
