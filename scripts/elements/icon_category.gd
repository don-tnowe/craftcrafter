extends VBoxContainer

onready var collection_filler := $"grid_container/collection_view_filler"
onready var node_status := $"panel/status"

var node_icon_chooser : Node
var folded := true


func _ready():
	$"panel/line_edit".text = name
	var cur_parent = get_parent()
	while is_instance_valid(cur_parent):
		if cur_parent.has_method("_on_icon_selected"):
			node_icon_chooser = cur_parent
			break
		
		cur_parent = cur_parent.get_parent()


func load_collection(collection):
	collection_filler.load_collection(collection)
	yield(get_tree(), "idle_frame")
	for i in collection_filler.get_parent().get_child_count() - 1:
		collection_filler.get_parent().get_child(i + 1).get_child(1).texture = (
			DataController.load_icon(collection[i]["filepath"])
		)
	node_status.text = "-"


func _on_fold_category():
	folded = !folded
	collection_filler.get_parent().visible = !folded
	if !folded:
		node_status.text = "..."
		node_icon_chooser.fetch_icons_in_category(name)

	else:
		node_status.text = "+"


func _on_icon_selected(icon_idx : String):
	node_icon_chooser._on_icon_selected(name, icon_idx.to_int())
