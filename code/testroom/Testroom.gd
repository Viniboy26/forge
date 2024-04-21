extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func sanity_check() -> void :
#	print("Sanity : ", Globals.sanity)
	var darkness = range_lerp(Globals.sanity, 0.0, 100.0, 0.0, 0.15)
#	print("Darkness : ", darkness)
	$CanvasModulate.color.v = darkness

func _process(delta):
	if Input.is_action_just_pressed("use_gadget"):
#		$TorchGadget.use()
		$SoundMineGadget.use()
