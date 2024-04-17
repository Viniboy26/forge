extends Node2D


# Different audio streams for rock_hit


export(int, 20, 100) var damage = 20


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
		var destroyed = area.get_parent().take_damage(damage)
		
		
		# Play a random rock hit sound
		var total_sounds : int = 6
		$HitRock.stream = load("res://assets/sfx/hammer/hit_rock" + String(randi() % total_sounds) + ".wav")
		$HitRock.play()

		# Play destroy sound if it got destroyed after taking this damage
		if destroyed:
			$Destroy.play()
