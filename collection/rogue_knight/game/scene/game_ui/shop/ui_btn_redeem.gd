extends Button

@export var btn_label: RichTextLabel
@export var input_box: TextEdit
var is_valid_checker: bool = false
func _ready():
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "white", "small", false, true)
	self.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE

func _input(event: InputEvent) -> void:

	if !event.is_echo() and self.button_pressed or is_valid_checker:
		match input_box.text:
			"rosebud":
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.05)
				util.root.data_instance.redeem_add_money.emit()
				util.root.data_instance.audio.sfx_dictionary.redeem_confirm.sfx.play()
			"redhair":	
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.05)
				util.root.data_instance.redeem_theme_red.emit()	
				util.root.data_instance.audio.sfx_dictionary.redeem_confirm.sfx.play()
			"bluesclues":	
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.05)
				util.root.data_instance.redeem_theme_blue.emit()		
				util.root.data_instance.audio.sfx_dictionary.redeem_confirm.sfx.play()			
			"inkjet":	
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.05)
				util.root.data_instance.redeem_theme_bw.emit()
				util.root.data_instance.audio.sfx_dictionary.redeem_confirm.sfx.play()	
			"marimo":	
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.05)
				util.root.data_instance.redeem_theme_moss.emit()
				util.root.data_instance.audio.sfx_dictionary.redeem_confirm.sfx.play()					
			"mickjagger":	
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.05)
				util.root.data_instance.redeem_add_move.emit()
				util.root.data_instance.audio.sfx_dictionary.redeem_confirm.sfx.play()					
			_:
				util.root.data_instance.game_data.current_cam.shake_node.shake(0.1)
				util.root.data_instance.audio.sfx_dictionary.redeem_deny.sfx.play()								

var current_text := ""
func _process(delta: float) -> void:
	if current_text != "" and Input.is_action_just_pressed("redeem"):
		is_valid_checker = true	
		input_box.text = input_box.text.replace('\n', '')
		#print(current_text)
	elif Input.is_action_just_released("redeem"):
		is_valid_checker = false	
	
	if Input.is_action_pressed("redeem"):
		input_box.text = input_box.text.replace('\n', '')
		input_box.select_all()
	
	if current_text != input_box.text:
		#print("changed")
		current_text = input_box.text
		util.root.data_instance.game_data.current_cam.shake_node.shake(0.035)
		util.root.data_instance.audio.sfx_dictionary.typing.sfx.play()
