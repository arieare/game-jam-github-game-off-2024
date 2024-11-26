extends PanelContainer

@export var text : RichTextLabel
var text_size_x

const max_width := 400
var chat := ""
var letter_index := 0
var letter_time := 0.03
var space_time := 0.06
var punctuation_time := 0.2
var text_speed_mult := 4

signal finish_displaying_chat
@export var label : PanelContainer

func _ready() -> void:
	self.top_level = true
	label.hide()
	self.connect("finish_displaying_chat", _on_finish_displaying_chat)

func display_text(text_to_display:String):
	chat = text_to_display
	text.text = text_to_display
	text_size_x = text.get_theme_font("normal_font").get_string_size(text.text,HORIZONTAL_ALIGNMENT_CENTER,-1,36).x
	text.custom_minimum_size.x = min(text_size_x, max_width)

	#await self.resized
	self.custom_minimum_size.x = min(text_size_x, max_width)
	print(text.size.y)
	
	if text.size.x > max_width:
		text.autowrap_mode = TextServer.AUTOWRAP_WORD
		await self.resized
		await self.resized
		#custom_minimum_size.y = text.size.y
	#
	global_position.x -= text.size.x / 2
	global_position.y -= text.size.y
	
	text.text = ""
	_display_letter()

func _display_letter():
	if letter_index < chat.length():
		text.text += str(chat[letter_index])
	util.root.data_instance.audio.sfx_dictionary.chat_bubble.sfx.play()
	letter_index += 1
	
	if letter_index >= chat.length():
		finish_displaying_chat.emit()
		text.text = "[wave amp=10.0 freq=3.0 connected=1]" + text.text + "[/wave]"
		return
	
	match chat[letter_index]:
		"!", ".", ",", "?":
			await get_tree().create_timer(punctuation_time / text_speed_mult).timeout
			_display_letter()
		" ":
			await get_tree().create_timer(space_time / text_speed_mult).timeout	
			_display_letter()		
		_:
			await get_tree().create_timer(letter_time / text_speed_mult).timeout
			_display_letter()						

func _on_finish_displaying_chat():
	label.show()
	label.global_position.x = self.global_position.x + self.size.x - 28
	label.global_position.y = self.global_position.y + self.size.y - 28
