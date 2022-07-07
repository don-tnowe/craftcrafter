extends LineEdit

export(String) var data_node_name

var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	var cur_parent = self
	data_collection = null
	
	while true:
		cur_parent = cur_parent.get_parent()
		if !is_instance_valid(cur_parent):
			break
		
		if data_collection == null && cur_parent.has_node(@"data_view_node"):
			load_collection(cur_parent.get_node(@"data_view_node").data_collection)
		
		if cur_parent.has_signal("returned_to_scene"):
			if data_collection == null:
				load_collection(cur_parent.screen_extra_data[0])

			cur_parent.connect("returned_to_scene", self, "load_collection", [data_collection])
	
	if connect("text_changed", self, "_on_text_changed") != OK:
		return


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name != "":
		text = collection.get(data_node_name, "")


func _on_text_changed(new_text : String) -> void:
	data_collection[data_node_name] = new_text
