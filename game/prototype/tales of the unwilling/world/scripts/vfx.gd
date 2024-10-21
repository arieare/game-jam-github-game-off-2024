extends Node

@onready var hit = preload("res://vfx/vfx_hit.tscn")
@onready var ringImpact = preload("res://vfx/vfx_ring_impact.tscn")
@onready var smokeExplosion = preload("res://vfx/vfx_smoke_explosion.tscn")

func spawnFx(vfx, position):
	var vfxInstance = vfx.instantiate()
	get_tree().root.get_node("world").add_child(vfxInstance)
	vfxInstance.global_position = position 
	return vfxInstance
