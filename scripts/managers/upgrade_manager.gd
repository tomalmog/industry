# Author: Tom Almog
# File Name: upgrade_manager.gd
# Project Name: Industry
# Creation Date: 1/12/2025
# Modified Date: 1/14/2025
# Description: manages building levels and upgrades, including storing the current level of each building type and the upgrade requirements for each building
extends Node

var BD = BuildData  # Reference to BuildData constants for building types
var IM = ItemManager  # Reference to ItemManager for item types

var building_levels: Dictionary  # stores the current level of each building type
var upgrade_requirements: Dictionary  # stores the upgrade requirements for each building type

# pre: none
# post: none
# description: Called when the node enters the scene tree for the first time, setting up the initial state for building levels and upgrade requirements.
func _ready():
	# initialize the building levels for each building type
	building_levels = {
		BD.HARVESTER_ID: 0,
		BD.BELT_ID: 0,
		BD.SMELTER_ID: 0,
		BD.HAMMER_ID: 0,
		BD.CUTTER_ID: 0,
		BD.TRASH_ID: 0
	}
	
	# initialize the upgrade requirements for each building type
	upgrade_requirements = {
		BD.HARVESTER_ID: [[IM.GOLD_ORE, 250], [IM.GOLD_ORE, 500]],
		BD.SMELTER_ID: [[IM.BRONZE_ORE, 150], [IM.BRONZE_ORE, 300]],
		BD.HAMMER_ID: [[IM.IRON_INGOT, 150], [IM.IRON_INGOT, 300]],
		BD.CUTTER_ID: [[IM.BRONZE_CUT, 100], [IM.GOLD_CUT, 200]]
	}

# pre: none
# post: returns the dictionary of upgrade requirements
# description: Retrieves the upgrade requirements for each building type.
func get_upgrade_requirements():
	return upgrade_requirements

# pre: id is a valid building type ID
# post: returns the current level of the building type specified by id
# description: Retrieves the current level of a specified building type.
func get_building_level(id: int):
	return building_levels[id]

# pre: id is a valid building type ID, level is the new level for the building
# post: none
# description: Sets the level of a specified building type.
func set_building_level(id: int, level: int):
	building_levels[id] = level

# pre: id is a valid building type ID
# post: none
# description: upgrades the level of a specified building type and upgrades all buildings of that type in the game.
func upgrade_building(id: int):
	# upgrades building level
	building_levels[id] += 1
	
	# retrieve all buildings in the game
	var buildings = BuildingManager.get_buildings()
	
	# iterate through all buildings to upgrade the relevant ones
	for building_pos in buildings:
		var building = buildings[building_pos]
		if building and building.get_type() == id:
			building.upgrade_building()

# pre: none
# post: returns the dictionary of building levels
# description: Retrieves the current levels of all buildings.
func get_building_levels():
	return building_levels
