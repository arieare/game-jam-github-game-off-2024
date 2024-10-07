extends CharacterBody2D
class_name class_car_top_down_2d

## turn a character body 2d into top-down car

var wheel_base = 30  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees
var steer_angle

var engine_power = 400  # Forward acceleration force.
var acceleration = Vector2.ZERO

var friction = -0.9
var drag = -0.0015

var braking = -450
var max_speed_reverse = 250

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

var collide_with

@onready var root_node = get_tree().get_root().get_child(0)
@export var stage_node: Node2D
# Control
@export var car_input:class_player_input


func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()	
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func get_input():
	var turn = 0
	if Input.is_action_pressed("ui_right"):
		turn += 1
	if Input.is_action_pressed("ui_left"):
		turn -= 1
	steer_angle = turn * steering_angle
	if Input.is_action_pressed("ui_down"):
		acceleration = transform.x * braking	
	if Input.is_action_pressed("ui_up"):
		acceleration = transform.x * engine_power

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
	if velocity.length() < 0.2:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force	
