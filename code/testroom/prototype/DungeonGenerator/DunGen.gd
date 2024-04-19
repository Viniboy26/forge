extends Node


"""
	Script that controls the procedural generated dungeon (Dungeon Generator)
	It will generate the basic rooms and paths to those rooms,
	to get a new dungeon layout every run
	
	We use BSP (Binary Space Partitioning) to generate the rooms and paths
"""


#const cell_size : int = 32
#onready var BspRoom = preload("res://code/testroom/prototype/DungeonGenerator/BspRoom.tscn")

# World dimensions (amount of cells, based on the tileset)
export(int, 100, 800) var world_width = 500
export(int, 80, 600) var world_height = 450



export(int, 1, 15) var bsp_depth = 5


export var center_offset : float = 10.0


var rooms = []
var rooms_to_split = []

var final_rooms = []

var paths = []


var player_room_id = 0
var anvil_room_id = 0

onready var tilemap = $Tilemap



func _ready():
	randomize()
#	generate_dungeon()

func _input(event):
	if event.is_action_released("retry"):
		generate_dungeon()


# Function that generates the basic layout for this run's dungeon (rooms and paths)
func generate_dungeon() -> void :
	rooms.clear()
	paths.clear()
	
	# Generate OuterWalls
#	print("Generating Borders")
	_generate_borders(world_width, world_height)
	
	# Generate the Room for the main world
#	print("Generating World room")
	var roomtree_root = BspRoom.new()
	roomtree_root.width = world_width
	roomtree_root.height = world_height
	
	# Add it to the room array
	rooms.append(roomtree_root)
	print(roomtree_root)
#	rooms_to_split.append(roomtree_root)
	
#	print("Starting BSP")
	_bsp()
	
	
	# Generate Dungeon layout
	_generate_rooms()
	_generate_paths()
	
	
	# Update bitmask area for the world so it draws correctly
	tilemap.update_bitmask_region(Vector2.ZERO, Vector2(world_width, world_height))




func _generate_borders(width : int, height : int) -> void :
	for x in range(width):
		# Horizontal Borders
		tilemap.set_cell(x, 0, Globals.Tiles.WALL)
		tilemap.set_cell(x, height, Globals.Tiles.WALL)
		
		for y in range(height):
			# Vertical Borders
			tilemap.set_cell(0, y, Globals.Tiles.WALL)
			tilemap.set_cell(width, y, Globals.Tiles.WALL)
			
			# Fill the rest with floor
			if x > 0 and x < width and y > 0 and y < height:
				tilemap.set_cell(x, y, Globals.Tiles.WALL)
				
	# Fill the bottom right corner
	tilemap.set_cell(width, height, Globals.Tiles.WALL)



# Main BSP algorithm
func _bsp() -> void :
	for layer in range(bsp_depth) :
		print("Layer : ", layer)
		_split_leafs()



# Function that goes through all the leafs that need to be split,
# generates new ones, and sets the new array of rooms to be split (the new leafs)
func _split_leafs() -> void :
	# Split the main world up into different layers
	
	# A buffer array
	var new_leafs = []
	
	# Split every leaf
	for room in rooms:
		
		# Split if it has no children
		if room.leafs.size() == 0 :
#			print("Splitting room : ", room)
			#room.split()
			
			
			# Make two new rooms based on the new split point, 
			# And if it's horizontal or not
			var room1 = BspRoom.new()
			var room2 = BspRoom.new()
			
			# Set the new leaf's parents
			room1.parent = room
			room2.parent = room
			
			
			# Get the new x and y pos for the rooms
			var split_point : Vector2 = Vector2.ZERO
			if room.horizontal :
				# Test if we can split into two valid rooms
				if room.height > 2 * room.min_height:
					split_point.y = (randi() % (room.height - int(0.4 * room.height))) + int(0.4 * room.height)
					
					# Split with an offset from the middle : middle + [ -1/3 * height ; 1/3 * height]
					split_point.y = (room.height / 2) + (randi() % (2 * (room.height / 4))) - (room.height / 4)
					
					# Set the new leafs' dimensions accordingly
					room1.height = split_point.y
					room2.height = room.height - split_point.y
					
					room1.width = room.width
					room2.width = room1.width
					
#					print("New size : ", split_point.y)
				else :
					print("Too small to split")
