
extends CanvasLayer

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():

	pass


func popup():
	get_node("window").popup()

func set_text(text):
	get_node("window/congrats_label").set_text(text)

func _on_level_select_button_pressed():
	get_node("/root/global").goto_scene("res://engine/level_select.scn")


func _on_continue_button_pressed():
	get_node("window").hide()
	
