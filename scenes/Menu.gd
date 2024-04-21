extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
#	$DunGen.generate_dungeon()
	$PanelContainer/Buttons/Button4.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Start main game and change ores
func _on_Button_pressed():
	Globals.ores = [2, 1, 1, 0, 0]
	SceneHandler.go_to(SceneHandler.forge_room)



# Go to Tutorial room and change ores
func _on_Button4_pressed():
	Globals.ores = [50, 50, 50, 0, 0]
	SceneHandler.go_to(SceneHandler.test_room)
