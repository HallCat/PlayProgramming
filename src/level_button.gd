extends TextureButton

# Export variables. Can be editted in the editor after the node has been added to a scene.
# level, used to add change the text label on the button.
export var level = 0
# variable to store the scene that should be opened. Will only look for .scn files.
export(String, FILE, ".scn") var level_path
# level_description will be used for the tooptip when hovering over the button.
export var level_description = ""


func _ready():
	
	# Get the player's level of unlock
	var unlocked = get_node("FileHelper").get_course_progress()
	
	# Check if this level is under the unlocked level
	if unlocked >= level:
		# if so, show the button.
		show()
	else:
		# if not, hide the button.
		hide()
	
	# Set the text of the level button
	get_node("level_label").set_text(str(level))
	
	# If the level description hasn't been set, default to Level X
	if level_description == "":
		level_description = "Level " + str(level)
		
	# Set the tool tip for the button
	set_tooltip(level_description)
	
	set_process_input(true)

func _on_LevelButton_pressed():
	var _global = get_node("/root/global")
	
	# Change the current level. 
	_global.set_current_level(level)
	# Set the current scene.
	_global.goto_scene(level_path)

# DEMO PURPOSES
func _input(event):
	if Input.is_key_pressed(KEY_U):
		show()
	
	if Input.is_key_pressed(KEY_R):
			
		# Get the player's level of unlock
		var unlocked = get_node("FileHelper").get_course_progress()
		
		# Check if this level is under the unlocked level
		if unlocked >= level:
			# if so, show the button.
			show()
		else:
			# if not, hide the button.
			hide()
