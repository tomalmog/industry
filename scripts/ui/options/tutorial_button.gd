extends TextureButton

# Timer for controlling the strobe speed
var time_accumulator: float = 0.0

# Strobe frequency (time to complete one cycle)
var strobe_speed: float = 0.5  # Adjust this value for faster or slower strobe effect

var direction = -1
var cutoff = 0.5

var tutorial_panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	tutorial_panel = get_node("../../../../CanvasLayer/ControlsControl/TutorialPanel")
	
	pressed.connect(toggle_tutorial)
	pass # No need for changes here.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if WorldManager.get_tutorial_data()[0] == false:
		if direction == 1:
			modulate.a += delta
		else:
			modulate.a -= delta
			
		if modulate.a > 1:
			direction = -1
			
		elif modulate.a < 0.5:
			direction = 1
	
func toggle_tutorial():
	WorldManager.set_tutorial_data(true, 0)
	
	tutorial_panel = get_node("../../../../CanvasLayer/ControlsControl/TutorialPanel")
	
	tutorial_panel.visible = !tutorial_panel.visible
	
	if tutorial_panel.visible:
		WorldManager.set_tutorial_data(true, 1)
	else:
		WorldManager.set_tutorial_data(false, 1)
