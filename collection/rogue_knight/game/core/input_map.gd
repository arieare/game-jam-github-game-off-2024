extends Node

func input_setting():	

	var event_left_click := InputEventMouseButton.new()
	event_left_click.button_index = MOUSE_BUTTON_LEFT
	InputMap.add_action("confirm")
	InputMap.action_add_event("confirm", event_left_click)
	
	var event_escape := InputEventKey.new()
	event_escape.physical_keycode = KEY_ESCAPE
	InputMap.add_action("cancel")
	InputMap.action_add_event("cancel", event_escape)	
	
	var event_right_click := InputEventMouseButton.new()
	event_right_click.button_index = MOUSE_BUTTON_RIGHT
	var event_space := InputEventKey.new()
	event_space.physical_keycode = KEY_SPACE
	
	InputMap.add_action("move")
	InputMap.action_add_event("move", event_space)	
	InputMap.action_add_event("move", event_right_click)		
	


func _ready() -> void:
	input_setting()
