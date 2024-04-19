extends Area2D


onready var tool_pickup = preload("res://code/tools/gather/Hammer.tscn")

var player = null



func _input(event):
	if event.is_action_pressed("interact") and player != null:
		if player.get_node("Tools").get_child_count() < player.inventory_size :
			player.give_tool(tool_pickup)
			queue_free()
		else :
			print("Inventory full !")


func _on_HammerPickup_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		
		
#		body.give_tool(tool_pickup)
#		queue_free()
		


func _on_HammerPickup_body_exited(body):
	if body.is_in_group("Player"):
		player = null
