extends Node

@export var energy_beam : Node3D
var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_child(0)
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("player_charge"):
		print("charge light")
		energy_beam.switch_show_line(true)
		energy_beam.set_line(player.position,Vector3.ZERO, delta)
	else:
		energy_beam.switch_show_line(false)
