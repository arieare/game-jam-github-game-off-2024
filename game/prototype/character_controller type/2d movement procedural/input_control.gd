extends Node

func get_input()->Vector2:
	var input_direction : Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"),0)
	if input_direction.length() > 1:
		input_direction = input_direction.normalized()
	return input_direction
