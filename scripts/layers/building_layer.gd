extends TileMapLayer

var hub_size: int
var unselected_last_click = false
var camera: Node
var panel: Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	camera = get_node("../Camera")
	hub_size = get_node("../BackgroundLayer").hub_size
	panel = get_node("../CanvasLayer/Panel")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var grid_position = local_to_map(mouse_position)
	
	
	
	print(get_local_mouse_position())
	
	if panel.get_global_rect().has_point(get_local_mouse_position()):
		return
	
	
	if Input.is_action_pressed("left_click"): 
		if BuildData.current_tile_id != BuildData.NO_SELECTION:
			if (grid_position.x < -hub_size || grid_position.x >= hub_size || grid_position.y < -hub_size || grid_position.y >= hub_size):
				place_building(grid_position)

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
		
		
func place_building(grid_position: Vector2):
	set_cell(grid_position, BuildData.current_tile_id, Vector2i(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	
	var new_building = BuildingManager.spawn_building(grid_position, BuildData.current_tile_id)
	
	new_building.type = BuildData.current_tile_id
	new_building.position = map_to_local(grid_position) - Vector2(32, 32)
	new_building.output_direction = BuildData.output_directions[BuildData.current_tile_rotations[BuildData.current_tile_id]]
	
	
func place_tile(grid_position: Vector2):
	set_cell(grid_position, BuildData.current_tile_id, Vector2i(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	
func delete_tile(grid_position: Vector2):
	set_cell(grid_position)
	
	BuildingManager.delete_building(grid_position)
