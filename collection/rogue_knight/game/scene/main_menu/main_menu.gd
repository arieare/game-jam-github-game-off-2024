extends Control

@export var fade_in_player: AnimationPlayer
@export var splash_tex: TextureRect
@export var splash_layer: CanvasLayer

func _ready() -> void:
	splash_layer.hide()
	splash_tex.hide()

	

func _process(delta: float) -> void:
	if util.root.data_instance: 
		if !util.root.data_instance.is_first_boot:
			splash_layer.show()
			splash_tex.show()			
			fade_in_player.play("fade_in")
			await fade_in_player.animation_finished
			splash_tex.hide()
			#fade_in_player.play("fade_out")
			#await fade_in_player.animation_finished
			splash_layer.hide()
			util.root.data_instance.is_first_boot = true	
		if util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.get_stream(0) == util.root.data_instance.audio.bgm_main_menu_file:
			if !util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.playing:
				util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()	
		else:
			util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()		
			util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.remove_stream(0)
			util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.add_stream(0,util.root.data_instance.audio.bgm_main_menu_file, 1.0)	
			util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()			
		#else:
			#util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()
			#util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.remove_stream(0)
			#util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.add_stream(0,util.root.data_instance.audio.bgm_main_menu_file, 1.0)	
			#util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()		
