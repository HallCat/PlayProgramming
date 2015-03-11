
extends CanvasLayer

# member variables here, example:
# var a=2
# var b="execute_labelvar"

var window
var code_text 
var http_helper
var file_helper
var execute_label
var char_label
var reward_popup

func _ready():
	
	window = get_node("WindowDialog")
	code_text = get_node("WindowDialog/codeEdit")
	http_helper = get_node("HttpHelper")
	file_helper = get_node("XML_helper")
	execute_label = get_node("WindowDialog/executeLabel")
	char_label = get_node("WindowDialog/char_label")
	reward_popup = get_node("RewardPopup")
	
	char_label.set_text(file_helper.get_quest_text())
	code_text.set_syntax_coloring(true)
	code_text.set_symbol_color(Color(1,.5833,0))
	
	code_text.add_color_region("\"", "\"", Color(0.7,0,1))
	code_text.add_keyword_color("print", Color(1,.5833,0))
	code_text.set_custom_bg_color(Color(0,0,0))
	


	set_fixed_process(true)
	set_process_input(true)
	
	
	pass



func _fixed_process(delta):
	pass
		

func _input(event):
	pass
		
func show():
	window.popup()

func _on_WindowDialog_popup_hide():	
	get_node("/root/global").toggle_player()


func _on_WindowDialog_about_to_show():
	get_node("/root/global").toggle_player()


# TO DO: Implement option 
func save_file(file):
	var f = File.new()
	f.open(file, File.WRITE)
	f.store_string(code_text.get_text())


func _on_executeButton_pressed():
	var res = http_helper.http_post_request(code_text.get_text())
	execute_label.set_text("OUTPUT: \n" + res)
	
	var check = file_helper.check_answer(res)

	if check[0]:
		var correct = ResourceLoader.load("splash/correct.png")	
		get_node("WindowDialog/check_label").set_texture(correct)
		window.hide()
		reward_popup.set_text(check[2])
		reward_popup.popup()
	
	else:
		var incorrect = ResourceLoader.load("splash/x_button.png")
		get_node("WindowDialog/check_label").set_texture(incorrect)
	
	pass # replace with function body


func _on_taskButton_pressed():
	char_label.set_text(file_helper.get_quest_text())

func _on_hintButton_pressed():
	char_label.set_text(file_helper.get_hint_text())
