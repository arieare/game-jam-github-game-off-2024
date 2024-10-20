extends Node2D

@export var player: CharacterBody2D
@export var player_point_light: PointLight2D

enum beam_type {DEBUG, SHADOW, FIRE, LIGHT}
var fx_beam_line_array : Array = []
var fx_spark_array : Array = []
var fx_spark_light_array : Array = []
var ray_cast_array : Array = []
var ray_cast_hit_point_array : PackedVector2Array = []
#var fx_beam_dict : = [{"fx_line": Line2D, "fx_spark": CPUParticles2D, "fx_spark_light" : PointLight2D, "beam_type": beam_type}]


var max_bounce : int = 3
#var bounce_attempt : int = 0
var ray_from : Vector2
var ray_to : Vector2
var ray_length = 1.0

#var cast_id = 0
var cast_collide_point = Vector2.ZERO
var cast_collide_normal = Vector2.ZERO

var collider 
var ray_origin 
var collider_point 
var incoming_direction 
var collider_normal 
var outgoing_direction

@onready var tex_spark_light = preload("res://asset/fx/texture_spark_light.tres")

var debug_color : Color = Color.GREEN_YELLOW

func _ready() -> void:
	for i in max_bounce:
		draw_beam()
		draw_spark()
		add_point_light()
		add_ray_cast()

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(1):
		var prev_collider = null
		
		for bounce_attempt in max_bounce:
			
			if bounce_attempt == 0: # first bounce
				
				ray_cast_array[bounce_attempt].visible = true
				ray_cast_array[bounce_attempt].global_position = player.global_position
				ray_cast_array[bounce_attempt].target_position = to_local(get_global_mouse_position())
				ray_cast_array[bounce_attempt].force_raycast_update()
				
				ray_cast_hit_point_array.remove_at(bounce_attempt)
				ray_cast_hit_point_array.insert(bounce_attempt, ray_cast_array[bounce_attempt].target_position)
				
				if ray_cast_array[bounce_attempt].is_colliding() and ray_cast_array[bounce_attempt].get_collider().is_in_group("alchemy_crystal"):
					ray_cast_array[bounce_attempt].target_position = to_local(ray_cast_array[bounce_attempt].get_collision_point()) 
					
					ray_cast_hit_point_array.remove_at(bounce_attempt)
					ray_cast_hit_point_array.insert(bounce_attempt, ray_cast_array[bounce_attempt].target_position)
				
			if ray_cast_array[bounce_attempt].is_colliding() and ray_cast_array[bounce_attempt].get_collider().is_in_group("alchemy_crystal"):
				ray_cast_array[bounce_attempt].visible = true
				ray_cast_array[bounce_attempt].target_position = to_local(ray_cast_array[bounce_attempt].get_collision_point()) 
				
				ray_cast_hit_point_array.remove_at(bounce_attempt)
				ray_cast_hit_point_array.insert(bounce_attempt, ray_cast_array[bounce_attempt].target_position)
				
				collider = ray_cast_array[bounce_attempt].get_collider()
				ray_origin = ray_cast_array[bounce_attempt].global_transform.origin
				collider_point = ray_cast_array[bounce_attempt].get_collision_point()
				incoming_direction = collider_point - ray_origin
				collider_normal = ray_cast_array[bounce_attempt].get_collision_normal()
				outgoing_direction = incoming_direction.bounce(collider_normal)	
				
				#if not collider.is_in_group("alchemy_crystal"): break
				if collider_normal == Vector2.ZERO: break
				
				
				if prev_collider != null:
					prev_collider.collision_mask = 3
					prev_collider.collision_layer = 3
				prev_collider = collider
				prev_collider.collision_mask = 0
				prev_collider.collision_layer = 0		
					
			if bounce_attempt > 0 and prev_collider != null:
				## subsequent bounce
				
				ray_cast_array[bounce_attempt].global_position = collider_point
	
				
				###==== calculate next direction 
				var flip_collider_point : Vector2
				var flip_outgoing_direction : Vector2
				var temp = to_local(collider_point)
				flip_collider_point.x = temp.y
				flip_collider_point.y = temp.x
				flip_outgoing_direction.x = outgoing_direction.y
				flip_outgoing_direction.y = -outgoing_direction.x				
				var bounce_vector : Vector2
				if collider_normal.x < 0 :
					bounce_vector =  (outgoing_direction * 2 + to_local(collider_point)) * ray_length
				elif collider_normal.x > 0:
					bounce_vector = (outgoing_direction * 2 - to_local(collider_point)) * -1 * ray_length
				elif collider_normal.y < 0:
					bounce_vector = (flip_outgoing_direction  * 2 + to_local(collider_point) ) * ray_length
				elif collider_normal.y > 0:
					bounce_vector = (flip_outgoing_direction  * 2 - to_local(collider_point) ) * -1 * ray_length
				
				###==== calculate next direction 
				
				if bounce_attempt % 2 == 0:
					bounce_vector = bounce_vector * -1
				ray_cast_array[bounce_attempt].target_position = bounce_vector
				ray_cast_array[bounce_attempt].force_raycast_update()
				
				ray_cast_hit_point_array.remove_at(bounce_attempt)
				ray_cast_hit_point_array.insert(bounce_attempt, ray_cast_array[bounce_attempt].target_position)
				
			
				
				if ray_cast_array[bounce_attempt-1].is_colliding() and ray_cast_array[bounce_attempt-1].get_collider().is_in_group("alchemy_crystal"):
					ray_cast_array[bounce_attempt].visible = true
					
					
					
				else:
					fx_beam_line_array[bounce_attempt].visible = false
		
		print(ray_cast_hit_point_array.size())
		
		#for i in ray_cast_hit_point_array.size() - 1:
			#fx_beam_line_array[i].visible = true
			#if i == 0:
				#fx_beam_line_array[i].set_point_position(0, to_local(player.global_position))
			#else:
				#fx_beam_line_array[i].set_point_position(0, ray_cast_hit_point_array[i-1])
			#
			#fx_beam_line_array[i].set_point_position(1, ray_cast_hit_point_array[i])
		
		if prev_collider != null:
			prev_collider.collision_mask = 3
			prev_collider.collision_layer = 3	
		
		

			
	else:
		for i in max_bounce:
			fx_beam_line_array[i].visible = false
			ray_cast_array[i].visible = false	
		ray_cast_hit_point_array.clear()

