extends TileMapLayer

var prevTile = Vector2i(0, 0)
var tile = Vector2i(0, 0)
var gridSize = 16;
var Dic = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#for x in gridSize:
		#for y in gridSize:
			#set_cell(Vector2(x, y), 1, Vector2(0, 0), 0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	prevTile = tile;
	tile = local_to_map(get_global_mouse_position() / 2)
	
	if prevTile == tile:
		pass
	else:
		set_cell(prevTile)
		set_cell(tile, 1, Vector2(0, 0), 0)
	
	pass
