
extends Node2D

func _ready():
	# Initalization here
	
	pass

func update_quest():
	
	var quest_dictionary = get_quest()
	
	create_quest_file(quest_dictionary["id"]+1)
	
	pass
	
func create_quest_file(id):
	
	var quest = File.new()
	var quest_name = get_file_name()
	
	
	quest.open(quest_name, File.WRITE)
	var default_dictionary={
		id = 0
	}
	quest.store_var(default_dictionary)
	quest.close()
	
	
func get_quest_id():
	var quest_file = File.new()
	
	var quest_name = get_file_name()
	
	if(!quest_file.file_exists(quest_name)):
		create_quest_file(0)
	
	quest_file.open(quest_name, File.READ)
	var d = quest_file.get_var()
	quest_file.close()
	
	return str(d["id"])

func get_file_name():
	var quest_name = "res://" + get_node("/root/global").get_current_course() + "/"
	quest_name += str(get_node("/root/global").get_current_level()) + "/"
	quest_name += "progress"
	
	return quest_name
