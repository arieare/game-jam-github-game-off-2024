extends Button

@export var btn_label: RichTextLabel

func _ready() -> void:
	self.grab_focus()
	util.root.data_instance.button_styler(self, btn_label, "purple", "big", false, true)

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLAYING
