extends Node
func _ready():
	pass
	
# Generates the quest filename, based on the current level and course.
func get_filename():

	var filename = "res://" + get_node("/root/global").get_current_course() + "/"
	filename += str(get_node("/root/global").get_current_level()) + "/"
	
	return filename
		

# Gets dialogue text for a character.
func get_text(character_name):
	var io = XMLParser.new()
	
	var file_name = get_filename() + character_name + ".xml"
	
	io.open(file_name)
	var result = ""
	var id_value = str(get_quest_id())
	while io.read() == 0  :
		var id = io.get_named_attribute_value("quest_id")
		if io.get_node_type() == io.NODE_TEXT and id_value >= id:
			
			result = io.get_node_data()
			
	return result
	
# Gets text from XML file, based on the id.
func get_text_from_xml(id):
	var io = XMLParser.new()
	
	var file_name = get_filename() + "quest.xml"
	
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
	var expected_answer = get_text_from_xml("answer").strip_edges()
	user_answer = user_answer.strip_edges()
	# Check the if the user's answer and expected answer match.
	if expected_answer.matchn(user_answer):
		# Gets the success message from the file.
		var success = get_text_from_xml("success")
		# Returns true for correct. expected answer, and the success messgae.
		update_quest()
		
		var level = get_node("/root/global").get_current_level()
		if level == get_course_progress():
			update_course()
		
		return [true, expected_answer, success]
	else:
		# Returns false for incorrect, and the expected answer
		return [false, expected_answer]
		
# Updates the quest ID by 1.
func update_quest():
	# Write the progress file.
	update_quest_file(get_quest_id() + 1)
	
# Update the quest id in the file to the given ID.
func update_quest_file(new_id):
	var quest_file = File.new()
	var filename = get_filename() + "progress"
	#Open the file.
	quest_file.open(filename, File.WRITE)
	
	var default_dictionary={
		id = new_id
	}
	# Write to the quest file.
	quest_file.store_var(default_dictionary)
	# Close the file.
	quest_file.close()
	
# Get the current quest's progrress/variables.
func get_quest_variables():
	var quest_file = File.new()
	var filename = get_filename() + "progress"
	# if the file doesn't exist. Create it.
	if(!quest_file.file_exists(filename)):
		update_quest_file(0)
	
	# Open the file
	quest_file.open(filename, File.READ)
	# Get the variables from the file
	var quest_vars = quest_file.get_var()
	# Close the file
	quest_file.close()

	return quest_vars
	
func get_quest_id():
	var id = get_quest_variables()["id"]
	return id

# Save the user's code to user.py in the current level's folder.
func save_code(user_code):
	var file = File.new()
	file.open(get_filename() + "user.py", File.WRITE)
	file.store_string(user_code)
	
	file.close()
	

func get_code():
	var file = File.new()
	var filename = get_filename() + "user.py"
	file.open(filename, File.READ)
	if(file.file_exists(filename)):
		var code = ""
		while(!file.eof_reached()):
			code = code + file.get_line() + "\n"
		
		file.close()
		return code
	else :
		return get_reset_code()

func get_reset_code():
	var file = File.new()
	var filename = get_filename() + "reset.py"
	file.open(filename, File.READ)
	if(file.file_exists(filename)):
		var code = ""
		while(!file.eof_reached()):
			code = code + file.get_line() + "\n"
		
		file.close()
		return code
	else:
		return "#Write Code Here: \n"
	
func update_course():
	update_course_file(get_course_progress() + 1)

# Update the course id in the file to the given ID.
func update_course_file(id):
	var quest_file = File.new()
	var filename = "res://" + get_node("/root/global").get_current_course() + "/progress"
	#Open the file.
	quest_file.open(filename, File.WRITE)
	
	var default_dictionary={
		unlocked = id
	}
	# Write to the quest file.
	quest_file.store_var(default_dictionary)
	# Close the file.
	quest_file.close()
	
# Get the current course's progrress/variables.
func get_course_progress():
	var quest_file = File.new()
	var filename = "res://" + get_node("/root/global").get_current_course() + "/progress"
	# if the file doesn't exist. Create it.
	if(!quest_file.file_exists(filename)):
		update_course_file(1)
	
	# Open the file
	quest_file.open(filename, File.READ)
	# Get the variables from the file
	var quest_vars = quest_file.get_var()
	# Close the file
	quest_file.close()

	var result =  quest_vars["unlocked"]
	return result

