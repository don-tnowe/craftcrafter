tool
extends GridContainer

signal color_selected(color)

const hue_count := 10
const row_count := 7
const inactive_button_margin := 8
const default_colors := {"bg": Color.black, "fg": Color.white, "bg2": Color.transparent}

export(String) var data_node_name
export(PackedScene) var button_scene

var data_collection
var selected_color_index := 0


func _ready() -> void:
	for i in hue_count * row_count:
		var node = button_scene.instance()
		add_child(node)
		node.connect("pressed", self, "_on_color_selected", [i])
		node.modulate = index_to_color(i)


func index_to_color(index : int) -> Color:
	if index == -1:
		return default_colors[data_node_name]
	
	var row = index / hue_count
	var col = index % hue_count
	if index % hue_count < hue_count - 1:
		return Color().from_hsv(
			float(col) / hue_count,
			min(float(row + 1) / row_count * 1.75, 0.75),
			min(float(row_count - row) / row_count * 1.25, 1.0))
	
	else:
		var value = float(row_count - row - 1) / (row_count - 1)
		return Color(value, value, value, 1.0)


func color_to_index(color : Color) -> int:
	# Won't write out a formula for this, time's tight. Just bruteforce for now
	for i in hue_count * row_count:
		if index_to_color(i) == color:
			return i
	
	return -1


func load_collection(collection) -> void:
	data_collection = collection
	reload_from_current_collection(data_node_name)


func reload_from_current_collection(key : String) -> void:
	data_node_name = key
		
	if data_collection.has(key):
		_on_color_selected(color_to_index(data_collection[key]))
		
	else:
		_on_color_selected(-1)


func _on_color_selected(index : int) -> void:
	if get_child_count() <= 1:
		yield(get_tree(), "idle_frame")
	
	var button
	if selected_color_index != -1:
		button = get_child(selected_color_index + 1).get_child(0)
		button.margin_left = inactive_button_margin
		button.margin_top = inactive_button_margin
		button.margin_right = -inactive_button_margin
		button.margin_bottom = -inactive_button_margin
		button.get_parent().show_behind_parent = true
		
	selected_color_index = index
	var selected_color = index_to_color(index)
	
	if index != -1:
		button = get_child(index + 1).get_child(0)
		button.margin_left = -inactive_button_margin
		button.margin_top = -inactive_button_margin
		button.margin_right = inactive_button_margin
		button.margin_bottom = inactive_button_margin
		button.get_parent().show_behind_parent = false
	
	data_collection[data_node_name] = selected_color
	emit_signal("color_selected", selected_color)
