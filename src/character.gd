extends Area2D

export(String) var character_name
export(Texture) var character_sprite

var dialogue_helper

var dialogue_popup
func _ready():
	# Initalization here
	dialogue_helper = get_node("dialogue_popup")
	dialogue_popup = get_node("dialogue_popup/panel")
	
	get_node("Sprite").set_texture(character_sprite)
	get_node("Sprite").set_hframes(character_sprite.get_width() / character_sprite.get_height())
	
	set_fixed_process(true)
	
	pass

func _on_NPC_body_enter( body ):
	dialogue_helper.set_character_name(character_name)
	dialogue_popup.popup()


func _on_NPC_body_exit( body ):
	dialogue_popup.hide()

func get_char_sprite():
	return character_sprite