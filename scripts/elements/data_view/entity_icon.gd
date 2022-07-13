extends TextureRect


func load_collection(collection) -> void:
	if !collection.has("id") || collection["id"] == "":
		return

	var entity_vis = DataController.project_data["entities"][collection["id"]]["visuals"]
	texture = load(entity_vis["icon_path"])
	self_modulate = entity_vis.get("fg", Color.white)
	$"bg".self_modulate = entity_vis.get("bg", Color.black)
	$"bg2".self_modulate = entity_vis.get("bg2", Color.transparent)
	
