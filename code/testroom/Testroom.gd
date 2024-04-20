extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func sanity_check() -> void :
#	print("Sanity : ", Globals.sanity)
	var darkness = range_lerp(Globals.sanity, 0.0, 100.0, 0.0, 0.15)
#	print("Darkness : ", darkness)
	$CanvasModulate.color.v = darkness
