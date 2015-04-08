extends Node

# Private Global Variables
var _current_scene = null
var _current_course = "python"
var _current_level = 1
var _root

func _ready():
	_root = get_tree().get_root()
	_current_scene = _root.get_child( _root.get_child_count() -1 )

func goto_scene(scene):
	#load the new scene.
	var s = ResourceLoader.load(scene)
	# free up the _current scene.
	_current_scene.queue_free()
	# set _current_scene to an instance of the new scene.
	_current_scene = s.instance()
	# Add the _current scene as a child to _root. ie. make it the active scene.
	_root.add_child(_current_scene)
	
# return the _current scene
func get_current_scene():
	return _current_scene

# return the _current level string, to be used for file structure.	
func get_current_level():
	return _current_level
	
# Set the _current level string to cur_level
func set_current_level(cur_level):
	_current_level = cur_level
	
# Return the _current course string, to be used for file structure.
func get_current_course():
	return _current_course
	
# Move the player to the 2D position pos.
func move_player(pos):
	# NOTE: player scene must be called player in _current scene.
	_current_scene.get_node("Player").set_pos(pos)
	
# Toggle the player. Pauses the player to prevent it from moving.
# This prevents prevents the player input from interupting the code/text input 
func toggle_player():
	_current_scene.get_node("Player").pause_player()
	