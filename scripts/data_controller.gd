extends Node


var project_data := {
	"entities": {
			"crystal1": {
				"id": "crystal1",
				"name": "Crystal of Testing",
				"visuals": {
					"icon_path": "res://builtin_content/icons/minerals.svg",
				},
				"step": 1.0,
			},
			"crystal2": {
				"id": "crystal2",
				"name": "Crystal of Idk",
				"visuals": {
					"icon_path": "res://builtin_content/icons/minerals.svg",
					"bg": Color.violet,
				},
				"step": 0.0,
			},
	},
	"transmutations": {
		"idk_from_testing": {
				"id": "idk_from_testing",
				"name": "Idk from Testing",
				"time": {
					"min": 30,
					"max": 40,
				},
				"consumed": [
					{
						"id": "crystal1",
						"min": 15,
						"max": 15,
					},
				],
				"produced": [
					{
						"id": "crystal2",
						"min": 1,
						"max": 2,
					},
				],
				"catalysts": [
				],
		},
		"idk_from_idk": {
				"id": "idk_from_idk",
				"name": "Idk from Idk",
				"time": {
					"min": 30,
					"max": 40,
				},
				"consumed": [
					{
						"id": "crystal1",
						"min": 2,
						"max": 2,
					},
				],
				"produced": [
					{
						"id": "crystal2",
						"min": 1,
						"max": 1,
					},
				],
				"catalysts": [
				],
		},
		"idk_from_idk2": {
				"id": "idk_from_idk2",
				"name": "Idk from Idk",
				"time": {
					"min": 1,
					"max": 2,
				},
				"consumed": [
					{
						"id": "crystal1",
						"min": 2,
						"max": 2,
					},
				],
				"produced": [
					{
						"id": "crystal2",
						"min": 1,
						"max": 1,
					},
					{
						"id": "crystal2",
						"min": 55,
						"max": 55,
					},
					{
						"id": "crystal2",
						"min": 11111,
						"max": 11111,
					},
				],
				"catalysts": [
				],
		},
	},
}


func get_data_from_path(path : String):
	var path_split = path.split("/")
	var cur_value = project_data
	for x in path_split:
		if cur_value is Array:
			cur_value = cur_value[x.to_int()]

		else:
			cur_value = cur_value[x]

	return cur_value


func add_item(in_collection : String, new_id : String, item : Dictionary) -> void:
	new_id = clean_id(new_id, project_data[in_collection])
	item["id"] = new_id
	project_data[in_collection][new_id] = item


func change_id(old_id : String, new_id : String, in_collection : String) -> void:
	new_id = clean_id(new_id, project_data[in_collection])

	if new_id == "":
		return

	project_data[in_collection][new_id] = project_data[in_collection][old_id]
	project_data[in_collection][new_id]["id"] = new_id
	project_data[in_collection].erase(old_id)

	if in_collection == "entities":
		var tm_dict = project_data["transmutations"]
		for tm in tm_dict:
			for en in tm_dict[tm]["consumed"]:
				if en["id"] == old_id:
					en["id"] = new_id

			for en in tm_dict[tm]["produced"]:
				if en["id"] == old_id:
					en["id"] = new_id

			for en in tm_dict[tm]["catalysts"]:
				if en["id"] == old_id:
					en["id"] = new_id


func clean_id(id : String, search_duplicates_in : Dictionary) -> String:
	var regex = RegEx.new()
	regex.compile("[\\s/\\\\\\[\\](){}]")
	id = regex.sub(id, "", true)

	if search_duplicates_in.has(id):
		var id_stripped = id.rstrip("1234567890")
		var suffix_num = 2
		if id_stripped != "":
			suffix_num = id.substr(id_stripped.length()).to_int()

		while search_duplicates_in.has(id_stripped + str(suffix_num)):
			suffix_num += 1
		
		id = id_stripped + str(suffix_num)

	return id


func delete_id(id : String, from_collection : String) -> void:
	project_data[from_collection].erase(id)
	if from_collection == "entities":
		var tm_dict = project_data["transmutations"]
		for tm in tm_dict:
			var value = tm_dict[tm]
			var copy  # Duplicate array to prevent errors while iterating and erasing

			copy = value["consumed"].duplicate()
			for en in copy:
				if en["id"] == id:
					value["consumed"].erase(en)

			copy = value["produced"].duplicate()
			for en in copy:
				if en["id"] == id:
					value["produced"].erase(en)

			copy = value["catalysts"].duplicate()
			for en in copy:
				if en["id"] == id:
					value["catalysts"].erase(en)
