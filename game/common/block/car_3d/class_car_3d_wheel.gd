extends RayCast3D
class_name class_car_3d_wheel

@onready var car: RigidBody3D = get_parent().get_parent()
var previous_spring_length: float = 0.0

@export var is_motor_wheel = false
@export var wheel_mesh : Node3D

func _ready():
	add_exception(car)
	set_wheel_position(car.wheel_radius)
	
func _physics_process(delta) :
	
	if is_colliding():
		# the direction the force will be applied
		var collision_point = get_collision_point()
		set_wheel_position(to_local(get_collision_point()).y  + car.wheel_radius)
		set_steer_rotation(delta)
		apply_suspension(delta, collision_point)
		apply_acceleration(delta, collision_point)
		apply_z_force(collision_point)
		apply_x_force(delta, collision_point)
		rotate_wheel(delta)

func set_steer_rotation(delta):
	var steering_rotation
	if car.steering_input:
		steering_rotation = car.steering_input * car.steering_angle
	else:
		steering_rotation = 0.0 * car.steering_angle
	
	if steering_rotation != 0:
		if !is_motor_wheel:
			var angle = clamp(self.rotation.y + steering_rotation, -car.steering_angle, car.steering_angle)
			var new_rotation = angle * delta / 2
		
			self.rotation.y = lerp(self.rotation.y, new_rotation, 0.5)
	else:
		self.rotation.y = lerp(self.rotation.y, 0.0, 0.2)

func set_wheel_position(new_y_pos:float):
	if wheel_mesh:
		for wheels in wheel_mesh.get_children():
			var wheel_name = wheels.name
			if wheel_name == self.name:
				wheels.position.x = self.position.x
				wheels.position.z = self.position.z
				wheels.position.y = lerp(wheels.position.y, new_y_pos, 0.6)
				
				if car.bool_is_drifting:
					# Add car drift decal code
					pass
				
				if !is_motor_wheel:
					wheels.rotation.y = self.rotation.y
	else:return

func rotate_wheel(delta:float):
	var dir = car.basis.z
	var rotate_direction = 1 if car.linear_velocity.dot(dir) > 0 else -1
	if wheel_mesh:
		for wheels in wheel_mesh.get_children():
			wheels.rotation.x += rotate_direction * car.linear_velocity.length() * delta

func apply_x_force(delta, collision_point):
	var dir = global_basis.x
	var state:= PhysicsServer3D.body_get_direct_state(car.get_rid())
	var tire_world_vel = state.get_velocity_at_local_position(global_position - car.global_position)
	var lateral_vel = dir.dot(tire_world_vel)
	var grip = car.front_tire_grip
	var x_force: float
	if !is_motor_wheel:
		grip = car.rear_tire_grip
	
	var desired_vel_change = -lateral_vel * grip

	x_force = desired_vel_change / delta * 8 # The bigger the number, the easier it is to turn
	car.bool_is_drifting = false
	
	if car.drifting_input:
		car.bool_is_drifting = true
		desired_vel_change = lerp(-lateral_vel, -lateral_vel * 0.01, 0.6)
		x_force = lerp(x_force, desired_vel_change / delta / 10, 1) 
		
		
	car.apply_force(dir * x_force, collision_point - car.global_position)
	

func apply_z_force(collision_point):
	var dir = global_basis.z
	var state:= PhysicsServer3D.body_get_direct_state(car.get_rid())
	var tire_world_vel = state.get_velocity_at_local_position(global_position - car.global_position)	
	var z_force = dir.dot(tire_world_vel) * car.mass / 10
	
	car.apply_force(-dir * z_force, collision_point - car.global_position)

func apply_acceleration(delta, collision_point):
	if !is_motor_wheel:
		return
	var acceleration_dir = -global_basis.z
	var torque
	if car.accel_input:
		torque = car.accel_input * car.engine_power
	else:
		torque = 0.0 * car.engine_power	
	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.z)
	var force = acceleration_dir * torque
	car.apply_force(acceleration_dir * torque, point - car.global_position)

func apply_suspension(delta, collision_point):
	var susp_dir = global_basis.y
	var raycast_origin = global_position
	var raycast_dest = collision_point
	var distance = raycast_dest. distance_to(raycast_origin)

	var contact = raycast_dest - car.global_position
	var spring_length = clamp (distance - car.wheel_radius, 0, car. suspension_rest_distance)
	var spring_force = car.spring_strength * (car.suspension_rest_distance - spring_length)
	var spring_velocity = (previous_spring_length - spring_length) / delta
	var damper_force = car.spring_damper * spring_velocity
	var suspension_force = basis.y * (spring_force + damper_force)

	previous_spring_length = spring_length


	var point = Vector3 (raycast_dest.x, raycast_dest.y + car.wheel_radius, raycast_dest.z)
	car.apply_force(susp_dir * suspension_force, point - car. global_position)
