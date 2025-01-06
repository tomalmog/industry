# Harvester.gd
extends "res://scripts/buildings/building.gd"
class_name Harvester

@export var harvest_interval: int = 4  # tick interval to generate resources
@export var resource_type: int = 0         # Resource type the harvester produces
var harvest_timer: float = 0            # Timer for harvesting

# Custom behavior for the harvester
func custom_behavior(delta: float):
	if !stored_item:
		harvest_timer += 1
		if harvest_timer >= harvest_interval:
			harvest_timer = 0
			generate_resource()

# Generate a resource item and add it to the scene
func generate_resource():
	if !stored_item:
		var item = ItemManager.spawn_item(0)
		
		item.type = resource_type
		item.position = position
		item.stored_by = self
		
		stored_item = item
		print("item generated")
