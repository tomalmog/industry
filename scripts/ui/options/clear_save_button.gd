extends TextureButton

# The amount to move the button on click
const MOVE_DISTANCE: float = -5.0
const MOVE_DURATION: float = 0.1  # Time in seconds to complete the movement

func _ready() -> void:
	# Connect the button press signal to the save function
	self.pressed.connect(toggle_confirm_panel)
	toggle_confirm_panel()

# Called when the save button is pressed
func toggle_confirm_panel() -> void:
	
	var panel = get_node("../../../ConfirmControl/Panel")
	panel.visible = !panel.visible

	# Example: Collect data to save (replace this with your actual game state)
	
