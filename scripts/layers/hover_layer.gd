extends TileMapLayer

# variables
var prev_cell = Vector2i(0, 0)
var curr_cell = Vector2i(0, 0)

# pre: delta is the time elapsed since the last frame
# post: none
# description: processes the mouse movement and updates the tile map dynamically
func _process(delta: float):
	prev_cell = curr_cell
	curr_cell = local_to_map(get_global_mouse_position())
	
	# clear the previous cell
	set_cell(prev_cell)
	
	var hub_size = WorldManager.HUB_SIZE
	
	# ensure the current cell is within the hub bounds
	if !(curr_cell.x < -hub_size or curr_cell.x >= hub_size or curr_cell.y < -hub_size or curr_cell.y >= hub_size):
		return
	
	# check if a valid tile is selected and update the current cell, spread out because line is too long
	if BuildData.get_current_tile_id() != BuildData.NO_SELECTION:
		set_cell(curr_cell, 
		BuildData.get_current_tile_id(), 
		Vector2(BuildData.get_current_tile_rotation(BuildData.get_current_tile_id()), 
		UpgradeManager.get_building_level(BuildData.get_current_tile_id())), 
		0
		)
