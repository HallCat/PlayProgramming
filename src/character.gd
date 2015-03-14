extends Area2D

# Export variables. Can be editted in the editor after the node has been added to a scene.
# Character name, used for setting the dialogue for the character.
export(String) var character_name
# Set the character sprite.
export(Texture) var character_sprite

export(bool) var quest_character

# Global variables. 
var dialogue_popup
var dialogue_popup_panel

func _ready():
	# Sets the global variables to nodes in the scene.
	dialogue_popup = get_node("dialogue_popup")
	dialogue_popup_panel = get_node("dialogue_popup/panel")
	
	
	# The following code will get the character sprite and calculate the size of one frame.
	# This can be used to set the visible sprite to the first/static frame.
	get_node("Sprite").set_texture(character_sprite)
	get_node("Sprite").set_hframes(character_sprite.get_width() / character_sprite.get_height())
	
	if(quest_character):
		dialogue_popup.set_quest_essential(true)
	else:
		dialogue_popup.set_quest_essential(false)
	
	# Sets the fixed process to true. (ie. keeps the scene 'looping')
	set_fixed_process(true)

# Listener Function. Activated when the user enters the character's bounding box.
func _on_NPC_body_enter( body ):
	# Sets the name of the character within the dialogue_popup. Used to read the dialogue file
	dialogue_popup.set_character_name(character_name)
	# popup() makes he dialogue window/panel visible.
	dialogue_popup_panel.popup()
	
# Listener Function. Activated when the user exits the character's bounding box.
func _on_NPC_body_exit( body ):
	# Set the dialogue window/panel to invisible.
	dialogue_popup_panel.hide()

# Returns the character sprite.
func get_char_sprite():
	return character_sprite
