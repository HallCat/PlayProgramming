
extends Area2D 

export(String, FILE, ".scn") var level_path

var _DOOR_WIDTH = 16

var _up_pressed = false
var _colliding = false

var _new_position = Vector2(0, 0)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	_up_pressed = Input.is_action_pressed("move_up")
	
	if _up_pressed and _colliding:
		get_node("/root/global").goto_scene(level_path)
		
		# circular-ish dependency on purpose to connect doors to each other
		_new_position = get_node("/root/global").get_current_scene().get_node("Door").get_pos()
		_new_position.x += _DOOR_WIDTH
		get_node("/root/global").move_player(_new_position)

func _on_Door_body_enter( body ):
	_colliding = true

func _on_Door_body_exit( body ):
	_colliding = false
