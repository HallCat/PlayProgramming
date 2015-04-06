
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

func _ready():

	_window = get_node("WindowDialog")
	_code_text = get_node("WindowDialog/codeEdit")
	_http_helper = get_node("HttpHelper")
	_file_helper = get_node("FileHelper")
	_output_label = get_node("WindowDialog/outputLabel")
	_description_label = get_node("WindowDialog/descriptionLabel")
	_reward_popup = get_node("RewardPopup")
	_check_label = get_node("WindowDialog/checkLabel")
	
	
	_output_label.set_text("OUTPUT:")
	_description_label.set_text(_file_helper.get_quest_text())
	
	_code_text.set_syntax_coloring(true)
	_code_text.set_symbol_color(Color(1,.5833,0))
	
	
	_code_text.add_color_region("#", "", Color(0.7,0,1), true)
	_code_text.add_color_region("\"", "\"", Color(0.7,0,1))
	_code_text.add_keyword_color("print", Color(1,.5833,0))
	_code_text.set_custom_bg_color(Color(0,0,0))

func show():
	_window.popup()

func _on_WindowDialog_popup_hide():	
	get_node("/root/global").toggle_player()

func _on_WindowDialog_about_to_show():
	get_node("/root/global").toggle_player()
	_code_text.set_text(_file_helper.get_code())

func _on_executeButton_pressed():
	var user_code = _code_text.get_text()
	user_code = user_code.replacen("'", "\"")

	_file_helper.save_code(user_code)
	var res = _http_helper.http_post_request(user_code)
	_output_label.set_text("OUTPUT :\n" + res)
	
	var check = _file_helper.check_answer(res)

	if check[0]:
		var correct = ResourceLoader.load("art/ui/correct.png")	
		_check_label.set_texture(correct)
		_window.hide()
		_reward_popup.set_text(check[2])
		_reward_popup.popup()
	
	else:
		var incorrect = ResourceLoader.load("art/ui/x_button.png")
		_check_label.set_texture(incorrect)
		
func _on_taskButton_pressed():
	_description_label.set_text(_file_helper.get_quest_text())

func _on_hintButton_pressed():
	_description_label.set_text(_file_helper.get_hint_text())


func _on_saveButton_pressed():
	_file_helper.save_code(_code_text.get_text())


func _on_resetButton_pressed():
	_code_text.set_text(_file_helper.get_reset_code())

