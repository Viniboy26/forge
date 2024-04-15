extends Node


# World dimensions (amount of cells, based on the tileset)
export(int, 100, 800) var width = 500
export(int, 80, 600) var height = 450

export(int, 1, 8) var room_depth = 5

func _ready():
	# Generate the dungeon
	$DunGen.world_width = width
	$DunGen.world_height = height
	$DunGen.bsp_depth = room_depth
	$DunGen.generate_dungeon()
	# Spawn the player at a random room
	$Character.global_position = $DunGen.get_spawn_position() * Globals.cell_size


func _input(event):
	if Input.is_action_just_pressed("switch_camera"):
		if $Character.get_node("KinematicBody2D/Camera2D").current:
			$DunGen.get_node("Camera2D").make_current()
		else:
			$Character/KinematicBody2D/Camera2D.make_current()
