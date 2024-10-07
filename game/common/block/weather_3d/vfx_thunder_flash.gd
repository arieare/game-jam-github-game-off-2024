extends Node

@export var env_node:Node
@export var light_node:Node
@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var target:Vector2 = Vector2(400.0, 225.0)

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	#light_node.world_light.light_energy = max_roll * amount * randf_range(-1, 1)
	env_node.env_profile.background_energy_multiplier = 0.5 + max_roll * amount * randf_range(-1, 1)
