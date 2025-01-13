extends TextureButton

var original_color: Color = Color(1, 1, 1)  # Default color (white)
var hover_color: Color = Color(1, 1, 1, 0.7)  # Hover color (gray)

func _ready() -> void:
	
	pressed.connect(_on_back_pressed)
	
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	# Change the button color on hover
	modulate = hover_color

func _on_mouse_exited():
	# Restore the original color when not hovering
	modulate = original_color
	
func _on_back_pressed():
	# Go back to the main scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	WorldManager.set_state(WorldManager.GAMEPLAY_STATE)
	InventoryManager.reload()
