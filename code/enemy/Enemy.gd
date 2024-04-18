extends KinematicBody2D

var direction : Vector2 = Vector2.RIGHT


export var min_move_wait_time : float = 2.0
export var max_move_wait_time : float = 10.0



var move_speed : float = 100

var chasing : bool = false
var chase_speed : float = 150


var location : Vector2 = Vector2.ZERO

func _ready():
	randomize()
	
	location = global_position
	
	# Give random time to timers
	$LocationTimer.wait_time = 0
	$LocationTimer.start()


func _process(delta):
	rotate_body()




func _physics_process(delta):
	
	# Get distance to new location to see if we have to move
	var new_dir = (location - global_position)
	
#	print("Aspect : ", new_dir.length())
	if new_dir.length() > 10.0 :
		
#		print("Moving")
		# Get the new direction
		direction = new_dir.normalized()
		
		
		# Get speed based on chasing or not
		var speed = move_speed
		if chasing :
			speed = chase_speed
		# Move to location
		move_and_slide(direction * speed)
	else :
		direction = Vector2.ZERO
#		print("Arrived at location")
		# Else we arrived and start the timer to get a new location
		if !($LocationTimer.time_left > 0.0) :
			$LocationTimer.wait_time = rand_range(min_move_wait_time, max_move_wait_time)
			$LocationTimer.start()
		


func rotate_body() -> void :
	rotation = -direction.angle_to(Vector2.UP)



# Get a new location to go to when the timer runs out, and restart the timer
func _get_location() -> Vector2 :
	randomize()
	var new_position : Vector2 = Vector2.ZERO
	
	
	# Get random position based on a radius and angle
	var radius = (randi() % 15) + 5
	var angle = rand_range(0.0, 180.0)
	
	
	# Convert to cartesian
	new_position.x = radius * cos(deg2rad(angle))
	new_position.y = radius * sin(deg2rad(angle))
	
	
	new_position.x *= Globals.cell_size
	new_position.y += Globals.cell_size


	new_position += global_position
#
#	print("Radius : ", radius)
#	print("Angle : ", deg2rad(angle))
#	print("New position : ", new_position)
	
	return new_position



# Get a new location
func _on_LocationTimer_timeout():
	location = _get_location()
	
#	# Only get a new locatino if it's in the world limits
#	while out_of_world(location) :
#		location = _get_location()


# Test if in world borders, because we can't go there
func out_of_world(pos : Vector2) -> bool :
	var world = get_parent().get_parent()
	var x_in_bound = (pos.x < (world.width * Globals.cell_size)) and (pos.x > 0)
	var y_in_bound = (pos.y < (world.height * Globals.cell_size)) and (pos.y > 0)
	var in_bounds = (!x_in_bound or !y_in_bound)
	return !in_bounds
