# loosely based off the Godot Kinematic Demos 
extends KinematicBody2D

const FALL_SPEED = 15.0
const MAX_FALL_SPEED = 250

const WALK_SPEED = 150
const JUMP_SPEED = -300

var velocity = Vector2(0, FALL_SPEED)

var can_jump=false
var pause = false
var sprite 


func _ready():
	#Initalization here
	sprite = get_node("sprite")
	set_fixed_process(true)
	pass


func _fixed_process(delta):

	
	calculate_velocity()
	
	var motion = velocity * delta

	# Check if KinematicBody2D is colliding
	if (is_colliding()):
		# Get normal of colliding object
		var normal = get_collision_normal()
		
		# If normal is UP, character is on the ground. So the character can jump.
		if (normal == Vector2(0,-1) ):
			can_jump = true
			velocity.y = 0
		
		# On colliding, the player stops. 
		# If we want to move while colliding (ie. walk), we "slide" from 
		# from the stopped point along the normal.
		motion = normal.slide(motion)
		move(motion)
		
	
	move(motion)

func calculate_velocity():
	var walk_left = Input.is_action_pressed("move_left") && !pause
	var walk_right = Input.is_action_pressed("move_right") && !pause
	var jump = Input.is_action_pressed("jump") && can_jump && !pause

		
	if (walk_left):
		move_left()
	elif (walk_right):
		move_right()
	else:
		velocity.x = 0
		
	
	if (jump):
		jump()
		
	if velocity.y < MAX_FALL_SPEED :
		velocity.y += FALL_SPEED

func jump():
	can_jump = false
	velocity.y = JUMP_SPEED

func move_left():
	sprite.set_flip_h(true)
	
	velocity.x = -WALK_SPEED

func move_right():
	sprite.set_flip_h(false)
		
	velocity.x = WALK_SPEED

func pause():
	pause = !pause


