class_name EditValueButton
extends Button

export(String) var data_node_name
export(String, FILE, "*.tscn") var edit_screen

var screen_switcher : Control
var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	var cur_parent = self
	data_collection = null
	
	while is_instance_valid(cur_parent):
		cur_parent = cur_parent.get_parent()
		
		if data_collection == null && cur_parent.has_node(@"data_view_node"):
			load_collection(cur_parent.get_node(@"data_view_node").data_collection)
		
		if cur_parent.has_method("switch_screen"):
			screen_switcher = cur_parent
			break
	
	
	if connect("pressed", self, "_on_pressed") != OK:
		return


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name != "":
		text = str(collection[data_node_name])


func _on_pressed() -> void:
	if !is_instance_valid(screen_switcher):
		return

	screen_switcher.switch_screen(edit_screen, [data_collection, false])
