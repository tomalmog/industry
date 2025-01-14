extends Button

# Pre: none
# Post: none
# Description: connects hide panel function to self.pressed
func _ready():
	pressed.connect(hide_panel)

# Pre: none
# Post: none
# Description: connects hide panel function to self.pressed
func hide_panel():
	# get parent node and hide it
	var panel = get_parent()
	panel.hide()
