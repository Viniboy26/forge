extends KinematicBody2D

# Player speed
var speed = 200

func _process(delta):
	var motion = Vector2.ZERO
	
	# Get joystick axis values for controller 1 (index 0)
	var joy_x = Input.get_joy_axis(0, JOY_AXIS_0)  # Left joystick X axis
	var joy_y = Input.get_joy_axis(0, JOY_AXIS_1)  # Left joystick Y axis
	
	# Construct motion vector from joystick input
	if Input.is_joy_known(0):
		motion.x = joy_x
		motion.y = joy_y
	else:
		if Input.is_action_just_pressed("left"):
			motion.x = -1
		if Input.is_action_just_pressed("right"):
			motion.x =  1
		if Input.is_action_just_pressed("up"):
			motion.x = -1
		if Input.is_action_just_pressed("down"):
			motion.x =  1
		
		
	# Normalize the motion vector to ensure consistent speed in all directions
	if motion.length() > 0:
		motion = motion.normalized() * speed
	
	# Move the character
	move_and_slide(motion)
