extends Control

export(Array, String) var search_keys
export(NodePath) var reload_collection

onready var node_reload_collection := get_node(reload_collection)
onready var node_line_edit := $"search_box/margin_container/line_edit"

var toggled_on := false
var last_line_edit_text := ""


func _ready() -> void:
	node_line_edit.connect("text_changed", self, "_on_text_changed")


func _on_pressed() -> void:
	toggled_on = !toggled_on
	$"button_search".self_modulate = Color.darkgray if toggled_on else Color.white
	$"search_box".visible = toggled_on
	if toggled_on:
		node_line_edit.grab_focus()
		
	else:
		OS.hide_virtual_keyboard()


func _on_text_changed(new_text : String) -> void:
	var displayed_collection = node_reload_collection.data_collection
		
	last_line_edit_text = new_text
	for k in node_reload_collection.display_nodes:
		node_reload_collection.display_nodes[k].visible = (
			any_key_found(displayed_collection[str(k)], new_text)
			|| new_text == "")


func _on_clear() -> void:
	_on_text_changed("")
	node_line_edit.text = ""
	_on_pressed()


func any_key_found(item, filter_string : String) -> bool:
	for x in search_keys:
		if item[x].findn(filter_string) != -1:
			return true
	
	return false
