extends TextureButton


# set direction and cutoff for alphda modulation
var direction = -1  
var cutoff = 0.5  

# reference to the tutorial panel node
var tutorial_panel  

# Pre: none
# Post: none
# Description: initializes the button by setting up connections and referencing the tutorial panel
func _ready():
	# get the reference to the tutorial panel node
	tutorial_panel = get_node("../../../../CanvasLayer/ControlsControl/TutorialPanel")
	
	# connect the button's pressed signal to toggle the tutorial visibility
	pressed.connect(toggle_tutorial)

# Pre: delta is a float representing the time elapsed since the previous frame
# Post: none
# Description: handles the strobe animation by modulating the alpha of the button
func _process(delta: float):
	# check if the tutorial has not been opened before in this save
	if WorldManager.get_tutorial_data()[0] == false:
		# adjust the alpha value based on the current direction
		if direction == 1:
			modulate.a += delta
		else:
			modulate.a -= delta
			
		# reverse direction if alpha exceeds bounds
		if modulate.a > 1:
			direction = -1
		elif modulate.a < cutoff:
			direction = 1

# Pre: none
# Post: none
# Description: shows or hides the tutorial panel and updates the relevant state in the WorldManager
func toggle_tutorial():
	# update the tutorial's has_been_activated state
	WorldManager.set_tutorial_data(true, 0)
	
	# toggle the visibility of the tutorial panel
	tutorial_panel = get_node("../../../../CanvasLayer/ControlsControl/TutorialPanel")
	tutorial_panel.visible = !tutorial_panel.visible
	
	# update the tutorial visibility state in the WorldManager
	if tutorial_panel.visible:
		WorldManager.set_tutorial_data(true, 1)
	else:
		WorldManager.set_tutorial_data(false, 1)
