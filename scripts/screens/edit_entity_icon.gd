extends ScreenBase

onready var node_grid := $"v_box_container/margin_container/color_grid"
onready var icon_data_leaf := $"v_box_container/control/icon/data_view_leaf"

var edited_property : String


func _ready():
	node_grid.connect("color_selected", self, "_on_color_selected")


func _on_edited_property_changed(prop : String) -> void:
	edited_property = prop
	if prop == "icon_path":
		node_grid.visible = false
		
	else:
		node_grid.visible = true
		node_grid.reload_from_current_collection(prop)


func _on_color_selected(_color : Color) -> void:
	icon_data_leaf.load_data()


func _on_bg_gradient_cleared() -> void:
	screen_extra_data[0]["visuals"]["bg2"] = Color.transparent
	icon_data_leaf.load_data()
