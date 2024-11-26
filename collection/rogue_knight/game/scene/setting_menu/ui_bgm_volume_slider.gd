extends HSlider

func _ready() -> void:
	self.set_value_no_signal(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("bgm")))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("bgm"), value)
