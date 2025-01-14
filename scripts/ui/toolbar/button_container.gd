extends HBoxContainer

var ids = [2, 3, 4, 5, 6, 9]
var counter = 0

var textures = {}

# Hover colors
var original_color: Color = Color("99999900")  # Default background color
var hover_color: Color = Color("8B8F9E80")  # Hover background color

# Called when the node enters the scene tree for the first time.
func _ready():
	# Iterate over each Panel in the HBoxContainer
	for panel in get_children():
		var texture_button = panel.get_children()[0]  # Assuming the TextureButton is the first child of the Panel
		# Connect the button press signal to the _button_pressed function, passing the corresponding building ID
		var id = ids[counter]
		texture_button.pressed.connect(func(): _button_pressed(id))
		
		# Connect hover signals for the panel
		panel.mouse_entered.connect(func(): _on_panel_mouse_entered(panel))
		panel.mouse_exited.connect(func(): _on_panel_mouse_exited(panel))
		
		
		texture_button.texture_normal = BuildData.get_building_icon(id)
		
		
		
		counter += 1
	pass

func _button_pressed(building_id: int):
	# Call the build selection function with the correct building ID
	BuildSelection.building_selected(building_id)

# Handle hover when mouse enters a panel
func _on_panel_mouse_entered(panel: Panel):
	panel.get_theme_stylebox("panel").bg_color = hover_color

# Handle hover when mouse exits a panel
func _on_panel_mouse_exited(panel: Panel):
	panel.get_theme_stylebox("panel").bg_color = original_color
