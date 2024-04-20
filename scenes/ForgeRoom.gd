extends Node2D


func sanity_check() -> void :
#	print("Sanity : ", Globals.sanity)
	var darkness = range_lerp(float(Globals.sanity), 0.0, 100.0, 0.0, 0.15)
#	print("Darkness : ", darkness)
	$CanvasModulate.color.v = darkness
