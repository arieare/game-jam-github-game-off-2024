extends PanelContainer

@export var text : RichTextLabel

const max_width := 256
var chat := ""
var letter_index := 0
var letter_time := 0.03
var space_time := 0.06
var punctuation_time := 0.2
var text_speed_mult := 4.0

signal finish_displaying_chat

func display_text(text_to_display:String):
	chat = text_to_display
	text.text = text_to_display

	#await resized
	#custom_minimum_size.x = min(size.x, max_width)
	
	#if size.x > max_width:
		#text.autowrap_mode = TextServer.AUTOWRAP_WORD
		#await resized
		#await resized
		#custom_minimum_size.y = size.y
	#
	#global_position.x -= size.x / 2
	#global_position.x -= size.y + 24
	
	text.text = ""
	_display_letter()

func _display_letter():
	if letter_index < chat.length():
		print(chat[letter_index])
		text.text += str(chat[letter_index])
	
	letter_index += 1
	
	if letter_index >= chat.length():
		finish_displaying_chat.emit()
		text.text = poem	
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

var poem = "Here’s to the Crazy Ones!
The misfits.
The [color=RED][shake rate=20.0 level=5 connected=1]rebels[/shake][/color].
The [tornado radius=10.0 freq=1.0 connected=1]troublemakers[/tornado].
The round pegs in the square holes.
The ones who see things differently.
They’re [pulse freq=1.0 color=#ffffff40 ease=-2.0]not[/pulse] fond of rules."

var poem2 = "Here’s to the Crazy Ones!
The misfits.
The rebels.
The troublemakers.
The round pegs in the square holes.
The ones who see things differently.
They’re not fond of rules."

func _ready() -> void:
	await get_tree().create_timer(punctuation_time)
	display_text(poem2)
