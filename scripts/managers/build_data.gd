# Author: Tom Almog
# File Name: build_data.gd
# Project Name: Industry
# Creation Date: 12/24/2024
# Modified Date: 1/14/2025
# Description: defines various constants, and loads some textures
extends Node

# Constants
const NO_SELECTION = -1  # No selection for the current tile
const BELT_ID = 2
const HARVESTER_ID = 3
const SMELTER_ID = 4
const HAMMER_ID = 5
const CUTTER_ID = 6
const TRASH_ID = 9
const ACCEPTER_ID = 10

# Directions
const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3
const DIRECTIONS = {UP: Vector2.UP, RIGHT: Vector2.RIGHT, DOWN: Vector2.DOWN, LEFT: Vector2.LEFT}
const DIRECTIONS_BY_VECTOR = {Vector2.UP: UP, Vector2.RIGHT: RIGHT, Vector2.DOWN: DOWN, Vector2.LEFT: LEFT}

# Lists to store icons for each building type
var belt_icons: Array
var harvester_icons: Array
var smelter_icons: Array
var hammer_icons: Array
var cutter_icons: Array
var trash_icons: Array

# Variables for current tile selection
var current_tile_id = NO_SELECTION
var current_tile_rotations = {NO_SELECTION: 0, HARVESTER_ID: 0, BELT_ID: 0, SMELTER_ID: 0, HAMMER_ID: 0, CUTTER_ID: 0, TRASH_ID: 0, ACCEPTER_ID: 0}

# Dictionary for building types mapped to their respective classes
var building_types = {BELT_ID: Belt, HARVESTER_ID: Harvester, SMELTER_ID: Smelter, HAMMER_ID: Hammer, CUTTER_ID: Cutter, TRASH_ID: Trash, ACCEPTER_ID: Accepter}

# dictionary to map building types to their respective icon lists
var building_icons: Dictionary

# pre: none
# post: initializes the icons for all building types
# description: called when the node enters the scene tree for the first time, 
# loading icons for all building types to be used in the UI
func _ready():
	# Load building icons
	belt_icons = [preload("res://assets/icons/belt_icon.png"), preload("res://assets/icons/belt_two_icon.png"), preload("res://assets/icons/belt_three_icon.png")]
	harvester_icons = [preload("res://assets/icons/harvester_icon.png"), preload("res://assets/icons/harvester_two_icon.png"), preload("res://assets/icons/harvester_three_icon.png")]
	smelter_icons = [preload("res://assets/icons/smelter_icon.png"), preload("res://assets/icons/smelter_two_icon.png"), preload("res://assets/icons/smelter_three_icon.png")]
	hammer_icons = [preload("res://assets/icons/hammer_icon.png"), preload("res://assets/icons/hammer_two_icon.png"), preload("res://assets/icons/hammer_three_icon.png")]
	cutter_icons = [preload("res://assets/icons/cutter_icon.png"), preload("res://assets/icons/cutter_two_icon.png"), preload("res://assets/icons/cutter_three_icon.png")]
	trash_icons = [preload("res://assets/icons/trash_icon.png")]
	
	# Map building types to their icons
	building_icons = {BELT_ID: belt_icons, HARVESTER_ID: harvester_icons, SMELTER_ID: smelter_icons, HAMMER_ID: hammer_icons, CUTTER_ID: cutter_icons, TRASH_ID: trash_icons}
			
# pre: id is the building type ID
# post: returns the appropriate icon for the building based on its level
# description: fetches the icon for the building type based on its current level
func get_building_icon(id: int):
	return building_icons[id][UpgradeManager.get_building_level(id)]
	
# pre: none
# post: returns the current tile ID
# description: retrieves the ID of the current selected tile
func get_current_tile_id():
	return current_tile_id

# pre: id is the new tile ID to be set
# post: none
# description: sets the ID of the current selected tile
func set_current_tile_id(id: int):
	current_tile_id = id

# pre: id is the building type ID
# post: returns the current rotation of the specified building type
# description: retrieves the rotation for the building type based on the tile ID
func get_current_tile_rotation(id: int):
	return current_tile_rotations[id]

# pre: id is the building type ID, rotation is the new rotation value
# post: none
# description: sets the rotation for the building type based on the tile ID
func set_current_tile_rotation(id: int, rotation: int):
	current_tile_rotations[id] = rotation
	
# pre: id is the building type ID
# post: returns the class that has that specific building ID
# description: retrieves the class associated with the inputted id
func get_building_type(id: int):
	return building_types[id]
