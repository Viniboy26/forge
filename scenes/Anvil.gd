extends Area2D


var can_interact : bool = false

var player = null


func _input(event):
	if event.is_action_released("interact") and player != null:
		# Save ores across scenes
		
		# Show forge UI
		if !player.get_node("UI/Control/ForgeUI").visible :
			player.get_node("UI/Control/ForgeUI").show()



func _on_InteractZone_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		


func _on_InteractZone_body_exited(body):
	if body.is_in_group("Player"):
		# Hide the forge UI
		player.get_node("UI/Control/ForgeUI").hide()
		
		player = null
		


# Ping our location
func _on_Timer_timeout():
	get_parent().get_parent().get_node("Ping").play()
	
	# Restart timer
	get_parent().get_parent().get_node("Timer").start()
