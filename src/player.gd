
extends KinematicBody2D

const FALL_SPEED = 25.0
const MAX_FALL_SPEED = 250

const WALK_SPEED = 150
const JUMP_SPEED = 400

var velocity = Vector2(0, FALL_SPEED)

var can_jump=false
var pause = false

func _fixed_process(delta):
	
	
	var stop = velocity.x!=0.0
	
	var walk_left = Input.is_action_pressed("move_left") && !pause
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump") && can_jump
	

	var stop=true
		
	if (walk_left):
		velocity.x = -WALK_SPEED
		stop=false
	
	elif (walk_right):
		velocity.x = WALK_SPEED
		stop=false
	else:
		velocity.x = 0
		
	
	if (jump):
		can_jump = false
		velocity.y = -JUMP_SPEED
	else :
		if velocity.y < MAX_FALL_SPEED :
			velocity.y += FALL_SPEED
	
	
	var motion = velocity * delta

	#move and consume motion
	move(motion)

	# Check if KinematicBody2D is colliding
	if (is_colliding()):
		
		# Get normal of colliding object
		var normal = get_collision_normal()
		
		# If normal is UP, character is on the ground.
		if (normal == Vector2(0,-1) ):
			can_jump = true
			
		
		# On colliding, the player stops. 
		# If we want to move while colliding (ie. walk), we "slide" from 
		# from the stopped point along the normal.
		velocity = normal.slide(velocity)
		motion = normal.slide(motion)
		move(motion)
	
func pause():
	pause = !pause

func _ready():
	#Initalization here
	set_fixed_process(true)
	pass


