# Harvester.gd
extends "res://scripts/buildings/building.gd"
class_name Harvester

var resource_type: int         # Resource type the harvester produces

func initialize(rotation: int):
	resource_type = ResourceManager.get_resource(grid_position)
	operation_interval = 4
	type = BuildData.HARVESTER_ID

func _run_tick():
	if resource_type != -1 && !stored_item:
		generate_resource()


# Generate a resource item and add it to the scene
func generate_resource():
	if !stored_item:
		var item = ItemManager.spawn_item(resource_type)
		item.spawn_at_building(self)
		
		stored_item = item
	
func can_accept_item(item: Item, input_direction: Vector2) -> bool:
	return false
