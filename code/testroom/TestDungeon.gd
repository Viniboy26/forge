extends Node

onready var dungeon_door = preload("res://code/world/Door/DungeonDoor.tscn")




# World dimensions (amount of cells, based on the tileset)
export(int, 100, 800) var width = 500
export(int, 80, 600) var height = 450

export(int, 1, 8) var room_depth = 5



export var ore_spawn_rate : float = 0.02
onready var ore_scene = preload("res://code/Material/Ore.tscn")



onready var torch_spawn_rate : int = 20
onready var torch_scene = preload("res://code/world/Torch.tscn")



func _ready():
	# Generate the dungeon
	$DunGen.world_width = width
	$DunGen.world_height = height
	$DunGen.bsp_depth = room_depth
	$DunGen.generate_dungeon()
	
	# Spawn the ores
	_spawn_ores($DunGen.final_rooms)
	
	# Spawn the lights
	_spawn_lights($DunGen.paths)
	
	
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



# Spawn ores in the different rooms, except for the room the player spawns in
func _spawn_ores(rooms) -> void :
	var id = 0
	for room in rooms :
		
		# Only spawn if it's not the player's spawn room
		if id != $DunGen.player_room_id:
			for x in range(1, room.room_width):
					for y in range(1, room.room_height):
						if randf() < ore_spawn_rate :
							# Spawn a new ore at this position
							var new_ore = ore_scene.instance()
							var new_position = (room.room_start + Vector2(x,y)) * Globals.cell_size
	#						print("Spawning ore at : ", new_position)
							new_ore.global_position = new_position
							
							$Interactables.add_child(new_ore)
		
		id += 1




func _spawn_lights(paths) -> void :
	randomize()
	for path in paths :
		
		var start_pos = path[0]
		var end_pos = path[1]
		
		var x_range = end_pos.x - start_pos.x
		var y_range = end_pos.y - start_pos.y
#		print("Xs : ", x_range)
#		print("Ys : ", y_range)
		
		
		for x in range(x_range) :
			if x % torch_spawn_rate == 0 :
	#			print("Setting x floor : ", start_pos + Vector2(x,0))
				var new_torch = torch_scene.instance()
				new_torch.position = (start_pos + Vector2(x , 1)) * Globals.cell_size
				
				# Add the torch to the scene
				$Decor.add_child(new_torch)
			
			
		
		for y in range(y_range) :
			if y % torch_spawn_rate == 0 :
	#			print("Setting y floor : ", start_pos + Vector2(0,y))
				var new_torch = torch_scene.instance()
				new_torch.position = (start_pos + Vector2(-1 , y)) * Globals.cell_size
				
				# Add the torch to the scene
				$Decor.add_child(new_torch)
