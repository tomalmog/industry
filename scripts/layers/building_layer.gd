extends TileMapLayer

var hub_size: int
var unselected_last_click = false
var camera: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	camera = get_node("../Camera")
	hub_size = get_node("../BackgroundLayer").hub_size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var cell_position = local_to_map(mouse_position)
	
	if Input.is_action_pressed("left_click"): 
		if BuildData.current_tile_id != BuildData.NO_SELECTION:
			if (cell_position.x < -hub_size || cell_position.x >= hub_size || cell_position.y < -hub_size || cell_position.y >= hub_size):
				place_building(cell_position)

	if Input.is_action_just_released("right_click"):
		unselected_last_click = false
		
	if Input.is_action_pressed("right_click"):		
		if unselected_last_click:
			return
		
		if BuildData.current_tile_id != BuildData.NO_SELECTION:
			BuildData.current_tile_id = BuildData.NO_SELECTION
			unselected_last_click = true
		else:
			delete_tile(cell_position)
		
		
func place_building(cell_position: Vector2):
	set_cell(cell_position, BuildData.current_tile_id, Vector2i(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	
	var new_building = BuildingManager.spawn_building(cell_position, BuildData.current_tile_id)
	
	new_building.type = BuildData.current_tile_id
	new_building.position = map_to_local(cell_position) - Vector2(32, 32)
	new_building.direction = BuildData.DIRECTIONS[BuildData.current_tile_rotations[BuildData.current_tile_id]]
	
	
func place_tile(cell_position: Vector2):
	set_cell(cell_position, BuildData.current_tile_id, Vector2i(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	
func delete_tile(cell_position: Vector2):
	set_cell(cell_position)
	
	BuildingManager.delete_building(cell_position)
