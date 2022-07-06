extends EditValueButton


func load_collection(collection) -> void:
	data_collection = collection
	if data_node_name == "min" && collection["min"] == collection["max"]:
		visible = false
		return
		
	visible = true
	text = sec_to_formatted_string(collection[data_node_name])


func sec_to_formatted_string(sec : float) -> String:
	if sec < 120.0: 
		return str(sec) + tr("time_seconds_s") 
	
	if sec < 3600.0: 
		return str(floor(sec / 60.0)) + tr("time_minutes_s") + str(fmod(sec, 60.0)) + tr("time_seconds_s") 
		
	return (
		str(floor(sec / 3600.0)) 
		+ tr("time_hours_s") 
		+ str(fmod(floor(sec / 60.0), 60.0))
		+ tr("time_minutes_s")  
		+ str(fmod(sec, 60.0))
		+ tr("time_seconds_s") 
	)
