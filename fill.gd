extends TileMapLayer

var gridSize = 16;
var Dic = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in gridSize:
		for y in gridSize:
			set_cell(Vector2(x, y), 0, Vector2(1, 1), 0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
