class_name class_state extends Node

var state_machine_parent: class_state_machine
var actor: Variant

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass
	
func process_input(event:InputEvent) -> class_state:
	return null

func process_frame(delta:float) -> class_state:
	return null

func process_physics(delta:float) -> class_state:
	return null
