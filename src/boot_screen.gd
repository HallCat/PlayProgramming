extends TextureFrame

# When the timer finishes, change to the title screen.
func _on_timer_timeout():
	get_node("/root/global").goto_scene("res://engine/TitleScreen.scn")
