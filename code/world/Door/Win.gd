extends Area2D


var can_interact : bool = false

var player = null

var magic_ores : int = 0

export var exit_limit : int = 10

func _input(event):
	if event.is_action_released("interact") and player != null:
		
		
		
		# Win game
		player.get_node("AnimationPlayer").play("Win")
		



func _on_InteractZone_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		


func _on_InteractZone_body_exited(body):
	if body.is_in_group("Player"):
		
		player = null
		
