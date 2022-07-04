extends Button

export(String) var method_name

func _ready() -> void:
	var cur_parent = self
	
	while true:
		cur_parent = cur_parent.get_parent()
		if !is_instance_valid(cur_parent):
			return

		if cur_parent.has_method(method_name):
			if connect("pressed", cur_parent, method_name) != OK:
				pass
				
			break
