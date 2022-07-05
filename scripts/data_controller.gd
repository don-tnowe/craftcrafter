extends Node


var project_data := {
	"entities": {
			"crystal1": {
				"name": "Crystal of Testing",
			},
			"crystal2": {
				"name": "Crystal of Idk",
			},
	},
	"transmutations": {
		"idk_from_testing": {
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
