extends Button

@export var btn_label: RichTextLabel

#var current_pos

func _ready() -> void:
	self.grab_focus()
	self.disabled = true
	util.root.data_instance.connect("board_ready", _on_board_ready)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "black", "big", false, true)

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLAYING

func _on_board_ready():
	var move_emphasis: Tween
	if move_emphasis:
		move_emphasis.kill()
	move_emphasis = create_tween().set_trans(Tween.TRANS_CIRC)
	move_emphasis.tween_property(self,"scale", Vector2(1.1,1.1),0.03)
	move_emphasis.tween_interval(0.1)
	move_emphasis.tween_property(self,"scale", Vector2(1,1),0.03)
	await move_emphasis.finished	
	self.disabled = false

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.PLAYING:
			self.disabled = true
			self.hide()
