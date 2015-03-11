extends Area2D

export(String) var character_name
export(Texture) var character_sprite

var dialogue_popup
var dialogue_popup_panel

func _ready():
	# Initalization here
	dialogue_popup = get_node("dialogue_popup")
	dialogue_popup_panel = get_node("dialogue_popup/panel")
	
	get_node("Sprite").set_texture(character_sprite)
	get_node("Sprite").set_hframes(character_sprite.get_width() / character_sprite.get_height())
	
	set_fixed_process(true)
	
	pass

func _on_NPC_body_enter( body ):
	dialogue_popup.set_character_name(character_name)
	dialogue_popup_panel.popup()
	
func _on_NPC_body_exit( body ):
	dialogue_popup_panel.hide()

func get_char_sprite():
	return character_sprite
