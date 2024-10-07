extends Node

@onready var flashingShader = preload("res://content/shader/canvas_flashing.gdshader")
@onready var teleportShader = preload("res://src/shader/teleport.gdshader")
@onready var outlineShader = preload("res://src/shader/outline.gdshader")

# Effects
func FlashSprite(spriteContext, color,opacity):
	spriteContext.material = ShaderMaterial.new()
	spriteContext.material.shader = flashingShader	
	spriteContext.material.set_shader_parameter("flashingModifier", opacity)
	spriteContext.material.set_shader_parameter("palette", color)

func TeleportSprite(spriteContext, from, to):
	spriteContext.material = ShaderMaterial.new()
	spriteContext.material.shader = teleportShader
	spriteContext.material.set_shader_parameter("progress", lerp(from, to, 0.2))

func OutlineSprite(spriteContext, thickness):
	spriteContext.material = ShaderMaterial.new()
	spriteContext.material.shader = outlineShader
	spriteContext.material.set_shader_parameter("width", thickness)

# Time Related
func FreezeFrame(duration):
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1

func DecayingSlowMo(slowness, duration):
	Engine.time_scale = slowness
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1	

func ResetTime():
	Engine.time_scale = 1	
