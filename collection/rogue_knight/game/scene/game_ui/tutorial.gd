extends Control

@export var panel: PanelContainer

func _ready() -> void:
	self.hide()
	self.modulate = Color.TRANSPARENT
	panel.position.x = 200
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	if util.root.data_instance.game_data.current_level == 1 and util.root.data_instance.is_tutorial_flag:
		match state:
			util.root.data_instance.GAME_STATE.PLAYING:
				await get_tree().create_timer(0.5).timeout
				self.show()
				var tween_appear: Tween
				tween_appear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_appear.set_parallel(true)
				tween_appear.tween_property(panel,"position:x",45,0.2)
				tween_appear.tween_property(self,"modulate",Color.WHITE,0.3)
			util.root.data_instance.GAME_STATE.WINNING:
				var tween_disappear: Tween
				tween_disappear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_disappear.set_parallel(true)
				tween_disappear.tween_property(panel,"position:x",200,0.5)
				tween_disappear.tween_property(self,"modulate",Color.TRANSPARENT,0.2)	
				await tween_disappear.finished
				self.hide()		
			
