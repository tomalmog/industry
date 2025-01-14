extends Node

@export var buildings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _on_pre_tick():
	#for building in buildings:
		#buildings[building]._on_pre_tick()
		
func _on_tick():
	
	for building in buildings:
		buildings[building]._on_tick()

	pass
	
func get_building(pos: Vector2):
	if buildings.has(pos):
		return buildings[pos]
	return null

func get_buildings():
	return buildings
	
func set_buildings(new_buildings: Dictionary):
	buildings = new_buildings

func spawn_building(grid_position: Vector2, type: int, direction: Vector2) -> Node2D:
	
	var building = BuildData.building_types[type].new()
	
	if buildings.has(grid_position) && !buildings[grid_position].is_empty():
		
		ItemManager.delete_item(buildings[grid_position].stored_item)
		
	building.grid_position = grid_position
	building.position = WorldManager.tilemap_to_local(grid_position)
	buildings[grid_position] = building
	building.output_direction = direction
	
	building.initialize(BuildData.current_tile_rotations[type])
	return building
	
func delete_building(grid_position: Vector2):
	if buildings.has(grid_position) && buildings[grid_position]:	
		var item = buildings[grid_position].stored_item
		if is_instance_valid(item):
			ItemManager.delete_item(item)
		buildings.erase(grid_position)
	
