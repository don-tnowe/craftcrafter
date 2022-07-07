class_name EditValueButton
extends Button

export(String) var data_node_name
export(String, FILE, "*.tscn") var edit_screen
export(Resource) var edit_format

var screen_switcher : Control
var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	var cur_parent = self
	data_collection = null
	
	while true:
		cur_parent = cur_parent.get_parent()
		if !is_instance_valid(cur_parent):
			break
		
		if data_collection == null && cur_parent.has_node(@"data_view_node"):
			load_collection(cur_parent.get_node(@"data_view_node").data_collection)
		
		if cur_parent.has_signal("returned_to_scene"):
			cur_parent.connect("returned_to_scene", self, "load_collection", [data_collection])
		
		if edit_format == null && "edit_format" in cur_parent:
			edit_format = cur_parent.edit_format
		
		if data_collection == null && "screen_extra_data" in cur_parent:
			data_collection = cur_parent.screen_extra_data[0]
		
		if cur_parent.has_method("switch_screen"):
			screen_switcher = cur_parent
			break
		
	if data_collection == null:
		data_collection = screen_switcher.screen_extra_data[0]

	if connect("pressed", self, "_on_pressed") != OK:
		return


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name != "":
		if collection[data_node_name] == INF:
			text = "∞"
			modulate.a = 0.25

		elif collection[data_node_name] == -INF:
			text = "-∞"
			modulate.a = 0.25

		else:
			text = str(collection[data_node_name])
			modulate.a = 1.0


func _on_pressed() -> void:
	if !is_instance_valid(screen_switcher):
		return

	screen_switcher.switch_screen(edit_screen, [data_collection, data_node_name, edit_format])

