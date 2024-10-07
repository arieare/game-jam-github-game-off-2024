extends StaticBody2D

@export var core_light: PointLight2D
var rnd:RandomNumberGenerator = RandomNumberGenerator.new()
@export var size_min = 0.5
@export var size_max = 0.75
var is_being_hit: bool
@onready var game_node = get_node("/root/game")

func _ready() -> void:
	#game_node.core_crystal_hit.connect(_when_core_crystal_hit)
	pass

func _physics_process(delta: float) -> void:
	supress_light(delta)
	core_light.texture_scale = lerpf(core_light.texture_scale,rnd.randf_range(1, 1.25),0.3)

func _when_core_crystal_hit():
	print("hit")
	core_light.texture.width += 1
	core_light.texture.height += 1
	is_being_hit = true

func supress_light(delta):
	if is_being_hit:
		return
	core_light.texture.width -= 0.01
	core_light.texture.height -= 0.01




	
