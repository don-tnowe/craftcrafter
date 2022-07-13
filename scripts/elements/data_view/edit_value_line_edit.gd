extends LineEdit

export(String) var data_node_name

var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	connect("text_changed", self, "_on_text_changed")


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name == "":
		return
		
	if data_node_name[0] != "/":
		text = collection.get(data_node_name, "")
		
	else:
		var path_split = data_node_name.split("/", false)
		for i in path_split.size():
			if path_split[i][0] == "{":
				path_split[i] = str(data_collection[path_split[i].substr(1, path_split[i].length() - 2)])
		
		text = DataController.get_data_from_path(path_split.join("/"))


func _on_text_changed(new_text : String) -> void:
	data_collection[data_node_name] = new_text
