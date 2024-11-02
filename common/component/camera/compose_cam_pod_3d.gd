@icon("res://content/icon/camera_3d.svg")
extends Node3D
class_name compose_cam_pod_3d

@onready var cam: Camera3D = Camera3D.new()

## modules
@onready var cam_shake: component_cam_shake = component_cam_shake.new()
@onready var cam_follow: component_cam_follow = component_cam_follow.new()
@onready var cam_free_look: component_cam_free_look = component_cam_free_look.new()
@onready var cam_filter: component_cam_filter_dither = component_cam_filter_dither.new()

## variables
@export var cam_target: Node3D
@export var cam_root: Node

## setting
var cam_offset_y: float = 8.0
var cam_offset_z: float = 8.0
var cam_fov = 75
var cam_rotation = -45
var cam_offset = Vector3(0, cam_offset_y, cam_offset_z)

func _ready() -> void:	
	cam_setting()
	cam_filter.init_pixelart_outline(cam)
	cam_filter.init_pixelart_style(cam_root)

func _process(delta):
	cam_shake.apply_shake(cam, delta)
	cam_follow.follow_cam(self, cam_target, cam_offset)
	cam_free_look.rotate_cam(self)

func cam_setting():
	self.add_child(cam)
	cam.projection = Camera3D.PROJECTION_PERSPECTIVE
	cam.fov = cam_fov
	cam.position = cam_offset
	cam.rotation_degrees.x = cam_rotation
	cam.near = 0.001
