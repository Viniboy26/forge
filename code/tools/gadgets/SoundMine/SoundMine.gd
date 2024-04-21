extends Node2D

var NUMBER_OF_IMPACTS = 5
var COOLDOWN_TIME = 5

var listening_enemies = []
var impacts_left = 0


func _ready():
	impacts_left = NUMBER_OF_IMPACTS
	$Timer.start()
	do_noise()

func do_noise():
	$AudioStreamPlayer2D.play()
	$CPUParticles2D.emitting = true
	$CPUParticles2D.restart()
	# Attract enemies in the listening area
	for enemy in listening_enemies :
		enemy.check_out(global_position)
		
	impacts_left -= 1
	if impacts_left == 0:
		deactivate()

func _on_Timer_timeout():
	do_noise()
	
func deactivate():
	self.queue_free()


# Add enemies that can hear the sound
func _on_SoundArea_body_entered(body):
	if body.is_in_group("Enemy"):
		# Add enemy to listening group
		listening_enemies.append(body)


func _on_SoundArea_body_exited(body):
	if body.is_in_group("Enemy"):
		# Remove this enemy from the listening group
		listening_enemies.remove(listening_enemies.rfind(body))


