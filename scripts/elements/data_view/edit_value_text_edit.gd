extends TextEdit

signal edit_started(text)

export(String) var data_node_name

var data_collection  # Variant: Array or Dictionary
var screen_switcher : Node setget set_screen_switcher


func _ready() -> void:
	connect("text_changed", self, "_on_text_changed")


func set_screen_switcher(v : Node) -> void:
	screen_switcher = v
	connect("edit_started", v, "show_keyboard")


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name != "":
		text = collection.get(data_node_name, "")


func _gui_input(event : InputEvent) -> void:
	if event is InputEventScreenTouch && !event.pressed:
		emit_signal("edit_started", text)
		screen_switcher.connect("keyboard_confirmed", self, "_on_external_text_changed")


func _on_external_text_changed(new_text : String) -> void:
	text = new_text
	screen_switcher.disconnect("keyboard_confirmed", self, "_on_external_text_changed")
	data_collection[data_node_name] = new_text


func _on_text_changed(new_text : String) -> void:
	data_collection[data_node_name] = new_text
