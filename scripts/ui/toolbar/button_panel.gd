extends Panel

var original_color: Color = Color("99999900")  # Default background color
var hover_color: Color = Color("8B8F9E80")  # Hover background color

func _ready():
	# Allow the Panel to pass mouse interactions to children
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Connect hover signals
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	# Ensure children do not block mouse_entered/exited for the Panel
	for child in get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_mouse_entered():
	get_theme_stylebox("panel").bg_color = hover_color

func _on_mouse_exited():
	get_theme_stylebox("panel").bg_color = original_color
