extends Node2D

var COOLDOWN_TIME = 5
var cooldown = load("res://code/tools/gadgets/Cooldown.gd").new()
var sound_mine = preload("res://code/tools/gadgets/SoundMine/SoundMine.tscn")

func use():
	if cooldown.get_cooldown_percentage(COOLDOWN_TIME) == 0:
		var sound_mine_instance = sound_mine.instance()
		var player = get_tree().get_nodes_in_group("Player")[0]
		sound_mine_instance.position = player.position
		player.get_parent().get_node("Interactables").add_child(sound_mine_instance)
		cooldown.trigger()
