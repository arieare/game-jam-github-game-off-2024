extends Button
class_name quit_btn_component

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		get_tree().quit()
