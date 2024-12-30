extends TileMapLayer

@export var chunk_size = 150
@export var hub_size = 4

var top_left = Vector2(-chunk_size, -chunk_size)
var bottom_right = Vector2(chunk_size, chunk_size)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			set_cell(Vector2(x, y), 0, Vector2(0, 0), 0)
			
	for x in range(-hub_size, hub_size):
		for y in range(-hub_size, hub_size):
			set_cell(Vector2(x, y), BuildData.NO_SELECTION)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
