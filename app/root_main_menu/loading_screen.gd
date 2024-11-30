extends CanvasLayer

func _ready() -> void:
	self.show()
	util.connect("data_ready", _on_data_ready)

func _on_data_ready():
	
	self.hide()
