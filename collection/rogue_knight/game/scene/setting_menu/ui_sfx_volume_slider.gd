extends HSlider

func _ready() -> void:
	self.set_value_no_signal(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), value)


func _on_drag_ended(value_changed: bool) -> void:
	util.root.data_instance.audio.sfx_dictionary.coin_3.sfx.play()
