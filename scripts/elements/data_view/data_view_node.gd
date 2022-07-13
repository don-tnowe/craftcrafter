extends Node

export(String) var data_node_name
export(bool) var data_node_name_from_parent_name
export(bool) var start_from_root

var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	find_parent_data_node()


func find_parent_data_node():
	var cur_parent = self
	data_collection = null
	
	if data_node_name_from_parent_name:
		data_node_name = get_parent().name
	
	while is_instance_valid(cur_parent):
		if cur_parent.has_signal("returned_to_scene") && !cur_parent.is_connected("returned_to_scene", self, "find_parent_data_node"):
			cur_parent.connect("returned_to_scene", self, "find_parent_data_node")

		if data_collection == null:
			if cur_parent.has_node(@"data_view_node"):
				var node = cur_parent.get_node(@"data_view_node")
				if node != self:
					data_collection = node.data_collection
					break
			
			if "screen_extra_data" in cur_parent && cur_parent.screen_extra_data != null:
				data_collection = cur_parent.screen_extra_data[0]
				break
				
		cur_parent = cur_parent.get_parent()

	if start_from_root || data_collection == null:
		data_collection = DataController.project_data

			
	if data_node_name != "":
		if data_collection is Array:
			data_collection = data_collection[data_node_name.to_int()]
			
		else:
			data_collection = data_collection[data_node_name]
