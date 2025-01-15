extends TextureButton

# The amount to move the button on click
const MOVE_DISTANCE: float = -5.0
const MOVE_DURATION: float = 0.1  # Time in seconds to complete the movement

# Pre: none
# Post: none
# Description: connects pressed signal to toggle panel, and initially toggles panel
func _ready():
	pressed.connect(toggle_confirm_panel)
	toggle_confirm_panel()

# Pre: none
# Post: none
# Description: toggles panel visibility
func toggle_confirm_panel():
	# get panel, then set its visibilty to the opposite of what it currently is
	var panel = get_node("../../../ConfirmControl/Panel")
	panel.visible = !panel.visible
