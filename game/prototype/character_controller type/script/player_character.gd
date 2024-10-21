extends RigidBody3D

var cam_offset


var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var ray_direction = Vector3.DOWN
var previous_velocity = Vector3.ZERO
var move_context: Vector2

var is_camera_direction = false
var ground_layer:int = 3

var should_maintain_height = true

## Height Spring
@export_group("Height Spring")
@export var ride_height:float = 1.75 # desired distance to ground (Note, this is distance from the original raycast position (currently centre of transform)).
@export var ray_to_ground_length:float = 3.0 # rayToGroundLength: max distance of raycast to ground (Note, this should be greater than the rideHeight).
@export var ride_spring_strength:float = 50.0 #strength of spring.
@export var ride_spring_damper:float = 5.0 #strength of spring.
#var oscillator

enum look_direction_option {VELOCITY, ACCELERATION, MOVE_INPUT}
var upright_target_rotation : Quaternion = Quaternion.IDENTITY
#var upright_target_rotation = Vector3.FORWARD
var last_target_rotation : Quaternion
var platform_initial_rotation : Vector3
var did_last_ray_hit : bool

## Upright Spring
@export_group("Upright Spring")
var character_look_direction = look_direction_option.MOVE_INPUT
var upright_spring_strength = 40.0
var upright_spring_damper = 5.0

## Movement
var move_input:Vector3
var speed_factor:float = 1.0
var max_accel_force_factor:float = 1.0
var m_goal_velocity:Vector3 = Vector3.ZERO
@export var max_speed:float = 8.0
@export var acceleration:float = 200.0
@export var max_accel_force:float = 150.0
@export var lean_factor:float = 0.25
@export var accel_factor_from_dot:Curve = Curve.new()
@export var max_accel_force_factor_from_dot:Curve = Curve.new()
@export var move_force_scale:Vector3 = Vector3(1.0, 0.0, 1.0)

## Jumping
var jump_input:Vector3
var time_since_jump_pressed:float = 0.0
var time_since_ungrounded:float = 0.0
var time_since_jump:float = 0.0
var is_jump_ready:bool = true
var is_jumping:bool = false

@export var jump_force_factor:float = 10.0
@export var rise_gravity_factor:float = 5.0
@export var fall_gravity_factor:float = 10.0 #typically > 1f (i.e. 5f).
@export var low_jump_factor:float = 2.5
@export var jump_buffer:float = 0.15 # Note, jumpBuffer shouldn't really exceed the time of the jump.
@export var coyote_time:float = 0.25

func _ready():
	cam_offset = world.top_down_cam.global_position - self.global_position

func _physics_process(delta):
	world.top_down_cam.global_position = self.global_position + cam_offset
	get_move_input_action()

# Use the result of a Raycast to determine if the capsules distance from the ground is sufficiently close to the desired ride height such that the character can be considered 'grounded'.
func check_if_grounded(is_ray_hit_ground: bool, ray_cast_hit:Dictionary) -> bool:
	var is_grounded:bool
	if is_ray_hit_ground == true:
		is_grounded = ray_cast_hit["position"].distance_to(self.transform.origin) <= ride_height * 2.3; # 1.3f allows for greater leniancy (as the value will oscillate about the rideHeight).
	else:
		is_grounded = false
	return is_grounded

# The method for determining the look direction is depends on the lookDirectionOption.
func get_look_direction(delta) -> Vector3:
	var look_direction = Vector3.ZERO
	if character_look_direction == look_direction_option.VELOCITY or character_look_direction == look_direction_option.ACCELERATION:
		var current_velocity = self.linear_velocity
		current_velocity.y = 0.0
		if character_look_direction == look_direction_option.VELOCITY:
			look_direction = current_velocity
		elif character_look_direction == look_direction_option.ACCELERATION:
			var delta_velocity = current_velocity - previous_velocity
			previous_velocity = current_velocity;
			var current_acceleration = delta_velocity / delta
			look_direction = current_acceleration;
		elif character_look_direction == look_direction_option.MOVE_INPUT:
			look_direction = move_input
	return look_direction

var is_previously_grounded:bool = false

