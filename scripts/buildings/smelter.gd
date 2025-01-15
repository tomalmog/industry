# Author: Tom Almog
# File Name: smelter.gd
# Project Name: Industry
# Creation Date: 1/5/2025
# Modified Date: 1/14/2025
# Description: defines the smelter building type, which processes ore and coal to generate smelted nuggets, speed is based on its operation level
extends TransformBuilding

class_name Smelter

# properties
var has_coal: bool  # flag indicating if the smelter has coal ready for processing
var has_ore: bool  # flag indicating if the smelter has ore ready for processing

# pre: rotation is the initial rotation of the smelter
# post: none
# description: initializes the smelter building, setting up inputs, operation intervals, and generating state
func initialize(rotation: int):
	# Initializes flags for coal and ore availability
	has_coal = false
	has_ore = false
	is_generating = false
	
	# Defines input directions and expected item types, ore and coal
	inputs = {BuildData.DIRECTIONS[(rotation + 2) % 4]: ItemManager.ORE, BuildData.DIRECTIONS[(rotation + 3) % 4]: ItemManager.COAL}
	
	# Sets the building type to SMELTER_ID
	type = BuildData.SMELTER_ID
	
	# Defines operation intervals based on building level
	operation_intervals = [8, 4, 2]
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]

# pre: item is the item being checked, input_direction is the direction from which the item is coming
# post: returns true if the smelter can accept the item, false otherwise
# description: checks if the smelter can accept the given item (coal or ore) from the specified input direction
func can_accept_item(item: Item, input_direction: Vector2) -> bool:
	if inputs.has(input_direction):
		if item.type == ItemManager.COAL and !has_coal:
			return true
		elif item.type % 10 == ItemManager.ORE and !has_ore:
			return true
	return false

# pre: none
# post: none
# description: handles the input of an item (coal or ore) into the smelter and starts the generation process if applicable
func input_item():
	# Check the type of the stored item, delete it from the world and mark it as accepted in self
	if stored_item.type == ItemManager.COAL:
		# delete item
		ItemManager.delete_item(stored_item)
		stored_item = null
		
		# mark as accepted
		has_coal = true
	elif stored_item.type % 10 == ItemManager.ORE:
		# set output type 
		output_type = stored_item.type
		
		# delete item
		ItemManager.delete_item(stored_item)
		stored_item = null
		
		# mark as accepted
		has_ore = true
	
	# Attempt to start generating the output
	try_generating()

# pre: none
# post: none
# description: attempts to start the generation process if both ore and coal are available
func try_generating():
	# if both resources are available and the building isn't currently generating, begin generating a nugget
	if has_ore and has_coal and !is_generating:
		is_generating = true
		tick_counter = 0
		has_ore = false
		has_coal = false
