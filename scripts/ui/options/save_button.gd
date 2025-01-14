extends TextureButton

# The amount to move the button on click
const MOVE_DISTANCE: float = -5.0
const MOVE_DURATION: float = 0.1  # Time in seconds to complete the movement

func _ready() -> void:
	# Connect the button press signal to the save function
	self.pressed.connect(save)

# Called when the save button is pressed
func save() -> void:
	# Move the button up and back down
	move_button()

	# Example: Collect data to save (replace this with your actual game state)
	SaveDataManager.save_game_data()

# Function to move the button
func move_button() -> void:
	# Move the button up
	position.y -= MOVE_DISTANCE

	# Create a timer to move the button back down after a short delay
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = MOVE_DURATION
	timer.one_shot = true
	timer.start()

	# When the timer finishes, move the button back down
	timer.timeout.connect(_on_timer_timeout)

# Function to handle timer timeout signal
func _on_timer_timeout() -> void:
	position.y += MOVE_DISTANCE
