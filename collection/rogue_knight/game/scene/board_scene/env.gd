extends WorldEnvironment

@export var light_node: DirectionalLight3D

var theme_color = {
	"high_noon" : {
		#395a7f
		#fda9a9
		"fog_color" : "#4379F2",
		"light_color" : "#F29F58",
	},
	"lavender" : { 
		"fog_color" : "#2e0a30", 
		"light_color" : "#9ABF80",
		#"light_color" : "#6cb9c9",
	},
	"moss" : { 
		#6d7769
		"fog_color" : "#557C56", 
		"light_color" : "#E68369",
		#"light_color" : "#E68369",
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
		"fog_color" : "#666666", 
		"light_color" : "#d5bbd5",
	},		
	"deep_sea" : {
		"fog_color" : "#262d2f", 
		"light_color" : "#605EA1",
	},	
	"sunset" : {
		"fog_color" : "#8D493A", 
		"light_color" : "#FFB22C",
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
	theme = theme_color["high_noon"]
	env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
	env.background_color = theme.fog_color
	light_node.light_color = theme.light_color		

func _on_redeem_theme_moss():
	theme = theme_color["moss"]
	env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
	env.background_color = theme.fog_color
	light_node.light_color = theme.light_color		
	
