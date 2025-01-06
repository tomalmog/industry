extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in range(4, 7):
		for y in range(4, 7):
			set_cell(Vector2(x, y), 0, Vector2(0, 0), 0)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
