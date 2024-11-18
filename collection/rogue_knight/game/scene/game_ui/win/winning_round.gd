extends Control

func _ready() -> void:
	#util.root.data_instance.vfx.vfx_win_confetti.reparent(self.get_child(0), false)
	util.root.data_instance.vfx.vfx_win_confetti.top_level = true
	var screen_size = self.get_child(0).size
	util.root.data_instance.vfx.vfx_win_confetti.position = Vector2(screen_size.x/2, screen_size.y/2)	
	self.hide()
	
func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		self.show()
		#$"../in_game".hide()
	else:
		self.hide()
		#$"../in_game".show()
