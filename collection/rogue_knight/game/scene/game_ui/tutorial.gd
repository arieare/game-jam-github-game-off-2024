extends Control

@export var tut_1: PanelContainer
@export var tut_2: PanelContainer
@export var tut_3: PanelContainer
@export var tut_3_anim: AnimationPlayer

func _ready() -> void:
	util.root.data_instance.connect("move_added", _on_move_added)
	self.hide()
	self.modulate = Color.TRANSPARENT
	tut_1.position.x = 200
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	if util.root.data_instance.game_data.current_level == 1 and util.root.data_instance.is_tutorial_flag:
		match state:
			util.root.data_instance.GAME_STATE.PLAYING:
				await get_tree().create_timer(0.3).timeout
				self.show()
				tut_1.show()
				var tween_appear: Tween
				tween_appear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_appear.set_parallel(true)
				tween_appear.tween_property(tut_1,"position:x",45,0.2)
				tween_appear.tween_property(self,"modulate",Color.WHITE,0.3)
									
					
			util.root.data_instance.GAME_STATE.WINNING:
				var tween_disappear: Tween
				tween_disappear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_disappear.set_parallel(true)
				tween_disappear.tween_property(tut_2,"position:x",200,0.5)
				tween_disappear.tween_property(self,"modulate",Color.TRANSPARENT,0.2)	
				await tween_disappear.finished
				tut_2.hide()
				self.hide()
	
	if util.root.data_instance.game_data.current_level == 2 and util.root.data_instance.is_tutorial_flag:
		match state:
			util.root.data_instance.GAME_STATE.PLAYING:
				await get_tree().create_timer(0.3).timeout
				self.show()
				tut_3.show()
				tut_3_anim.play("flip_card")
				var tween_appear: Tween
				tween_appear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_appear.set_parallel(true)
				tween_appear.tween_property(tut_3,"position:x",45,0.2)
				tween_appear.tween_property(self,"modulate",Color.WHITE,0.3)
					
			util.root.data_instance.GAME_STATE.WINNING:
				var tween_disappear: Tween
				tween_disappear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_disappear.set_parallel(true)
				tween_disappear.tween_property(tut_3,"position:x",200,0.5)
				tween_disappear.tween_property(self,"modulate",Color.TRANSPARENT,0.2)	
				await tween_disappear.finished
				tut_3.hide()
				self.hide()
		
			
func _on_move_added():
	if util.root.data_instance.game_data.current_level == 1 and util.root.data_instance.is_tutorial_flag:	
		if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLAYING:
			if util.root.data_instance.game_data.move_step.size() == 1:
				var tween_disappear: Tween
				tween_disappear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_disappear.set_parallel(true)
				tween_disappear.tween_property(tut_1,"position:x",200,0.5)
				tween_disappear.tween_property(self,"modulate",Color.TRANSPARENT,0.2)	
				await tween_disappear.finished
				tut_1.hide()
				self.hide()		
				await get_tree().create_timer(0.1).timeout
				self.show()
				tut_2.show()
				var tween_appear: Tween
				tween_appear = create_tween().set_trans(Tween.TRANS_CIRC)
				tween_appear.set_parallel(true)
				tween_appear.tween_property(tut_2,"position:x",45,0.2)
				tween_appear.tween_property(self,"modulate",Color.WHITE,0.3)		
