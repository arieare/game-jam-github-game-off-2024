extends NodePlus
class_name State

var actor: RigidBody3D
var state_machine_parent: StateMachine

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass
	
func process_input(event:InputEvent) -> State:
	return null

func process_frame(delta:float) -> State:
	return null

func process_physics(delta:float) -> State:
	return null	
