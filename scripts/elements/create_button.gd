extends EditValueButton


func _on_pressed() -> void:
	data_collection = DataController.create_empty_item(data_node_name)
	._on_pressed()


func load_collection(_collection) -> void:
	# Nothing to load - this only creates.
	pass
