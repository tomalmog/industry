extends TileMapLayer

var prev_cell = Vector2i(0, 0)
var curr_cell = Vector2i(0, 0)
var Dic = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	prev_cell = curr_cell;
	curr_cell = local_to_map(get_global_mouse_position())
	
	set_cell(prev_cell)
	
	if BuildData.current_tile_id != BuildData.no_selection:
		set_cell(curr_cell, BuildData.current_tile_id, Vector2(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	

	pass
