# Author: Tom Almog
# File Name: belt.gd
# Project Name: Industry
# Creation Date: 12/24/2024
# Modified Date: 1/10/2025
# Description: defines the belt building type, used for transporting items across the grid
extends Building

class_name Belt

# pre: rotation is the initial rotation of the belt
# post: none
# description: initializes the belt building, setting its type to belt
func initialize(rotation: int):
	type = BuildData.BELT_ID
