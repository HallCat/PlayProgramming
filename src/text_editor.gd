
extends CanvasLayer

# Global Variables
var _window
var _code_text 
var _http_helper
var _file_helper
var _output_label
var _description_label
var _reward_popup
var _check_label
var _global

func _ready():
	# Initialize the global variables.
	_global = get_node("/root/global")
	_window = get_node("WindowDialog")
	_code_text = get_node("WindowDialog/codeEdit")
	_http_helper = get_node("HttpHelper")
	_file_helper = get_node("FileHelper")
	_output_label = get_node("WindowDialog/outputLabel")
	_description_label = get_node("WindowDialog/descriptionLabel")
	_reward_popup = get_node("RewardPopup")
	_check_label = get_node("WindowDialog/checkLabel")
	_output_label.set_text("OUTPUT: ")
	

	_description_label.set_text(_file_helper.get_quest_text())
	
	# Set the code syntax highlighting.
	set_syntax()

func set_syntax():
	_code_text.set_syntax_coloring(true)
	_code_text.set_symbol_color(Color(1,.5833,0))
	
	_code_text.add_color_region("#", "", Color(0.7,0,1), true)
	_code_text.add_color_region("\"", "\"", Color(0.7,0,1))
	_code_text.add_keyword_color("print", Color(1,.5833,0))
	_code_text.set_custom_bg_color(Color(0,0,0))
	
# Make the Text Editor visible.
func show():
	_window.popup()

# Activate the player, when the window is hidden
func _on_WindowDialog_popup_hide():	
	_global.toggle_player()

# Called Just before the window is shown
func _on_WindowDialog_about_to_show():
	# Deactivate the player input
	_global.toggle_player()
	# Set the code to user/reset.py
	_code_text.set_text(_file_helper.get_code())

# Called on click of the execution button.
func _on_executeButton_pressed():
	# Get the user code.
	var user_code = _code_text.get_text()
	# Replace any ' with " to work with bash command.
	user_code = user_code.replacen("'", "\"")

	# Save the user's code to user.py
	_file_helper.save_code(user_code)
	
	# Make the POST Request to execute the code.
	var res = _http_helper.http_post_request(user_code)
	# Set the result in the output text.
	_output_label.set_text("OUTPUT :\n" + res)
	
	var check = _file_helper.check_answer(res)

	# If the answer is correct.
	if check[0]:
		# Load & Set the correct image
		var correct = ResourceLoader.load("art/ui/correct.png")	
		_check_label.set_texture(correct)
		# Hide the Text Editor
		_window.hide()
		# Set the reward popup's text
		_reward_popup.set_text(check[2])
		# Show the reward popup
		_reward_popup.popup()
	else:
		# Load & Set the incorrect (X) image.
		var incorrect = ResourceLoader.load("art/ui/x_button.png")
		_check_label.set_texture(incorrect)
		
# Show the task description
func _on_taskButton_pressed():
	_description_label.set_text(_file_helper.get_quest_text())

# Show the hint
func _on_hintButton_pressed():
	_description_label.set_text(_file_helper.get_hint_text())

# Save the code to user.py
func _on_saveButton_pressed():
	_file_helper.save_code(_code_text.get_text())

# Reset the code to the original state in reset.py
func _on_resetButton_pressed():
	_code_text.set_text(_file_helper.get_reset_code())

