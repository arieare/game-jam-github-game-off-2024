extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world.player.playerInput.x != 0 or world.player.playerInput.y != 0:
		time = time + delta
		var rot
		rot = sin(time*10*PI)
		rot = clamp(rot,-0.05,0.05)	
		self.rotation.z = lerp(self.rotation.z, rot, 0.5)
		self.transform.origin.y = lerp(self.transform.origin.y, self.transform.origin.y + rot, 0.5)
	else:
		self.rotation.z = 0
		self.transform.origin.y = 0
		time = 0.0
