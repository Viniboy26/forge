extends Node
class_name BspRoom

"""
	Room to use in dungeon generation
	It keeps track of it's children (leafs in the tree)
"""

# The array of child rooms
var leafs = []

var parent = null

var horizontal : bool = false

#const cell_size : int = 32

var width : int = 16 #* Globals.cell_size
var height : int = 10 #* Globals.cell_size


var min_width : int = 16
var min_height : int = 10


var room_pos = Vector2.ZERO


var room_start : Vector2 = Vector2.ZERO
var room_end : Vector2 = Vector2(width, height)

var room_width : int = min_width
var room_height : int = min_height

var center = Vector2.ZERO


func split() -> void :
	# Make two new rooms based on the new split point, 
	# And if it's horizontal or not
#	var room1 = BspRoom.new()
#	var room2 = BspRoom.new()
	
	# Set the new leaf's parents
#	room1.parent = self
#	room2.parent = self
#
#
#	# Get the new x and y pos for the rooms
#	var split_point : Vector2 = Vector2.ZERO
#	if horizontal :
#		split_point.y = (randi() % (height - min_height)) + min_height
#
#		# Set the new leafs' dimensions accordingly
#		room1.height = split_point.y
#		room2.height = width - split_point.y   
#	else:
#		split_point.x = (randi() % (width - min_width)) + min_width
#
#		room1.width = split_point.x   
#		room2.width = width - split_point.x 
#
#
#	# Set the new room's positions
#	room1.room_pos = room_pos
#	room2.room_pos = room_pos + split_point
#
#	# Set new leafs' horizontal bool
#	room1.horizontal = !horizontal
#	room2.horizontal = !horizontal
#
#
#	leafs.append(room1)
#	leafs.append(room2)
	pass


# Called to generate the final room
func generate_room() -> void :
#	randomize()
	var min_x_offset = int(floor(min_width / 4.0))
	var min_y_offset = int(floor(min_height / 4.0))
	
	room_width = min_width - 1
	room_height = min_height - 1
	
	if width - min_width > 0:
		room_width = randi() % (width - room_width) + room_width
	if height - min_height > 0:
		room_height = randi() % (height - room_height) + room_height
	
	
	
	# Generate an offset for every direction, where the room will start and end
#	var left_offset = (randi() % (int(floor(width / 2.0)) - min_x_offset)) + min_x_offset
#	var top_offset = (randi() % (int(floor(height / 2.0)) - min_y_offset)) + min_y_offset
#	var start_offset = Vector2(left_offset, top_offset)
#
#	var right_offset = (randi() % (int(floor(width / 2.0)) - min_x_offset)) + min_x_offset
#	var bottom_offset = (randi() % (int(floor(height / 2.0)) - min_y_offset)) + min_y_offset
#	var end_offset = Vector2(right_offset, bottom_offset)

	# Now set the start and end pos of this room,
	# which will be used to fill send data to the tilemap
	room_end = Vector2(width, height)
	center = room_pos + 0.5 * room_end #Vector2(width / 2, height / 2)
	
	room_start = center - Vector2(room_width / 2, room_height / 2)
	room_end = center + Vector2(room_width / 2, room_height / 2)
#
#	room_start = room_pos
#	room_end = Vector2(width, height)
	
	# Set the room's dimensions
#	room_width = room_end.x - room_start.x
#	room_height = room_end.y - room_start.y
	
#
#	room_width = width
#	room_height = height