#					break
			else:
				if room.width > 2 * room.min_width :
					split_point.x = (randi() % (room.width - int(0.4 * room.width))) + int(0.4 * room.width)
					
					# Split with an offest from the middle
					split_point.x = (room.width / 2) + (randi() % (2 * (room.width / 4))) - (room.width / 4)
					
					room1.width = split_point.x   
					room2.width = room.width - split_point.x
					
					room1.height = room.height
					room2.height = room1.height
					
#					print("New size : ", split_point.x)
				else :
					print("Too small to split")
#					break
			
			# Only generate new rooms if we're able to split
			if split_point != Vector2.ZERO:
#				print("Split point : ", split_point)
				# Set the new room's positions
				room1.room_pos = room.room_pos
				room2.room_pos = room.room_pos + split_point
			
				# Set new leafs' horizontal bool
				room1.horizontal = !room.horizontal
				room2.horizontal = room1.horizontal
			
				room.leafs.append(room1)
				room.leafs.append(room2)
			
				# Append the new rooms to the current array, to go through them the next iteration
				new_leafs.append_array(room.leafs)
	
	
	
	rooms.append_array(new_leafs)
	
	
	# Set the rooms to split to the new leafs we just generated
#	rooms_to_split.clear()
#	rooms_to_split = new_leafs.duplicate()



func _generate_rooms() -> void :
	# Generate a room for every leaf, then set the according area to floor in the tilemap
	for leaf in rooms :
		# Test if it's a leaf (it doesn't have leaves)
		if leaf.leafs.empty() :
			#print("Generating room")
			# Generate a start and end pos for this room
			leaf.generate_room()
			
			# Add this to the final_rooms list, so we can generate more stuff in it by code
			final_rooms.append(leaf)
			
			# Set the cell from start to end pos of this new room to a floor tile
#			print("Room at : ", leaf.room_start, ", with size : ", leaf.room_width, "w, ", leaf.room_height, "h")
			for x in range(1, leaf.room_width):
				for y in range(1, leaf.room_height):
					tilemap.set_cellv(leaf.room_start + Vector2(x,y), Globals.Tiles.FLOOR)
					
					
		else:
			leaf.generate_room()




# Generate paths between the "sister leafs", until we're at the root room
func _generate_paths() -> void :
	for room in rooms :
		# If it has leafs, generate a path between those
		if !room.leafs.empty() :
			var leaf1 = room.leafs[0]
			var leaf2 = room.leafs[1]
			
#			print("Path between leafs : ", leaf1.center, " and ", leaf2.center)
			
			# Append a list of the 2 centers to the path list
			paths.append([leaf1.center, leaf2.center])
	
	
	# Go through every path and generate floor tiles
	for path in paths :
		var start_pos = path[0]
		var end_pos = path[1]
		
		var x_range = end_pos.x - start_pos.x
		var y_range = end_pos.y - start_pos.y
#		print("Xs : ", x_range)
#		print("Ys : ", y_range)
		
		
		for x in range(x_range) :
#			print("Setting x floor : ", start_pos + Vector2(x,0))
			tilemap.set_cellv(start_pos + Vector2(x , 0), Globals.Tiles.FLOOR)
			
			# Add one layer above and below
			tilemap.set_cellv(start_pos + Vector2(x ,-1), Globals.Tiles.FLOOR)
			tilemap.set_cellv(start_pos + Vector2(x , 1), Globals.Tiles.FLOOR)
			
		
		for y in range(y_range) :
#			print("Setting y floor : ", start_pos + Vector2(0,y))
			tilemap.set_cellv(start_pos + Vector2(0 , y), Globals.Tiles.FLOOR)
			
			# Add one layer to the left and right
			tilemap.set_cellv(start_pos + Vector2( 1 , y), Globals.Tiles.FLOOR)
			tilemap.set_cellv(start_pos + Vector2(-1 , y), Globals.Tiles.FLOOR)
			



func get_spawn_position() -> Vector2 :
	player_room_id = randi() % (final_rooms.size())
#	print("Final rooms size : ", final_rooms.size())
#	print("Player room : ", player_room_id)
	
	return final_rooms[player_room_id].center
	


func get_anvil_position() -> Vector2 :
	anvil_room_id = randi() % (final_rooms.size())
	
	# Don't make it the same room as the player
	while(anvil_room_id == player_room_id):
		anvil_room_id = randi() % (final_rooms.size())
		
	
	return final_rooms[anvil_room_id].center
	
