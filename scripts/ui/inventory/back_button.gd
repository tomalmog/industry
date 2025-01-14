extends TextureButton

# colors for hover effect
var original_color: Color = Color(1, 1, 1)  
var hover_color: Color = Color(1, 1, 1, 0.7) 

# Pre: none
# Post: none
# Description: connects mouse signals
func _ready():
	# connects pressed 
	pressed.connect(_on_back_pressed)
	
	# connects mouse entered and mouse exit for hover effect
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# Pre: none
# Post: none
# Description: updates texture on hover
func _on_mouse_entered():
	modulate = hover_color

# Pre: none
# Post: none
# Description: update texture on stop hover
func _on_mouse_exited():
	modulate = original_color

# Pre: none
# Post: none
# Description: returns to main scene
func _on_back_pressed():
	# go back to the main scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	# set gamestate to gameplay state and reload inventory
	WorldManager.set_state(WorldManager.GAMEPLAY_STATE)
	InventoryManager.reload()
