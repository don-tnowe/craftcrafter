class_name EditValueBase
extends ScreenBase

export(Array, NodePath) var edit_elements

onready var node_edited_field := $"keyboard/margin_container/v_box_container/h_box_container/field"
onready var node_keypad := $"keyboard/margin_container/v_box_container/grid_container"
onready var node_keypad_clear := node_keypad.get_node("button_clear")
onready var node_keypad_erase := node_keypad.get_node("button_erase")
onready var node_keypad_negative := node_keypad.get_node("button_negative")
onready var node_keypad_inf := node_keypad.get_node("button_inf")
onready var node_keypad_point := node_keypad.get_node("button_point")
onready var node_keypad_ok := node_keypad.get_node("button_ok")

var field_nodes := {}
var field_values := {}
var selected_field : Button
var selected_property : String

var value_step := 0.0
var can_negative := true
var can_inf := true
var can_point := true


func update_property(property : String, value : float) -> void:
	if value_step != 0.0:
		value = round(value / value_step) * value_step  
	
	field_values[property] = value

	if value == INF:
		field_nodes[property].text = "∞"

	elif value == -INF:
		field_nodes[property].text = "-∞"
	
	else:
		field_nodes[property].text = str(value)


func update_edited_field(value : float) -> void:
	if value == INF:
		node_edited_field.text = "∞"

	elif value == -INF:
		node_edited_field.text = "-∞"
	
	else:
		node_edited_field.text = str(value)


func setup_properties() -> void:
	for x in edit_elements:
		var key = get_node(x).method_binds[0]
		field_nodes[key] = get_node(x)
		update_property(key, screen_extra_data[0].get(key, field_values.get(key, 0.0)))


func _enter_tree() -> void:
	# Must be in enter_tree() to activate before theme overriders
	if screen_extra_data[2] is ValueEditFormat:
		theme_color = screen_extra_data[2].screen_color


func _ready() -> void:
	setup_properties()

	if screen_extra_data[0].has("id"):
		var entity = DataController.project_data["entities"][screen_extra_data[0]["id"]]
		value_step = entity.get("step", 0.0)
		$"label".text = entity["name"]

	if screen_extra_data[2] is ValueEditFormat:
		var format = screen_extra_data[2]
		can_point = can_point && format.allow_fractions
		can_inf = can_inf && format.allow_infinity
		can_negative = can_negative && format.allow_negatives

	if value_step != 0.0 && fmod(value_step, 1.0) == 0.0:
		can_point = false
	
	if !can_point: 
		node_keypad_point.modulate.a = 0.2

	if !can_negative: 
		node_keypad_negative.modulate.a = 0.2
	
	if !can_inf: 
		node_keypad_inf.modulate.a = 0.2
	
	_on_select_field(screen_extra_data[1])


func _on_select_field(property : String) -> void:
	if is_instance_valid(selected_field):
		selected_field.modulate = Color.white
		
	selected_field = field_nodes[property]
	selected_field.modulate = theme_color.blend(Color(1, 1, 1, 0.5))
	selected_property = property
	update_edited_field(field_values[property])


func _on_keypad_number(number : int) -> void:
	if field_values[selected_property] == INF || field_values[selected_property] == -INF:
		node_edited_field.text = ""

	node_edited_field.text += str(number)
	update_property(selected_property, float(node_edited_field.text))


func _on_keypad_ok() -> void:
	var output_dict = screen_extra_data[0]
	for k in field_values:
		output_dict[k] = field_values[k]

	go_back()
	

func _on_keypad_clear() -> void:
	node_edited_field.text = ""
	update_property(selected_property, 0)


func _on_keypad_erase() -> void:
	var newlen = node_edited_field.text.length() - 1
	if newlen < 0:
		return
	
	node_edited_field.text = node_edited_field.text.substr(0, newlen)
	
	if newlen == 0:
		update_property(selected_property, 0)
		return

	update_property(selected_property, float(node_edited_field.text))
	

func _on_keypad_negative() -> void:
	if !can_negative:
		return

	if field_values[selected_property] == INF || field_values[selected_property] == -INF:
		node_edited_field.text = ""
	
	update_property(selected_property, -field_values[selected_property])
	update_edited_field(field_values[selected_property])


func _on_keypad_point() -> void:
	if !can_point:
		return
	
	if node_edited_field.text == "":
		node_edited_field.text = "0"

	node_edited_field.text = node_edited_field.text.replace(".", "") + "."
	# Do not update property!


func _on_keypad_inf() -> void:
	if !can_inf:
		return

	var property_positive = field_values[selected_property] >= 0
	update_property(selected_property, INF if property_positive else -INF)
	update_edited_field(field_values[selected_property])


func _on_adjust_value(adjustment : float) -> void:
	if value_step > abs(adjustment):
		adjustment = value_step * sign(adjustment)

	var new_value = float(node_edited_field.text) + adjustment
	if !can_negative && new_value < 0:
		new_value = 0.0

	update_property(selected_property, new_value)
	update_edited_field(new_value)
