extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("belt"):
		building_selected(BuildData.BELT_ID)
		
	if Input.is_action_just_pressed("smelter"):
		building_selected(BuildData.SMELTER_ID)
		
	if Input.is_action_just_pressed("cutter"):
		building_selected(BuildData.CUTTER_ID)
	
	if Input.is_action_just_pressed("harvester"):
		building_selected(BuildData.HARVESTER_ID)
		
	if Input.is_action_just_pressed("rotate"):
		rotate_selected_tile()


func building_selected(building_id: int):
		if BuildData.current_tile_id != building_id:
			BuildData.current_tile_id = building_id
		else:
			BuildData.current_tile_id = BuildData.NO_SELECTION

func rotate_selected_tile():
	BuildData.current_tile_rotations[BuildData.current_tile_id] = (BuildData.current_tile_rotations[BuildData.current_tile_id] + 1) % 4
