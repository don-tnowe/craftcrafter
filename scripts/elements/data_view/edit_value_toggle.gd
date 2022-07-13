tool
extends TextureButton

export(String) var data_node_name
export(Color) var enabled_color
export(bool) var toggled_on := false setget set_toggled

onready var node_peg := $"peg"

var data_collection  # Variant: Array or Dictionary
var screen : Control


func _ready() -> void:
	var cur_parent = self
	connect("pressed", self, "_on_pressed")

	while is_instance_valid(cur_parent):
		if "theme_color" in cur_parent:
			enabled_color = cur_parent.theme_color
			if toggled_on:
				node_peg.modulate = enabled_color

			break

		cur_parent = cur_parent.get_parent()


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name != "":
		set_toggled(collection.get(data_node_name, toggled_on))


func _on_pressed() -> void:
	set_toggled(!toggled_on)
	data_collection[data_node_name] = toggled_on


func set_toggled(value : bool) -> void:
	toggled_on = value
	if !is_inside_tree():
		return
	
	node_peg.rect_position.x = 53 if toggled_on else -11
	node_peg.modulate = enabled_color if toggled_on else Color(0.9, 0.9, 0.9)
