extends Node

onready var dungeon_door = preload("res://code/world/Door/DungeonDoor.tscn")





# World dimensions (amount of cells, based on the tileset)
export(int, 100, 800) var width = 500
export(int, 80, 600) var height = 450

export(int, 1, 8) var room_depth = 5



export var ore_spawn_rate : float = 0.05
onready var ore_scene = preload("res://code/Material/Ore.tscn")



func _ready():
	# Generate the dungeon
	$DunGen.world_width = width
	$DunGen.world_height = height
	$DunGen.bsp_depth = room_depth
	$DunGen.generate_dungeon()
	
	# Spawn the ores
	_spawn_ores($DunGen.final_rooms)
	
	
	# Spawn the player at a random room
	$Character.global_position = $DunGen.get_spawn_position() * Globals.cell_size
	
	# Spawn a door to return right on the player
	var return_door = dungeon_door.instance()
	return_door.global_position = $Character.global_position
	
	$Interactables.add_child(return_door)


func _input(event):
	if Input.is_action_just_pressed("switch_camera"):
		if $Character.get_node("Camera2D").current:
			$DunGen.get_node("Camera2D").make_current()
		else:
			$Character/Camera2D.make_current()



func _spawn_ores(rooms) -> void :
	for room in rooms :
		
		for x in range(1, room.room_width):
				for y in range(1, room.room_height):
					if randf() < ore_spawn_rate :
						# Spawn a new ore at this position
						var new_ore = ore_scene.instance()
						var new_position = (room.room_start + Vector2(x,y)) * Globals.cell_size
						print("Spawning ore at : ", new_position)
						new_ore.global_position = new_position
						
						$Interactables.add_child(new_ore)
