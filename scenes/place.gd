extends TileMapLayer


var unselected_last_click = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var cell_position = local_to_map(mouse_position)
	
	
	
	# need to make a method for changing between the many types of machines and handling this without an independant if else statement
	if Input.is_action_just_pressed("belt"):
		building_selected(BuildData.belt_id)
		
	if Input.is_action_just_pressed("smelter"):
		building_selected(BuildData.smelter_id)
		
	if Input.is_action_just_pressed("cutter"):
		building_selected(BuildData.cutter_id)
		
	
	if Input.is_action_just_pressed("rotate"):
		rotate_selected_tile()
	
	if Input.is_action_pressed("left_click"): 
		if BuildData.current_tile_id != BuildData.no_selection:
			place_tile(cell_position)
		
		
		
	if Input.is_action_just_released("right_click"):
		unselected_last_click = false
		
	if Input.is_action_pressed("right_click"):		
		if unselected_last_click:
			return
		
		if BuildData.current_tile_id != BuildData.no_selection:
			BuildData.current_tile_id = BuildData.no_selection
			unselected_last_click = true
		else:
			delete_tile(cell_position)
		



func place_tile(cell_position: Vector2):
	set_cell(cell_position, BuildData.current_tile_id, Vector2i(BuildData.current_tile_rotations[BuildData.current_tile_id], 0), 0)
	
func delete_tile(cell_position: Vector2):
	set_cell(cell_position)
	
func building_selected(building_id: int):
		if BuildData.current_tile_id != building_id:
			BuildData.current_tile_id = building_id
		else:
			BuildData.current_tile_id = BuildData.no_selection
	
	

func rotate_selected_tile():
	BuildData.current_tile_rotations[BuildData.current_tile_id] = (BuildData.current_tile_rotations[BuildData.current_tile_id] + 1) % 4



func rotate_hovered_tile(cell_position: Vector2):
	var rotation = (get_cell_atlas_coords(cell_position).x + 1) % 4
	var id = get_cell_source_id(cell_position)
	
	set_cell(cell_position, id, Vector2i(rotation, 0))
	
	
	
	print('rotated')
	
