extends "res://code/world/Torch.gd"


var DISCHARGE_TIME: float = 5
var COOLDOWN_TIME: float = 10
var intensity: float = 0
var active: bool = false
var cooldown = load("res://code/tools/gadgets/Cooldown.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready():
	$RepellerLight.hide()
	light_node = $RepellerLight


func deactivate():
	$RepellerLight.hide()
	$AudioStreamPlayer2D.stop()
	cooldown.trigger()
	active = false
		
func activate():
	$RepellerLight.scale = Vector2(1, 1)
	$RepellerLight.show()
	$AudioStreamPlayer2D.play()
	intensity = 1
	active = true


func _physics_process(delta):
	if intensity > 0:
		intensity -= delta / DISCHARGE_TIME
		$RepellerLight.scale = Vector2(intensity, intensity)
		$AudioStreamPlayer2D.volume_db = lerp(-30, 0, intensity)
	
	if intensity <= 0 and active:
		deactivate()
		
	
func use():
	if not active and cooldown.get_cooldown_percentage(COOLDOWN_TIME) == 0:
		activate()
		
