extends Node


"""
	Script that controls the procedural generated dungeon (Dungeon Generator)
	It will generate the basic rooms and paths to those rooms,
	to get a new dungeon layout every run
	
	We use BSP (Binary Space Partitioning) to generate the rooms and paths
"""

#const cell_size : int = 32


# World dimensions, will be based on cell_size
export(int, 10, 100) var world_width = 30
export(int, 6, 80) var world_height = 30



export(int, 1, 6) var bsp_depth = 1


export var center_offset : float = 10.0


var rooms = []
var rooms_to_split = []


enum Tiles { WALL, FLOOR }
onready var tilemap = $Tilemap



func _ready():
	generate_dungeon()




# Function that generates the basic layout for this run's dungeon (rooms and paths)
func generate_dungeon() -> void :
	# Generate OuterWalls
	_generate_borders(world_width, world_height)
	
	# Generate the Room for the main world
	var roomtree_root = DungeonRoom.new()
	roomtree_root.width = world_width
	roomtree_root.height = world_height
	
	# Add it to the room array
	rooms.append(roomtree_root)
	rooms_to_split.append(roomtree_root)
	
	_generate_rooms()
	
	
	# Update bitmask area for the world so it draws correctly
	tilemap.update_bitmask_region(Vector2.ZERO, Vector2(world_width, world_height))




func _generate_borders(width : int, height : int) -> void :
	for x in range(width):
		# Horizontal Borders
		tilemap.set_cell(x, 0, Tiles.WALL)
		tilemap.set_cell(x, height, Tiles.WALL)
		
		for y in range(height):
			# Vertical Borders
			tilemap.set_cell(0, y, Tiles.WALL)
			tilemap.set_cell(width, y, Tiles.WALL)
			
			# Fill the rest with floor
			if x > 0 and x < width and y > 0 and y < height:
				tilemap.set_cell(x, y, Tiles.FLOOR)
				
	# Fill the bottom right corner
	tilemap.set_cell(width, height, Tiles.WALL)



func _generate_rooms() -> void :
	# Split the main world up into different layers
	
	for layer in range(bsp_depth):
		# Every two steps you split horizontally
		if (layers % 2) == 0:
			var split_point = randi() 
		
		# Else we split vertically
		else:
		
		
