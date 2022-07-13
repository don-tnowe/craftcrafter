extends Node

var data_view_node : Node
var edit_format_found := false


func _ready() -> void:
	var cur_parent = self
	data_view_node = null
	
	while is_instance_valid(cur_parent):
		if data_view_node == null && cur_parent.has_node(@"data_view_node"):
			data_view_node = cur_parent.get_node(@"data_view_node")
			load_data()

		if cur_parent.has_signal("returned_to_scene") && !cur_parent.is_connected("returned_to_scene", self, "load_data"):
			cur_parent.connect("returned_to_scene", self, "load_data")

		if !edit_format_found && "edit_format" in cur_parent && "edit_format" in get_parent():
			edit_format_found = true
			get_parent().edit_format = cur_parent.edit_format

		if cur_parent.has_method("switch_screen") && "screen_switcher" in get_parent():
			get_parent().screen_switcher = cur_parent
			break

		cur_parent = cur_parent.get_parent()


func load_data() -> void:
	get_parent().load_collection(data_view_node.data_collection)
