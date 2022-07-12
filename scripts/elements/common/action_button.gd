extends Button

export(String) var method_name
export(Array) var method_binds
export(NodePath) var bind_name_of

func _ready() -> void:
	if has_node(bind_name_of):
		method_binds.append(get_node(bind_name_of).name)
	
	var cur_parent = self
	
	while is_instance_valid(cur_parent):
		if cur_parent.has_method(method_name):
			if connect("pressed", cur_parent, method_name, method_binds) != OK:
				pass
				
			break
			
		cur_parent = cur_parent.get_parent()
