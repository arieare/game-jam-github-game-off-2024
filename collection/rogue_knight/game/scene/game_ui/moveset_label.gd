extends Label

func _process(delta: float) -> void:
	self.text = ""
	for step in util.root.data_instance.game_data.move_step:
		self.text += alphabet[str(step.y + 1)]
		self.text += str(step.x + 1)
		self.text += " "
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING or util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.LOSING:
		self.get_parent().hide()

var alphabet:Dictionary = {
	"1":"A",
	"2":"B",
	"3":"C",
	"4":"D",
	"5":"E",
	"6":"F",
	"7":"G",
	"8":"H",
	"9":"I",
	"10":"J",
	"11":"K",
	"12":"L",
	"13":"M",
	"14":"N",
	"15":"O",
	"16":"P",
	"17":"Q",
	"18":"R",
	"19":"S",
	"20":"T",
	"21":"U",
	"22":"V",
	"23":"W",
	"24":"X",
	"25":"Y",
	"26":"Z"
}
