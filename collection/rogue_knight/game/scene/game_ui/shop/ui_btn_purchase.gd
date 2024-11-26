extends Button
@onready var item_root = get_parent().get_parent()
@export var price_text: RichTextLabel
#@export var item_image: TextureRect
	

func _ready() -> void:
	util.root.data_instance.stylesheet.button_styler(self, price_text, "green_secondary", "medium", false, false)
	
	price_text.text = "¢" + item_root.patch_price_text
	
	if item_root.item_data["price"] > util.root.data_instance.game_data.money:
		util.root.data_instance.stylesheet.button_styler(self, price_text, "green_secondary", "medium", true, false)
	else:
		util.root.data_instance.stylesheet.button_styler(self, price_text, "green_secondary", "medium", false, false)	
		

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		if item_root and util.root.data_instance.game_data.patch_inventory.size() < util.root.data_instance.game_data.max_patch_inventory:
			if item_root.item_data["price"] < util.root.data_instance.game_data.money:
	
				util.root.data_instance.game_data.patch_inventory.append(item_root.item_data)
				util.root.data_instance.add_patch_to_inventory.emit(item_root.item_data)
				util.root.data_instance.money_amount_change.emit(-item_root.item_data["price"])
				item_root.queue_free()
	
func _process(delta: float) -> void:
	if item_root.item_data["price"] >= util.root.data_instance.game_data.money:
		util.root.data_instance.stylesheet.button_styler(self, price_text, "green_secondary", "medium", true, false)
	else:
		util.root.data_instance.stylesheet.button_styler(self, price_text, "green_secondary", "medium", false, false)		
	
	
#func button_enabled(is_btn_enabled:bool):
	#if is_btn_enabled:
		#util.root.data_instance.button_styler(self, price_text, "green", "medium", false, true)
		##self.disabled = false
		#price_text.add_theme_color_override("default_color",Color.DARK_GREEN)
		#price_text.add_theme_color_override("font_shadow_color",Color.LIME_GREEN)	
	#else:
		#util.root.data_instance.button_styler(self, price_text, "green", "medium", true, true)
		##self.disabled = true
		#price_text.add_theme_color_override("default_color",Color.WEB_GRAY)
		#price_text.add_theme_color_override("font_shadow_color",Color.GRAY)		
