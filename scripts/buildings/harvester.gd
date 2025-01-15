# Author: Tom Almog
# File Name: harvester.gd
# Project Name: Industry
# Creation Date: 1/5/2025
# Modified Date: 1/14/2025
# Description: defines the harvester building type, which generates resources based on its level and grid position
extends Building

class_name Harvester

# the type of resource the harvester produces
var resource_type: int  

# pre: rotation is the initial rotation of the harvester
# post: none
# description: initializes the harvester building, setting its resource type, type, and operation intervals based on its level
func initialize(rotation: int):
	# gets the resource type the harvester will produce based on its grid position
	resource_type = ResourceManager.get_resource(grid_position)
	
	# sets the building type to HARVESTER_ID
	type = BuildData.HARVESTER_ID
	
	# defines operation intervals for different building levels
	operation_intervals = [4, 2, 1]
	
	# sets the operation interval based on the building's current level
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]

# pre: none
# post: none
# description: handles the generation of a resource when the building is ready to process
func run_tick():
	# checks if the harvester is ready to generate a resource and if it doesn't already have a stored item
	if resource_type != -1 && !stored_item:
		generate_resource()

# pre: none
# post: none
# description: creates a resource item and adds it to the scene
func generate_resource():
	# ensures the harvester doesn't generate resources if there is already a stored item
	if !stored_item:
		ItemManager.spawn_item(resource_type, self)

# pre: item and input_direction are parameters, but they aren't used in this function
# post: returns false since the harvester doesn't accept items
# description: method that checks if the harvester can accept an item, always returns false since they never can
func can_accept_item(item: Item, input_direction: Vector2):
	return false
