extends HBoxContainer

var building_ids = {"Belt": BuildData.BELT_ID}

var ids = [2, 3, 4, 5, 6, 9]
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for panel in get_children():
		var texture_button = panel.get_children()[0]
		# Connect the button press signal to the _button_pressed function, passing the corresponding building ID
		var id = ids[counter]
		texture_button.pressed.connect(func(): _button_pressed(id))
		counter += 1
	pass

func _button_pressed(building_id: int):
	# Call the build selection function with the correct building ID
	BuildSelection.building_selected(building_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
