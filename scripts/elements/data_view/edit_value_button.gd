class_name EditValueButton
extends Button

export(String) var data_node_name
export(String, FILE, "*.tscn") var edit_screen
export(Resource) var edit_format

var screen_switcher : Control
var data_collection  # Variant: Array or Dictionary


func _ready() -> void:
	connect("pressed", self, "_on_pressed")


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

