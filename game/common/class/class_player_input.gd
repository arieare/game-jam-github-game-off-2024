extends Node
class_name class_player_input

func _ready() -> void:
	global.input_map.input_setting()

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
