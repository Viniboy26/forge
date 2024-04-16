extends Node


onready var menu = preload("res://scenes/Menu.tscn")
onready var forge_room = preload("res://scenes/ForgeRoom.tscn")
onready var dungeon = preload("res://code/testroom/TestDungeon.tscn")

onready var last_scene = null
onready var current_scene = null


func _ready():
	current_scene = menu

func go_to(scene) -> void :
	last_scene = current_scene
	current_scene = scene
	
	get_tree().change_scene_to(current_scene)
