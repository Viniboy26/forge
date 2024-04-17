extends Node


var ores = [1000, 1000, 1000, 1000, 0]


const cell_size : int = 32

enum Type {
	IRON,
	COPPER,
	TIN,
	BRONZE,
	MAGIC
}

enum Tiles { WALL, FLOOR }

func type_to_material(type : int) -> String :
	match type :
		Type.IRON :
			return "Iron"
		Type.COPPER :
			return "Copper"
		Type.TIN :
			return "Tin"
		Type.BRONZE :
			return "Bronze"
		Type.MAGIC : 
			return "Magic"
	
	# Return unknown if it doesn't match any type
	return "Unknown"


func _input(event) :
	if event.is_action_pressed("full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen
