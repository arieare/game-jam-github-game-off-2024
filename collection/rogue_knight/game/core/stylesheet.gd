extends Node

func _ready():
	self.get_parent().stylesheet = self #dependency injection

func button_styler(btn:Button, btn_label:RichTextLabel, theme:String, size:String, disabled:bool, fit_width:bool):
	var border_size:= 1
	var border_size_focused:= 3
	var text_shadow_offset:= 4
	var shadow_size:= 1
	var button_shadow_offset:= 3
	var button_shadow_offset_pressed:= 3
	var button_margin:= 24
	
	var button_style = {
		"purple": {
			"bg_color" : Color.SLATE_BLUE,
			"bg_color_hover" : Color.MEDIUM_PURPLE,
			"bg_color_pressed" : Color.REBECCA_PURPLE,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0),
			"text_color" : Color.GHOST_WHITE,
			"text_color_hover" : Color.GHOST_WHITE,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.LAVENDER
		},
		"black": {
			"bg_color" : Color("#222222"),
			"bg_color_hover" : Color("#333333"),
			"bg_color_pressed" : Color.BLACK,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0),
			"text_color" : Color.GHOST_WHITE,
			"text_color_hover" : Color.WHITE,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.BLACK,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.DIM_GRAY,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.GHOST_WHITE
		},		
		"white": {
			"bg_color" : Color("#eeeeee"),
			"bg_color_hover" : Color("#ffffff"),
			"bg_color_pressed" : Color("#ffffff"),
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color.TRANSPARENT,
			"text_color" : Color.BLACK,
			"text_color_hover" : Color("#222222"),
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.BLACK,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color("#bbbbbb"),
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.DIM_GRAY
		},				
		"purple_secondary": {
			"bg_color" : Color.LAVENDER,
			"bg_color_hover" : Color.WHITE,
			"bg_color_pressed" : Color.WHITE,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0),
			"text_color" : Color.DARK_SLATE_BLUE,
			"text_color_hover" : Color.DARK_SLATE_BLUE,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.GRAY,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.PLUM
		},		
		"green": {
			"bg_color" : Color.LAWN_GREEN,
			"bg_color_hover" : Color.GREEN_YELLOW,
			"bg_color_pressed" : Color.LIME_GREEN,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0),
			"text_color" : Color.DARK_GREEN,
			"text_color_hover" : Color.FOREST_GREEN,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.DARK_GREEN,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.LIME_GREEN,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.YELLOW
		},
		"green_secondary": {
			"bg_color" : Color("#eeeeee"),
			"bg_color_hover" : Color("#ffffff"),
			"bg_color_pressed" : Color("#ffffff"),
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color.TRANSPARENT,
			"text_color" : Color.DARK_GREEN,
			"text_color_hover" : Color.FOREST_GREEN,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.BLACK,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.LIME_GREEN,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.YELLOW
		},			
		"red": {
			"bg_color" : Color.CRIMSON,
			"bg_color_hover" : Color.ORANGE_RED,
			"bg_color_pressed" : Color.FIREBRICK,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0),
			"text_color" : Color.GHOST_WHITE,
			"text_color_hover" : Color.GHOST_WHITE,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.LIGHT_CORAL
		},		
		"red_secondary": {
			"bg_color" : Color.LAVENDER,
			"bg_color_hover" : Color.WHITE,
			"bg_color_pressed" : Color.WHITE,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0),
			"text_color" : Color.ORANGE_RED,
			"text_color_hover" : Color.CRIMSON,
			"text_color_disabled" : Color.WEB_GRAY,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			"text_shadow_color": Color.GRAY,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			"border_color_focus": Color.LAVENDER
		},
	}
	var button_size ={
		"small": {
			"font_size": 28,
			"button_height": 48,
			"corner_radius": 3
		},
		"medium": {
			"font_size": 36,
			"button_height": 56,
			"corner_radius": 3
		},
		"big": {
			"font_size": 40,
			"button_height": 64,
			"corner_radius": 3
		}		
	}

	## DISABLED
	var disabled_style := StyleBoxFlat.new()
	# Style corner radius
	disabled_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	disabled_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	disabled_style.corner_radius_top_left = button_size[size]["corner_radius"]
	disabled_style.corner_radius_top_right = button_size[size]["corner_radius"]
	disabled_style.bg_color = button_style[theme]["bg_color_disabled"]
	# Style shadow
	disabled_style.shadow_size = shadow_size
	disabled_style.shadow_offset.y = button_shadow_offset
	disabled_style.shadow_color = button_style[theme]["shadow_color_disabled"]
	# Style border
	disabled_style.border_width_bottom = border_size
	disabled_style.border_width_top = border_size
	disabled_style.border_width_left = border_size
	disabled_style.border_width_right = border_size
	disabled_style.border_color = button_style[theme]["shadow_color_disabled"]
	btn.add_theme_stylebox_override("disabled", disabled_style)		
	
	## NORMAL
	var normal_style := StyleBoxFlat.new()
	## Style corner radius
	normal_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	normal_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	normal_style.corner_radius_top_left = button_size[size]["corner_radius"]
	normal_style.corner_radius_top_right = button_size[size]["corner_radius"]
	normal_style.bg_color = button_style[theme]["bg_color"]
	## Style shadow
	normal_style.shadow_size = shadow_size
	normal_style.shadow_offset.y = button_shadow_offset
	normal_style.shadow_color = button_style[theme]["shadow_color"]
	## Style border
	normal_style.border_width_bottom = border_size
	normal_style.border_width_top = border_size
	normal_style.border_width_left = border_size
	normal_style.border_width_right = border_size
	normal_style.border_color = button_style[theme]["shadow_color"]
	btn.add_theme_stylebox_override("normal", normal_style)
	
	## HOVER
	var hover_style := StyleBoxFlat.new()
	## Style corner radius
	hover_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	hover_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	hover_style.corner_radius_top_left = button_size[size]["corner_radius"]
	hover_style.corner_radius_top_right = button_size[size]["corner_radius"]
	hover_style.bg_color = button_style[theme]["bg_color_hover"]
	## Style shadow
	hover_style.shadow_size = shadow_size
	hover_style.shadow_offset.y = button_shadow_offset
	hover_style.shadow_color = button_style[theme]["shadow_color"]
	## Style border
	hover_style.border_width_bottom = border_size
	hover_style.border_width_top = border_size
	hover_style.border_width_left = border_size
	hover_style.border_width_right = border_size
	hover_style.border_color = button_style[theme]["shadow_color"]
	btn.add_theme_stylebox_override("hover", hover_style)
	
	## PRESSED
	var pressed_style := StyleBoxFlat.new()
	## Style corner radius
	pressed_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	pressed_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	pressed_style.corner_radius_top_left = button_size[size]["corner_radius"]
	pressed_style.corner_radius_top_right = button_size[size]["corner_radius"]
	pressed_style.bg_color = button_style[theme]["bg_color_pressed"]
	## Style shadow
	pressed_style.shadow_size = shadow_size
	pressed_style.shadow_offset.y = button_shadow_offset_pressed
	pressed_style.shadow_color = button_style[theme]["shadow_color"]
	## Style border
	pressed_style.border_width_bottom = border_size
	pressed_style.border_width_top = border_size
	pressed_style.border_width_left = border_size
	pressed_style.border_width_right = border_size
	pressed_style.border_color = button_style[theme]["shadow_color"]
	btn.add_theme_stylebox_override("pressed", pressed_style)	
	
	var hover_pressed_style := StyleBoxFlat.new()
	# Style corner radius
	hover_pressed_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	hover_pressed_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	hover_pressed_style.corner_radius_top_left = button_size[size]["corner_radius"]
	hover_pressed_style.corner_radius_top_right = button_size[size]["corner_radius"]
	hover_pressed_style.bg_color = button_style[theme]["bg_color_pressed"]
	# Style shadow
	hover_pressed_style.shadow_size = shadow_size
	hover_pressed_style.shadow_offset.y = button_shadow_offset_pressed
	hover_pressed_style.shadow_color = button_style[theme]["shadow_color"]
	# Style border
	hover_pressed_style.border_width_bottom = border_size
	hover_pressed_style.border_width_top = border_size
	hover_pressed_style.border_width_left = border_size
	hover_pressed_style.border_width_right = border_size
	hover_pressed_style.border_color = button_style[theme]["shadow_color"]	
	btn.add_theme_stylebox_override("hover_pressed", hover_pressed_style)	
	
	## FOCUS
	var focus_style := StyleBoxFlat.new()
	# Style corner radius
	focus_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	focus_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	focus_style.corner_radius_top_left = button_size[size]["corner_radius"]
	focus_style.corner_radius_top_right = button_size[size]["corner_radius"]
	focus_style.bg_color = button_style[theme]["bg_color_focus"]
	# Style shadow
	focus_style.shadow_size = shadow_size
	focus_style.shadow_offset.y = button_shadow_offset
	focus_style.shadow_color = button_style[theme]["shadow_color"]
	# Style border
	focus_style.border_width_bottom = border_size_focused
	focus_style.border_width_top = border_size_focused
	focus_style.border_width_left = border_size_focused
	focus_style.border_width_right = border_size_focused
	focus_style.border_color = button_style[theme]["border_color_focus"]
	focus_style.draw_center = false
	btn.add_theme_stylebox_override("focus", focus_style)		
	
	## BTN LABEL
	btn_label.add_theme_color_override("default_color", button_style[theme]["text_color"])
	btn_label.add_theme_color_override("font_shadow_color", button_style[theme]["text_shadow_color"])
	btn_label.add_theme_font_size_override("normal_font_size", button_size[size]["font_size"])
	btn_label.add_theme_constant_override("shadow_offset", text_shadow_offset)
	btn_label.custom_minimum_size.x = btn_label.get_theme_font("normal_font").get_string_size(strip_bbcode(btn_label.text),HORIZONTAL_ALIGNMENT_CENTER,-1,button_size[size]["font_size"]).x
	
	if disabled:
		btn.disabled = true
		btn_label.add_theme_color_override("default_color", button_style[theme]["text_color_disabled"])
		btn_label.add_theme_color_override("font_shadow_color", button_style[theme]["text_shadow_color_disabled"])
		
	btn.custom_minimum_size.y = button_size[size]["button_height"]
	if fit_width:
		btn.custom_minimum_size.x = btn_label.custom_minimum_size.x + button_margin

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)



