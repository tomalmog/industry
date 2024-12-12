extends Camera2D

# Movement speed for panning the camera
@export var pan_speed: float = 600.0
@export var speed_multiplier: float = 3

# Zoom limits and speed
@export var zoom_speed: float = 0.1
@export var min_zoom: Vector2 = Vector2(0.5, 0.5)  # Maximum zoom-in
@export var max_zoom: Vector2 = Vector2(3, 3)      # Maximum zoom-out


func _process(delta):
	# Camera panning
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if Input.is_action_pressed("speed_up"):
		input_direction *= speed_multiplier
		
	if Input.is_action_just_pressed("center"):
		position = Vector2(0, 0)
	
	position += input_direction * pan_speed * delta

	# Camera zooming (mouse wheel or custom input)
	if Input.is_action_just_pressed("zoom_in"):
		zoom_camera(zoom_speed)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_camera(-zoom_speed)



	# Mouse wheel zoom support
	#var scroll_input = Input.get_mouse_scroll_y()
	#if scroll_input != 0:
		#zoom_camera(scroll_input * zoom_speed * -0.1)

func zoom_camera(delta_zoom: float):
	# Adjust zoom while clamping to min/max limits
	var new_zoom = zoom + Vector2(delta_zoom, delta_zoom)
	zoom.x = clamp(new_zoom.x, min_zoom.x, max_zoom.x)
	zoom.y = clamp(new_zoom.y, min_zoom.y, max_zoom.y)
	
	
