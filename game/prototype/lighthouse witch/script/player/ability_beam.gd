extends Node

@onready var arm_right = $"../body/arm/arm_right"
@onready var arm_left = $"../body/arm/arm_left"
@onready var shoot_pos_marker = $"../body/arm/shoot_pos"
@onready var arm_right_init_pos = arm_right.transform.origin
@onready var arm_left_init_pos = arm_left.transform.origin

@onready var sparks = preload("res://asset/vfx/sparks.tscn")
#onready var beam_line = $beam_line
var layer_mask_beam = 3


var max_bounce = 3

var beam_ray_cast_array : Array = []
var fx_sparks_array : Array = []

func _ready():
	# init array of raycasts
	for i in max_bounce:
		var new_ray_cast = RayCast3D.new()
		self.add_child(new_ray_cast)
		new_ray_cast.enabled = false
		new_ray_cast.exclude_parent = true
		beam_ray_cast_array.append(new_ray_cast)
	for i in max_bounce:
		var new_sparks = sparks.instantiate(1)
		self.add_child(new_sparks)
		new_sparks.emitting = false
		fx_sparks_array.append(new_sparks)
	
#	beam_line.remove_line()
#	for i in max_bounce:
#		beam_line.add_line_point(Vector3.ZERO)
#	beam_line.add_line_point(Vector3.ZERO)
#	beam_line.add_line_point(Vector3.ZERO)


func _process(delta):
	if Input.is_mouse_button_pressed(1):
#		world.player.global_transform.origin.y += 1.0
		var ray_cast_id = -1
		
		var collide_point = Vector3.ZERO
		var collide_normal = Vector3.ZERO
		#add sparks effect
		fx_sparks_array[ray_cast_id].global_transform.origin = world.cursor.transform.origin
		fx_sparks_array[ray_cast_id].emitting = true		
		for ray_cast_beam in beam_ray_cast_array:
			ray_cast_id += 1	
			ray_cast_beam.enabled = true
			# if it's the first raycast, shoot from player towards the mouse
			if ray_cast_id == 0:
			
				ray_cast_beam.transform.origin = world.player.global_transform.origin 
				var cursor_position = world.cursor.transform.origin - ray_cast_beam.transform.origin # getting local position
				ray_cast_beam.set_target_position(cursor_position)
				ray_cast_beam.force_raycast_update()
				
				
				#add line effect
#				beam_line.switch_show_line(true)
#				beam_line.set_line_point(1,world.cursor.global_transform.origin)
#				beam_line.set_line_point(2,world.cursor.global_transform.origin)
#				beam_line.set_line_point(3,world.cursor.global_transform.origin)
#				beam_line.draw_line(ray_cast_beam.transform.origin, world.cursor.transform.origin)
				
										
				if ray_cast_beam.is_colliding():
					print(ray_cast_beam.get_collision_mask_value(0))
					collide_point = ray_cast_beam.get_collision_point()
					collide_normal = ray_cast_beam.get_collision_normal()

#					#update line effect
					fx_sparks_array[ray_cast_id].global_transform.origin = collide_point
#					beam_line.set_line_point(1,beam_ray_cast_array[ray_cast_id].get_collision_point())
#					beam_line.set_line_point(2,beam_ray_cast_array[ray_cast_id].get_collision_point())
#					beam_line.set_line_point(3,beam_ray_cast_array[ray_cast_id].get_collision_point())	
#					beam_line.set_line_point(4,beam_ray_cast_array[ray_cast_id].get_collision_point())	
#					beam_line.draw_line(beam_ray_cast_array[ray_cast_id].transform.origin, beam_ray_cast_array[ray_cast_id].get_collision_point())

					
			else:
				if collide_point == Vector3.ZERO:
					return
				else:
					ray_cast_beam.transform.origin = collide_point
					var velocity_vector = collide_point - beam_ray_cast_array[ray_cast_id-1].global_transform.origin
					ray_cast_beam.set_target_position(velocity_vector.bounce(collide_normal) * 200)
					ray_cast_beam.force_raycast_update()
					
					
#					beam_line.set_line_point(ray_cast_id + 1, velocity_vector.bounce(collide_normal) * 200)			
					if ray_cast_beam.is_colliding():
						collide_point = ray_cast_beam.get_collision_point()
						collide_normal = ray_cast_beam.get_collision_normal()
						
						#add sparks effect
						fx_sparks_array[ray_cast_id].global_transform.origin = collide_point
						fx_sparks_array[ray_cast_id].emitting = true	
						
#						beam_line.set_line_point(ray_cast_id + 1,beam_ray_cast_array[ray_cast_id].get_collision_point())	
#						beam_line.set_line_point(ray_cast_id + 2,beam_ray_cast_array[ray_cast_id].get_collision_point())	
#						beam_line.set_line_point(ray_cast_id + 3,beam_ray_cast_array[ray_cast_id].get_collision_point())					
					else:
						# turn off sparks effect:
						fx_sparks_array[ray_cast_id].emitting = false						


#		energy_beam.set_line(world.player.global_transform.origin,cursor_position, delta)
		
		# Animate arm position
#		arm_right.transform.origin = lerp(arm_right_init_pos, shoot_pos_marker.transform.origin, 0.4)
#		arm_left.transform.origin = lerp(arm_left_init_pos, shoot_pos_marker.transform.origin, 0.4)
	else:
#		print("shoot end")
		# turn off all ray_cast_beam and effect
		for ray_cast_beam in beam_ray_cast_array:
			ray_cast_beam.enabled = false
		for fx_sparks in fx_sparks_array:
			fx_sparks.emitting = false
#		beam_line.remove_line()
#		for i in max_bounce:
#			beam_line.add_line_point(Vector3.ZERO)
#		beam_line.add_line_point(Vector3.ZERO)
#		beam_line.add_line_point(Vector3.ZERO)
##		for fx_beam_line in fx_beam_line_array:
#			fx_beam_line.switch_show_line(false)

#		energy_beam.set_line(Vector3.ZERO,Vector3.ZERO, delta)
		
		# Revert arm position
#		arm_right.transform.origin = lerp(arm_right.transform.origin, arm_right_init_pos, 0.2)
#		arm_left.transform.origin = lerp(arm_left.transform.origin, arm_left_init_pos, 0.2)
