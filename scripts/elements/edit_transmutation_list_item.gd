tool
extends MarginContainer

export(String, FILE, "*.tscn") var edit_screen
export(Color) var theme_color setget set_theme_color
export(String) var header_title setget set_header_title
export(Resource) var edit_format


func update_style() -> void:
	$"v_box_container/color_rect".color = theme_color
	$"v_box_container/color_rect/label".text = header_title


func _ready() -> void:
	update_style()


func add_item() -> void:
	var new_collection = {"id": "", "min": 1, "max": 2}
	$"data_view_node".data_collection.append(new_collection)
	
	var cur_parent = self
	while true:
		if cur_parent.has_method("switch_screen"):
			cur_parent.switch_screen(edit_screen, [new_collection, "id", edit_format])
			break
			
		cur_parent = cur_parent.get_parent()


func set_theme_color(value : Color) -> void:
	theme_color = value
	if is_inside_tree():
		update_style()


func set_header_title(value : String) -> void:
	header_title = value
	if is_inside_tree():
		update_style()
