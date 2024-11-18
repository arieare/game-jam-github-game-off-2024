extends Control

func _process(delta: float) -> void:
	if util.root.data_instance and !util.root.data_instance.audio.sfx_dictionary.bgm_intro.sfx.playing:
		util.root.data_instance.audio.sfx_dictionary.bgm_intro.sfx.play()
	if util.root.data_instance and util.root.data_instance.audio.sfx_dictionary.bgm_in_game_1.sfx.playing:
		util.root.data_instance.audio.sfx_dictionary.bgm_in_game_1.sfx.stop()		
