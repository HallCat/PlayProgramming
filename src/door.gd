
extends Area2D 
# member variables here, example:
# var a=2
# var b="textvar"
export(String, FILE, ".scn") var level_path

var door_width = 16

var up_pressed = false
var collide = false

var to_pos = Vector2(0, 0)


func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	up_pressed = Input.is_action_pressed("move_up")
	
	if up_pressed and collide:
		get_node("/root/global").goto_scene(level_path)
		
		# circular-ish dependency on purpose to connect doors to each other
		to_pos = get_node("/root/global").get_current_scene().get_node("Door").get_pos()
		to_pos.x += door_width
		get_node("/root/global").move_player(to_pos)




func _on_Door_body_enter( body ):
	collide = true

func _on_Door_body_exit( body ):
	collide = false
