extends Node
class_name DungeonRoom

"""
	Room to use in dungeon generation
	It keeps track of it's children (leafs in the tree)
"""

# The array of child rooms
var leafs = []

var horizontal : bool = false

#const cell_size : int = 32

var width = 8 #* Globals.cell_size
var height = 5 #* Globals.cell_size


var room_start : Vector2 = Vector2.ZERO
var room_end : Vector2 = Vector2(width, height)


func split(point : int) -> void :
	# Make two new rooms based on the new split point, 
	# And if it's horizontal or not
	var room1 = Room.new()
	var room2 = Room.new()


# Called to generate the final room
func generate() -> void :
	pass
