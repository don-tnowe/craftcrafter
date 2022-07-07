extends EditValueBase

var linked = false


func setup_properties() -> void:
	.setup_properties()
	if field_values["max"] == field_values["min"]:
		$"h_box_container/button".toggled_on = true
		linked = true


func update_property(property : String, value : float) -> void:
	if linked || property == "min":
		.update_property("min", value)
		
	if linked || property == "max":
		.update_property("max", value)


func _on_link_toggled(value : bool) -> void:
	linked = value
	update_property(selected_property, field_values[selected_property])


func _on_keypad_ok() -> void:
	if field_values["min"] > field_values["max"]:
		var swap = field_values["max"]
		.update_property("max", field_values["min"])
		.update_property("min", swap)

	._on_keypad_ok()
