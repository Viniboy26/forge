extends KinematicBody2D

onready var primary = null
onready var current_tool : int = 0

export var inventory_size : int = 2


onready var sanity : int = 100


# Player speed
var speed = 200

# Iron, Copper, Tin, Bronze, Magic
var ores = [0, 0, 0, 0, 0]


var last_dir : Vector2 = Vector2.UP

var lost = false



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
	if Globals.sanity > 0.0 :
		pass
	var direction = _move_input()
	if direction != Vector2.ZERO:
		last_dir = direction
		
		#Walk sound
		if $AnimationPlayer.assigned_animation != "Transform" :
			$AnimationPlayer.play("walk")
		
		rotate_character(direction)
	else:
		if $AnimationPlayer.assigned_animation == "walk":
		# Stop walk sound
			$AnimationPlayer.stop()
			$AudioStreamPlayer.stop()
#			move_and_slide(Vector2.ZERO)
			
	# Move the character
	move_and_slide(direction)
		
		# Rotate the character


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
	
#		print(motion)
		if joy_x != 0 :
			motion.x = joy_x
		else :
			motion.x = 0
		if joy_y != 0 :
			motion.y = joy_y
		else :
			motion.y = 0
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
	
#	print("New stats : ", stats)
	
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






# Sanity gets drained when enemy gets close, and our speed gets slowed
func drain_sanity() -> void :
	if Globals.sanity > 0.0 :
		Globals.sanity -= 0.5
		
#		$CPUParticles2D.emitting = true
		
		get_parent().sanity_check()
	else :
		# Swap to ghost body
		if !lost and $AnimationPlayer.assigned_animation != "Transform":
			$AnimationPlayer.play("Transform")
#			print("You got lost !")
		



func restore_sanity() -> void :
	if Globals.sanity < 100.0 :
		Globals.sanity += 0.25
		
		
#		$CPUParticles2D.emitting = false
		
		get_parent().sanity_check()
		



# Give magic ores to the exit, to reconstruct it
func give_magic_to_exit() -> int :
	var magic_ores : int = Globals.ores[Globals.Type.MAGIC]
	
	# Set them to 0 and update UI
	Globals.ores[Globals.Type.MAGIC] = 0
	$UI/Control/Resources/Magic/Label.text = String(0)
	
	# Return the original amount
	return magic_ores




# Pop lose UI on lose animation finished
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Transform" :
		# Pause the game and show lose UI
#		get_tree().paused = true
		lost = true
		$UI/Control/LoseUI.show()
		$UI/Control/LoseUI/VBoxContainer/HBoxContainer/Retry.grab_focus()



# Retry or go to menu
func _on_Retry_pressed():
	Globals.reset_variables()
	SceneHandler.go_to(SceneHandler.forge_room)


func _on_Home_pressed():
	Globals.reset_variables()
	SceneHandler.go_to(SceneHandler.menu)
	get_tree().paused = false


func _on_Back_pressed():
	# Unpause game and hide PauseUI
	$UI/Control/PauseUI.hide()
	get_tree().paused = false
