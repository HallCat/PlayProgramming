
extends CanvasLayer

# member variables here, example:
# var a=2
# var b="textvar"


var text_label
var dialogue_helper
var text_editor
var character_name

func _ready():
	# Initalization here
	text_label = get_node("panel/label")
	text_editor = get_node("TextEditor")
	dialogue_helper = get_node("DialogueHelper")
	
	pass

func set_character_name(char_name):
	character_name = char_name

func _on_panel_about_to_show():
	text_label.set_text(dialogue_helper.get_text(character_name))


func _on_acceptButton_pressed():
	get_node("panel").popup()
	text_editor.show()
	
	
	