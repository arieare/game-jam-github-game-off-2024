extends Path2D

@export var player:CharacterBody2D
@export var follow_progress:PathFollow2D
var car_max_speed: float = 150.0

@export var stage_node: Node2D

var start_timer: Timer

var max_point_count = 5000.0
func _ready() -> void:
	curve.clear_points()
	self.visible = false
	start_timer = Timer.new()
	self.add_child(start_timer)
	start_timer.autostart = false
	start_timer.one_shot = true
	start_timer.wait_time = 3.0
	start_timer.start()
	
	curve.add_point(Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curve.add_point(player.position)
	if start_timer.time_left == 0:
		self.position = Vector2.ZERO
		#$PathFollow2D/Sprite2D.position = curve.get_point_in(0)
		$PathFollow2D/Sprite2D.position = curve.get_point_in(0)
	
		remove_path(delta/2)
		follow_progress.progress += clampf(car_max_speed * delta, 0.0, car_max_speed)
	
		if $sfx_rev_enemy.is_playing() == false:
			$sfx_rev_enemy.play()
		
		$sfx_rev_enemy.pitch_scale = randf_range(1.3, 1.5)
		if self.visible == false:
			await get_tree().create_timer(1.0).timeout
			self.visible = true
			#stage_node.emit_signal("arcade_state", "outrun the shadow-car!")

func remove_path(delta):
	if curve.point_count > max_point_count:
		curve.remove_point(delta)
