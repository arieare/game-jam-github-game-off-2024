extends Node

func input_setting():	

	var event_left_click := InputEventMouseButton.new()
	event_left_click.button_index = MOUSE_BUTTON_LEFT
	InputMap.add_action("blow")
	InputMap.action_add_event("blow", event_left_click)
	
	var event_right_click := InputEventMouseButton.new()
	event_right_click.button_index = MOUSE_BUTTON_RIGHT
	InputMap.add_action("suck")
	InputMap.action_add_event("suck", event_right_click)	

func _ready() -> void:
	input_setting()
