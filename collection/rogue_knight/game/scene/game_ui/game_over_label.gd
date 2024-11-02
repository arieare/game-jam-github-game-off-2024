extends Label

func _process(delta: float) -> void:
	if util.bob_sine.calculate(delta, 2, 10) < 0:
		self.hide()
	else:
		self.show()
