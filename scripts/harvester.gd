# Harvester.gd
extends "res://scripts/building.gd"

@export var harvest_interval: float = 3.0  # Time interval to generate resources
@export var resource_type: int = 0         # Resource type the harvester produces
var harvest_timer: float = 0.0             # Timer for harvesting

# Custom behavior for the harvester
func custom_behavior(delta: float):
	harvest_timer += delta
	if harvest_timer >= harvest_interval:
		harvest_timer = 0.0
		generate_resource()

# Generate a resource item and add it to the scene
func generate_resource():
	var item_scene = preload("res://scenes/item.tscn")  # Ensure this path is correct
	var new_item = item_scene.instance()
	new_item.type = resource_type
	new_item.global_position = global_position
	get_tree().root.add_child(new_item)  # Add the new item to the scene tree
