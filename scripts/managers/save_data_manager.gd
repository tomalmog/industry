# Author: Tom Almog
# File Name: save_data_manager.gd
# Project Name: Industry
# Creation Date: 1/13/2025
# Modified Date: 1/14/2025
# Description: handles saving and loading game data using file IO
extends Node

# Single file path for saving/loading data
const SAVE_FILE_PATH = "save_data/game_data.json"

# Set up amount of ticks between autosaves, at 4 ticks a second, this autosaves every minute
const TICKS_BETWEEN_AUTOSAVES = 240
var tick_counter = 0

# Placeholder for the game data to save
var game_data: Dictionary = {}

# pre: none
# post: none
# description: called every tick to check if it's time to save the game data
func _on_tick():
	if tick_counter >= TICKS_BETWEEN_AUTOSAVES:
		# save game data and reset counter
		save_game_data()
		tick_counter = 0
	else:
		#increment counter
		tick_counter += 1
	
# pre: none
# post: loads the game data at the start
# description: loads the saved game data when the game starts
func _ready():
	load_game_data()

# pre: none
# post: none
# description: clears the save data by overwriting the save file with an empty string
func clear_save_data():
	save_file("", SAVE_FILE_PATH)

# pre: none
# post: none
# description: saves the current game data, including resources, buildings, upgrades, inventory, and quests
func save_game_data() -> void:
	# Save resource data
	# get all resource nodes and initialize dictionary to store data
	var resources = ResourceManager.get_resources()
	var resource_data = {}
	
	# populate dictionary with resource nodes
	for pos in resources:
		resource_data[pos] = [resources[pos]]
	
	# store resource data
	game_data["resources"] = resource_data

	# Save building data
	# get all buildings and initialize dictionary to store data
	var buildings = BuildingManager.get_buildings()
	var building_data = {}
	
	# populate dictionary with buildings and building info
	for pos in buildings:
		var building = buildings[pos]
		
		# do not add accepter type buildings to the list
		if building.get_type() == BuildData.ACCEPTER_ID:
			continue
		
		# store item and item visibility if item is not null
		var stored_item_type
		var stored_item_visibility
		if building.get_stored_item() == null:
			stored_item_type = -1
		else:
			stored_item_type = building.get_stored_item().get_type()
			stored_item_visibility = building.get_stored_item().get_visibility()
		
		# add all the information to the dictionary
		building_data[pos] = [building.get_type(), building.get_direction(), [stored_item_type, stored_item_visibility]]
	
	# store building data
	game_data["buildings"] = building_data

	# Save upgrade data
	var upgrade_data = UpgradeManager.get_building_levels()
	game_data["upgrades"] = upgrade_data
	
	# save inventory data
	var inventory_data = InventoryManager.get_inventory()
	game_data["inventory"] = inventory_data
	
	# save quest data
	game_data["quests_completed"] = InventoryManager.get_quests_completed()
	
	# save tutorial data
	game_data["has_opened_tutorial"] = WorldManager.get_tutorial_data()[0]

	# Save the consolidated game data to a single file
	save_file(JSON.stringify(game_data), SAVE_FILE_PATH)

func load_game_data() -> void:
	# load the consolidated game data from the single file
	
	var loaded_data = load_file(SAVE_FILE_PATH)
	if loaded_data:
		# Load resources
		if loaded_data.has("resources"):
			for pos in loaded_data["resources"]:
				ResourceManager.set_resource(string_to_vector2(pos), loaded_data["resources"][pos][0])

		# Load upgrades
		if loaded_data.has("upgrades"):
			for upgrade in loaded_data["upgrades"]:
				UpgradeManager.set_building_level(int(upgrade), int(loaded_data["upgrades"][upgrade]))
				
		# Load buildings, use string_to_vector to convert the strings back into vector2
		if loaded_data.has("buildings"):
			for pos in loaded_data["buildings"]:
				var building_info = loaded_data["buildings"][pos]
				var building = BuildingManager.spawn_building(
					string_to_vector2(pos),
					building_info[0],
					string_to_vector2(building_info[1])
				)
				
				# if the building has an item, spawn it at itself
				if building_info[2][0] != -1:
					var item = ItemManager.spawn_item(building_info[2][0], building)
					item.set_visibility(building_info[2][1])
				
		# load inventory
		if loaded_data.has("inventory"):
			for item in loaded_data["inventory"]:
				InventoryManager.set_inventory_count(int(item), int(loaded_data["inventory"][item]))
		
		# load quests
		if loaded_data.has("quests_completed"):
			InventoryManager.set_quests_completed(int(loaded_data["quests_completed"]))
		
		# load tutorial
		if loaded_data.has("has_opened_tutorial"):
			WorldManager.set_tutorial_data(bool(loaded_data["has_opened_tutorial"]), 0)
	
func string_to_vector2(str: String) -> Vector2:
	# remove the parentheses and split the string by the comma
	var cleaned_str = str.strip_edges().substr(1, str.length() - 2)
	var parts = cleaned_str.split(", ")
	
	# convert the split parts to integers and create a Vector2
	var x = int(parts[0])
	var y = int(parts[1])

	return Vector2(x, y)

func save_file(json_string: String, file_path: String) -> bool:
	# attempt to open the file for writing
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
	if file == null:
		push_error("Failed to open file for writing at path: %s" % file_path)
		return false
	
	# write the content to the file
	file.store_string(json_string)
	file.close()
	return true

func load_file(file_path: String) -> Dictionary:
	# check if the file exists
	if !FileAccess.file_exists(file_path):
		push_error("File not found at path: %s" % file_path)
		return {}
	
	# attempt to open the file for reading
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
	if file == null:
		push_error("Failed to open file for reading at path: %s" % file_path)
		return {}
	
	# read the content of the file
	var json_string = file.get_as_text()
	file.close()

	# parse the JSON string
	var parse_result = JSON.parse_string(json_string)
	if parse_result == null:
		push_error("Failed to parse JSON: The result is null.")
		return {}
	
	# Return the parsed dictionary
	return parse_result
