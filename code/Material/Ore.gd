extends StaticBody2D


onready var pickup = preload("res://code/Material/Pickup.tscn")

var durability : int = 100


# Spawn rates for different ores
export var iron_spawn_rate : float = 0.8
export var copper_spawn_rate : float = 0.1
export var tin_spawn_rate : float = 0.1


var type : int = 0

func _ready():
	# Get a random material assigned, based on rarity
	randomize()
	
	# Add other spawn rates for the correct spawn rate
	copper_spawn_rate += iron_spawn_rate
	tin_spawn_rate += copper_spawn_rate
	
	var probability : float = randf()
	
	if probability < iron_spawn_rate :
		spawn_iron()
	elif probability < copper_spawn_rate :
		spawn_copper()
	elif probability < tin_spawn_rate :
		spawn_tin()
		
	
	# Show the correct type of material
	$Material.get_children()[type].show()




func _process(delta):
	
	# Destroy this ore if it's durability gets down to 0
	if durability <= 0.0 :
		_destroy()




func spawn_iron() -> void:
	# Show iron and hide rest
#	$Material/Iron.show()
	type = Globals.Type.IRON

func spawn_copper() -> void:
#	$Material/Copper.show()
	
	type = Globals.Type.COPPER
	
func spawn_tin() -> void:
#	$Material/Tin.show()
	
	type = Globals.Type.TIN





func take_damage(damage : int) -> bool :
	print("Took damage : ", damage)
	durability -= damage
	
	$CPUParticles2D.emitting = true
	
	# Return if it's destroyed or not upon taking damage
	return durability > 0




# Destroy this ore and drop the pickup
func _destroy() -> void :
	var new_pickup = pickup.instance()
	
	# Set it's variables
	new_pickup.position = position
	new_pickup.type = type
	
	# Add it to the scene
	var world = get_parent()
	world.add_child(new_pickup)
	
	
	print("Spawning Ore : ", new_pickup)
	# Destroy this ore
	queue_free()
