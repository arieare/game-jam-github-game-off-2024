extends Control

@export var item_info:PanelContainer

@export var item_image:TextureRect
var item_image_path:String = ""

@export var patch_name: RichTextLabel
var patch_name_text:String = ""

@export var patch_price: RichTextLabel
var patch_price_text:String = ""

@export var patch_description: RichTextLabel
var patch_description_text:String = ""

var item_overlay_color: Color
@export var btn_purchase: Button

var item_data = {}

func _ready() -> void:
	init_item()
	item_image.connect("mouse_entered", _on_mouse_entered)
	item_image.connect("mouse_exited", _on_mouse_exited)

var is_image_hovered:=false

func _on_mouse_entered():
	is_image_hovered = true
	item_info.show()
	

func _on_mouse_exited():
	is_image_hovered = false
	item_info.hide()	

func init_item():
	item_image.texture = load(item_image_path)
	item_image.self_modulate = item_overlay_color
	patch_name.text = patch_name_text
	#patch_price.text = "$" + patch_price_text
	patch_description.text = patch_description_text
	
func _process(delta: float) -> void:
	if is_image_hovered and Input.is_action_just_pressed("confirm"):
		if util.root.data_instance.game_data.patch_inventory.size() < util.root.data_instance.game_data.max_patch_inventory:
			if item_data["price"] < util.root.data_instance.game_data.money:
				#print(item_data)
				util.root.data_instance.game_data.patch_inventory.append(item_data)
				util.root.data_instance.add_patch_to_inventory.emit(item_data)
				util.root.data_instance.money_amount_change.emit(-item_data["price"])
				queue_free()	
