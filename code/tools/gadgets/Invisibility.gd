extends Node2D

var COOLDOWN_TIME = 5
var cooldown = load("res://code/tools/gadgets/Cooldown.gd").new()


func use():
	if cooldown.get_cooldown_percentage(COOLDOWN_TIME) == 0:
		var player = get_tree().get_nodes_in_group("Player")[0]
		player.set_invisible()
