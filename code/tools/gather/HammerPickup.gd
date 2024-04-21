extends Area2D


onready var tool_pickup = preload("res://code/tools/gather/Hammer.tscn")

var player = null

var stats : Vector2 = Vector2.ZERO
var durability : int = 0
var damage : int = 0


func _input(event):
	if event.is_action_pressed("interact") and player != null:
		if player.get_node("Tools").get_child_count() < player.inventory_size :
			player.give_tool(tool_pickup, stats)
			queue_free()
		else :
			print("Inventory full !")


func _on_HammerPickup_body_entered(body):
	if body.is_in_group("Player"):
		player = body
#		player.give_tool(tool_pickup, stats)
#		queue_free()
		
		
#		body.give_tool(tool_pickup)
#		queue_free()
		


func _on_HammerPickup_body_exited(body):
	if body.is_in_group("Player"):
		player = null
