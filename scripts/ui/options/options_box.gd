extends HBoxContainer

var original_color: Color = Color(1, 1, 1)  # Default color (white)
var hover_color: Color = Color(1, 1, 1, 0.7)  # Hover color (gray)

func _ready() -> void:
	for button in get_children():
		button.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(button))
		button.connect("mouse_exited", Callable(self, "_on_mouse_exited").bind(button))

func _on_mouse_entered(button: Control):
	# Change the button color on hover
	button.modulate = hover_color

func _on_mouse_exited(button: Control):
	# Restore the original color when not hovering
	button.modulate = original_color
