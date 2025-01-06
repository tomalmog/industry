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
		buildings[building].custom_behavior(1.0 / WorldManager.ticks_per_second)

	pass
	
func get_building(pos: Vector2):
	if buildings.has(pos):
		return buildings[pos]
	return null


func spawn_building(grid_position: Vector2, type: int) -> Node2D:
	
	
	var building = BuildData.building_types[type].new()
	
	if buildings.has(grid_position) && !buildings[grid_position].is_empty():
		
		var item = buildings[grid_position].stored_item
		item.stored_by = building
		building.stored_item = item
		

	
	building.grid_position = grid_position
	buildings[grid_position] = building
	return building
	
func delete_building(grid_position: Vector2):
	if buildings.has(grid_position) && buildings[grid_position]:	
		var item = buildings[grid_position].stored_item
		if is_instance_valid(item):
			ItemManager.items.erase(item)
			item.queue_free()
		buildings.erase(grid_position)
	
