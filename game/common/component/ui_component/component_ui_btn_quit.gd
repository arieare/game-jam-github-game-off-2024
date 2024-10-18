class_name ui_btn_quit extends Button

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed: get_tree().quit()
