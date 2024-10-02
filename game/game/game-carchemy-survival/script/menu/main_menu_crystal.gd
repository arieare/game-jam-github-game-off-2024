extends Sprite2D

func _process(delta: float) -> void:
	ApplyBob(delta)

func ApplyBob(time : float):
	
	
	var bobOscillate : float = sin(time * 90 * (2 * PI))
	print(clampf(bobOscillate, -1, 1))
	self.position.y += bobOscillate
