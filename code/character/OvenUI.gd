extends PanelContainer


onready var bronze_pickup = preload("res://code/Material/Pickup.tscn")

onready var current_pickup = bronze_pickup


var progress_speed : float = 0.5

var forge_threshold : float = 70

var max_progress : float = 100.0

var up : bool = true



var steps : int = 2
var recipe_step : int = 0


var current_ore : int = 0


# Stats for the final forged tool
var final_damage : int = 0
var final_durability : int = 0


func _physics_process(delta):
	if Input.is_action_pressed("attack") and visible :
		update_bar()
	
	



# Make the progress bar go up and down
func update_bar() -> void :
	if up :
		$VBoxContainer/CenterContainer/TextureProgress.value += progress_speed
		
		up = ($VBoxContainer/CenterContainer/TextureProgress.value < max_progress)
	else:
		$VBoxContainer/CenterContainer/TextureProgress.value -= progress_speed
		
		up = ($VBoxContainer/CenterContainer/TextureProgress.value <= 0)
#	$VBoxContainer/TextureProgress.value %= max_progress



func _input(event):
	if event.is_action_released("attack") and visible :
		# Test if we have enough resources for the recipe
		
		# Test if we have 1 of each
		if Globals.ores[Globals.Type.COPPER] > 0 and Globals.ores[Globals.Type.TIN] :
			
			# Test if we're in the correct range
			var progress = $VBoxContainer/CenterContainer/TextureProgress.value
			if progress > forge_threshold :
				# Make a bronze with 1 copper and 1 tin
				
#				Globals.ores[Globals.Type.BRONZE] += 1
				
				
				
				$VBoxContainer/Label.text = "Forged !"
#					
					
					
				$Forged.play()
					
				# Drop the pickup
				var new_pickup = current_pickup.instance()
				var player = get_tree().get_nodes_in_group("Player")[0]
				new_pickup.global_position = player.global_position + Vector2(0, 80)
				
				# Give it the bronze type
				new_pickup.type = Globals.Type.BRONZE
					
				var world = player.get_parent().get_node("Interactables")
#				print("World : ", world)
				world.add_child(new_pickup)
					
				# Hide ourselves
				hide()
				
				var message : String = "Ok"
				if progress > 90 :
					message = "Perfect Hit !"
				elif progress > 80 :
					message = "Nice !"
				elif progress > 70 :
					message = "Good"
				
				$VBoxContainer/Label.text = message
				
				$CorrectHit.play()
					
			else:
				# Destroy ores and restart
				
				$FalseHit.play()
				
				$VBoxContainer/Label.text = "Failed"
			
			
			
			
			# Decrease the ore
			Globals.ores[Globals.Type.COPPER] -= 1
			Globals.ores[Globals.Type.TIN] -= 1
			
			# UGLYYYYYYYY (grab UI and update ores)
			get_parent().get_node("Resources/Copper/Label").text = String(Globals.ores[Globals.Type.COPPER])
			get_parent().get_node("Resources/Tin/Label").text = String(Globals.ores[Globals.Type.TIN])
			
			
			
		else:
			$VBoxContainer/Label.text = "Not enough"
			# We don't have enough resources for this recipe
#			print("Not enough !")





# Close this forge UI
func _on_Close_pressed():
	hide()





func _on_OvenUI_visibility_changed():
	$VBoxContainer/CenterContainer/TextureProgress.value = 0
	
	$VBoxContainer/Label.text = 'Hold "Swing"'
