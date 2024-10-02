@icon("res://content/icon/node_icon_camera.svg")
extends Node3D

@onready var root = get_tree().get_root().get_child(0)
@export var scene_root: Node3D
@onready var cam_child:Camera3D = self.get_child(0)

## Modules
var cam_feature:Dictionary = {}
@onready var cam_filter:Cam = CamFilterDither.new()

func init_modules():
	for key in cam_feature:
		cam_feature[key].assert_cam_parent(self)
	#cam_feature["cam_shake"].assert_cam_parent(self)
	#cam_feature["cam_follow"].assert_cam_parent(self)
	#cam_feature["cam_free_look"].assert_cam_parent(self)
	cam_filter.assert_cam_parent(self)

## Camera Setting
var cam_offset_y: float = 18.0
var cam_offset_z: float = 15.0
var cam_fov = 75
var cam_rotation = -30
var cam_offset = Vector3(0, cam_offset_y, cam_offset_z)

func cam_setting():
	cam_child.fov = cam_fov
	cam_child.position = cam_offset
	cam_child.rotation_degrees.x = cam_rotation	
	#cam_child.rotation_degrees.y = cam_rotation_y

func register_self_to_root():
	root.cam = self

func _ready() -> void:	
	root.get_module(cam_child, cam_feature)
	print(cam_feature)
	register_self_to_root()
	cam_setting()
	init_modules()
	#if cam_filter: 
		#cam_filter.init_pixelart_outline(cam_filter.pixel_outline_filter)
		#cam_filter.init_pixelart_style(scene_root, cam_filter.dither_filter)	

func _process(delta):
	cam_feature["cam_shake"].apply_shake(delta)
	cam_feature["cam_follow"].follow_cam(root.cam_target, cam_offset)
	cam_feature["cam_free_look"].rotate_cam()
