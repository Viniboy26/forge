extends CanvasLayer


func _input(event):
	if event.is_action_pressed("pause") :
		get_tree().paused = !get_tree().paused
		
		$Control/PauseUI.visible = get_tree().paused
		
		if $Control/PauseUI.visible :
			$Control/PauseUI/VBoxContainer/HBoxContainer/Back.grab_focus()


func _on_WinUI_visibility_changed():
	if $Control/WinUI.visible :
		$Control/WinUI/VBoxContainer/HBoxContainer/Retry.grab_focus()
