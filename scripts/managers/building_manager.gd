# Author: Tom Almog
# File Name: building_manager.gd
# Project Name: Industry
# Creation Date: 12/24/2024
# Modified Date: 1/14/2025
# Description: Manages the buildings in the game world, including spawning, deleting, and updating their state
extends Node

# A dictionary to hold buildings, keyed by their grid position
var buildings: Dictionary

# pre: none
# post: none
# description: sets up the buildings dictionary to keep track of the buildings in the game world
func _ready():
	buildings = {}

# pre: none
# post: none
# description: iterates through all the buildings and calls their _on_tick function to have them perform their operations
func _on_tick():
	for building in buildings:
		buildings[building]._on_tick()

# pre: pos is the grid position to search for
# post: returns the building at the specified position or null if it doesn't exist
# description: checks if a building exists at the specified position and returns it
func get_building(pos: Vector2):
	if buildings.has(pos):
		return buildings[pos]
	return null

# pre: none
# post: returns the buildings dictionary
# description: returns all buildings currently in the world
func get_buildings():
	return buildings

# pre: grid_position is the position to place the building, type is the building's type, direction is the building's rotation
# post: creates and returns the new building instance
# description: spawns a new building of a given type, checks for an existing building at the grid position, and deletes any building & stored item in that position
func spawn_building(grid_position: Vector2, type: int, direction: Vector2):
	# get new instance of building
	var building: Building = BuildData.get_building_type(type).new()
	
	# If there’s an existing building at the grid position, delete its stored item
	if buildings.has(grid_position) && !buildings[grid_position].is_empty():
		ItemManager.delete_item(buildings[grid_position].get_stored_item())
	
	# set the building's properties
	building.set_type(type)
	building.set_grid_pos(grid_position)
	building.set_direction(direction)

	# update the buildings dictinoary to contain the new building
	buildings[grid_position] = building
	
	# Initialize the building with the proper rotation
	building.initialize(BuildData.DIRECTIONS_BY_VECTOR[direction])
	
	# return the new building
	return building
	
# pre: grid_position is the position of the building to delete
# post: none
# description: deletes the building at the specified position, and removes its stored item if there is one
func delete_building(grid_position: Vector2):
	# check if there is a building to be deleted
	if buildings.has(grid_position) && buildings[grid_position]:
		# if there is a stored item, delete it
		var item = buildings[grid_position].stored_item
		if is_instance_valid(item):
			ItemManager.delete_item(item)
			
		# delete the building by eraing it from the building array
		buildings.erase(grid_position)
