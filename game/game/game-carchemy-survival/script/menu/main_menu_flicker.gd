extends PointLight2D

var rnd:RandomNumberGenerator = RandomNumberGenerator.new()
var time_passed : float = 0.0
@export var size_min = 0.5
@export var size_max = 0.75

func _process(delta: float) -> void:
	self.texture_scale = rnd.randf_range(1, 1.75)
