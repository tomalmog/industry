extends TextureButton

# The amount to move the button on click
const MOVE_DISTANCE: float = -5.0
const MOVE_DURATION: float = 0.1  # Time in seconds to complete the movement

func _ready() -> void:
	# Connect the button press signal to the save function
	self.pressed.connect(save_game_data)

# Called when the save button is pressed
func save_game_data() -> void:
	# Move the button up and back down

	# Example: Collect data to save (replace this with your actual game state)
	SaveDataManager.save_game_data()
