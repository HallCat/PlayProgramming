
extends CanvasLayer

func popup():
	get_node("window").popup()

func set_text(text):
	get_node("window/congrats_label").set_text(text)

func _on_level_select_button_pressed():
	get_node("window").hide()
	get_node("/root/global").goto_scene("res://engine/LevelSelect.scn")


func _on_continue_button_pressed():
	get_node("window").hide()
	