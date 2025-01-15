# Author: Tom Almog
# File Name: building_layer.gd
# Project Name: Industry
# Creation Date: 1/1/2025
# Modified Date: 1/14/2025
# Description: tilemap layer for player and non-player placed buildings, handles visuals for buildings and updates the building manager accordingly
extends TileMapLayer

# variables
var unselected_last_click = false
var toolbar_panel: Panel
var options_control: Control
var hub_size = WorldManager.HUB_SIZE

# pre: none
# post: nones
# description: initializes the tile map layer and sets up the buildings based on their positions
func _ready():
	# load in any buildings that already exist
	var buildings = BuildingManager.get_buildings()
	
	# for each loaded building, add it to the tilemap
	for position in buildings:
		var building = buildings[position]
		if building:
			# use the building's type and rotation to set the tile
			if building.get_type() != BuildData.ACCEPTER_ID:	
				set_cell(position, building.get_type(), Vector2(BuildData.DIRECTIONS_BY_VECTOR[building.get_direction()], UpgradeManager.get_building_level(building.get_type())), 0)
	
	# load panels
	toolbar_panel = get_node("../CanvasLayer/ToolbarControl/IconPanel")
	options_control = get_node("../CanvasLayer/OptionsControl")

# pre: delta is the time elapsed since the last frame
# post: none
# description: processes user inputs to handle building placement, deletion, and tile interactions
func _process(delta: float):
	# get current mouse and grid positions
	var mouse_position = get_global_mouse_position()
	var grid_position = local_to_map(mouse_position)

	# skip processing if the mouse is over toolbar or options panel
	if toolbar_panel.get_global_rect().has_point(get_viewport().get_mouse_position()):
		return
	
	if options_control.get_global_rect().has_point(get_viewport().get_mouse_position()):
		return
	
	# handle left click for placing buildings, ensures a building is selected and the position isnt inside the hub
	if Input.is_action_pressed("left_click"): 
		if BuildData.get_current_tile_id() != BuildData.NO_SELECTION:
			if grid_position.x < -hub_size or grid_position.x >= hub_size or grid_position.y < -hub_size or grid_position.y >= hub_size:
				place_building(grid_position, BuildData.get_current_tile_id())

	# handle right click for building deletion and deselection
	if Input.is_action_just_released("right_click"):
		unselected_last_click = false
	
	if Input.is_action_pressed("right_click"):
		# if an item was deselected this click, do not delete a building
		if unselected_last_click:
			return
		
		# if a building is selected, unselect it, otherwise, delete the currently hovered building
		if BuildData.get_current_tile_id() != BuildData.NO_SELECTION:
			BuildData.set_current_tile_id(BuildData.NO_SELECTION)
			unselected_last_click = true
		else:
			delete_tile(grid_position)

# pre: grid_position is the position to place the building, id is the building type
# post: none
# description: places a building at the specified grid position
func place_building(grid_position: Vector2, id: int):
	# sets tilemap cell and spawns building using manager
	set_cell(grid_position, id, Vector2i(BuildData.get_current_tile_rotation(id), UpgradeManager.get_building_level(id)), 0)
	BuildingManager.spawn_building(grid_position, id, BuildData.DIRECTIONS[BuildData.get_current_tile_rotation(id)])

# pre: grid_position is the position to upgrade the building
# post: none
# description: places an upgraded version of the building at the specified grid position
func place_upgraded_building(grid_position: Vector2):
	# get the updated tile texture and id
	var atlas_coords = get_cell_atlas_coords(grid_position)
	var id = get_cell_source_id(grid_position)
	
	# set the tilemap cell
	set_cell(grid_position, id, atlas_coords + Vector2(0, 1), 0)

# pre: grid_position is the position to place the tile
# post: none
# description: places a tile at the specified grid position
func place_tile(grid_position: Vector2):
	set_cell(grid_position, BuildData.get_current_tile_id(), Vector2i(BuildData.get_current_tile_rotation(BuildData.get_current_tile_id()), 0), 0)

# pre: grid_position is the position to delete the tile
# post: none
# description: deletes the tile and any associated building at the specified grid position
func delete_tile(grid_position: Vector2):
	set_cell(grid_position)
	BuildingManager.delete_building(grid_position)

# pre: grid_position is the grid position to convert
# post: returns the local position corresponding to the grid position
# description: converts a grid position to a local position
func get_map_to_local(grid_position: Vector2):
	return map_to_local(grid_position) - Vector2(32, 32)
