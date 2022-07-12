extends ScreenBase


func _on_selected(id : String) -> void:
	screen_extra_data[0]["id"] = id
	go_back()
