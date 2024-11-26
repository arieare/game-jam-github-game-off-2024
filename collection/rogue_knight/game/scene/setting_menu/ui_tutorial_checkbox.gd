extends CheckBox

func _ready() -> void:
	self.set_pressed_no_signal(util.root.data_instance.is_tutorial_flag)


func _on_toggled(toggled_on: bool) -> void:
	util.root.data_instance.is_tutorial_flag = toggled_on
	util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx.play()

var is_it_hovered:= false
func _process(delta: float) -> void:
	if self.is_hovered() and !is_it_hovered:
		is_it_hovered = true
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()
	elif !self.is_hovered():
		is_it_hovered = false
		self.rotation_degrees = 0
