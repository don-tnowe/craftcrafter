extends Button

export(String) var button_tag
export(String, FILE, "*.tscn") var switch_to_screen

var screen : Control
var screen_switcher : Control


func _ready() -> void:
	if switch_to_screen == "":
		return
		
	var cur_parent = self
	
	while true:
		cur_parent = cur_parent.get_parent()
		if !is_instance_valid(cur_parent):
			return

		if cur_parent.has_method("get_switch_extra_from_tag"):
			screen = cur_parent

		if cur_parent.has_method("switch_screen"):
			screen_switcher = cur_parent
			break

	if connect("pressed", self, "_on_pressed") != OK:
		return


func _on_pressed() -> void:
	if !is_instance_valid(screen_switcher):
		return

	if !is_instance_valid(screen):
		screen_switcher.switch_screen(switch_to_screen)

	else:
		screen_switcher.switch_screen(switch_to_screen, screen.get_switch_extra_from_tag(button_tag))
