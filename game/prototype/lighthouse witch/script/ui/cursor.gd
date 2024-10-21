extends Node3D


@onready var look_mouse_module = $look_at_mouse
var mouse_position = Vector3.ZERO

func _ready():
	world.emit_signal("cursor_available", self)

func _process(delta):
	if look_mouse_module:
		mouse_position = look_mouse_module.get_look_direction()
		if mouse_position != null:
			self.transform.origin = Vector3(mouse_position.x, world.player.global_transform.origin.y, mouse_position.z)
