extends Node2D

@export var player: CharacterBody2D

var beam_line_start: Vector2
var beam_line_end: Vector2
var dir : Vector2
var pos : Vector2
var max_bounce: int = 6
var bounces: int = 0
var beam_line_array: PackedVector2Array

func _physics_process(delta):
	beam_line_start = player.global_position
	beam_line_end = get_global_mouse_position()
	if Input.is_mouse_button_pressed(1):
		var space_state = get_world_2d().direct_space_state
		#var query = PhysicsRayQueryParameters2D.create(player.global_position, ray_target, collision_mask, [self])
		var query : PhysicsRayQueryParameters2D
		var data : Dictionary
		queue_redraw()
		beam_line_array.append(beam_line_start)
		while bounces < max_bounce:
			beam_line_end = beam_line_start + dir * 100.0
			query = PhysicsRayQueryParameters2D.create(beam_line_start, beam_line_end)	
			query.exclude = [self.get_parent()]		
			data = space_state.intersect_ray(query)
			if data:
				
				if data["collider"] is CharacterBody2D:
					## register hit				
					##data.collider.get_hit({dir = dir})
					beam_line_end = data['position'] - (data['position'] - beam_line_start).normalized() * 0.01
					bounces = 0
					
					
				else:
					
					beam_line_end = data["position"] - (data["position"] - beam_line_start).normalized() * 0.01
					dir = dir.bounce(data['normal']).normalized()
					bounces += 1
					
				
			beam_line_start = beam_line_end
			beam_line_array.append(beam_line_start)				
			
		print(beam_line_array)
		
	else:
		bounces = 0
		
		#beam_line_array.clear()
		#beam_line_start = Vector2.ZERO
		#beam_line_end = Vector2.ZERO

func _draw()->void:
	if !beam_line_array.is_empty():
		for i in beam_line_array.size() -1:
			#var t:float = (time - trace_line[i][1]) / fade_time
			#if t <= 1.0:
			var p1:Vector2 = to_local(beam_line_array[i])
			var p2:Vector2 = to_local(beam_line_array[i+1])
			var c: = Color.GREEN
			#var p1:Vector2 = to_local(beam_line_start)
			#var p2:Vector2 = to_local(beam_line_end)
			var thic:float = 4.0
			draw_line(p1, p2, c, thic)
