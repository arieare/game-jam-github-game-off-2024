extends Label

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		self.add_theme_color_override("font_shadow_color", Color.DARK_GREEN)
		self.add_theme_color_override("font_color", Color.WHITE)
	elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.LOSING:
		self.add_theme_color_override("font_shadow_color", Color.DARK_RED)
		self.add_theme_color_override("font_color", Color.WHITE)
