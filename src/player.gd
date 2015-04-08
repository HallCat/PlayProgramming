# Loosely based off the Godot Kinematic Demos 
extends KinematicBody2D

# Constants for player speeds. Can be modified to speed up/slow down the game
const FALL_SPEED = 15.0
const WALK_SPEED = 150
const JUMP_SPEED = -300

# Global variables. 
var _velocity = Vector2(0, FALL_SPEED)
var _can_jump=false
var _pause = false
var _sprite 
var _animation_player
var _current_animation = "Idle"


func _ready():
	#Initalization of some instanced objects
	_sprite = get_node("Sprite")
	_animation_player = get_node("AnimationPlayer")
	
	# Start the main loop.
	set_fixed_process(true)
	pass


func _fixed_process(delta):
	# calculate the player's velocity
	calculate_velocity()
	
	var motion = _velocity * delta
	
	# Check if KinematicBody2D is colliding
	if (is_colliding()):
		# Get normal of colliding object
		var normal = get_collision_normal()
		
		# If normal is UP, character is on the ground. So the character can jump.
		if (normal == Vector2(0,-1) ):
			_can_jump = true
			_velocity.y = 0
		
		# On colliding, the player stops. 
		# If we want to move while colliding (ie. walk), we "slide" from 
		# from the stopped point along the normal.
		motion = normal.slide(motion)
		move(motion)
		
	move(motion)
	
	var escape = Input.is_action_pressed("ui_cancel") && !_pause
	
	# if escape has been pressed, return to the title screen.
	if (escape):
		get_node("/root/global").goto_scene("res://engine/TitleScreen.scn")




# Function to calculate the velocity of the player based on user input
func calculate_velocity():
	var walk_left = Input.is_action_pressed("move_left") && !_pause
	var walk_right = Input.is_action_pressed("move_right") && !_pause
	var jump = Input.is_action_pressed("jump") && _can_jump && !_pause

	if (walk_left):
		move_left()
		play_animation("RunningLeft")
	elif (walk_right):
		move_right()		
		play_animation("Running")
	else:
		play_animation("Idle")
		_velocity.x = 0
	
	if (jump):
		jump()
		
	_velocity.y += FALL_SPEED

# Apply jump speed to veloctity. Called on jump.
func jump():
	# Change _can_jump to false to allow user to only jump once.
	_can_jump = false
	_velocity.y = JUMP_SPEED


# Apply negative walk speed to veloctity. Called on left pressed.
func move_left():
	_velocity.x = -WALK_SPEED

# Apply negative walk speed to veloctity. Called on right pressed.
func move_right():
	_velocity.x = WALK_SPEED

# Changes the animation to new_animation
func play_animation(new_animation):
	# Make sure the animation has been changed.
	if new_animation != _current_animation:
		# Set the current animation to the new animation
		_current_animation = new_animation
		# Play the animation
		_animation_player.play(new_animation)

# Used to pause the player, this is to stop the player input from
# interacting with the Text Editor.
func pause_player():
	_pause = !_pause


