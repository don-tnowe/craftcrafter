extends Control


onready var node_frame := $"frame"
onready var node_anim := $"anim"

var can_change_screen := true


func _ready() -> void:
	if $"header/color_rect/box/back".connect("pressed", self, "_on_back_pressed") != OK: 
		return
	
	get_tree().set_quit_on_go_back(false)


func switch_screen(scene_path : String, extra = null) -> void:
	if !can_change_screen:
		return

	var bottom_node = node_frame.get_child(node_frame.get_child_count() - 1)
	var top_node = load(scene_path).instance()
	
	if top_node.has_method("open_screen"):
		top_node.open_screen(extra)
	
	node_frame.add_child(top_node)

	start_animation("open_screen", str(get_path_to(bottom_node)), str(get_path_to(top_node)))
		

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
		
	start_animation("close_screen", str(get_path_to(bottom_node)), str(get_path_to(top_node)))
		

func start_animation(name : String, bottom_node_path_str : String, top_node_path_str : String):
	var animation = node_anim.get_animation(name)
	animation.track_set_path(0, NodePath(bottom_node_path_str + ":modulate"))
	animation.track_set_path(1, NodePath(bottom_node_path_str + ":visible"))
	animation.track_set_path(2, NodePath(top_node_path_str + ":anchor_left"))
	animation.track_set_path(3, NodePath(top_node_path_str + ":anchor_right"))

	node_anim.play(name)
	can_change_screen = false
	

func _on_anim_animation_finished(anim_name) -> void:
	can_change_screen = true
	if anim_name == "close_screen":
		node_frame.get_child(node_frame.get_child_count() - 1).free()


func _notification(what) -> void:
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		_on_back_pressed()
