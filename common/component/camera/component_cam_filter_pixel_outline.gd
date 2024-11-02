class_name cam_filter_pixel_outline extends Node

var parent_cam
var pixel_outline_filter = preload("res://content/material/pixel_outline.tres")

func init_pixelart_outline(cam):
	var plane_mesh = QuadMesh.new()
	plane_mesh.resource_name = "Plane"
	plane_mesh.size = Vector2(2,2)
	plane_mesh.flip_faces = true
	var pixel_outline_renderer = MeshInstance3D.new()
	pixel_outline_renderer.name = "pixel_renderer"
	pixel_outline_renderer.mesh = plane_mesh
	pixel_outline_renderer.extra_cull_margin = 16300 # Extra big number
	pixel_outline_renderer.material_overlay = pixel_outline_filter
	cam.add_child.call_deferred(pixel_outline_renderer)

func _ready() -> void:
	parent_cam = get_parent()
	if parent_cam is Camera2D or parent_cam is Camera3D:
		init_pixelart_outline(parent_cam)
	else: return	
