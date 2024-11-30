extends Button

@export var btn_label: RichTextLabel
@export var badge_label: PanelContainer

#var current_pos

func _ready() -> void:
	self.grab_focus()
	self.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	self.connect("pressed", _on_pressed)
	self.disabled = true
	util.root.data_instance.connect("board_ready", _on_board_ready)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "black", "big", false, true)
	badge_label.hide()
	if util.root.data_instance.is_tutorial_flag:
		badge_label.show()		
	

func _input(event: InputEvent) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING:
		if !event.is_echo() and self.button_pressed or event.is_action_released("begin_run"):
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

var is_it_hovered:=false
func _process(delta: float) -> void:
	if self.is_hovered() and !is_it_hovered:
		is_it_hovered = true
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()
		self.pivot_offset = self.size/2
		self.rotation_degrees = randf_range(-3,3)
	elif !self.is_hovered():
		is_it_hovered = false
		self.rotation_degrees = 0

func _on_pressed() -> void:
	util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx.play()
