extends Control

export(String, FILE, "*.tscn") var init_screen

onready var node_frame := $"frame"
onready var node_header_title := $"header/color_rect/box/control/label"
onready var node_anim := $"anim"

var can_change_screen := true


func _ready() -> void:
	if $"header/color_rect/box/back".connect("pressed", self, "_on_back_pressed") != OK: 
		return
	
	get_tree().set_quit_on_go_back(false)
	switch_screen(init_screen)


func switch_screen(scene_path : String, extra = null) -> void:
	if !can_change_screen:
		return

	var bottom_node = node_frame.get_child(node_frame.get_child_count() - 1)
	var top_node = load(scene_path).instance()
	
	if top_node.has_method("open_screen"):
		top_node.open_screen(extra)
	
	node_frame.add_child(top_node)

	node_header_title.text = top_node.header_title
	start_animation("open_screen", bottom_node, top_node)


func _on_back_pressed() -> void:
	if !can_change_screen:
		node_anim.advance(10.0)

	if node_frame.get_child_count() <= 2: 
		get_tree().quit()

	var bottom_node = node_frame.get_child(node_frame.get_child_count() - 2)
	var top_node = node_frame.get_child(node_frame.get_child_count() - 1)
	
	if top_node.has_method("close_screen"):
		top_node.close_screen()
	
	if bottom_node.has_method("reopen_screen"):
		if top_node.has_method("get_result"):
			bottom_node.reopen_screen(top_node.get_result())
			
		else: 
			bottom_node.reopen_screen()
		
	node_header_title.text = bottom_node.header_title
	start_animation("close_screen", bottom_node, top_node)
		

func start_animation(name : String, bottom_node : ColorRect, top_node : ColorRect):
	var animation = node_anim.get_animation(name)
	var bottom_node_path_str = str(get_path_to(bottom_node))
	var top_node_path_str = str(get_path_to(top_node))
	
	animation.track_set_path(0, NodePath(bottom_node_path_str + ":modulate"))
	animation.track_set_path(1, NodePath(bottom_node_path_str + ":visible"))
	animation.track_set_path(2, NodePath(top_node_path_str + ":anchor_left"))
	animation.track_set_path(3, NodePath(top_node_path_str + ":anchor_right"))
	
	if name == "close_screen":
		animation.track_set_key_value(4, 0, top_node.theme_color)
		animation.track_set_key_value(4, 1, bottom_node.theme_color)
		
	else:
		animation.track_set_key_value(4, 0, bottom_node.theme_color)
		animation.track_set_key_value(4, 1, top_node.theme_color)

	node_anim.play(name)
	can_change_screen = false
	

func _on_anim_animation_finished(anim_name) -> void:
	can_change_screen = true
	if anim_name == "close_screen":
		node_frame.get_child(node_frame.get_child_count() - 1).free()


func _notification(what) -> void:
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		_on_back_pressed()
