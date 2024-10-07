extends CanvasModulate

var rnd:RandomNumberGenerator = RandomNumberGenerator.new()
var time_passed : float = 0.0
@export var size_min = -1
@export var size_max = 1
#@onready var sound = $"../../../AudioStreamPlayer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sound.play()
	#

	pass 


func _process(_delta: float) -> void:
	#sound.pitch_scale = randi() % 3
	var flash = rnd.randi_range(1, 100)
	if flash == 2:
		self.color = Color("7579ba")
	else:
		self.color = Color("535592")
