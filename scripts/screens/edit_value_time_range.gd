extends EditValueBase

var linked = false


func setup_properties() -> void:
	can_negative = false
	can_inf = false
	
	.setup_properties()
	
	if field_values["max"] == field_values["min"]:
		$"h_box_container/button".toggled_on = true
		linked = true
		
	# Seconds get converted by verify_fields() inside _on_select_field()


func update_property(property : String, value : float) -> void:
	if linked:
		.update_property(
			("min" if property.substr(0, 3) == "max" else "max")
			+ property.substr(3), value)
			
	.update_property(property, value)


func _on_link_toggled(value : bool) -> void:
	linked = value
	
	var prefix = selected_property.substr(0, 3)
	update_property(prefix, field_values[prefix])
	update_property(prefix + "_m", field_values[prefix + "_m"])
	update_property(prefix + "_h", field_values[prefix + "_h"])


func _on_select_field(property : String) -> void:
	verify_fields("min")
	verify_fields("max")
	
	._on_select_field(property)


func _on_keypad_ok() -> void:
	verify_fields("min")
	verify_fields("max")

	field_values = {
		"min" : get_seconds(field_values["min"], field_values["min_m"], field_values["min_h"]),
		"max" : get_seconds(field_values["max"], field_values["max_m"], field_values["max_h"]),
	}
	._on_keypad_ok()


func verify_fields(prefix : String) -> void:
	var s = field_values[prefix]
	var m = field_values[prefix + "_m"]
	var h = field_values[prefix + "_h"]
	var delta = 0.0

	# If Hours or Minutes have fractions, convert fraction * 60 to lower measurement.
	
	if fmod(h, 1.0) > 0.0:
		delta = fmod(h, 1.0)
		h -= delta
		m += delta * 60.0

	if fmod(m, 1.0) > 0.0:
		delta = fmod(m, 1.0)
		m -= delta
		s += delta * 60.0
	
	# If Seconds or Minutes higher than 60, convert integer part to higher measurement.
	
	if s >= 60.0:
		delta = floor(s / 60.0) 
		m += delta
		s -= delta * 60.0

	if m >= 60.0:
		delta = floor(m / 60.0)
		h += delta
		m -= delta * 60.0

	if delta != 0.0:
		update_property(prefix, s)
		update_property(prefix + "_m", m)
		update_property(prefix + "_h", h)


func get_seconds(s : float, m : float, h : float) -> float:
	return s + m * 60.0 + h * 3600.0
