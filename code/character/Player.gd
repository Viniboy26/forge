extends KinematicBody2D

onready var primary = null
onready var current_tool : int = 0

export var inventory_size : int = 2


# Player speed
var speed = 200

# Iron, Copper, Tin, Bronze, Magic
var ores = [0, 0, 0, 0, 0]


var last_dir : Vector2 = Vector2.UP



func _ready():
	# Add the tools from globals
	for new_tool in Globals.tools :
#		print("Adding : ", new_tool)
		new_tool.hide()
		$Tools.add_child(new_tool)
	
	
	if $Tools.get_child_count() > 0:
		current_tool = 0
		primary = $Tools.get_children()[current_tool]
		$Tools.position = primary.player_offset
		primary.show()
	
	# Set ores in UI
	var type : int = 0
	for ore in $UI/Control/Resources.get_children():
		ore.get_node("Label").text = String(Globals.ores[type])
		
		type += 1
		



func _physics_process(delta):
	
	
	var direction = _move_input()
	if direction != Vector2.ZERO:
		last_dir = direction
		
	# Move the character
	move_and_slide(direction)
	
	# Rotate the character
	rotate_character(last_dir)


func _input(event):
	if event.is_action_pressed("attack"):
		if is_instance_valid(primary) :
			primary.attack()
			
	if event.is_action_pressed("switch_tool"):
		switch_tool()
		
		
		
		


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
	


func switch_tool() -> void :
	# Hide current tool
	if is_instance_valid(primary):
		primary.hide()
	
	# Switch secondary to primary, if there is one
	if $Tools.get_child_count() > 0 :
		current_tool += 1
		current_tool %= $Tools.get_child_count()
		
		if $Tools.get_child_count() == 1 :
			current_tool = 0
		
		primary = $Tools.get_children()[current_tool]
		
		
		# Set new tool position
		$Tools.position = primary.player_offset
		# Show current primary
		primary.show()
		
	
	if $Tools.get_child_count() > 1 :
		$Pickup.play()



func pickup(type) -> void :
	# Increase the ore type, and update the UI
	Globals.ores[type] += 1
	
	$UI/Control/Resources.get_children()[type].get_node("Label").text = String(Globals.ores[type])
	
	$Pickup.play()



# Pickup a new tool that you crafted/found
func give_tool(new_tool_scene, stats) -> void :
	var new_tool = new_tool_scene.instance()
	
	# Set stats
	new_tool.durability = stats.x
	new_tool.damage = stats.y
	
	print("New stats : ", stats)
	
	# Swap with current primary if full
	new_tool.hide()
	$Tools.add_child(new_tool)
	
	$Pickup.play()


# Used to save tools across scenes
func save_tools() -> void :
#	print("Saving tools : ", $Tools.get_child_count())
	Globals.tools.clear()
	for new_tool in $Tools.get_children() :
		Globals.tools.append(new_tool.duplicate())

