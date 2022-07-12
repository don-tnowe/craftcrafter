extends TextureRect


var data_collection


func _ready() -> void:
	var cur_parent = self
	data_collection = null
	
	while is_instance_valid(cur_parent):
		if data_collection == null && cur_parent.has_node(@"data_view_node"):
			load_collection(cur_parent.get_node(@"data_view_node").data_collection)
			
		if cur_parent.has_signal("returned_to_scene"):
			cur_parent.connect("returned_to_scene", self, "load_collection", [data_collection])
			
		cur_parent = cur_parent.get_parent()


func load_collection(collection) -> void:
	data_collection = collection
	var entity_vis = DataController.project_data["entities"][collection["id"]]["visuals"]
	texture = load(entity_vis["icon_path"])
	self_modulate = entity_vis.get("fg", Color.white)
	$"bg".self_modulate = entity_vis.get("bg", Color.black)
	$"bg2".self_modulate = entity_vis.get("bg2", Color.transparent)
	
