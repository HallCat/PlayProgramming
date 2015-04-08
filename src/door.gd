# Doors are used to load a new lavel. When the player is collided with the door, and
# the up button is pressed, the player will enter the house/room. A door node should have
# the same name as it's corresponding door name.

extends Area2D 

export(String, FILE, ".scn") var level_path

# Constant for Door width. Doors are the same width throughout the game.
const DOOR_WIDTH = 20

# Globals
var _up_pressed = false
var _colliding = false
var _global

func _ready():
	# Initialize 
	_global = get_node("/root/global")
	
	# MainLoop
	set_fixed_process(true)

func _fixed_process(delta):
	# Check if the up button has been pressed
	_up_pressed = Input.is_action_pressed("move_up")
	
	# Check if the player is  up button 
	if _up_pressed and _colliding:
		_global.goto_scene(level_path)
		
		# New postition determined by the location of the linked door.
		var _new_position = _global.get_current_scene().get_node(get_name()).get_pos()
		# Add Door_Width to the door, so the player will be in front of the door.
		_new_position.x += DOOR_WIDTH
		# Moves the player to the new_position.
		_global.move_player(_new_position)

# Called when the player is colliding with the door.
func _on_Door_body_enter( body ):
	_colliding = true

# Called when the player has stopped colliding with the door.
func _on_Door_body_exit( body ):
	_colliding = false
