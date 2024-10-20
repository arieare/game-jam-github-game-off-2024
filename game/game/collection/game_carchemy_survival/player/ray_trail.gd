extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -400.0
var dir : Vector2
var shoot:bool = false
var bounce_attempt: int = 0
var max_bounce: int = 10
var trace_line: PackedVector2Array
var time: float
var fade_time: float = 0.5
var col1: = Color.WHITE
var col2: = Color(0.0, 0.0, 0.0, 0.0)
@export var player: CharacterBody2D
var colorArray: PackedColorArray = [Color.RED, Color.GREEN, Color.BLUE]
enum beam_type {DEBUG, SHADOW, FIRE, LIGHT}
var fx_spark_array : Array = []

var shoot_timer = 0.0
var is_shooting :bool = false

@onready var game_node = get_node("/root/game")

func _ready() -> void:
	for i in max_bounce:
		#draw_beam()
		draw_spark()
		#add_point_light()
		#add_ray_cast()
func _process(delta: float) -> void:	
	if !trace_line.is_empty():
		trace_line[0] = player.global_position
	## Trial 2
	if !is_shooting:
		self.global_position = player.global_position
	if Input.is_action_just_pressed("click"):
		is_shooting = true
		dir = to_local(get_global_mouse_position())
		bounce_attempt = 0
		trace_line.append(self.position)
	if is_shooting:
		
		queue_redraw()
		var collider = move_and_collide(dir * delta * SPEED)
		
		
		if collider:
			if collider.get_collider().name == "core_crystal":
				bounce_attempt == max_bounce
				trace_line.append(collider.get_position())
				fx_spark_array[bounce_attempt].position = to_local(collider.get_position())
				fx_spark_array[bounce_attempt].emitting = true
				game_node.core_crystal_hit.emit()
			else:
				bounce_attempt += 1
				trace_line.append(collider.get_position())
				dir = dir.bounce(collider.get_normal())
				collider = move_and_collide(dir * delta * SPEED)
			
	
			
		if bounce_attempt == max_bounce:
			self.velocity = lerp(self.velocity, Vector2.ZERO, 0.5)
			is_shooting = false
			self.global_position = player.global_position
	if Input.is_action_just_released("click"):
		self.velocity = lerp(self.velocity, Vector2.ZERO, 0.5)
		is_shooting = false
		self.global_position = player.global_position
		trace_line.clear()
		queue_redraw()
		
	## Trial 3

	#if Input.is_action_pressed("click"):
		#if is_shooting:
			#shoot_timer += delta
			#trace_line.clear()
			#queue_redraw()
		#
		#if shoot_timer > 1:
			#shoot_ray(delta)
			#shoot_timer = 0
			#self.global_position = player.global_position
			#trace_line.clear()
			#queue_redraw()
		#else:
			#shoot_ray(delta)
			#is_shooting = true
			#shoot_timer = 0
	#
	#if Input.is_action_just_released("click"):
		#is_shooting = false
		#shoot_timer = 0
		#self.global_position = player.global_position
		#trace_line.clear()
		#queue_redraw()

func shoot_ray(delta):
	
	dir = to_local(get_global_mouse_position())
	bounce_attempt = 0
	trace_line.append(player.global_position)
	trace_line.append(to_global(dir))
	queue_redraw()
	var collider = move_and_collide(dir * delta * SPEED)
	if collider:
		bounce_attempt += 1
		
		print(collider)
		dir = dir.bounce(collider.get_normal())
		collider = move_and_collide(dir * delta * SPEED)
		trace_line.append(global_position)
	


func _physics_process(delta: float) -> void:
	time += delta

func _draw()->void:
	var rng = RandomNumberGenerator.new()
	if !trace_line.is_empty():
		for i in trace_line.size() -1:
			#var t:float = (time - trace_line[i][1]) / fade_time
			#if t <= 1.0:
			#var c: = col2.lerp(col1, 1.0-t)
			#var c: = colorArray[rng.randi_range(0,colorArray.size()-1)]
			var c: = Color.ORANGE_RED
			var p1:Vector2 = to_local(trace_line[i])
			var p2:Vector2 = to_local(trace_line[i+1])
			#var thic:float = clamp(4 * (1.0-t*5.0), 1.0, 10.0)
			var thic:float = 3.0
			draw_line(p1, p2, c, thic)


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
