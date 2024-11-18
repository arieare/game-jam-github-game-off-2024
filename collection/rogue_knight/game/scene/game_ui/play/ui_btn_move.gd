extends Button

@export var btn_label: RichTextLabel

var move_set: Array

func _ready() -> void:
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "black", "medium", false, false)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _process(delta: float) -> void:
	move_set = util.root.data_instance.game_data.move_step
	if move_set.size() < util.root.data_instance.game_data.chess_piece.movement_strategy.step_size or util.root.data_instance.game_data.chess_piece.is_moving:
		self.hide()
	else:
		self.show()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed or event.is_action_pressed("move") and !util.root.data_instance.game_data.chess_piece.is_moving and move_set.size() == util.root.data_instance.game_data.chess_piece.movement_strategy.step_size:
		util.root.data_instance.audio.sfx_dictionary.tile_select_move.sfx.play()
		util.root.data_instance.game_data.chess_piece.parse_movement()

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.PLAYING:
			self.show()
		util.root.data_instance.GAME_STATE.PLANNING:
			self.hide()
