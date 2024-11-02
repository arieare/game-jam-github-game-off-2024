extends TextureButton

func _input(event: InputEvent) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING:
		if !event.is_echo() and self.button_pressed:
			util.root.data_instance.patch_picked.emit("queen")
			self.queue_free()
