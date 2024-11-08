extends Control

@onready var shop_item: PackedScene = preload("res://collection/rogue_knight/game/prefab/shop/shop_item.tscn")


func _ready() -> void:
	init_audio()
	util.root.data_instance.connect("board_ready", _on_board_ready)


func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING and util.root.data_instance.game_data.current_level > 2:
		self.show()
	else:
		self.hide()		

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
	if util.root.data_instance.game_data.current_level > 2:
		for i in util.root.data_instance.game_data.max_shop_size:
			var rarity:int=get_item_rarity()
			var item = util.root.data_instance.patch_dictionary[rarity].values().pick_random()
			init_shop_item(rarity,item["id"])
			audio_player_item_added.play()
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

var audio_player_item_added:=AudioStreamPlayer.new()
@export var sfx_shop_item_added: AudioStream
func init_audio():
	audio_player_item_added.max_polyphony = 128
	audio_player_item_added.pitch_scale = 0.8
	var random_audio := AudioStreamRandomizer.new()
	audio_player_item_added.stream = random_audio

	random_audio.add_stream(0, sfx_shop_item_added, 1.0)
	random_audio.playback_mode = AudioStreamRandomizer.PLAYBACK_SEQUENTIAL
	random_audio.random_pitch = 1.25
	self.add_child(audio_player_item_added)	
