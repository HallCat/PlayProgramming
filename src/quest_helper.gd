
extends Node2D

var filename

var quest_file = File.new()

func _ready():
	# Initalization here
	filename = get_file_name()
	print(filename)
	print(get_quest())
	print(get_quest_id())
	
	set_fixed_process(true)
	pass

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

