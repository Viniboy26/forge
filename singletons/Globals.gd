extends Node


# Stats = (durability, damage)
var ore_stats = [Vector2(10, 10), Vector2(20, 10), Vector2(10, 20), Vector2(50, 50), Vector2(200, 200)]
var ores = [5, 0, 0, 0, 0]



var tools = []



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
