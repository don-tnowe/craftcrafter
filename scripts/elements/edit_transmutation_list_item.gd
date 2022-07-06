tool
extends MarginContainer

export(Color) var theme_color setget set_theme_color
export(String) var header_title setget set_header_title


func update_style() -> void:
	$"v_box_container/color_rect".color = theme_color
	$"v_box_container/color_rect/label".text = header_title


func _ready() -> void:
	update_style()


func set_theme_color(value : Color) -> void:
	theme_color = value
	if is_inside_tree():
		update_style()


func set_header_title(value : String) -> void:
	header_title = value
	if is_inside_tree():
		update_style()
