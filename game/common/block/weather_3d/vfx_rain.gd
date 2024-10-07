extends Node3D

enum drizzle{DRY, DRIZZLE, RAIN, STORM}
var rain_intensity:drizzle
@onready var vfx_rain_node:GPUParticles3D = $vfx_rain
@onready var vfx_rain_ripple:GPUParticles3D = $vfx_rain_ripple

func _ready() -> void:
	rain_intensity = drizzle.DRIZZLE

func set_rain_intensity(intensity:drizzle, dir:StringName, strength:float):
	rain_intensity = intensity
	
	if dir == &"central":
		vfx_rain_node.rotation.x = 0.0
	if dir == &"south" or dir == &"west":
		vfx_rain_node.rotation.x = deg_to_rad(-15.0	* strength)
	if dir == &"north" or dir == &"east":
		vfx_rain_node.rotation.x = deg_to_rad(15.0	* strength)
	
	match rain_intensity:
		drizzle.DRY:
			vfx_rain_node.amount = lerpf(vfx_rain_node.amount, 1.0, 0.1)
			await get_tree().create_timer(0.2).timeout
			vfx_rain_node.emitting = false
			vfx_rain_ripple.emitting = false
		drizzle.DRIZZLE:
			vfx_rain_node.emitting = true
			vfx_rain_ripple.emitting = true
			vfx_rain_node.amount = lerpf(vfx_rain_node.amount, 50.0, 0.1)						
			vfx_rain_node.speed_scale = 0.75
		drizzle.RAIN:
			vfx_rain_node.emitting = true
			vfx_rain_ripple.emitting = true
			vfx_rain_node.amount = lerpf(vfx_rain_node.amount, 250.0, 0.1)			
			vfx_rain_node.speed_scale = 1.0
		drizzle.STORM:
			vfx_rain_node.emitting = true
			vfx_rain_ripple.emitting = true
			vfx_rain_node.amount = lerpf(vfx_rain_node.amount, 500.0, 0.1)			
			vfx_rain_node.speed_scale = 1.5
