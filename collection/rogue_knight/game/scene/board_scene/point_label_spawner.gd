extends Node3D

var iterator := 0
var point

var secret_string_array := []
var pointer = 0

func _ready() -> void:
	secret_string_array = util.root.data_instance.game_data.secret_string_array

var secret_letter_iterator:=0
func spawn_point(score, location):
	var sfx = util.root.data_instance.audio.sfx_dictionary.point_spawned.sfx
	if iterator > util.root.data_instance.instance_pool.point_label_array.size()-1:
		iterator = 0
	point = util.root.data_instance.instance_pool.point_label_array[iterator]
	iterator += 1
	
	point.hide()
	point.global_position = location
	point.show()
	point.text = "+" + str(score)
	point.tween_spawn(Color.BLACK, Color.WHITE)
	
	## Add secret string here
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
			if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].has("spawn_secret"):
				if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].spawn_secret == true:
					if secret_letter_iterator < util.root.data_instance.game_data.initial_move / 2:
						secret_letter_iterator += 1
						if util.root.data_instance.game_data.secret_string_cursor <= secret_string_array.size()-1:
							point.text = secret_string_array[util.root.data_instance.game_data.secret_string_cursor]
							
							util.root.data_instance.secret_letter_spawned.emit()
							
							point.tween_spawn(Color.GREEN_YELLOW, Color.ORANGE_RED)
							sfx = util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx
			
	util.root.data_instance.score_added.emit(score)
	sfx.play()

func hide_point():
	if point:
		point.hide()