func add_ray_cast():
	var ray_cast = RayCast2D.new()
	ray_cast.position = Vector2.ZERO
	ray_cast.target_position = Vector2.ZERO
	ray_cast.enabled = false
	ray_cast.exclude_parent = true
	ray_cast.collide_with_areas = false
	ray_cast.collide_with_bodies = true
	
	self.add_child(ray_cast)
	ray_cast_array.append(ray_cast)	

func draw_spark():
	var spark = CPUParticles2D.new()
	var spark_mat = CanvasItemMaterial.new()
	spark_mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	spark.material = spark_mat
	spark.global_position = (Vector2.ZERO)
	spark.emitting = false
	spark.preprocess = 0.1
	set_spark_type(spark, beam_type.DEBUG)
	# Add to child and dictionary
	self.add_child(spark)
	fx_spark_array.append(spark)

func draw_beam():
	var line = Line2D.new()
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	var line_mat = CanvasItemMaterial.new()
	line_mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	line.material = line_mat
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	set_beam_type(line, beam_type.DEBUG)
	
	# Add to child and dictionary
	self.add_child(line)
	fx_beam_line_array.append(line)

func add_point_light():
	var light = PointLight2D.new()
	light.visible = false
	set_light_type(light)
	
	# Add to child and dictionary
	self.add_child(light)
	fx_spark_light_array.append(light)

func set_spark_type(spark:CPUParticles2D, type:beam_type):
	spark.amount = 12
	spark.lifetime = 0.2
	
	spark.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	spark.emission_sphere_radius = 4
	
	spark.direction = Vector2(0,0)
	spark.spread = 180
	
	spark.gravity = Vector2(0,0)
	spark.scale_amount_min = 0
	
	spark.initial_velocity_min = 150
	spark.initial_velocity_max = 150
	
	# Line property
	match type:
		beam_type.DEBUG:
			spark.color = debug_color
			spark.scale_amount_min = 2
			spark.scale_amount_max = 2
		beam_type.FIRE:
			spark.color = Color.ORANGE_RED
			spark.scale_amount_min = 4
			spark.scale_amount_max = 4
		beam_type.SHADOW:
			spark.color = Color.REBECCA_PURPLE
			spark.scale_amount_min = 4
			spark.scale_amount_max = 4		

func set_beam_type(line:Line2D, type:beam_type):
	# Line property
	match type:
		beam_type.DEBUG:
			line.width = 2
			line.default_color = debug_color
		beam_type.FIRE:
			line.width = 4
			line.default_color = Color.ORANGE_RED
		beam_type.SHADOW:
			line.width = 4
			line.default_color = Color.REBECCA_PURPLE	

func set_light_type(light:PointLight2D):
	var light_gradient = GradientTexture2D.new()
	light_gradient.gradient = tex_spark_light
	light_gradient.use_hdr = true
	light_gradient.fill = GradientTexture2D.FILL_RADIAL
	light_gradient.fill_from.x = 0.5
	light_gradient.fill_from.y = 0.5
	light.texture = light_gradient
	light.energy = 1.5
	light.shadow_enabled = true
	light.color = debug_color
	light.texture_scale = 0.5
	light.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	

func oscilate_value(value:float, clamp_val, magnitude, delta) -> float:
		var time: float = 0.0
		time = time + delta
		var oscilation
		oscilation = sin(time * magnitude * PI)
		oscilation = clampf(oscilation,-clamp_val,clamp_val)
		var oscilate_val
		oscilate_val = lerpf(value,oscilation, 0.8)
		return oscilate_val
	
