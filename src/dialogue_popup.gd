
extends CanvasLayer

# Global Variables.
var _text_label
var _dialogue_helper
var _text_editor
var _character_name
var _accept_button
var _quest_essential
var _char_texture

func _ready():
	# Sets the global variables to child nodes of the class.
	_text_label = get_node("panel/label")
	_text_editor = get_node("TextEditor")
	_dialogue_helper = get_node("FileHelper")
	_accept_button = get_node("panel/acceptButton")
	_char_texture = get_node("panel/charTexture")

# Sets the character name. Used later to get the text.
func set_character_name(char_name):
	_character_name = char_name

# Sets the character texture for the popup
func set_character_texture(texture):
	_char_texture.set_texture(texture)
	
# Set _quest_essential to essential, used for making the code button shown or not.
func set_quest_essential(essential):
	_quest_essential = essential

# Listener function. Called when popup() is called.
func _on_panel_about_to_show():
	# Check if the character is essential to the quest.
	# Quest Essential characters will give the player access to the Code Editor.
	if _quest_essential:
		# Show the accept button.
		_accept_button.show()
	else :
		# Hide the accept button.
		_accept_button.hide()
		
	# Sets the text of the dialogue popup to the dialogue, read in from the file.
	_text_label.set_text(_dialogue_helper.get_text(_character_name))
	
# Listener function. Called when the _accept_button is pressed/clicked.
func _on_acceptButton_pressed():
	# hides the window/panel 
	get_node("panel").hide()
	# Makes the text editor visible
	_text_editor.show()

	