extends ui_btn_change_scene
@export var btn_label: RichTextLabel

func _ready():
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "white", "small", false, true)
	game_node = null
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.main_menu
	#self.connect("pressed", _on_press)
	#data_node = null
	self.pressed.connect(self._on_press.bind())

func scene_update():
	super()
	util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.STARTING


var is_it_hovered:=false
func _process(delta: float) -> void:
	if self.is_hovered() and !is_it_hovered:
		is_it_hovered = true
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()
		self.pivot_offset = self.size/2
		self.rotation_degrees = randf_range(-3,3)
	elif !self.is_hovered():
		is_it_hovered = false
		self.rotation_degrees = 0
	
func _on_press():
	print("press")
	util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx.play()
