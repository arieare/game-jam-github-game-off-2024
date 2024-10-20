extends CharacterBody2D

var wheel_base = 30  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees
var steer_angle

var engine_power = 300  # Forward acceleration force.
var engine_power_multiplier = 1.0
var acceleration = Vector2.ZERO

var friction = -0.9 # -0.9
var friction_multiplier = 1.0
var drag = -0.0015

var braking = -450
var max_speed_reverse = 250

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

var collide_with

@onready var root_node = get_tree().get_root().get_child(0)
@export var stage_node: Node2D

enum car_type{NORMAL,ICE,FIRE,STEAM,WATER}
var current_car_type
@onready var car_sprite:Sprite2D = $body/Sprite2D




#"res://game/collection/game_carchemy_survival/content/sprite/tiny_cars_shadow.png"



var car_normal_sprite = preload("res://content/collection/game_carchemy_survival/sprite/tiny_cars.png")
var car_ice_sprite = preload("res://content/collection/game_carchemy_survival/sprite/tiny_cars_ice.png")
var car_fire_sprite = preload("res://content/collection/game_carchemy_survival/sprite/tiny_cars_fire.png")
var car_steam_sprite = preload("res://content/collection/game_carchemy_survival/sprite/tiny_cars_steam.png")
var car_water_sprite = preload("res://content/collection/game_carchemy_survival/sprite/tiny_cars_water.png")
@onready var car_id_label_node = $"../ui_layer/ui/car_id"


## FX
@onready var fx_crystal_hit_node = $fx_crystal_hit
@onready var fx_explosion_node = $fx_explosion
@onready var fx_shadow_node = $fx_shadow

var start_timer: Timer
var crystal_timer: Timer


func _ready() -> void:
	root_node.connect("crystal_hit", on_crystal_hit)
	
	start_timer = Timer.new()
	self.add_child(start_timer)
	start_timer.autostart = false
	start_timer.one_shot = true
	start_timer.wait_time = 5.0
	start_timer.start()
	
	crystal_timer = Timer.new()
	self.add_child(crystal_timer)
	crystal_timer.autostart = false
	crystal_timer.one_shot = true
	crystal_timer.wait_time = 4.0
	
	current_car_type = car_type.NORMAL	

func _physics_process(delta: float) -> void:
	collide_with = get_last_slide_collision()
	if collide_with and collide_with.get_collider().is_in_group("spikes"):
		if current_car_type != car_type.WATER or collide_with.get_collider().is_in_group("enemy"):
			_hit_by_spikes()

	acceleration = Vector2.ZERO
	check_speed()
	get_input()
	apply_friction()	
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	if $sfx/sfx_rev.is_playing() == false:
		$sfx/sfx_rev.play()
	
	$sfx/sfx_rev.pitch_scale = maxf(velocity.length() / 20, 4.0)
	
	match current_car_type:
		car_type.NORMAL:
			car_sprite.texture = car_normal_sprite
			car_id_label_node.text = "normal car"
			friction_multiplier = 1.0		
			engine_power_multiplier = 1.0				
			self.collision_layer = 1		
		car_type.ICE:
			car_sprite.texture = car_ice_sprite
			car_id_label_node.text = "ice car"
			friction_multiplier = 10.0
			engine_power_multiplier = 1.0	
			self.collision_layer = 1		
			
			crystal_reset_to_normal()

		car_type.STEAM:
			car_sprite.texture = car_steam_sprite
			car_id_label_node.text = "steam car"
			self.collision_layer = 2
			friction_multiplier = 1.0		
			engine_power_multiplier = 0.9	
			
			crystal_reset_to_normal()
	
		car_type.FIRE:
			car_sprite.texture = car_fire_sprite
			car_id_label_node.text = "fire car"
			friction_multiplier = 1.0		
			engine_power_multiplier = 1.5
			self.collision_layer = 1
			
			crystal_reset_to_normal()

		car_type.WATER:
			car_sprite.texture = car_water_sprite
			car_id_label_node.text = "water car"
			
			friction_multiplier = 1.0		
			engine_power_multiplier = 1.0	
			self.collision_layer = 2		

			crystal_reset_to_normal()	
	#print(friction_multiplier)
	
