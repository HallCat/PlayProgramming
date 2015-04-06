extends TextureFrame

func _ready():
	# Input expected. set_process_input will listen for input events.
	set_process_input(true)
	pass

func _on_TextureButton_pressed():
	# Switch current scene to the Level Seclect SCreen.
	get_node("/root/global").goto_scene("res://engine/LevelSelect.scn")
	

func _input(event):
	# Space key will activate the button
	if Input.is_key_pressed(KEY_SPACE):
		_on_TextureButton_pressed()
	