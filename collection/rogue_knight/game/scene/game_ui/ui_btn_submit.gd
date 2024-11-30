extends Button

@export var btn_label: RichTextLabel
@export var input_field: TextEdit
#var current_pos

func _ready() -> void:
	#self.grab_focus()
	#self.disabled = true
	#util.root.data_instance.connect("board_ready", _on_board_ready)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "white", "big", false, false)

var can_interact:=false
func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.FINALE_2:
			can_interact = true
		_:
			can_interact = false
			
func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
	#if !event.is_echo() or self.button_pressed or event.is_action_pressed("redeem"):
		if can_interact:
			var secret_code = util.root.data_instance.game_data.secret_string.to_lower()
			var submitted_code = input_field.text.to_lower()
			var unwanted_chars = [".",",",":","?"," ",'\n'] #and so on
			input_field.select_all()
			
			for c in unwanted_chars:
				secret_code = secret_code.replace(c,"")		
				submitted_code = submitted_code.replace(c,"")
			if submitted_code == secret_code:
				#print("secret code is " + secret_code)
				#print("submitted code is " + submitted_code)
				#print("match")
				util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.FINALE_SECRET_CORRECT	
			else:
				#print("mismatch")
				util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.FINALE_SECRET_WRONG	
		

var current_text := ""
func _process(delta: float) -> void:
	
	if current_text != input_field.text:
		current_text = input_field.text
		util.root.data_instance.game_data.current_cam.shake_node.shake(0.035)
		util.root.data_instance.audio.sfx_dictionary.typing.sfx.play()
