extends Node

# Global Variables
var filename
var quest_file = File.new() 

func _ready():
	# Set the global filename
	filename = get_file_name()

# Generates the quest filename, based on the current level and course.
func get_file_name():
	var quest_name = "res://" + get_node("/root/global").get_current_course() + "/"
	quest_name += str(get_node("/root/global").get_current_level()) + "/"
	quest_name += "progress"
	
	return quest_name
	
# Gets dialogue text for a character.
func get_text(character_name):
	
	var io = XMLParser.new()
	
	var file_name = "res://" + get_node("/root/global").get_current_course() + "/"
	file_name += str(get_node("/root/global").get_current_level()) + "/"
	file_name += character_name + ".xml"
	
	io.open(file_name)
	var result = ""
	var id_value = str(get_quest_id())

	while io.read() == 0  :
		if io.get_node_type() == io.NODE_TEXT and io.get_named_attribute_value("id").match(id_value):
			result = io.get_node_data()
			
	return result
	
# Gets text from XML file, based on the id.
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

# Gets the quest text, by calling get_text_from_xml
func get_quest_text():
	return get_text_from_xml("quest_text")
	
# Gets the hint text, by calling get_text_from_xml
func get_hint_text():
	return get_text_from_xml("hint_text")

# Checks the answer by comparing the user's answer, wit the expected answer from the file.
func check_answer(user_answer):
	# Gets the expected answer from the file.
	var expected_answer = get_text_from_xml("answer")
	
	# Check the if the user's answer and expected answer match.
	if expected_answer.matchn(user_answer):
		# Gets the success message from the file.
		var success = get_text_from_xml("success")
		# Returns true for correct. expected answer, and the success messgae.
		return [true, expected_answer, success]
	else:
		# Returns false for incorrect, and the expected answer
		return [false, expected_answer]
		
# Updates the quest ID by 1.
func update_quest():
	# Write the progress file.
	update_quest_file(str(get_quest_id() + 1))
	
# Update the quest id in the file to the given ID.
func update_quest_file(new_id):
	#Open the file.
	quest_file.open(filename, File.WRITE)
	
	var default_dictionary={
		id = new_id
	}
	# Write to the quest file.
	quest_file.store_var(default_dictionary)
	# Close the file.
	quest_file.close()
	
#
func get_quest():
	
	if(!quest_file.file_exists(filename)):
		update_quest_file(1)
	
	quest_file.open(filename, File.READ)
	var d = quest_file.get_var()
	
	quest_file.close()
	
	print(d)
	
	return d
		
func get_quest_id():
	return get_quest()["id"]

