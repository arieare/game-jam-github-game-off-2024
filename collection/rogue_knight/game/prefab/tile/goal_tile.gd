extends CSGBox3D

@export var vfx_glow: GPUParticles3D

func _ready() -> void:
	util.root.data_instance.connect("board_ready", _on_board_ready)

func _on_board_ready():
	vfx_glow.emitting = true
