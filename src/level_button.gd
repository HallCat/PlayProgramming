
extends TextureButton

export var level = ""
export var level_description = ""

func _ready():
	
	get_node("level_label").set_text(level)
	set_tooltip(level_description)
	pass

func _on_LevelButton_pressed():
	var level = get_name()
	var course = get_node("/root/global").get_current_course()
	get_node("/root/global").set_current_level(level)
	get_node("/root/global").goto_scene("res://" + course + "/" + level + "/main.scn")
	pass # replace with function body
