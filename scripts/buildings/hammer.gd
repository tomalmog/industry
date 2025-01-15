# Author: Tom Almog
# File Name: hammer.gd
# Project Name: Industry
# Creation Date: 1/4/2025
# Modified Date: 1/14/2025
# Description: defines the hammer building type, which processes nuggets into ingots with varying different speeds depending on the building's level
extends TransformBuilding

class_name Hammer

# pre: rotation is the initial rotation of the hammer
# post: none
# description: initializes the hammer building
func initialize(rotation: int):
	# sets inputs based on rotation, where input direction is adjusted by the rotation
	inputs = {BuildData.DIRECTIONS[(rotation + 2) % 4]: 1}
	
	# sets building type to HAMMER_ID
	type = BuildData.HAMMER_ID
	
	# defines operation intervals for different building levels
	operation_intervals = [12, 6, 3]
	
	# sets the operation interval based on the building's current level
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]
