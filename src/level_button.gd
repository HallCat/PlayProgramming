
extends TextureButton

export var level = ""
export(String, FILE, ".scn") var level_path
export var level_description = ""

func _ready():
	
	get_node("level_label").set_text(level)
	set_tooltip(level_description)
	pass

func _on_LevelButton_pressed():
	get_node("/root/global").set_current_level(level)
	print(level_path)
	get_node("/root/global").goto_scene(level_path)
	pass # replace with function body
