extends Control

func _ready() -> void:
	self.hide()

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.LOSING:
		
		if util.root.data_instance.game_data.score > util.root.data_instance.game_data.high_score:
			util.root.data_instance.game_data.high_score = util.root.data_instance.game_data.score	
		
		var move_number = util.root.data_instance.game_data.initial_move - util.root.data_instance.game_data.max_move
		if move_number < util.root.data_instance.game_data.shortest_move and move_number > 1 :
			util.root.data_instance.game_data.shortest_move = move_number
		
		self.show()
		if util.root.data_instance: 
			if util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.get_stream(0) == util.root.data_instance.audio.bgm_game_over_file:
				if !util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.playing:
					util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()	
			else:
				util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()		
				util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.remove_stream(0)
				util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.add_stream(0,util.root.data_instance.audio.bgm_game_over_file, 1.0)	
				util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()			
	else:
		self.hide()
