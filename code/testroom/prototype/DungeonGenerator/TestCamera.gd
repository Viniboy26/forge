extends Camera2D

# Settings
var zoom_speed: float = 0.05  # Zoom sensitivity
var min_zoom: Vector2 = Vector2(1, 1)  # Minimum zoom level
var max_zoom: Vector2 = Vector2(8, 8)  # Maximum zoom level

var dragging: bool = false  # Flag to check if dragging is happening
var drag_last_position: Vector2  # Last position of the cursor when dragging

func _ready():
	# Make sure the camera is the active camera
#	self.current = true
	global_position.x = (get_parent().world_width * Globals.cell_size / 2.0) - 400
	global_position.y = (get_parent().world_height * Globals.cell_size / 2.0) - 800

func _input(event):
	# Handle zooming with mouse wheel
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			_zoom(-zoom_speed)
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			_zoom(zoom_speed)
		elif event.button_index == BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				drag_last_position = event.position  # Record the start position of the drag
			else:
				drag_last_position = Vector2()  # Reset when the button is released

	# Handle camera movement by dragging
	if event is InputEventMouseMotion and dragging:
		var drag_current_position = event.position
		var drag_offset = drag_last_position - drag_current_position
		position += drag_offset
		drag_last_position = event.position  # Update the last position for smooth dragging

func _zoom(amount: float):
	# Adjust the zoom factor
	zoom.x = clamp(zoom.x + amount, min_zoom.x, max_zoom.x)
	zoom.y = clamp(zoom.y + amount, min_zoom.y, max_zoom.y)