func crystal_reset_to_normal():
	if crystal_timer.is_stopped():
		crystal_timer.start()
	if crystal_timer.time_left < 0.1:
		fx_crystal_hit_node.color = Color.WHITE
		fx_crystal_hit_node.emitting = true
		current_car_type = car_type.NORMAL		

func get_input():
	var turn = 0
	if Input.is_action_pressed("move_right"):
		turn += 1
	if Input.is_action_pressed("move_left"):
		turn -= 1
	steer_angle = turn * steering_angle
	if Input.is_action_pressed("move_backward"):
		acceleration = transform.x * braking	
	if Input.is_action_pressed("move_forward"):
		acceleration = transform.x * engine_power * engine_power_multiplier

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func apply_friction():
	if velocity.length() < 0.5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction / friction_multiplier
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force	
	


## Die Condition

func check_speed():
	if start_timer.time_left == 0:
		if velocity.length() == 0.0:
			print("you die")
			#root_node.emit_signal("times_up", stage_node.elapsed_timer)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	print("out of bound")
	velocity = lerp(velocity,Vector2.ZERO,0.8)
	car_sprite.modulate = lerp(Color.WHITE, Color.BLACK, 0.6)
	car_sprite.scale.x = lerpf(1.0,1.5,0.9)
	car_sprite.scale.y = lerpf(1.0,1.5,0.9)
	await get_tree().create_timer(0.1).timeout
	$"../ui_layer/ui/car_id".visible = false
	car_sprite.scale.x = lerpf(1.0,0.01,0.5)
	car_sprite.scale.y = lerpf(1.0,0.01,0.5)
	$sfx/sfx_fall.play()
	$fx_car_engine.emitting = false
	$"../env/Camera2D/camera_shake_2d".add_trauma(0.2)	
	await get_tree().create_timer(0.25).timeout
	root_node.emit_signal("times_up", stage_node.elapsed_timer)


func _on_shadow_body_body_entered(_body: Node2D) -> void:
	print("shadow catches you")
	velocity = lerp(velocity,Vector2.ZERO,0.8)
	$sfx/sfx_smash.pitch_scale = randf_range(0.3,0.4)
	$sfx/sfx_smash.play()
	$sfx/sfx_bell.play()
	fx_explosion_node.emitting = true
	fx_shadow_node.texture_scale = lerpf(fx_shadow_node.texture_scale, 1.5, 0.5)
	$"../env/Camera2D/camera_shake_2d".add_trauma(0.5)
	await get_tree().create_timer(0.5).timeout
	fx_shadow_node.texture_scale = 0.01
	#root_node.emit_signal("times_up", stage_node.elapsed_timer)

func _hit_by_spikes():
	print("SPIKED!")
	$sfx/sfx_smash.pitch_scale = randf_range(0.3,0.4)
	$sfx/sfx_smash.play()
	$sfx/sfx_bell.play()
	fx_explosion_node.emitting = true
	$"../env/Camera2D/camera_shake_2d".add_trauma(0.05)
	await get_tree().create_timer(0.25).timeout
	root_node.emit_signal("times_up", stage_node.elapsed_timer)
	

func on_crystal_hit(crystal_type):
	crystal_timer.stop()
	$sfx/sfx_crystal_hit.pitch_scale = randf_range(1.0,2.0)
	$sfx/sfx_crystal_hit.play()	
	fx_crystal_hit_node.emitting = true
	$"../env/Camera2D/camera_shake_2d".add_trauma(0.2)	
	match crystal_type:
		"ice_crystal":
			fx_crystal_hit_node.color = Color.AQUA
			match current_car_type:
				car_type.NORMAL:
					current_car_type = car_type.ICE
				car_type.ICE:
					current_car_type = car_type.ICE			
				car_type.STEAM:
					current_car_type = car_type.WATER			
				car_type.FIRE:
					current_car_type = car_type.STEAM
				car_type.WATER:
					current_car_type = car_type.ICE					
		"fire_crystal":
			fx_crystal_hit_node.color = Color.YELLOW
			match current_car_type:
				car_type.NORMAL:
					current_car_type = car_type.FIRE
				car_type.STEAM:
					current_car_type = car_type.FIRE			
				car_type.ICE:
					current_car_type = car_type.WATER
				car_type.FIRE:
					current_car_type = car_type.FIRE		
				car_type.WATER:
					current_car_type = car_type.STEAM
