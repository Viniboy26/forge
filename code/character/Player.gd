extends KinematicBody2D

onready var primary = null


# Player speed
var speed = 200

# Iron, Copper, Tin, Bronze, Magic
var ores = [0, 0, 0, 0, 0]


var last_dir : Vector2 = Vector2.UP



func _ready():
	primary = $Primary/Hammer
	
	# Set ores in UI
	var type : int = 0
	for ore in $UI/Control/Resources.get_children():
		ore.get_node("Label").text = String(Globals.ores[type])
		
		type += 1 



func _process(delta):
	
	
	var direction = _move_input()
	if direction != Vector2.ZERO:
		last_dir = direction
		
	# Move the character
	move_and_slide(direction)
	
	# Rotate the character
	rotate_character(last_dir)


func _input(event):
	if event.is_action_pressed("attack"):
		if primary :
			primary.attack()


func _move_input() -> Vector2 :
	var motion = Vector2.ZERO
	
	# Construct motion vector from joystick input
	if Input.is_joy_known(0):
		# Get joystick axis values for controller 1 (index 0)
		var joy_x = Input.get_joy_axis(0, JOY_AXIS_0)  # Left joystick X axis
		var joy_y = Input.get_joy_axis(0, JOY_AXIS_1)  # Left joystick Y axis
	
		motion.x = joy_x
		motion.y = joy_y
	else:
		# Else we take keyboard commands
		if Input.is_action_pressed("left"):
			motion.x = -1
		if Input.is_action_pressed("right"):
			motion.x =  1
		if Input.is_action_pressed("up"):
			motion.y = -1
		if Input.is_action_pressed("down"):
			motion.y =  1
		
		
	# Normalize the motion vector to ensure consistent speed in all directions
	if motion.length() > 0:
		motion = motion.normalized() * speed
		
	return motion
	


func rotate_character(direction : Vector2) -> void :
	rotation = -direction.angle_to(Vector2.UP)


func _interact() -> void :
	pass
	


func pickup(type) -> void :
	# Increase the ore type, and update the UI
	Globals.ores[type] += 1
	
	$UI/Control/Resources.get_children()[type].get_node("Label").text = String(Globals.ores[type])
	
	$Pickup.play()

