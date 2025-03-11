# Author: Tom Almog
# File Name: inventory_manager.gd
# Project Name: Industry
# Creation Date: 1/12/2025
# Modified Date: 1/24/2025
# Description: Manages quests and inventory, including quest progression and inventory operations
extends Node

var IM = ItemManager  # Reference to the ItemManager for item constants
var inventory: Dictionary  # Stores the inventory with item types as keys and counts as values

# List of quests where each quest specifies an item and the required quantity
var quests = [
	[IM.GOLD_ORE, 50], 
	[IM.IRON_ORE, 150], 
	[IM.BRONZE_ORE, 200], 
	[IM.BRONZE_NUGGET, 150], 
	[IM.COAL, 300],
	[IM.BRONZE_INGOT, 150],
	[IM.IRON_NUGGET, 300],
	[IM.IRON_INGOT, 300],
	[IM.GOLD_NUGGET, 300],
	[IM.GOLD_INGOT, 400],
	[IM.GOLD_CUT, 500],
	[IM.BRONZE_CUT, 500],
	[IM.IRON_CUT, 500]
]

# amount of quests in the game
const QUEST_AMOUNT = 13

var quests_completed: int  # Tracks the number of completed quests

# UI elements
var item_label: Label  # Label displaying the current quest item
var item_texture: TextureRect  # Texture displaying the current quest item image

# pre: none
# post: none
# description: resets inventory and completed quests
func _ready():
	# reset relevent data
	inventory = {}
	quests_completed = 0
	
	# reload nodes
	reload()

# pre: none
# post: none
# description: reloads UI nodes for quest updates
func reload():
	item_label = get_node("/root/World/Hub/ItemLabel")
	item_texture = get_node("/root/World/Hub/ItemTexture")

# pre: delta is the elapsed time since the previous frame
# post: none
# description: processes quest completion and updates relevant UI elements
func _process(delta: float):
	# get quest item and required amount
	var item = get_quest_item()
	var required = get_quest_requirement()
	
	# if it is in inventory, and there is more than the required amount, complete the quest and remove the items from inventory
	if inventory.has(item) && inventory[item] >= required:
		# mark quest as complete by moving forward
		quests_completed += 1
		
		# remove the amount of required items from inventory
		inventory[item] -= required
		
		# ensure that UI nodes are loaded and updated
		if !item_label:
			reload()
			
		item_label.update_quest_item()
		item_texture.update_quest_item()

# pre: none
# post: returns the item ID for the current quest
# description: retrieves the item type for the current quest
func get_quest_item():
	return quests[quests_completed % QUEST_AMOUNT][0]

# pre: none
# post: returns the required quantity for the current quest
# description: retrieves the item quantity required for the current quest. if quests have started repeating, multiply by 10 ^ times this quest has repeated
func get_quest_requirement():
	var requirement = quests[quests_completed % QUEST_AMOUNT][1] * pow(10, quests_completed / QUEST_AMOUNT)
	return requirement

# pre: none
# post: returns the number of quests completed
# description: retrieves the count of completed quests
func get_quests_completed():
	return quests_completed

# pre: completed is the new number of completed quests
# post: none
# description: sets the number of quests completed
func set_quests_completed(completed: int):
	quests_completed = completed
	item_label.update_quest_item()
	item_texture.update_quest_item()

# pre: type is the item type, count is the new inventory count for that type
# post: none
# description: sets the quantity of a specific item in the inventory
func set_inventory_count(type: int, count: int):
	inventory[type] = count

# pre: type is the item type
# post: returns the inventory count for the given item type
# description: retrieves the quantity of a specific item from the inventory
func get_inventory_count(type: int):
	if inventory.has(type):
		return inventory[type]
	else:
		return 0

# pre: none
# post: returns the full inventory dictionary
# description: returns the entire inventory dictionary
func get_inventory():
	return inventory

# pre: takes in a valid item to add to the inventory
# post: none
# description: adds an item to inventory
func add_to_inventory(item: Item):
	var type = item.get_type()
	if inventory.has(type):
		inventory[type] += 1
	else:
		inventory[type] = 1
