extends Node2D


export(int, 20, 100) var damage = 50


var swinging : bool = false




func attack() -> void:
	swing()


func swing() -> void :
	# Only swing if it's not playing
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("swing")



# Hit the ore
func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("Ore"):
		area.get_parent().take_damage(damage)
