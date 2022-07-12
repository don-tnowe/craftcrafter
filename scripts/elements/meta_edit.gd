extends MarginContainer

export(String) var root_collection_name

onready var node_id_line_edit := $"v_box_container/id/v_box_container/line_edit"

var old_id : String


func _ready() -> void:
	var cur_parent = self
	
	while is_instance_valid(cur_parent):
		if cur_parent.has_signal("scene_closed"):
			cur_parent.connect("scene_closed", self, "save_changes")
			break
		
		cur_parent = cur_parent.get_parent()
		
	yield(get_tree(), "idle_frame")
	old_id = node_id_line_edit.text


func save_changes() -> void:
	var new_id = node_id_line_edit.text
	var new_item = $"data_view_node".data_collection
	if !new_item.has("id"):
		if new_id == "":
			new_id = new_item.name

		DataController.add_item(root_collection_name, new_id, new_item)
		return

	if old_id != new_id:
		DataController.change_id(old_id, new_id, root_collection_name)
