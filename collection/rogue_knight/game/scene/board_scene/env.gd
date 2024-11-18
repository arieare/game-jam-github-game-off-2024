extends WorldEnvironment

@export var light_node: DirectionalLight3D

var theme_color = {
	"blue" : {
		"fog_color" : "#82939b",
		"light_color" : "#fda9a9",
	},
	"lavender" : { 
		"fog_color" : "#2e0a30", 
		"light_color" : "#6cb9c9",
	},
	"moss" : {
		"fog_color" : "#6d7769", 
		"light_color" : "#e5c5a8",
	},	
	"boss" : {
		"fog_color" : "#5e363e", 
		"light_color" : "#ffcbb5",
	},		
	"white" : {
		"fog_color" : "#333333", 
		"light_color" : "#dddddd",
	},	
	"deep_sea" : {
		"fog_color" : "#262d2f", 
		"light_color" : "#83b3b0",
	},				
}

func _ready() -> void:
	
	var env = self.environment
	var theme
	
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		var theme_string = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].theme_color
		if theme_string != "":
			theme = theme_color[theme_string]
		else:
			theme = theme_color["deep_sea"]
		env.sky.sky_material.set_shader_parameter("sky_color",Color.from_string(theme.fog_color,Color.BLACK))
		env.background_color = theme.fog_color
		light_node.light_color = theme.light_color
