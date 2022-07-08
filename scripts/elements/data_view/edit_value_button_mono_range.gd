extends EditValueButton


func load_collection(collection) -> void:
	data_collection = collection
	if collection["min"] == collection["max"]:
		text = get_num_string(collection["min"])
		
	else:
		text = get_num_string(collection["min"]) + "-" + get_num_string(collection["max"])


func get_num_string(num : float) -> String:
	if num == INF:
		return "∞"

	elif num == -INF:
		return "-∞"

	else:
		return str(num)
