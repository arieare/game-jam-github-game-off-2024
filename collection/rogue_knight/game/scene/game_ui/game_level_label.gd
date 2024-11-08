extends Label

@export var game_level_name:Label

func _process(delta: float) -> void:
	self.text = "Stage " + str(util.root.data_instance.game_data.current_level)
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		game_level_name.text = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].title
