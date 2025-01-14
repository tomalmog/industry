# Harvester.gd
extends "res://scripts/buildings/building.gd"
class_name Harvester

var resource_type: int         # Resource type the harvester produces

func initialize(rotation: int):
	resource_type = ResourceManager.get_resource(grid_position)
	type = BuildData.HARVESTER_ID
	
	operation_intervals = [4, 2, 1]
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]

func _run_tick():
	if resource_type != -1 && !stored_item:
		generate_resource()


# Generate a resource item and add it to the scene
func generate_resource():
	if !stored_item:
		var item = ItemManager.spawn_item(resource_type, self)
	
func can_accept_item(item: Item, input_direction: Vector2) -> bool:
	return false
