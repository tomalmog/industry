extends HBoxContainer

# set colors for hover effect
var original_color: Color = Color(1, 1, 1)
var hover_color: Color = Color(1, 1, 1, 0.7)

# Pre: none
# Post: none
# Description: connects mouse_entered and mouse_exited signals for all child buttons
func _ready():
	# iterate through all child nodes of this container
	for button in get_children():
		# connect the mouse_entered signal to the _on_mouse_entered function
		button.connect("mouse_entered", Callable(self, "on_mouse_entered").bind(button))
		# connect the mouse_exited signal to the _on_mouse_exited function
		button.connect("mouse_exited", Callable(self, "on_mouse_exited").bind(button))

# Pre: button is a valid Control node
# Post: none
# Description: changes the button color when the mouse hovers over it
func on_mouse_entered(button: Control):
	# update the button's modulate property to the hover color
	button.modulate = hover_color

# Pre: button is a valid Control node
# Post: none
# Description: resets the button color when the mouse stops hovering over it
func on_mouse_exited(button: Control):
	# reset the button's modulate property to the original color
	button.modulate = original_color