func _process(delta):
	move_input = Vector3(move_context.x, 0, move_context.y)
	if (is_camera_direction):
		move_input = adjust_input_to_face_cam(move_input)

	var ray_cast_result = raycast_to_ground()

	var ray_hit_ground:bool = ray_cast_result[0]
	var ray_hit = ray_cast_result[1]

	#set_platform(ray_hit)
	var is_grounded:bool = check_if_grounded(ray_hit_ground, ray_hit)
	if (is_grounded == true):
		if is_previously_grounded:
			#TODO play landing audio if audio find
			print("")
		if move_context.length() != 0:
			#TODO play walking audio if audio find
			print("")
		else:
			#TODO stop walking audio if audio find
			print("")
		#TODO emit dust particle system
	   #if (_dustParticleSystem)
			#{
				#if (_emission.enabled == false)
				#{
					#_emission.enabled = true; // Applies the new value directly to the Particle System                  
				#}
			#}			
		time_since_ungrounded = 0.0
		if time_since_jump > 0.2:
			is_jumping = false
	
	else:
		#TODO stop walking audio if audio find
		print("")
			#if (_dustParticleSystem)
			#{
				#if (_emission.enabled == true)
				#{
					#_emission.enabled = false; // Applies the new value directly to the Particle System
				#}
			#}
		time_since_ungrounded += delta

	character_move(move_input, ray_hit, delta)
	#character_jump(jump_input, is_grounded, ray_hit, delta)
	
	#if (ray_hit_ground and should_maintain_height):
		#maintain_height(ray_hit)
	
	var look_direction:Vector3 = get_look_direction(character_look_direction)
	#maintain_upright(look_direction, ray_hit)
	
	is_previously_grounded = is_grounded
	return

# Adjusts the input, so that the movement matches input regardless of camera rotation.
func adjust_input_to_face_cam(move_input:Vector3) -> Vector3:
	var facing:float = world.top_down_cam.rotation_degrees.y;
	var rotation = Basis(Vector3(0,1,0), deg_to_rad(facing)).get_rotation_quaternion()
	return (rotation * move_input)

func raycast_to_ground() -> Array:
	var ray_cast_hit = {}
	var ray_to_ground_origin = self.global_transform.origin
	var physics_query = PhysicsRayQueryParameters3D.create(ray_to_ground_origin,ray_to_ground_origin + ray_direction * ray_to_ground_length,ground_layer,[])
	var space_state = get_world_3d().direct_space_state
	var ray_cast_result = space_state.intersect_ray(physics_query)
	var is_ray_hit_ground = ray_cast_result.size() > 0
	
	if is_ray_hit_ground:
		ray_cast_hit = ray_cast_result
	
	return [is_ray_hit_ground, ray_cast_hit]

#Set the transform parent to be the result of RaycastToGround.
#If the raycast didn't hit, then unset the transform parent.
#func set_platform(ray_cast_hit:RayCast3D):
	#if
#RigidPlatform rigidPlatform = rayHit.transform.GetComponent<RigidPlatform>();
#RigidParent rigidParent = rigidPlatform.rigidParent;
#transform.SetParent(rigidParent.transform);
#}Å
#catch
#{
#transform.SetParent(null);
#}
#}

# Adds torque to the character to keep the character upright, acting as a torsional oscillator (i.e. vertically flipped pendulum).
#func maintain_upright(y_look_at:Vector3, ray_cast_hit:Dictionary):
	#calculate_target_rotation(y_look_at, ray_cast_hit)
	#var current_rotation:Quaternion = transform.basis
	##var to_goal:Quaternion = shortest_rotation(upright_target_rotation, current_rotation)
	#var to_goal =  upright_target_rotation.slerp(current_rotation,1)
	##var rotation_axis: Vector3
	##var rotation_degree:float
	#
	##var angle_rad = to_goal.get_angle()
	##rotation_axis = to_goal.get_axis()
	##rotation_axis = rotation_axis.normalized()
#
	##rotation_degree = rad_to_deg(angle_rad)
	##var rot_radians = deg_to_rad(rotation_degree)
	#
	#self.apply_torque((to_goal.get_axis() * (deg_to_rad(to_goal.get_angle())*upright_spring_strength) - (self.angular_velocity * upright_spring_damper)))
	##self.apply_torque((rotation_axis * (rot_radians * upright_spring_strength)) - (self.angular_velocity * upright_spring_damper))

## Calculate shortest rotation
#func shortest_rotation(target_rot: Quaternion, current_rot: Quaternion) -> Quaternion:
	#var shortest_rot = current_rot.inverse() * target_rot
	#if shortest_rot.dot(current_rot) < 0:
		#shortest_rot = -shortest_rot
	#return shortest_rot
