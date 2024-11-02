extends Label
@export var move_label: Label
@export var colon: Label
@onready var max = util.root.data_instance.game_data.max_move

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
		self.text = str(util.root.data_instance.game_data.max_move)
	if util.root.data_instance.game_data.max_move < 4:
		self.add_theme_color_override("font_color", Color.LIGHT_CORAL)
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		#self.text = str(util.root.data_instance.game_data.max_move)
		self.add_theme_color_override("font_shadow_color", Color.DARK_GREEN)
		move_label.add_theme_color_override("font_shadow_color", Color.DARK_GREEN)
		colon.add_theme_color_override("font_shadow_color", Color.DARK_GREEN)
		
		self.add_theme_color_override("font_color", Color.WHITE)
		move_label.add_theme_color_override("font_color", Color.WHITE)
		colon.add_theme_color_override("font_color", Color.WHITE)
	elif util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.LOSING:
		self.text = str(util.root.data_instance.game_data.max_move)
		self.add_theme_color_override("font_shadow_color", Color.DARK_RED)
		move_label.add_theme_color_override("font_shadow_color", Color.DARK_RED)
		colon.add_theme_color_override("font_shadow_color", Color.DARK_RED)
		
		self.add_theme_color_override("font_color", Color.WHITE)
		move_label.add_theme_color_override("font_color", Color.WHITE)
		colon.add_theme_color_override("font_color", Color.WHITE)	
