extends Control

@onready var shop_item: PackedScene = preload("res://collection/rogue_knight/game/prefab/shop/shop_item.tscn")


func _ready() -> void:
	util.root.data_instance.connect("board_ready", _on_board_ready)

var item_array := []
func init_shop_item(rarity:int, id:String):
	var new_item = shop_item.instantiate()
	new_item.name = util.root.data_instance.patch_dictionary[rarity][id]["id"]
	new_item.item_image_path = util.root.data_instance.patch_dictionary[rarity][id]["image"]
	new_item.item_overlay_color = util.root.data_instance.patch_dictionary[rarity][id]["color"]
	new_item.patch_name_text = util.root.data_instance.patch_dictionary[rarity][id]["name"]
	new_item.patch_price_text = str(util.root.data_instance.patch_dictionary[rarity][id]["price"])
	new_item.patch_description_text = util.root.data_instance.patch_dictionary[rarity][id]["description"]
	new_item.item_image.rotation_degrees = randf_range(-4.0,4.0)


	new_item.item_data = util.root.data_instance.patch_dictionary[rarity][id]
	item_array.append(new_item)
	self.add_child(new_item)
	
func _on_board_ready():
	for i in util.root.data_instance.game_data.max_shop_size:
		var rarity:int=get_item_rarity()
		var item = util.root.data_instance.patch_dictionary[rarity].values().pick_random()
		init_shop_item(rarity,item["id"])
		util.root.data_instance.audio.sfx_dictionary.shop_item_added.sfx.play()
		await get_tree().create_timer(0.05).timeout		

var rng:=RandomNumberGenerator.new()

func get_item_rarity():
	rng.randomize()
	var weighted_sum:=0
	for n in util.root.data_instance.patch_dictionary.keys():
		weighted_sum += n
	var item = rng.randi_range(0,weighted_sum)
	for n in util.root.data_instance.patch_dictionary.keys():
		if item <= n:
			return n
		item -= n
