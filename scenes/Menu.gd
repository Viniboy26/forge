extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
#	$DunGen.generate_dungeon()
	$PanelContainer/Buttons/Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	SceneHandler.go_to(SceneHandler.forge_room)
