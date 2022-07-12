extends EditValueBase


func setup_properties() -> void:
	var property = screen_extra_data[1]
	field_values["value"] = screen_extra_data[0][property]
	$"label".text = tr($"label".text) + ": " + tr("edit_property_" + property)
	.setup_properties()


func _on_select_field(_property : String) -> void:
	._on_select_field("value")


func _on_keypad_ok() -> void:
	field_values[screen_extra_data[1]] = field_values["value"]
	._on_keypad_ok()
