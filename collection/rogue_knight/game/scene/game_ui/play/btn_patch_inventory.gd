extends TextureButton

## Button Patch Inventory
# This is the primary patches at hand interactable to plan the game.

var patch_id := ""
@export var description_panel : PanelContainer
@export var patch_name: RichTextLabel
var patch_name_text := ""
@export var patch_description: RichTextLabel
var patch_description_text := ""
var patch_image := ""
var patch_color: Color

func _ready() -> void:
	patch_name.text = patch_name_text
	patch_description.text = patch_description_text
	self.texture_normal = load(patch_image)
	self.self_modulate = patch_color

func _input(event: InputEvent) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING:
		if !event.is_echo() and self.button_pressed:
			util.root.data_instance.patch_picked.emit(patch_id)
			util.root.data_instance.remove_patch_from_inventory.emit(patch_id)
			for patch in util.root.data_instance.game_data.patch_inventory:
				if patch["id"] == patch_id:
					util.root.data_instance.game_data.patch_inventory.erase(patch)
			self.get_parent().queue_free()
		if !event.is_echo() and self.is_hovered():
			description_panel.show()
			self.position.y = -20
			self.scale = Vector2(1.1,1.1)
		else:
			description_panel.hide()
			self.position.y = 0
			self.scale = Vector2(1,1)
			
