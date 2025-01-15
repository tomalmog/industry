# Author: Tom Almog
# File Name: build_selection.gd
# Project Name: Industry
# Creation Date: 12/20/2024
# Modified Date: 12/30/2024
# Description: Handles player input for selecting and interacting with buildings.
extends Node

# pre: delta is the time elapsed since the last frame
# post: none
# description: called every frame to process player input for building selection and rotation
func _process(delta: float):
	#if a building selection input is pressed, select that building
	if Input.is_action_just_pressed("belt"):
		building_selected(BuildData.BELT_ID)
	
	if Input.is_action_just_pressed("harvester"):
		building_selected(BuildData.HARVESTER_ID)
		
	if Input.is_action_just_pressed("smelter"):
		building_selected(BuildData.SMELTER_ID)
		
	if Input.is_action_just_pressed("hammer"):
		building_selected(BuildData.HAMMER_ID)
	
	if Input.is_action_just_pressed("cutter"):
		building_selected(BuildData.CUTTER_ID)
		
	if Input.is_action_just_pressed("trash"):
		building_selected(BuildData.TRASH_ID)
		
	# if rotate is pressed, rotate the currently selected tile
	if Input.is_action_just_pressed("rotate"):
		rotate_selected_tile()

# pre: building_id is the ID of the building type being selected
# post: none
# description: toggles the selection of a building based on the inputted ID
func building_selected(building_id: int):
	if BuildData.get_current_tile_id() != building_id:
		BuildData.set_current_tile_id(building_id)
	else:
		BuildData.set_current_tile_id(BuildData.NO_SELECTION)

# pre: none
# post: rotates the currently selected tile to the next direction
# description: increments the rotation of the currently selected tile
func rotate_selected_tile():
	BuildData.set_current_tile_rotation(
		BuildData.get_current_tile_id(),
		(BuildData.get_current_tile_rotation(BuildData.get_current_tile_id()) + 1) % 4
	)
