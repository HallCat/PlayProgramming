extends Node


var filename

var quest_file = File.new() 

func _ready():
	# Initalization here
	filename = get_file_name()

func get_text(character_name):
	
	var io = XMLParser.new()
	
	var file_name = "res://" + get_node("/root/global").get_current_course() + "/"
	file_name += str(get_node("/root/global").get_current_level()) + "/"
	file_name += character_name + ".xml"
	
	io.open(file_name)
	var result = ""
	var id_value = str(get_quest_id())

	while io.read() == 0  :
		if io.get_node_type() == io.NODE_TEXT and io.get_named_attribute_value("quest_id").match(id_value):
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
	var id_value = str(get_quest_id())
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
		
func update_quest():
	create_quest_file(str(get_quest_id() + 1))
	
	pass
	
func create_quest_file(id):
	
	quest_file.open(filename, File.WRITE)
	var default_dictionary={
		id = 0
	}
	quest_file.store_var(default_dictionary)
	quest_file.close()
	

func get_quest():
	
	if(!quest_file.file_exists(filename)):
		create_quest_file(1)
	
	quest_file.open(filename, File.READ)
	var d = quest_file.get_var()
	
	quest_file.close()
	
	print(d)
	
	return d
		
func get_quest_id():
	return get_quest()["id"]

func get_file_name():
	var quest_name = "res://" + get_node("/root/global").get_current_course() + "/"
	quest_name += str(get_node("/root/global").get_current_level()) + "/"
	quest_name += "progress"
	
	return quest_name
	
func unlock_level():
	pass

	

