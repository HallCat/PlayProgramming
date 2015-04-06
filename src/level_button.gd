
extends TextureButton

export var level = 0
export(String, FILE, ".scn") var level_path
export var level_description = ""

func _ready():
	var unlocked = get_node("FileHelper").get_course_progress()
	if unlocked < level:
		hide()
	else:
		show()
	
	
	get_node("level_label").set_text(str(level))
	set_tooltip(level_description)
	pass

func _on_LevelButton_pressed():
	get_node("/root/global").set_current_level(level)
	get_node("/root/global").goto_scene(level_path)
	pass # replace with function body