#
## Determines the desired y rotation for the character, with account for platform rotation.
#func calculate_target_rotation(y_look_at:Vector3, ray_cast_hit:Dictionary):
	#if y_look_at != Vector3.ZERO:
		#upright_target_rotation = transform.basis.looking_at(y_look_at, Vector3.UP)
		#last_target_rotation = upright_target_rotation;


# Reads the player movement input.
func get_move_input_action():
	move_context = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

#func maintain_height(ray_cast_hit:Dictionary):
	##TODO implement maintain_height function
	#pass

## Apply forces to move the character up to a maximum acceleration, with consideration to acceleration graphs.
func character_move(move_input:Vector3, ray_cast_hit:Dictionary, delta):
	var m_unit_goal:Vector3 = move_input
	var unit_velocity:Vector3 = m_goal_velocity.normalized()
	var velocity_dot:float = m_unit_goal.dot(unit_velocity)
	#var accel:float = acceleration * accel_factor_from_dot.sample_baked(velocity_dot)
	var accel:float = acceleration * lerpf(velocity_dot,acceleration,0.5)
	
	var goal_velocity:Vector3 = m_unit_goal * max_speed * speed_factor
	var other_velocity:Vector3 = Vector3.ZERO
	#if ray_cast_hit:
	var hit_body = ray_cast_hit["collider"]
	m_goal_velocity = m_goal_velocity.move_toward(goal_velocity, accel * delta)
	print(m_goal_velocity)
	var needed_accel:Vector3 = (m_goal_velocity - self.linear_velocity) / delta
	var max_accel:float = max_accel_force * max_accel_force_factor * lerpf(max_accel_force_factor,velocity_dot,0.5)

	#var accel_min = needed_accel.normalized() * -1
	var accel_max = needed_accel * max_accel
	needed_accel = clamp(needed_accel,needed_accel,Vector3(max_accel,max_accel,max_accel))
	#self.apply_force((needed_accel*self.mass) * move_force_scale, self.global_position + Vector3(0, self.scale.y * lean_factor, 0.0))
	self.apply_central_force((needed_accel*self.mass) * move_force_scale)
	
	
#func character_jump(jump_input:Vector3,is_grounded:bool, ray_cast_hit:Dictionary, delta):
	#time_since_jump_pressed += delta;
	#time_since_jump += delta;
	#if self.linear_velocity.y < 0:
		#should_maintain_height = true
		#is_jump_ready = true;
	#if ! is_grounded:
		##Increase downforce for a sudden plummet.
		#self.apply_force(Vector3(0,-GRAVITY,0) * (fall_gravity_factor - 1.0)) # Hmm... this feels a bit weird. I want a reactive jump, but I don't want it to dive all the time...
	#elif self.linear_velocity.y > 0:
		#if !is_grounded:
			#if is_jumping:
				#self.apply_force(-GRAVITY * (rise_gravity_factor - 1.0))
			#if jump_input == Vector3.ZERO:
				## Impede the jump height to achieve a low jump.
				#self.apply_force(-GRAVITY * (low_jump_factor - 1.0))
	#
	#if time_since_jump_pressed < jump_buffer:
		#if time_since_ungrounded < coyote_time:
			#if is_jump_ready:
				#is_jump_ready = false
				#should_maintain_height = false
				#is_jumping = true
				#self.set_linear_velocity(Vector3(self.linear_velocity.x, 0.0, self.linear_velocity.z)) # Cheat fix... (see comment below when adding force to rigidbody).
				#if (ray_cast_hit["position"].distance_to(self.transform.origin) != 0): #i.e. if the ray has hit
					#self.position = Vector3(self.position.x, self.position.y - (ray_cast_hit["position"].distance_to(self.transform.origin) - ride_height), self.position.z)
				#self.apply_central_impulse(Vector3.UP * jump_force_factor) # This does not work very consistently... Jump height is affected by initial y velocity and y position relative to RideHeight... Want to adopt a fancier approach (more like PlayerMovement). A cheat fix to ensure consistency has been issued above...
				#time_since_jump_pressed = jump_buffer # So as to not activate further jumps, in the case that the player lands before the jump timer surpasses the buffer.
				#time_since_jump = 0.0
#
				##TODO play sound jumping
