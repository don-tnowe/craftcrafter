extends Node

export(String) var data_node_name
export(bool) var data_node_name_from_parent_name
export(bool) var start_from_root

var data_collection  # Variant: Array or Dictionary
var data_parent : Node


func _ready() -> void:
	find_parent_data_node()


func find_parent_data_node() -> void:
	var cur_parent = self
	data_collection = null
	
	if data_node_name_from_parent_name:
		data_node_name = get_parent().name
	
	if start_from_root:
		data_collection = DataController.project_data
		load_data_node()
		return
	
	while is_instance_valid(cur_parent):
		if cur_parent.has_signal("returned_to_scene") && !cur_parent.is_connected("returned_to_scene", self, "load_data_node"):
			cur_parent.connect("returned_to_scene", self, "load_data_node")

		if data_parent == null:
			if cur_parent.has_node(@"data_view_node"):
				var node = cur_parent.get_node(@"data_view_node")
				if node != self:
					data_parent = node
			
			if "screen_extra_data" in cur_parent && cur_parent.screen_extra_data != null:
				data_collection = cur_parent.screen_extra_data[0]
				
		cur_parent = cur_parent.get_parent()

	load_data_node()


func load_data_node():
	if data_parent != null:
		data_collection = data_parent.data_collection

	if data_node_name != "":
		if data_collection is Array:
			if data_collection.size() <= data_node_name.to_int():
				return

			data_collection = data_collection[data_node_name.to_int()]
			
		else:
			if !data_collection.has(data_node_name):
				return

			data_collection = data_collection[data_node_name]
