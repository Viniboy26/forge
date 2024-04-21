extends Node2D
class_name Torch

var enemies_in_area = []


var player = null
var light_node = null

func _ready():
	light_node = $Light2D2

func _physics_process(delta):
	if light_node != null && not light_node.is_visible_in_tree():
		return
		
	if is_instance_valid(player) :
		player.restore_sanity()
		
	
	# Repel enemies in light
	for enemy in enemies_in_area :
		enemy.repel(global_position)

func _on_DetectionArea_body_entered(body):
	# Restore sanity to player
	if body.is_in_group("Player"):
		player = body
		
	# 
	elif body.is_in_group("Enemy"):
		body.repelled = true
		enemies_in_area.append(body)
		
func _on_DetectionArea_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		
	# Remove enemy from list to repel 
	elif body.is_in_group("Enemy"):
		body.repelled = false
		enemies_in_area.remove(enemies_in_area.rfind(body))
