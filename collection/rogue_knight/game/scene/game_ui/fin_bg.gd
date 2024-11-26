extends ColorRect

@export var control: BoxContainer

var elapsed:=0.0
func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.TRUE_ENDING:
		self.material.set_shader_parameter("progress",elapsed);
		elapsed += delta / 10
		if elapsed > 0.9:
			control.show()
	else:
		elapsed = 0
		control.hide()
		self.material.set_shader_parameter("progress",0);
