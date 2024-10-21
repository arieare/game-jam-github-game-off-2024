extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var world_cam : Camera3D
var player : CharacterBody3D
var cursor : Node3D

signal player_enter(player_body)
signal camera_available(camera_node)
signal cursor_available(cursor_node)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	self.connect("player_enter", Callable(self, "on_player_enter"))
	self.connect("camera_available", Callable(self, "on_camera_enter"))
	self.connect("cursor_available", Callable(self, "on_cursor_enter"))
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func on_player_enter(player_body):
	player = player_body
	print(player.name)

func on_camera_enter(camera_node):
	world_cam = camera_node
	print(world_cam.name)

func on_cursor_enter(cursor_node):
	cursor = cursor_node
	print(cursor.name)
