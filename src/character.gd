extends Area2D

# Export variables. Can be editted in the editor after the node has been added to a scene.
# Character name, used for setting the dialogue for the character. 
# character_name.xml will be the file used for dialogue
export(String) var character_name

# Set the character sprite.
export(Texture) var character_sprite 

# Set whether or not the chatacter is a quest_essential character. 
# one which will have a coding challenge.
export(bool) var quest_character

# Flip the character_sprite if needed.
export(bool) var flipped = false

# Global variables. 
var _dialogue_popup
var _dialogue_popup_panel

func _ready():
	# Sets the global variables to nodes in the scene.
	_dialogue_popup = get_node("DialoguePopup")
	_dialogue_popup_panel = get_node("DialoguePopup/panel")
	
	
	# The following code will get the character sprite and calculate the size of one frame.
	# This can be used to set the visible sprite to the first/static frame.
	get_node("Sprite").set_texture(character_sprite)
	get_node("Sprite").set_hframes(character_sprite.get_width() / character_sprite.get_height())
	get_node("Sprite").set_flip_h(flipped)
	
	# Check if the character is essential for the current quest/task
	if(quest_character):
		# If so, the quest/Code button will be visible/active.
		_dialogue_popup.set_quest_essential(true)
	else:
		_dialogue_popup.set_quest_essential(false)
	
	# Sets the fixed process to true. (ie. keeps the scene 'looping')
	set_fixed_process(true)

# Listener Function. Activated when the user enters the character's bounding box.
func _on_NPC_body_enter( body ):
	# Sets the name of the character within the dialogue popup. Used to read the dialogue file
	_dialogue_popup.set_character_name(character_name)

	# Set the character texture for the dialogue popup
	_dialogue_popup.set_character_texture(get_char_sprite())
	
	# popup() makes he dialogue window/panel visible.
	_dialogue_popup_panel.popup()
	
# Listener Function. Activated when the user exits the character's bounding box.
func _on_NPC_body_exit( body ):
	# Set the dialogue window/panel to invisible.
	_dialogue_popup_panel.hide()

# Returns the character sprite.
func get_char_sprite():
	return character_sprite
