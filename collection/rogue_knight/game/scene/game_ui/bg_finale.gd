extends ColorRect

var elapsed:=0.0
func _process(delta: float) -> void:
	
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.FINALE_2:
		self.material.set_shader_parameter("progress",elapsed);
		elapsed += delta * 1.5
	else:
		elapsed = 0
		self.material.set_shader_parameter("progress",elapsed);
