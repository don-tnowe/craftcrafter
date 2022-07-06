class_name ScreenBase
extends ColorRect

signal returned_to_scene()

export(String) var header_title = "screen_title_"
export(Color) var theme_color = Color.darkgray

var screen_extra_data  # Variant


func get_switch_extra_from_tag(button_tag : String):
	return null


func open_screen(extra) -> void:
	screen_extra_data = extra


func close_screen() -> void:
	pass


func reopen_screen(closed_screen_result) -> void:
	emit_signal("returned_to_scene")


func get_result() -> void:
	pass
