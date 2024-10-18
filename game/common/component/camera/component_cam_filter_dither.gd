extends Node
class_name component_cam_filter_dither

## plug pixelated camera effect

var parent_cam
var pixel_outline_filter = preload("res://content/material/pixel_outline.tres")
var dither_filter = preload("res://content/material/dither.tres")
var pixel_size = 1

var pixel_subviewport

func init_pixelart_outline(cam:Camera3D):
	pass
	## Mesh Renderer
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

func init_pixelart_style(cam_root):
	## Add Subviewport setting only if PixelArt display is enabled
	var pixel_viewport = SubViewportContainer.new()
	pixel_viewport.name = "pixel_viewport"
	pixel_viewport.stretch = true
	pixel_viewport.stretch_shrink = pixel_size
	pixel_viewport.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	pixel_viewport.anchors_preset = Control.PRESET_FULL_RECT
	pixel_viewport.layout_direction = Control.LAYOUT_DIRECTION_LOCALE
	pixel_viewport.size = DisplayServer.window_get_size()
	pixel_viewport.size_flags_horizontal = Control.SIZE_FILL
	pixel_viewport.size_flags_vertical = Control.SIZE_FILL
	pixel_viewport.material = dither_filter
	#root.node_list["game"].get_child(0).add_child.call_deferred(pixel_viewport)
	cam_root.add_child.call_deferred(pixel_viewport)	
	
	pixel_subviewport = SubViewport.new()
	pixel_subviewport.name = "pixel_sub_viewport"
	pixel_subviewport.handle_input_locally = false
	pixel_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	pixel_viewport.add_child.call_deferred(pixel_subviewport)
		
	# Reparent to pixel filter
	#for child in root.node_list["game"].get_child(0).get_children():
	for child in cam_root.get_children():		
		if child is not SubViewportContainer:
			child.reparent.call_deferred(pixel_subviewport)
	

#func _ready() -> void:
	#parent_cam = get_parent()
	#init_pixelart_style(dither_filter)
	#init_pixelart_outline(pixel_outline_filter)
