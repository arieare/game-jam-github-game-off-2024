extends Node


func _ready():
	self.get_parent().vfx = self #dependency injection
	_init_vfx_goal_tile()
	_init_vfx_win_confetti()

var frame := 0
var is_loaded := false
func _physics_process(delta: float) -> void:
	if frame > 3:
		set_physics_process(false)
		is_loaded = true
		print("is_loaded" + str(is_loaded))
	else:
		frame += 1

#how to use -> util.root.data_instance.vfx.vfx_goal_tile.emitting = true

var vfx_goal_tile_glow = preload("res://collection/rogue_knight/content/vfx/vfx_goal_tile_glow.tres")
var vfx_goal_tile_glow_mesh = preload("res://collection/rogue_knight/content/vfx/vfx_goal_tile_glow_mesh.tres")
var vfx_goal_tile := GPUParticles3D.new()
func _init_vfx_goal_tile():
	vfx_goal_tile.name = "vfx_goal_tile"
	vfx_goal_tile.process_material = vfx_goal_tile_glow
	vfx_goal_tile.amount = 10
	vfx_goal_tile.lifetime = 2.0
	vfx_goal_tile.speed_scale = 0.75
	var draw_pass = QuadMesh.new()
	draw_pass.size = Vector2(0.02,0.02)
	draw_pass.material = vfx_goal_tile_glow_mesh
	vfx_goal_tile.draw_pass_1 = draw_pass
	vfx_goal_tile.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	self.add_child(vfx_goal_tile)
	vfx_goal_tile.emitting = true
	vfx_goal_tile.emitting = false	

var vfx_win_confetti_material = preload("res://collection/rogue_knight/content/vfx/vfx_win_confetti_material.tres")
var vfx_win_confetti_material_sprite = preload("res://collection/rogue_knight/content/vfx/vfx_win_confetti_sprite.tres")
var vfx_win_confetti := GPUParticles2D.new()
func _init_vfx_win_confetti():
	vfx_win_confetti.name = "vfx_win_confetti"
	vfx_win_confetti.amount = 50
	vfx_win_confetti.lifetime = 10.0
	vfx_win_confetti.one_shot = true
	vfx_win_confetti.speed_scale = 2.5
	vfx_win_confetti.explosiveness = 1.0
	vfx_win_confetti.randomness = 1.0
	vfx_win_confetti.process_material = vfx_win_confetti_material
	vfx_win_confetti.texture = vfx_win_confetti_material_sprite
	self.add_child(vfx_win_confetti)
	vfx_win_confetti.emitting = true
	vfx_win_confetti.emitting = false	
