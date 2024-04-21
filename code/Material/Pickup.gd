extends Area2D

var type : int = 0

func _ready():
	# Show the correct material based on type
	
	$Material.get_children()[type].show()



# Make the player pickup the material
func _on_Pickup_body_entered(body):
	if body.is_in_group("Player"):
#		print("Picked up : ", Globals.type_to_material(type))
		
		body.pickup(type)
		
		# Destroy pickup
		queue_free()
