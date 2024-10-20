extends Node

func input_setting():
	var event_w := InputEventKey.new()
	event_w.physical_keycode = KEY_W
	InputMap.add_action("move_forward")
	InputMap.action_add_event("move_forward", event_w)
	
	var event_s := InputEventKey.new()
	event_s.physical_keycode = KEY_S
	InputMap.add_action("move_backward")
	InputMap.action_add_event("move_backward", event_s)	
	
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

func _ready() -> void:
	input_setting()
