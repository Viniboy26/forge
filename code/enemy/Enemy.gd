extends KinematicBody2D

var direction : Vector2 = Vector2.RIGHT




func _process(delta):
	rotate_body()




func rotate_body() -> void :
	rotation = -direction.angle_to(Vector2.RIGHT)
