extends Camera2D

# set world size
const WORLD_PIXEL_SIZE = 8200

# movement speed for panning the camera
var pan_speed: float = 600.0
var speed_multiplier: float = 3

# zoom limits and speed
var zoom_speed: float = 0.1
var min_zoom: Vector2 = Vector2(0.5, 0.5)  # maximum zoom-in
var max_zoom: Vector2 = Vector2(3, 3)      # maximum zoom-out

# camera bounds
var bounds_min: Vector2 = Vector2(-WORLD_PIXEL_SIZE, -WORLD_PIXEL_SIZE)  # top-left corner of the boundary
var bounds_max: Vector2 = Vector2(WORLD_PIXEL_SIZE, WORLD_PIXEL_SIZE)    # bottom-right corner of the boundary

# pre: none
# post: none
# description: initializes the camera position and zoom from saved data
func _ready():
	var data = WorldManager.get_camera()
	position = data[0]
	zoom = data[1]

# pre: delta is the time elapsed since the last frame
# post: none
# description: updates the camera position and zoom based on user input
func _process(delta: float):
	# camera panning
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if Input.is_action_pressed("speed_up"):
		input_direction *= speed_multiplier
		
	if Input.is_action_just_pressed("center"):
		position = Vector2(0, 0)
	
	position += input_direction * pan_speed * delta
	position = clamp_position(position)  # clamp the position within bounds

	# camera zooming 
	if Input.is_action_just_pressed("zoom_in"):
		zoom_camera(zoom_speed)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_camera(-zoom_speed)

# pre: delta_zoom is the zoom change amount
# post: none
# description: adjusts the zoom while clamping to min/max limits
func zoom_camera(delta_zoom: float):
	# adjust zoom while clamping to min/max limits
	var new_zoom = zoom + Vector2(delta_zoom, delta_zoom)
	zoom.x = clamp(new_zoom.x, min_zoom.x, max_zoom.x)
	zoom.y = clamp(new_zoom.y, min_zoom.y, max_zoom.y)

# pre: pos is the desired camera position
# post: clamped position
# description: clamps the position to stay within the defined bounds
func clamp_position(pos: Vector2) -> Vector2:
	# clamp the position to stay within the defined bounds
	return Vector2(
		clamp(pos.x, bounds_min.x, bounds_max.x),
		clamp(pos.y, bounds_min.y, bounds_max.y)
	)

# pre: none
# post: none
# description: saves the camera position and zoom
func save_camera():
	WorldManager.save_camera(position, zoom)
