
extends TextureFrame

func _ready():
	set_process_input(true)
	pass

func _on_TextureButton_pressed():
	get_node("/root/global").goto_scene("res://engine/level_select.scn")
	

func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		_on_TextureButton_pressed()
	