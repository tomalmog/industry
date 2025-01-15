# Author: Tom Almog
# File Name: cutter.gd
# Project Name: Industry
# Creation Date: 1/4/2025
# Modified Date: 1/14/2025
# Description: defines the cutter building type, which processes ingots into cuts with different operation speeds depending on the building's level
extends TransformBuilding

class_name Cutter

# pre: rotation is the initial rotation of the cutter
# post: none
# description: initializes the cutter building, setting its type, operation intervals, and inputs
# updates operation interval based on building level
func initialize(rotation: int):
	# sets building type to CUTTER_ID
	type = BuildData.CUTTER_ID
	
	# defines operation intervals for different building levels
	operation_intervals = [16, 8, 4] 
	
	# sets the operation interval based on the building's current level
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]
	
	# sets inputs based on rotation, where input direction is adjusted by the rotation
	inputs = {BuildData.DIRECTIONS[(rotation + 2) % 4]: 2}
