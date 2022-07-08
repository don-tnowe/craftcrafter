tool
extends Node

export(PackedScene) var collection_item
export(float) var end_padding = 0


func reposition_in_parent() -> void:
	if get_parent().has_node(@"data_view_node"):
		get_parent().call_deferred("move_child", self, get_parent().get_node(@"data_view_node").get_position_in_parent() + 1)


func _ready() -> void:
	if Engine.editor_hint:
		get_tree().connect("tree_changed", self, "reposition_in_parent")
		return
		
	var node = find_data_view_node()
	var collection = node.data_collection
	
	if collection is Array:
		for i in collection.size():
			var new_item = collection_item.instance()
			new_item.name = str(i)
			get_parent().call_deferred("add_child", new_item)
			
	else:
		for k in collection:
			var new_item = collection_item.instance()
			new_item.name = k
			get_parent().call_deferred("add_child", new_item)
	
	if end_padding > 0:
		var padding_node = Control.new()
		padding_node.rect_min_size.y = end_padding
		padding_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		get_parent().call_deferred("add_child", padding_node)


func find_data_view_node() -> Node:
	var cur_parent = self
	
	while is_instance_valid(cur_parent):
		if cur_parent.has_node(@"data_view_node"):
			return cur_parent.get_node(@"data_view_node")
			
		cur_parent = cur_parent.get_parent()
		
	return null
