tool
extends Node

export(PackedScene) var collection_item
export(float) var end_padding = 0
export(String) var sorting_key = ""

var display_nodes := {}
var padding_node : Control
var data_collection


func reposition_in_parent() -> void:
	if !is_instance_valid(get_parent()):
		return
		
	if get_parent().has_node(@"data_view_node"):
		get_parent().call_deferred("move_child", self, get_parent().get_node(@"data_view_node").get_position_in_parent() + 1)


func _ready() -> void:
	if Engine.editor_hint:
		get_tree().connect("tree_changed", self, "reposition_in_parent")
		return
		
	if end_padding > 0:
		padding_node = Control.new()
		padding_node.rect_min_size.y = end_padding
		padding_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		get_parent().call_deferred("add_child", padding_node)


func load_collection(collection) -> void:
	data_collection = collection
	var collection_keys

	if collection is Array:
		collection_keys = range(collection.size())
		while display_nodes.size() > collection.size():
			var k = str(display_nodes.size() - 1)
			display_nodes[k].free()
			display_nodes.erase(k)
			
		while display_nodes.size() < collection.size():
			create_item(str(display_nodes.size()))
	
	else:
		collection_keys = collection.keys()
		for k in display_nodes:
			if !collection.has(k):
				display_nodes[k].free()
				display_nodes.erase(k)
		
		for k in collection:
			if !display_nodes.has(k):
				create_item(k)
				
	yield(get_tree(), "idle_frame")
	
	if sorting_key != "":
		collection_keys.sort_custom(self, "custom_sorting")
		for x in collection_keys:
			display_nodes[x].raise()
		
	if padding_node != null:
		padding_node.raise()


func create_item(key : String) -> void:
	var new_item = collection_item.instance()
	new_item.name = key
	display_nodes[key] = new_item
	get_parent().call_deferred("add_child", new_item)


func custom_sorting(a : String, b : String) -> bool:
	return data_collection[a][sorting_key].nocasecmp_to(data_collection[b][sorting_key]) < 0
