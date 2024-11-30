extends ui_btn_change_scene

@export var btn_label: RichTextLabel

func _ready():
	self.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.setting_menu

func scene_update():
	super()

var is_it_hovered:=false	
func _process(delta: float) -> void:
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "black", "big", false, false)
	if self.is_hovered() and !is_it_hovered:
		is_it_hovered = true
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()
		self.pivot_offset = self.size/2
		self.rotation_degrees = randf_range(-3,3)
	elif !self.is_hovered():
		is_it_hovered = false
		self.rotation_degrees = 0

func _on_pressed() -> void:
	util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx.play()
