extends BoxContainer

@export var patch_template:PackedScene
@export var patch_inventory_list:HBoxContainer
@export var patch_inventory_heading:BoxContainer

var placeholder_inventory_array:=[]
var array_cursor:=0

func _ready() -> void:
	for placeholder in patch_inventory_list.get_children():
		if placeholder is Panel:
			placeholder_inventory_array.append(placeholder)

	if util.root.data_instance.game_data.patch_inventory.size() > 0:
		for patch in util.root.data_instance.game_data.patch_inventory:
			_on_patch_inventory_added(patch)		
	util.root.data_instance.connect("add_patch_to_inventory", _on_patch_inventory_added)
	util.root.data_instance.connect("remove_patch_from_inventory", _on_patch_inventory_removed)
	
	#if util.root.data_instance.game_data.current_level > 0:
		#patch_inventory_list.show()
		#patch_inventory_heading.show()
	#else:
		#patch_inventory_list.hide()
		#patch_inventory_heading.hide()

#func _process(delta: float) -> void:
	#if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING and util.root.data_instance.game_data.current_level > 0:
		#self.show()
	#else:
		#self.hide()		

func _on_patch_inventory_added(patch_data:Dictionary):
	placeholder_inventory_array[array_cursor].hide()
	array_cursor += 1
	var new_patch = patch_template.instantiate()
	var control_parent = Control.new()
	new_patch.patch_id = patch_data["id"]
	new_patch.patch_name_text = patch_data["name"]
	new_patch.patch_description_text = patch_data["description"]
	new_patch.patch_image = patch_data["image"]
	new_patch.patch_color = patch_data["color"]
	new_patch.rotation_degrees = randf_range(-3.0,3.0)
	new_patch.description_panel.rotation_degrees = new_patch.rotation_degrees * -1
	control_parent.custom_minimum_size = Vector2(80,80)
	control_parent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	patch_inventory_list.add_child(control_parent)
	control_parent.add_child(new_patch)
	
	var spawn_tween: Tween
	spawn_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	spawn_tween.tween_property(new_patch,"scale", Vector2(1.4,1.4),0.05)
	spawn_tween.tween_property(new_patch,"position:y", -20,0.02)
	spawn_tween.tween_interval(0.02)
	spawn_tween.tween_property(new_patch,"scale", Vector2(1,1),0.05)	
	spawn_tween.tween_property(new_patch,"position:y", 0,0.02)

func _on_patch_inventory_removed(patch_data:String):
	array_cursor -= 1
	placeholder_inventory_array[array_cursor].show()
	
