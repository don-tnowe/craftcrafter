extends LineEdit

export(String) var data_node_name
export(int, "Never", "Always", "If Empty") var focus_on_start = 0

var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	connect("text_changed", self, "_on_text_changed")
	if focus_on_start == 1 || focus_on_start == 2 && text == "":
		call_deferred("grab_focus")
			


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