func badge_styler(badge:PanelContainer, theme:String, size:String):
	var badge_label = badge.get_child(0)
	var border_size:= 0
	var text_shadow_offset:= 2
	var shadow_size:= 0
	var badge_shadow_offset:= 0
	var badge_margin:= 12
	
	var badge_style = {
		"black": {
			"bg_color" : Color.BLACK,
			"text_color" : Color.GHOST_WHITE,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color": Color.DARK_SLATE_BLUE,
		},
		"white": {
			"bg_color" : Color.WHITE,
			"text_color" : Color.BLACK,
			"shadow_color": Color.GRAY,
			"text_shadow_color": Color.GRAY,
		},	
		"move": {
			"bg_color" : "#6679BD",
			"text_color" : Color.WHITE,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color": Color.DARK_SLATE_BLUE,
		},	
		"point": {
			"bg_color" : "#F58700",
			"text_color" : Color.WHITE,
			"shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color": Color.DARK_SLATE_BLUE,
		},			
	}
	var badge_size ={
		"small": {
			"font_size": 24,
			"badge_height": 32,
			"corner_radius": 3,
			"badge_margin" : 12
		},
		"medium": {
			"font_size": 32,
			"badge_height": 40,
			"corner_radius": 6,
			"badge_margin" : 16
		},
		"big": {
			"font_size": 40,
			"badge_height": 56,
			"corner_radius": 8,
			"badge_margin" : 24
		}		
	}
	
	
	## NORMAL
	var normal_style := StyleBoxFlat.new()
	## Style corner radius
	normal_style.corner_radius_bottom_left = badge_size[size]["corner_radius"]
	normal_style.corner_radius_bottom_right = badge_size[size]["corner_radius"]
	normal_style.corner_radius_top_left = badge_size[size]["corner_radius"]
	normal_style.corner_radius_top_right = badge_size[size]["corner_radius"]
	normal_style.bg_color = badge_style[theme]["bg_color"]
	## Style shadow
	normal_style.shadow_size = shadow_size
	normal_style.shadow_offset.y = badge_shadow_offset
	normal_style.shadow_color = badge_style[theme]["shadow_color"]
	## Style border
	normal_style.border_width_bottom = border_size
	normal_style.border_width_top = border_size
	normal_style.border_width_left = border_size
	normal_style.border_width_right = border_size
	normal_style.border_color = badge_style[theme]["shadow_color"]
	badge.add_theme_stylebox_override("panel", normal_style)
	
	
	
	## BTN LABEL
	badge_label.add_theme_color_override("default_color", badge_style[theme]["text_color"])
	badge_label.add_theme_color_override("font_shadow_color", badge_style[theme]["text_shadow_color"])
	badge_label.add_theme_font_size_override("normal_font_size", badge_size[size]["font_size"])
	badge_label.add_theme_constant_override("shadow_offset", text_shadow_offset)
	badge_label.custom_minimum_size.x = badge_label.get_theme_font("normal_font").get_string_size(strip_bbcode(badge_label.text),HORIZONTAL_ALIGNMENT_CENTER,-1,badge_size[size]["font_size"]).x

		
	badge.custom_minimum_size.y = badge_size[size]["badge_height"]
	badge.custom_minimum_size.x = badge_label.custom_minimum_size.x + badge_size[size]["badge_margin"]
