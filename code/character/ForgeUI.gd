extends PanelContainer


onready var hammer_pickup = preload("res://code/tools/gather/HammerPickup.tscn")
onready var pickaxe_pickup = preload("res://code/tools/gather/PickaxePickup.tscn")
onready var sledge_pickup = preload("res://code/tools/gather/SledgePickup.tscn")

onready var current_pickup = hammer_pickup


var progress_speed : int = 2

var forge_threshold : int = 60

var max_progress : int = 100

var up : bool = true



var steps : int = 2
var recipe_step : int = 0


onready var current_recipe = $VBoxContainer/VBoxContainer/Recipe
var current_ore : int = 0


func _physics_process(delta):
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
	if event.is_action_pressed("attack") and visible :
		# Test if we have enough resources for the recipe
		var amount_needed = current_recipe.get_children().size()
		
		if true : #Globals.ores[current_ore] >= amount_needed:
			
			# Test if we're in the correct range
			var progress = $VBoxContainer/CenterContainer/TextureProgress.value
			if progress > forge_threshold :
				
				current_recipe.get_children()[recipe_step].pressed = true
				
				# Go to next ore
				recipe_step += 1
				
				if recipe_step >= current_recipe.get_children().size() :
					# Recipe completed
					$VBoxContainer/Label.text = "Forged !"
#					print("Recipe done !")
					recipe_step = 0
					
					# Reset every check box from the recipe
					for checkbox in current_recipe.get_children() :
						checkbox.pressed = false
					
					
					$Forged.play()
					
					# Drop the pickup
					var new_pickup = current_pickup.instance()
					var player = get_tree().get_nodes_in_group("Player")[0]
					new_pickup.global_position = player.global_position + Vector2(0, 50)
					
					var world = player.get_parent().get_node("Interactables")
#					print("World : ", world)
					world.add_child(new_pickup)
					
					# Hide ourselves
					hide()
				else:
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
				current_recipe.get_children()[recipe_step].pressed = false
				
				# Reset every check box from the recipe
				for checkbox in current_recipe.get_children() :
					checkbox.pressed = false
				
				$FalseHit.play()
				
				$VBoxContainer/Label.text = "Failed"
#				print("Recipe failed !")
				recipe_step = 0
			
			
			
			
			# Decrease the ore
			Globals.ores[current_ore] -= 1
			
			# UGLYYYYYYYY (grab UI and update ores)
			get_parent().get_node("Resources").get_children()[current_ore].get_node("Label").text = String(Globals.ores[current_ore])
			
			
			
		else:
			$VBoxContainer/Label.text = "Not enough Ores"
			# We don't have enough resources for this recipe
#			print("Not enough !")


# ======== Switch recipes ========
func _on_Hammer_pressed():
	# Show hammer recipe and switch to it
	current_recipe.hide()
	current_recipe = $VBoxContainer/VBoxContainer/Recipe
	current_recipe.show()
	
	current_pickup = hammer_pickup
	
	$VBoxContainer/Label.text = 'Press "Use Item" to Forge'


func _on_Pickaxe_pressed():
	current_recipe.hide()
	current_recipe = $VBoxContainer/VBoxContainer/Recipe2
	current_recipe.show()
	
	current_pickup = pickaxe_pickup
	
	$VBoxContainer/Label.text = 'Press "Use Item" to Forge'

func _on_SledgeHammer_pressed():
	current_recipe.hide()
	current_recipe = $VBoxContainer/VBoxContainer/Recipe3
	current_recipe.show()
	
	current_pickup = sledge_pickup
	
	$VBoxContainer/Label.text = 'Press "Use Item" to Forge'





# ======== Switch time to forge ========
func _on_IronOre_pressed():
	progress_speed = 2
	current_ore = Globals.Type.IRON


func _on_CopperOre_pressed():
	progress_speed = 4
	current_ore = Globals.Type.COPPER


func _on_TinOre_pressed():
	progress_speed = 4
	current_ore = Globals.Type.TIN


func _on_BronzeOre_pressed():
	progress_speed = 6
	current_ore = Globals.Type.BRONZE


# Close this forge UI
func _on_Close_pressed():
	hide()


func _on_ForgeUI_visibility_changed():
	if visible :
		$VBoxContainer/VBoxContainer/ForgeChoice/Hammer.grab_focus()
		$VBoxContainer/Label.text = "Choose Recipe and Ore"
