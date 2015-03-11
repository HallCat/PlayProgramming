extends Node


var current_scene = null
var current_course = "python"
var current_level = "1"


	
func _ready():
	var root = get_scene().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )

func goto_scene(scene):
	#load new scene
	print(scene)
	var s = ResourceLoader.load(scene)
	current_scene.queue_free()
	#instance the new scene
	current_scene = s.instance()
	#add it to the active scene, as child of root
	get_scene().get_root().add_child(current_scene)
	
func get_current_scene():
	return current_scene
	
func get_current_level():
	return current_level
	
func set_current_level(cur_level):
	current_level = cur_level
	
func get_current_course():
	return current_course
	
func move_player(pos):
	current_scene.get_node("player").set_pos(pos)
	
func toggle_player():
	current_scene.get_node("player").pause()
	
