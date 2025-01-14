extends TileMapLayer

var unselected_last_click = false
var toolbar_panel: Panel
var options_control: Control

var hub_size = WorldManager.HUB_SIZE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var buildings = BuildingManager.buildings
	
	for position in buildings:
		var building = buildings[position]
		if building:
			# Use the building's type and rotation to set the tile
			if building.get_type() != BuildData.ACCEPTER_ID:	
				set_cell(position, building.get_type(), Vector2(BuildData.get_rotation(building.output_direction), UpgradeManager.get_building_level(building.get_type())), 0)
		
	toolbar_panel = get_node("../CanvasLayer/ToolbarControl/IconPanel")
	options_control = get_node("../CanvasLayer/OptionsControl")
	
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var grid_position = local_to_map(mouse_position)
	
	
	
	if toolbar_panel.get_global_rect().has_point(get_viewport().get_mouse_position()):
		return
	
	if options_control.get_global_rect().has_point(get_viewport().get_mouse_position()):
		return
	
	
	if Input.is_action_pressed("left_click"): 
		if BuildData.current_tile_id != BuildData.NO_SELECTION:
			if (grid_position.x < -hub_size || grid_position.x >= hub_size || grid_position.y < -hub_size || grid_position.y >= hub_size):
				place_building(grid_position, BuildData.current_tile_id)

	if Input.is_action_just_released("right_click"):
		unselected_last_click = false
		
	if Input.is_action_pressed("right_click"):		
		if unselected_last_click:
			return
		
		if BuildData.current_tile_id != BuildData.NO_SELECTION:
			BuildData.current_tile_id = BuildData.NO_SELECTION
			unselected_last_click = true
		else:
			delete_tile(grid_position)
		
		
func place_building(grid_position: Vector2, id: int):
	set_cell(grid_position, id, Vector2i(BuildData.current_tile_rotations[id], UpgradeManager.get_building_level(id)), 0)
	
	var new_building = BuildingManager.spawn_building(grid_position, id, BuildData.directions[BuildData.current_tile_rotations[id]])
	
func place_upgraded_building(grid_position: Vector2):
	var atlas_coords = get_cell_atlas_coords(grid_position)
	var id = get_cell_source_id(grid_position)
	set_cell(grid_position, id, atlas_coords + Vector2(0, 1), 0)
	
func place_tile(grid_position: Vector2):
	set_cell(grid_position, BuildData.current_tile_id, Vector2i(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	
func delete_tile(grid_position: Vector2):
	set_cell(grid_position)
	
	BuildingManager.delete_building(grid_position)
	
func get_map_to_local(grid_position: Vector2):
	return map_to_local(grid_position) - Vector2(32, 32)
