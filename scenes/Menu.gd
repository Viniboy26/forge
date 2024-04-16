extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
#	$DunGen.generate_dungeon()
	$Buttons/Button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	SceneHandler.go_to(SceneHandler.forge_room)
