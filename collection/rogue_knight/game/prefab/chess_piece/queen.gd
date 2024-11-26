extends Node3D

@export var board_node: Node3D

func _ready() -> void:
	util.root.data_instance.connect("board_ready", _on_board_ready)
	self.hide()

func _on_board_ready():
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].title == "the letter":
			self.show()	
	#if util.root.data_instance.game_data.current_level == 4:
		#self.show()
			var starting_pos:= Vector2(0,2)
		#starting_pos = util.root.data_instance.game_data.board_data.starting_position
			self.position = board_node.board_array[int(starting_pos.x)][int(starting_pos.y)].position
		#tween_appear()
