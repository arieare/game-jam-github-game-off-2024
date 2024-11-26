extends WorldEnvironment

@export var light_node: DirectionalLight3D

var theme_color = {
	"blue" : {
		"fog_color" : "#395a7f",
		"light_color" : "#fda9a9",
	},
	"lavender" : { 
		"fog_color" : "#2e0a30", 
		"light_color" : "#6cb9c9",
	},
	"moss" : { 
		"fog_color" : "#6d7769", 
		"light_color" : "#F2DDA4",
		#"light_color" : "#e5c5a8",
	},	
	"boss" : {
		"fog_color" : "#5e363e", 
		"light_color" : "#ffcbb5",
	},		
	"white" : {
		"fog_color" : "#222222", 
		"light_color" : "#cccccc",
	},	
	"snow" : {
		"fog_color" : "#eeeeee", 
		"light_color" : "#aaaaaa",
	},		
	"deep_sea" : {
		"fog_color" : "#262d2f", 
		"light_color" : "#83b3b0",
	},					
}

var env = self.environment
var theme
func _ready() -> void:
	util.root.data_instance.connect("redeem_theme_red", _on_redeem_theme_red)
	util.root.data_instance.connect("redeem_theme_bw", _on_redeem_theme_bw)
	util.root.data_instance.connect("redeem_theme_blue", _on_redeem_theme_blue)
	util.root.data_instance.connect("redeem_theme_moss", _on_redeem_theme_moss)
	
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		var theme_string = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].theme_color
		if theme_string != "":
			theme = theme_color[theme_string]
		else:
			theme = theme_color["blue"]
		env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
		env.background_color = theme.fog_color
		light_node.light_color = theme.light_color

func _on_redeem_theme_red():
	theme = theme_color["boss"]
	env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
	env.background_color = theme.fog_color
	light_node.light_color = theme.light_color	
	
func _on_redeem_theme_bw():
	theme = theme_color["white"]
	env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
	env.background_color = theme.fog_color
	light_node.light_color = theme.light_color	

func _on_redeem_theme_blue():
	theme = theme_color["blue"]
	env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
	env.background_color = theme.fog_color
	light_node.light_color = theme.light_color		

func _on_redeem_theme_moss():
	theme = theme_color["moss"]
	env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
	env.background_color = theme.fog_color
	light_node.light_color = theme.light_color		
	
