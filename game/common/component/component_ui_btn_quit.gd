extends NodeButtonPlus
class_name component_ui_btn_quit

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		get_tree().quit()
