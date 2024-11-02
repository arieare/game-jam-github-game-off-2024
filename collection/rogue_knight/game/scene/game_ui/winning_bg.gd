extends ColorRect

var elapsed:=0.0
func _process(delta: float) -> void:
	
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		self.material.set_shader_parameter("progress",elapsed);
		elapsed += delta
	else:
		elapsed = 0
		self.material.set_shader_parameter("progress",0);
