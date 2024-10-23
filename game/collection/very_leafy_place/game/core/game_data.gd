extends Node

var game_data:Dictionary = {"score": 1, "value_2": 2}
	#set(value):
		#print(value)
var save_path := "user://very_leafy_place.save"	

func _ready() -> void:
	if util.save_load.load_data(save_path):
		game_data = util.save_load.load_data(save_path)
	game_data.score += 1
	util.save_load.save(save_path,game_data)
	print(game_data)
