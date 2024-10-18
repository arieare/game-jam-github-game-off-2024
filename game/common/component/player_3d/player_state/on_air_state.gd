# on air class_state
extends class_state
class_name component_state_on_air

func process_physics(delta: float) -> class_state:
	if actor.ray.is_on_floor:
		return state_machine_parent.state_list["on_ground"]
	return null
