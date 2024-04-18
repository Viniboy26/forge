extends StaticBody2D


onready var enemy = preload("res://code/enemy/Enemy.tscn")

onready var new_pickup = null

var durability : int = 500


export var spawn_time : float = 10.0


var type : int = 0

func _ready():
	# Get a random material assigned, based on rarity
	randomize()
	
	$SpawnTimer.wait_time = spawn_time




func _process(delta):
	
	# Destroy this ore if it's durability gets down to 0
	if !(durability > 0.0) :
		_destroy()






func take_damage(damage : int) -> bool :
	print("Took damage : ", damage)
	durability -= damage
	
	$CPUParticles2D.emitting = true
	
	# Return if it's destroyed or not upon taking damage
	return durability > 0


# Destroy this Spawner and drop the pickup
func _destroy() -> void :
	# Drop Magic ore ?
	if false :
		var new_pickup = new_pickup.instance()
		
		# Set it's variables
		new_pickup.position = position
		new_pickup.type = type
		
		# Add it to the scene
		var world = get_parent()
		world.add_child(new_pickup)
		
		
		print("Spawning Ore : ", new_pickup)
		
		
		
	# Destroy this Spawner
	queue_free()



# Spawn a new enemy
func _on_SpawnTimer_timeout():
	
	var new_enemy = enemy.instance()
	
	new_enemy.global_position = global_position
	
	get_parent().add_child(new_enemy)
