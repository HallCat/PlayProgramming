# Popup to show a reward message and allow player to return to level select scene.
extends CanvasLayer

# Global variables
var _window

func _ready():
	# Initialize the window.
	_window = get_node("window")

func popup():
	# Make the window popup.
	_window.popup()

# Set the text of the reward label.
func set_text(text):
	_window.get_node("congrats_label").set_text(text)

# Change the scene to the level select screen.
func _on_level_select_button_pressed():
	_window.hide()
	get_node("/root/global").goto_scene("res://engine/LevelSelect.scn")

# Allow the player to continue.
func _on_continue_button_pressed():
	_window.hide()
