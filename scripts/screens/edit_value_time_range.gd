extends EditValueBase


func setup_properties() -> void:
	can_negative = false
	can_inf = false

	var min_value = screen_extra_data[0]["min"]
	var max_value = screen_extra_data[0]["max"]
	field_values = {
		"min_s" : fmod(min_value, 60.0),
		"min_m" : fmod(floor(min_value / 60.0), 60.0),
		"min_h" : floor(min_value / 3600.0),
		"max_s" : fmod(max_value, 60.0),
		"max_m" : fmod(floor(max_value / 60.0), 60.0),
		"max_h" : floor(max_value / 3600.0),
	}
	.setup_properties()

	screen_extra_data[1] = screen_extra_data[1] + "_s"


func _on_select_field(property : String) -> void:
	verify_fields("min")
	verify_fields("max")

	._on_select_field(property)


func _on_keypad_ok() -> void:
	verify_fields("min")
	verify_fields("max")

	field_values = {
		"min" : get_seconds(field_values["min_s"], field_values["min_m"], field_values["min_h"]),
		"max" : get_seconds(field_values["max_s"], field_values["max_m"], field_values["max_h"]),
	}
	._on_keypad_ok()


func verify_fields(prefix : String) -> void:
	var s = field_values[prefix + "_s"]
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
		update_property(prefix + "_s", s)
		update_property(prefix + "_m", m)
		update_property(prefix + "_h", h)


func get_seconds(s : float, m : float, h : float) -> float:
	return s + m * 60.0 + h * 3600.0
