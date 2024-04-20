extends "res://code/world/Torch.gd"


var DISCHARGE_TIME: float = 5
var COOLDOWN_TIME: float = 10
var intensity: float = 0
var last_usage: int = -1
var active: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$RepellerLight.hide()
	light_node = $RepellerLight


func deactivate():
	$RepellerLight.hide()
	$AudioStreamPlayer2D.stop()
	last_usage = Time.get_ticks_msec()
	active = false
		
func activate():
	$RepellerLight.scale = Vector2(1, 1)
	$RepellerLight.show()
	$AudioStreamPlayer2D.play()
	intensity = 1
	active = true
	
func get_cooldown_percentage():
	if last_usage == -1:
		return 0
	return max(COOLDOWN_TIME * 1000 - (Time.get_ticks_msec() - last_usage), 0) / (COOLDOWN_TIME * 1000)


func _process(delta):
	if intensity > 0:
		intensity -= delta / DISCHARGE_TIME
		$RepellerLight.scale = Vector2(intensity, intensity)
		$AudioStreamPlayer2D.volume_db = lerp(-30, 0, intensity)
	
	if intensity <= 0 && active:
		deactivate()
		
	
func use():
	if get_cooldown_percentage() == 0:
		activate()
		
