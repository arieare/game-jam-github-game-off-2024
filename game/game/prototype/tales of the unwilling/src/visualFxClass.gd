extends AnimatedSprite2D
class_name VisualFX


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	set_process_unhandled_input(true)
	play("fx")
	connect("animation_finished", _on_animation_finished)

func _on_animation_finished():
	queue_free()
