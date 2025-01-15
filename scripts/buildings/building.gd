# Author: Tom Almog
# File Name: building.gd
# Project Name: Industry
# Creation Date: 12/24/2024
# Modified Date: 1/14/2025
# Description: abstract base building class. defines the general behavior and structure for all buildings in the game
extends Node2D

class_name Building

# properties
var type: int  # type of building, e.g 0: Smelter, 1: Harvester
var grid_position: Vector2  # position on tilemap
var output_direction: Vector2 = Vector2.UP  # direction the building is facing, default is up
var stored_item: Item = null  # reference to the item currently stored by the building
var inputs: Dictionary  # dictionary to store building-specific inputs
var operation_interval: int  # interval between operations in ticks
var operation_intervals: Array  # list of intervals for different building levels
var tick_counter: int = 0  # counts the ticks for operation timing

# pre: none
# post: none
# description: upgrades the building by adjusting its operation interval
func upgrade_building():
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]

# pre: rotation is the initial rotation of the building
# post: none
# description: overriden method that initializes the building using the rotation (direction it is facing)
# each building overrides this method and has a slightly different initialization
func initialize(rotation: int):
	pass

# pre: none
# post: returns the position of the next tile in the output direction
# description: calculates and returns the next tile position
func get_next():
	return grid_position + output_direction

# pre: item is the item being checked, input_direction is the direction from which the item is coming
# post: returns true if the item can be accepted, false otherwise
# description: overriden function that checks if the building can accept an item, 
# default behavior is to accept an item if there is space, but some buildings override this and have unique functionality 
func can_accept_item(item: Item, input_direction: Vector2):
	return is_empty()

# pre: none
# post: returns true if the building has no stored item, false otherwise
# description: checks if the building is empty
func is_empty():
	return stored_item == null

# pre: none
# post: none
# description: overriden method that handles the input of an item to a building, default method does nothing
func input_item():
	pass

# pre: none
# post: returns the type of the building
# description: retrieves the type of the building
func get_type():
	return type
	
# pre: id is the type the building will be set to
# post: returns the type of the building
# description: sets the building type
func set_type(id: int):
	type = id
	
# pre: new pos is the new position of the building
# post: none
# description: sets the building position
func set_grid_pos(new_pos: Vector2):
	grid_position = new_pos
	position = WorldManager.tilemap_to_local(grid_position)

# pre: none
# post: returns the output direction of the building
# description: retrieves the direction the building is facing
func get_direction():
	return output_direction
	
# pre: new dir is the new direction of the building
# post: none
# description: sets the direction the building is facing
func set_direction(new_dir: Vector2):
	output_direction = new_dir

# pre: none
# post: returns the integer representation of the output direction
# description: retrieves the direction of the building as an integer
func get_direction_int():
	return BuildData.DIRECTIONS_BY_VECTOR[output_direction]

# pre: none
# post: returns the stored item
# description: retrieves the item currently stored in the building
func get_stored_item():
	return stored_item
	
# pre: none
# post: returns the buildings position
# description: retrieves the global building position
func get_pos():
	return position

# pre: item is the item to store in the building
# post: none
# description: sets the item currently stored in the building
func set_stored_item(item: Item):
	stored_item = item

# pre: none
# post: none
# description: handles tick counting for every building, increments tick counter by one every tick and resets it once it has reached its operation interval
func _on_tick():
	tick_counter += 1
	
	# once operation interval is reached, run the building tick and reset counter
	if tick_counter >= operation_interval:
		run_tick()
		tick_counter = 0
	pass

# pre: none
# post: none
# description: overriden method that defines the building's behavior when its operation interval is reached
# to be implemented in the sub classes, default behavior is to do nothing on tick
func run_tick():
	pass
