extends Node

func _ready():
	pass

func get_text(character_name):	
	
	var io = XMLParser.new()
	
	var file_name = "res://" + get_node("/root/global").get_current_course() + "/"
	file_name += str(get_node("/root/global").get_current_level()) + "/"
	file_name += character_name + ".xml"
	
	io.open(file_name)
	var result = ""
	var id_value = get_node("QuestHelper").get_quest_id()
	

	while io.read() == 0  :
		if io.get_node_type() == io.NODE_TEXT and io.get_named_attribute_value("id").match(id_value):
			result = io.get_node_data()	
			
	return result
	
	
func get_text_from_xml(id):
	var io = XMLParser.new()
	
	var file_name = "res://" + get_node("/root/global").get_current_course() + "/"
	file_name += str(get_node("/root/global").get_current_level()) + "/quest.xml"
	
	io.open(file_name)
	var result = ""
	while io.read() == 0  :
		if io.get_node_type() == io.NODE_TEXT and io.get_named_attribute_value("id").match(id):
			result = io.get_node_data()
	
	return result
	

func get_quest_text():
	return get_text_from_xml("quest_text")
	
func get_hint_text():
	return get_text_from_xml("hint_text")

func check_answer(user_answer):
	var io = XMLParser.new()
	
	var file_name = "res://" + get_node("/root/global").get_current_course() + "/"
	file_name += str(get_node("/root/global").get_current_level()) + "/quest.xml"
	
	io.open(file_name)
	var result = ""
	var success = ""
	while io.read() == 0  :
		if io.get_node_type() == io.NODE_TEXT :
			if io.get_named_attribute_value("id").match("answer"):
				result = io.get_node_data()
			elif io.get_named_attribute_value("id").match("success"):
				success = io.get_node_data()
	
	if result.matchn(user_answer):
		return [true, result, success]
	else:
		return [false, result]
		
