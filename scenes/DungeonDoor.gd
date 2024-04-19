extends Area2D

var can_enter_door : bool = false

func _input(event):
	if event.is_action_released("interact") and can_enter_door:
		# Save tools across scenes
		get_tree().get_nodes_in_group("Player")[0].save_tools()
		
		# Enter the door
		if SceneHandler.current_scene == SceneHandler.forge_room :
			SceneHandler.go_to(SceneHandler.dungeon)
		else:
			SceneHandler.go_to(SceneHandler.forge_room)



# Enter the dungeon when interact is pressed in this area
func _on_DungeonDoor_body_entered(body):
	if body.is_in_group("Player"):
		can_enter_door = true
		



func _on_DungeonDoor_body_exited(body):
	if body.is_in_group("Player"):
		can_enter_door = false
