extends VBoxContainer

signal icon_selected(filepath)
signal concurrent_request_ready()

const url_all_tags := "https://game-icons.net/tags.html"
const url_tag := "https://game-icons.net/tags/"  # + name.html
const url_github := "https://raw.githubusercontent.com/game-icons/icons/master/"  # + contributor/name.svg
const icon_download_path := "user://icons/game-icons/"
const icon_downloads_file := "user://icondownloads.txt"
const max_concurrent_requests := 6

export(String) var data_node_name

onready var collection_filler := $"scroll_container/v_box_container/collection_view_filler"

var concurrent_requests := 0
var last_request_code : int
var last_request_body := {}
var http_requesters := {}
var http_requesters_queue := []


func _ready():
	game_icons_net_fetch_all_tags()
	connect("concurrent_request_ready", self, "_on_concurrent_request_ready")


func http_request(url : String, tag : String) -> HTTPRequest:
	var requester = HTTPRequest.new()
	add_child(requester)
	http_requesters[tag] = requester
	requester.connect("request_completed", self, "_on_request_completed", [tag])

	if concurrent_requests < max_concurrent_requests:
		concurrent_requests += 1
		requester.request(url)

	else:
		http_requesters_queue.append([requester, url, tag])

	return requester


func _on_concurrent_request_ready():
	if http_requesters_queue.size() == 0:
		return
	
	var entry = http_requesters_queue.pop_back()
	http_requesters[entry[2]] = entry[0]
	entry[0].request(entry[1])
	concurrent_requests += 1


func _on_request_completed(_result : int, response_code : int, _headers : PoolStringArray, body : PoolByteArray, tag : String) -> void:
	last_request_code = response_code
	last_request_body[tag] = body
	http_requesters[tag].queue_free()
	http_requesters.erase(tag)
	concurrent_requests -= 1

	if concurrent_requests < max_concurrent_requests:
		emit_signal("concurrent_request_ready")

	if concurrent_requests < 1:
		save_icon_downloads()


func _on_icon_selected(category : String, index : int) -> void:
	var info = DataController.icon_paths[category][index]
	$"panel/label".text = info["name"]
	$"panel/label2".text = "By " + info["contributor"]
	$"../data_view_node".data_collection[data_node_name] = info["filepath"]
	emit_signal("icon_selected", info["filepath"])


func display_categories() -> void:
	collection_filler.load_collection(DataController.icon_paths)


func save_icon_downloads() -> void:
	var file = File.new()
	file.open(icon_downloads_file, File.WRITE)
	file.store_var(DataController.icon_paths)
	file.close()


func fetch_icons_in_category(key : String) -> void:
	var dir = Directory.new()
	if !dir.dir_exists(icon_download_path):
		dir.make_dir_recursive(icon_download_path)
		
	if DataController.icon_paths.has(key) && DataController.icon_paths[key].size() > 1:
		var ctg_node = collection_filler.get_node("../" + key)
		ctg_node.load_collection(DataController.icon_paths[key])

	else:
		game_icons_net_fetch_icons_in_tag(key)


func game_icons_net_fetch_all_tags() -> void:
	var file = File.new()

	if file.file_exists(icon_downloads_file):
		file.open(icon_downloads_file, File.READ)
		DataController.icon_paths = file.get_var()
		display_categories()
		return
	
	yield(http_request(url_all_tags, "all_tags"), "request_completed")
	if last_request_code != HTTPClient.RESPONSE_OK:
		return
	
	var xml = XMLParser.new()
	xml.open_buffer(last_request_body["all_tags"])
	last_request_body.erase("all_tags")
	
	var found_collection = false
	
	while xml.read() == OK:
		if !found_collection:
			if xml.get_named_attribute_value_safe("class") == "tags cover":
				found_collection = true
			
			continue
		
		if xml.has_attribute("href"):
			var path = xml.get_named_attribute_value("href").substr(6)
			DataController.icon_paths[path.substr(0, path.find("."))] = []
			
		if xml.get_node_type() != XMLParser.NODE_TEXT && xml.get_node_name() == "article":
			break
			
	file.close()
	display_categories()


func game_icons_net_fetch_icons_in_tag(tag : String) -> void:
	yield(http_request(url_tag + tag + ".html", "tag_" + tag), "request_completed")
	if last_request_code != HTTPClient.RESPONSE_OK:
		return
	
	var xml = XMLParser.new()
	xml.open_buffer(last_request_body["tag_" + tag])
	last_request_body.erase("tag_" + tag)
	
	var found_collection = false
	var ctg_node = collection_filler.get_node("../" + tag)
	var paths_to_load = []
	
	while xml.read() == OK:
		if !found_collection:
			if xml.get_named_attribute_value_safe("class") == "icons":
				found_collection = true
			
			continue
		
		if xml.get_named_attribute_value_safe("class") == "hint--top":
			while xml.get_node_type() == XMLParser.NODE_TEXT || !xml.has_attribute("href"):
				xml.read()
				
			var path = xml.get_named_attribute_value("href")
			paths_to_load.append(path)
			
		if xml.get_node_type() != XMLParser.NODE_TEXT && xml.get_node_name() == "aside":
			break

	for x in paths_to_load:
		game_icons_load_svg(x, tag, ctg_node)


func game_icons_load_svg(path : String, tag : String, update_node : Node) -> void:
	path = path.substr(5, path.length() - 10)
	var download_path = icon_download_path + path + ".svg"

	var file = File.new()
	if file.file_exists(download_path):
		update_node.load_collection(DataController.icon_paths[tag])
		return

	var dir = Directory.new()
	var path_split = path.split("/")
	var url = url_github + path_split[0] + "/" + path_split[1] + ".svg"

	yield(http_request(url, "svg_" + path), "request_completed")
	if last_request_code != HTTPClient.RESPONSE_OK:
		return
		
	var svg = last_request_body["svg_" + path].get_string_from_utf8()
	last_request_body.erase("svg_" + path)

	# Remove the black rectangle background
	svg = svg.replace("<path d=\"M0 0h512v512H0z\"/>", "")

	if !dir.dir_exists(icon_download_path + path_split[0]):
		dir.make_dir(icon_download_path + path_split[0])

	file.open(download_path, File.WRITE)
	file.store_string(svg)
	file.close()

	DataController.icon_paths[tag].append({
		"name": path_split[1],
		"contributor": path_split[0],
		"filepath": download_path,
	})
	
	update_node.load_collection(DataController.icon_paths[tag])
