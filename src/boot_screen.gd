
extends TextureFrame

func _on_timer_timeout():
	get_node("/root/global").goto_scene("res://engine/TitleScreen.scn")
