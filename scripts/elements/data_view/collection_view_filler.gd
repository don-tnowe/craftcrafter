tool
extends Node

export(PackedScene) var collection_item
export(float) var end_padding = 0

var data_collection
var display_nodes := {}
var padding_node : Control


func reposition_in_parent() -> void:
	if get_parent().has_node(@"data_view_node"):
		get_parent().call_deferred("move_child", self, get_parent().get_node(@"data_view_node").get_position_in_parent() + 1)


func _ready() -> void:
	if Engine.editor_hint:
		get_tree().connect("tree_changed", self, "reposition_in_parent")
		return
		
	var cur_parent = self
	
	while is_instance_valid(cur_parent):
		if data_collection == null && cur_parent.has_node(@"data_view_node"):
			load_collection(cur_parent.get_node(@"data_view_node").data_collection)
			
		if cur_parent.has_signal("returned_to_scene"):
			cur_parent.connect("returned_to_scene", self, "load_collection", [data_collection])
			
		cur_parent = cur_parent.get_parent()
		
	if end_padding > 0:
		padding_node = Control.new()
		padding_node.rect_min_size.y = end_padding
		padding_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		get_parent().call_deferred("add_child", padding_node)


func load_collection(collection) -> void:
	data_collection = collection
		
	if collection is Array:
		while display_nodes.size() > collection.size():
			var k = str(display_nodes.size() - 1)
			display_nodes[k].queue_free()
			display_nodes.erase(k)
			
		while display_nodes.size() < collection.size():
			create_item(str(display_nodes.size()))
	
	else:
		for k in display_nodes:
			if !collection.has(k):
				display_nodes[k].queue_free()
				display_nodes.erase(k)
		
		for k in collection:
			if !display_nodes.has(k):
				create_item(k)
				
	if padding_node != null:
		get_parent().call_deferred("move_child", padding_node, get_parent().get_child_count())


func create_item(key : String) -> void:
	var new_item = collection_item.instance()
	new_item.name = key
	display_nodes[key] = new_item
	get_parent().call_deferred("add_child", new_item)
