extends Node2D


# Different audio streams for rock_hit

export var player_offset : Vector2 = Vector2.RIGHT


export(int, 20, 10000) var damage = 20
export(int, 15, 1000) var durability = 20


var swinging : bool = false


var listening_enemies = []

func attack() -> void:
	swing()


func swing() -> void :
	# Only swing if it's not playing
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("swing")
		
		



# Hit the ore
func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("Ore") or area.get_parent().is_in_group("Spawner"):
		var destroyed = area.get_parent().take_damage(damage)
		
		
		# Play a random rock hit sound
		var total_sounds : int = 6
		$HitRock.stream = load("res://assets/sfx/hammer/hit_rock" + String(randi() % total_sounds) + ".wav")
		$HitRock.play()
		
		# Attract enemies in the listening area
		for enemy in listening_enemies :
			enemy.check_out(global_position)
		
		# Play destroy sound if it got destroyed after taking this damage
		if destroyed:
			$Destroy.play()
			
		# Reduce durability
		durability -= 1
		
		# Check if we destroy the object
		if durability <= 0 :
			var player = get_tree().get_nodes_in_group("Player")[0]
			player.primary = null
			player.switch_tool()
			queue_free()


func _on_Area2D_area_exited(area):
	pass # Replace with function body.



# Add enemies that can hear the sound
func _on_SoundArea_body_entered(body):
	if body.is_in_group("Enemy"):
		# Add enemy to listening group
		listening_enemies.append(body)


func _on_SoundArea_body_exited(body):
	if body.is_in_group("Enemy"):
		# Remove this enemy from the listening group
		listening_enemies.remove(listening_enemies.rfind(body))
