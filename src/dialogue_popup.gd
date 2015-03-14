
extends CanvasLayer

# Global Variables.
var text_label
var dialogue_helper
var text_editor
var character_name
var accept_button
var _quest_essential

func _ready():
	# Sets the global variables to child nodes of the class.
	text_label = get_node("panel/label")
	text_editor = get_node("TextEditor")
	dialogue_helper = get_node("DialogueHelper")
	accept_button = get_node("panel/acceptButton")
	
	pass

# Sets the character name. Used later to get the text.
func set_character_name(char_name):
	character_name = char_name
	
func set_quest_essential(essential):
	_quest_essential = essential

# Listener function. Called when popup() is called.
func _on_panel_about_to_show():
	
	if _quest_essential:
		accept_button.show()
	else :
		accept_button.hide()
		
	# Sets the text of the dialogue popup to the dialogue, read in from the file.
	text_label.set_text(dialogue_helper.get_text(character_name))
	
# Listener function. Called when the accept_button is pressed/clicked.
func _on_acceptButton_pressed():
	# hides the window/panel 
	get_node("panel").hide()
	# Makes the text editor visible
	text_editor.show()

	