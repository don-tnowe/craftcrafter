tool
extends Node

export(String) var theme_class
export(Array, String) var theme_stylebox_overrides
export(Array, String) var theme_color_overrides
export(bool) var override_stylebox_color
export(bool) var override_font


func _ready() -> void:
	if Engine.editor_hint:
		get_tree().connect("tree_changed", self, "apply")
		return

	apply()


func apply() -> void:
	var theme = get_theme()
	
	for x in theme_color_overrides:
		get_parent().add_color_override(x, theme.get_color(x, theme_class))
	
	if override_font && theme.has_font("font", theme_class) :
		get_parent().add_font_override("font", theme.get_font("font", theme_class))
	
	if override_stylebox_color:
		var color = get_override_color()
		
		for x in theme_stylebox_overrides:
			var box = theme.get_stylebox(x, theme_class).duplicate()
			
			if box is StyleBoxTexture:
				box.modulate_color = box.modulate_color * color
				
			if box is StyleBoxFlat:
				box.bg_color = box.bg_color * color
			
			get_parent().add_stylebox_override(x, box)
			pass
	
	else:
		for x in theme_stylebox_overrides:
			get_parent().add_stylebox_override(x, theme.get_stylebox(x, theme_class))



func get_override_color() -> Color:
	var cur_parent = get_parent()
	
	while true:
		cur_parent = cur_parent.get_parent()
		if !is_instance_valid(cur_parent):
			break
		
		if "theme_color" in cur_parent:
			return cur_parent.theme_color
		
	return Color.gray


func get_theme() -> Resource:
	var cur_parent = get_parent()
	
	while is_instance_valid(cur_parent):
		cur_parent = cur_parent.get_parent()
		if cur_parent is Viewport:
			break  # When in editor, might be no theme on scene - don't pull it from the editor GUI
		
		if cur_parent is Control && cur_parent.theme != null:
			return cur_parent.theme
	
	return load(ProjectSettings.get_setting("gui/theme/custom"))
