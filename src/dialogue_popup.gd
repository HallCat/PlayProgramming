
extends CanvasLayer

var text_label
var dialogue_helper
var text_editor
var character_name
var accept_button

func _ready():
	# Initalization here
	text_label = get_node("panel/label")
	text_editor = get_node("TextEditor")
	dialogue_helper = get_node("DialogueHelper")
	accept_button = get_node("panel/acceptButton")
	
	pass

func set_character_name(char_name):
	character_name = char_name

func _on_panel_about_to_show():
	text_label.set_text(dialogue_helper.get_text(character_name))
	
func _on_acceptButton_pressed():
	get_node("panel").popup()
	text_editor.show()
	
func _on_panel_popup_hide():
	accept_button.set_pressed(false)

