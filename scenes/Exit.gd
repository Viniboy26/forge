extends Area2D


var can_interact : bool = false

var player = null

var magic_ores : int = 0

export var exit_limit : int = 10

func _input(event):
	if event.is_action_released("interact") and player != null:
		
		# Give Magic ores to elevator
		magic_ores += player.give_magic_to_exit()
		
		
		# Update visual
		get_parent().get_node("Label").text = String(magic_ores) + "/" + String(exit_limit)
		
		# Test if we won
		if magic_ores >= exit_limit :
			print("You got out !")
		



func _on_InteractZone_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		


func _on_InteractZone_body_exited(body):
	if body.is_in_group("Player"):
		
		player = null
		
