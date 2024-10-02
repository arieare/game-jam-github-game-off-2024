extends Node
class_name InputHandler

var input_accelerate : float 
var input_steer : float 
var input_drift : bool	

func get_input_accel() -> float:
	input_accelerate = Input.get_axis("move_backward", "move_forward")
	return input_accelerate

func get_input_steer() -> float:
	input_steer = Input.get_axis("move_right", "move_left")
	return input_steer 

func get_input_drift() -> bool:
	if Input.is_action_pressed("drift"):
		input_drift = true
	else: input_drift = false
	return input_drift 
