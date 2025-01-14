extends Node

# Single file path for saving/loading data
const SAVE_FILE_PATH = "save_data/game_data.json"

# at 4 ticks a second, this sets up an autosave every minute
var ticks_between_autosaves = 240
var tick_counter = 0

# Placeholder for the game data to save
var game_data: Dictionary = {}



func _on_tick():
	if tick_counter >= ticks_between_autosaves:
		save_game_data()
		tick_counter = 0
	else:
		tick_counter += 1
	

func _ready() -> void:
	load_game_data()

func clear_save_data():
	save_file("", SAVE_FILE_PATH)

func save_game_data() -> void:
	# Save resource data
	var resources = ResourceManager.get_resources()
	var resource_data = {}
	for pos in resources:
		resource_data[pos] = [resources[pos]]
	game_data["resources"] = resource_data

	# Save building data
	var buildings = BuildingManager.get_buildings()
	var building_data = {}
	for pos in buildings:
		var building = buildings[pos]
		if building.get_type() == BuildData.ACCEPTER_ID:
			continue
		
		var stored_item_type
		var stored_item_visibility
		if building.get_stored_item() == null:
			stored_item_type = -1
		else:
			stored_item_type = building.get_stored_item().get_type()
			stored_item_visibility = building.get_stored_item().get_visibility()
			
		building_data[pos] = [building.get_type(), building.get_direction(), [stored_item_type, stored_item_visibility]]
	game_data["buildings"] = building_data

	# Save upgrade data
	var upgrade_data = UpgradeManager.get_building_levels()
	game_data["upgrades"] = upgrade_data
	
	# save inventory data
	var inventory_data = InventoryManager.get_inventory()
	game_data["inventory"] = inventory_data
	
	game_data["quests_completed"] = InventoryManager.get_quests_completed()
	game_data["has_opened_tutorial"] = WorldManager.get_tutorial_data()[0]

	# Save the consolidated game data to a single file
	save_file(JSON.stringify(game_data), SAVE_FILE_PATH)

func load_game_data() -> void:
	# Load the consolidated game data from the single file
	
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
				
		# Load buildings
		if loaded_data.has("buildings"):
			for pos in loaded_data["buildings"]:
				var building_info = loaded_data["buildings"][pos]
				var building = BuildingManager.spawn_building(
					string_to_vector2(pos),
					building_info[0],
					string_to_vector2(building_info[1])
				)
			
				if building_info[2][0] != -1:
					var item = ItemManager.spawn_item(building_info[2][0], building)
					item.set_visibility(building_info[2][1])
				
		# load inventory
		if loaded_data.has("inventory"):
			for item in loaded_data["inventory"]:
				InventoryManager.set_inventory_count(int(item), int(loaded_data["inventory"][item]))
			
		if loaded_data.has("quests_completed"):
			InventoryManager.set_quests_completed(int(loaded_data["quests_completed"]))
			
		if loaded_data.has("has_opened_tutorial"):
			WorldManager.set_tutorial_data(bool(loaded_data["has_opened_tutorial"]), 0)
	
		
		
		
		


func string_to_vector2(str: String) -> Vector2:
	# Remove the parentheses and split the string by the comma
	var cleaned_str = str.strip_edges().substr(1, str.length() - 2)
	var parts = cleaned_str.split(", ")
	
	# Convert the split parts to integers and create a Vector2
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
	
	# Read the content of the file
	var json_string = file.get_as_text()
	file.close()

	# Parse the JSON string
	var parse_result = JSON.parse_string(json_string)
	if parse_result == null:
		push_error("Failed to parse JSON: The result is null.")
		return {}
	
	# Return the parsed dictionary
	return parse_result
