class_name cam_filter_dither extends Node

## plug pixelated camera effect

var parent_cam
var dither_filter = preload("res://content/material/dither.tres")
var pixel_size = 1

var pixel_subviewport

func init_pixelart_style(cam_parent):
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
	cam_parent.add_child.call_deferred(pixel_viewport)	
	
	pixel_subviewport = SubViewport.new()
	pixel_subviewport.name = "pixel_sub_viewport"
	pixel_subviewport.handle_input_locally = false
	pixel_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	pixel_viewport.add_child.call_deferred(pixel_subviewport)
		
	for child in cam_parent.get_children():		
		if child is not SubViewportContainer:
			child.reparent.call_deferred(pixel_subviewport)
	

func _ready() -> void:
	parent_cam = get_parent()
	if parent_cam is Camera2D or parent_cam is Camera3D:
		init_pixelart_style(parent_cam.get_parent())
	else: return
