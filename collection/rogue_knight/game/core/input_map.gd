extends Node

func input_setting():	

	var event_left_click := InputEventMouseButton.new()
	event_left_click.button_index = MOUSE_BUTTON_LEFT
	var event_space := InputEventKey.new()
	event_space.physical_keycode = KEY_SPACE

	InputMap.add_action("confirm")
	InputMap.action_add_event("confirm", event_left_click)
	InputMap.action_add_event("confirm", event_space)	
	
	var event_x := InputEventKey.new()
	event_x.physical_keycode = KEY_X
	InputMap.add_action("cancel")
	InputMap.action_add_event("cancel", event_x)	
	
	var event_r := InputEventKey.new()
	event_r.physical_keycode = KEY_R
	InputMap.add_action("restart")
	InputMap.action_add_event("restart", event_r)		
	
	var event_right_click := InputEventMouseButton.new()
	event_right_click.button_index = MOUSE_BUTTON_RIGHT
	
	InputMap.add_action("move")
	InputMap.action_add_event("move", event_space)	
	InputMap.action_add_event("move", event_right_click)	
	
	var event_enter := InputEventKey.new()
	event_enter.physical_keycode = KEY_ENTER
	InputMap.add_action("redeem")
	InputMap.action_add_event("redeem", event_enter)
	
	InputMap.add_action("begin_run")
	InputMap.action_add_event("begin_run", event_space)		
	
	var event_z := InputEventKey.new()
	event_z.physical_keycode = KEY_Z
	InputMap.add_action("chat")
	InputMap.action_add_event("chat", event_z)
	
	var event_up := InputEventKey.new()
	event_up.physical_keycode = KEY_UP
	InputMap.add_action("up")
	InputMap.action_add_event("up", event_up)	

	var event_down := InputEventKey.new()
	event_down.physical_keycode = KEY_DOWN
	InputMap.add_action("down")
	InputMap.action_add_event("down", event_down)		

	var event_left := InputEventKey.new()
	event_left.physical_keycode = KEY_LEFT
	InputMap.add_action("left")
	InputMap.action_add_event("left", event_left)	
			
	var event_right := InputEventKey.new()
	event_right.physical_keycode = KEY_RIGHT
	InputMap.add_action("right")
	InputMap.action_add_event("right", event_right)				
	


func _ready() -> void:
	input_setting()
