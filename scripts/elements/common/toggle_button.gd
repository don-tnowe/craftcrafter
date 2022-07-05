tool
extends TextureButton

export(String) var method_name
export(Color) var enabled_color
export(bool) var toggled_on := false setget set_toggled

onready var node_peg := $"peg"

var screen : Control


func _ready() -> void:
	var cur_parent = self
	if connect("pressed", self, "_on_pressed") != OK:
		pass
	
	while true:
		cur_parent = cur_parent.get_parent()
		if !is_instance_valid(cur_parent):
			return

		if cur_parent.has_method(method_name):
			screen = cur_parent
			break


func _on_pressed() -> void:
	set_toggled(!toggled_on)
	if is_instance_valid(screen):
		screen.call(method_name, toggled_on)


func set_toggled(value : bool) -> void:
	if !is_inside_tree():
		call_deferred("set_toggled", value)
		return
	
	toggled_on = value
	node_peg.rect_position.x = 53 if toggled_on else -11
	node_peg.modulate = enabled_color if toggled_on else Color(0.9, 0.9, 0.9)
