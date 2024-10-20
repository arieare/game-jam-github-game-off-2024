extends Node
class_name class_player_input

func _ready() -> void:
	input_setting()	

func input_setting():
	var event_w := InputEventKey.new()
	event_w.physical_keycode = KEY_W
	InputMap.add_action("move_forward")
	InputMap.action_add_event("move_forward", event_w)
	
	var event_s := InputEventKey.new()
	event_s.physical_keycode = KEY_S
	InputMap.add_action("move_backward")
	InputMap.action_add_event("move_backward", event_s)	
	
	var event_left := InputEventKey.new()
	event_left.physical_keycode = KEY_LEFT
	InputMap.add_action("steer_left")
	InputMap.action_add_event("steer_left", event_left)
	
	var event_a := InputEventKey.new()
	event_a.physical_keycode = KEY_A
	InputMap.add_action("move_left")
	InputMap.action_add_event("move_left", event_a)
	
	var event_right := InputEventKey.new()
	event_right.physical_keycode = KEY_RIGHT
	InputMap.add_action("steer_right")
	InputMap.action_add_event("steer_right", event_right)
	
	var event_d := InputEventKey.new()
	event_d.physical_keycode = KEY_D
	InputMap.add_action("move_right")
	InputMap.action_add_event("move_right", event_d)		
		
	var event_space := InputEventKey.new()
	event_space.physical_keycode = KEY_SPACE	
	InputMap.add_action("drift")
	InputMap.action_add_event("drift", event_space)	
	InputMap.add_action("jump")
	InputMap.action_add_event("jump", event_space)	

	var event_e := InputEventKey.new()
	event_e.physical_keycode = KEY_E	
	InputMap.add_action("interact")
	InputMap.action_add_event("interact", event_e)	
		
	#region combat input
	var event_shift := InputEventKey.new()
	event_shift.physical_keycode = KEY_SHIFT
	InputMap.add_action("switch_weapon")
	InputMap.action_add_event("switch_weapon", event_shift)		

	var event_left_click := InputEventMouseButton.new()
	event_left_click.button_index = MOUSE_BUTTON_LEFT
	InputMap.add_action("attack")
	InputMap.action_add_event("attack", event_left_click)
	
	var event_right_click := InputEventMouseButton.new()
	event_right_click.button_index = MOUSE_BUTTON_RIGHT
	InputMap.add_action("warp")
	InputMap.action_add_event("warp", event_right_click)	
	#endregion
	
	#region camera input
	var event_arrow_left := InputEventKey.new()
	event_arrow_left.physical_keycode = KEY_LEFT
	InputMap.add_action("cam_rotate_left")
	InputMap.action_add_event("cam_rotate_left", event_arrow_left)		

	var event_arrow_right := InputEventKey.new()
	event_arrow_right.physical_keycode = KEY_RIGHT
	InputMap.add_action("cam_rotate_right")
	InputMap.action_add_event("cam_rotate_right", event_arrow_right)
	#endregion

func get_direction():
	var input: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
		)
	var vector_direction: Vector3 = Vector3(input.x, 0, input.y)
	return vector_direction

func want_to_jump() -> bool:
	return Input.is_action_just_pressed("jump")

func want_to_attack() -> bool:
	return Input.is_action_just_pressed("attack")

func want_to_warp() -> bool:
	return Input.is_action_just_pressed("warp")

func want_to_finish_warp() -> bool:
	return Input.is_action_just_released("warp")

func want_to_finish_attack() -> bool:
	return Input.is_action_just_released("attack")	

func want_to_switch_weapon() -> bool:
	return Input.is_action_just_pressed("switch_weapon")
