extends HBoxContainer

# list of building ids corresponding to buttons
var BD = BuildData
var ids = [BD.BELT_ID, BD.HARVESTER_ID, BD.SMELTER_ID, BD.HAMMER_ID, BD.CUTTER_ID, BD.TRASH_ID]
var counter = 0  # tracks the index of the current button

# dictionary to store textures for buildings
var textures = {}

# hover colors for panel backgrounds
var original_color: Color = Color("99999900") 
var hover_color: Color = Color("8B8F9E80")  

# Pre: none
# Post: none
# Description: initializes the container, setting up button connections and hover effects
func _ready():
	# iterate over each panel in the HBoxContainer
	for panel in get_children():
		# retrieve the TextureButton within the panel
		var texture_button = panel.get_children()[0]  # assumes TextureButton is the first child of the panel
		
		# assign the current id to the button and connect its pressed signal
		var id = ids[counter]
		texture_button.pressed.connect(func(): button_pressed(id))
		
		# connect hover signals for the panel
		panel.mouse_entered.connect(func(): on_panel_mouse_entered(panel))
		panel.mouse_exited.connect(func(): on_panel_mouse_exited(panel))
		
		# set the button's texture to the corresponding building icon
		texture_button.texture_normal = BuildData.get_building_icon(id)
		
		# increment the counter to process the next id
		counter += 1

# Pre: building_id is a valid id corresponding to a building
# Post: none
# Description: handles the logic when a button is pressed, selecting the appropriate building
func button_pressed(building_id: int):
	BuildSelection.building_selected(building_id)

# Pre: panel is a valid Panel node
# Post: none
# Description: updates the panel's background color when hovered over
func on_panel_mouse_entered(panel: Panel):
	panel.get_theme_stylebox("panel").bg_color = hover_color

# Pre: panel is a valid Panel node
# Post: none
# Description: restores the panel's original background color when the hover ends
func on_panel_mouse_exited(panel: Panel):
	panel.get_theme_stylebox("panel").bg_color = original_color
