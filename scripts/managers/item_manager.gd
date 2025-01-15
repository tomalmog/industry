# Author: Tom Almog
# File Name: item_manager.gd
# Project Name: Industry
# Creation Date: 1/3/2025
# Modified Date: 1/14/2025
# Description: Manages item behaviors, including spawning, movement, deletion, and interactions with buildings.
extends Node

# Item types categorized by group
const ORE = 0
const GOLD_ORE = 10
const IRON_ORE = 20
const BRONZE_ORE = 30

const NUGGET = 1
const GOLD_NUGGET = 11
const IRON_NUGGET = 21
const BRONZE_NUGGET = 31

const INGOT = 2
const GOLD_INGOT = 12
const IRON_INGOT = 22
const BRONZE_INGOT = 32

const CUT = 3
const GOLD_CUT = 13
const IRON_CUT = 23
const BRONZE_CUT = 33

const COAL = 49

var item_instances = {}  # Dictionary mapping item types to their respective scene instances
var items: Array[Item]  # List of all items in the game

# pre: none
# post: none
# description: Initializes item instances and prepares the game state for gameplay.
func _ready():
	items = []

	# Preload item scenes and store in the item_instances dictionary
	item_instances[GOLD_ORE] = preload("res://scenes/items/gold_ore.tscn")
	item_instances[GOLD_NUGGET] = preload("res://scenes/items/gold_nugget.tscn")
	item_instances[GOLD_INGOT] = preload("res://scenes/items/gold_ingot.tscn")
	item_instances[GOLD_CUT] = preload("res://scenes/items/gold_cut.tscn")
	item_instances[IRON_ORE] = preload("res://scenes/items/iron_ore.tscn")
	item_instances[IRON_NUGGET] = preload("res://scenes/items/iron_nugget.tscn")
	item_instances[IRON_INGOT] = preload("res://scenes/items/iron_ingot.tscn")
	item_instances[IRON_CUT] = preload("res://scenes/items/iron_cut.tscn")
	item_instances[BRONZE_ORE] = preload("res://scenes/items/bronze_ore.tscn")
	item_instances[BRONZE_NUGGET] = preload("res://scenes/items/bronze_nugget.tscn")
	item_instances[BRONZE_INGOT] = preload("res://scenes/items/bronze_ingot.tscn")
	item_instances[BRONZE_CUT] = preload("res://scenes/items/bronze_cut.tscn")
	item_instances[COAL] = preload("res://scenes/items/coal_ore.tscn")

# pre: none
# post: none
# description: resets item movevment at the start of the frame, setting all items to stop moving
func stop_item_movement():
	# loop through all items, resetting their movement and snapping their position to their building
	for item in items:
		item.set_is_moving(false)
		item.set_position(item.get_stored_by().get_pos())

# pre: none
# post: none
# description: Handles the movement of all items during each game tick. 
# this function performs an iterative depth-first search to determine valid item movements through the  belt network
# It ensures items are moved to the next valid position, updates their state, and resolves any collisions or movement constraints
func _on_tick():
	var visited_items = {}  # tracks items that have already been processed during this tick
	stop_item_movement()  # reset item movement and snap them to their storage positions

	# iterate through all items in the game
	for item in items:
		if visited_items.has(item):  # skip items that have already been processed
			continue

		# initialize stacks and tracking structures for the DFS process
		var building_stack = [item.get_stored_by()]  # stack of buildings to go through
		var chain = []  # tracks the movement chain for this item
		var visited_buildings = {}  # tracks buildings visited during this item's DFS

		# perform DFS to calculate the movement chain for the item
		while building_stack.size() > 0:
			var building = building_stack.pop_back()  # get the next building to process
			var current_item = building.get_stored_item()  # get the item stored at the current building

			if visited_buildings.has(building):  # avoid processing the same building twice
				break
			if visited_items.has(current_item):  # skip if the item was already processed
				continue

			# determine the next position and building in the chain
			var next_pos = building.get_next()  # calculate the next position based on building logic
			var next_building = BuildingManager.get_building(next_pos)  # get the building at the next position

			# record the item and its next position in the movement chain
			chain.push_back([current_item, next_pos])
			visited_items[current_item] = true  # mark the item as processed
			visited_buildings[building] = true  # mark the building as visited

			# Stop if there are no more valid movements for the item
			if next_building == null or current_item == null or next_building.get_type() == BuildData.HARVESTER_ID:
				break

			# If the next building can accept the item, add the building to the stack for so that the DFS can continue to search through that added building
			if next_building.can_accept_item(current_item, building.get_direction() * -1):
				# push the building onto the stop
				building_stack.push_back(next_building)

		# process the chain of movements calculated by the DFS
		for pair in chain:
			move_item_to_next_tile(pair[0], pair[1])

# pre: item is valid, next_pos is a valid position
# post: none
# description: Moves the specified item to the next tile.
func move_item_to_next_tile(item: Item, next_pos: Vector2) -> void:
	if item != null:
		WorldManager.move_stored_item(item.get_stored_by(), BuildingManager.get_building(next_pos))

# pre: type is a valid item type, building is a valid Building object that the item will be added to
# post: returns the spawned item
# description: Spawns a new item of the specified type at the given building.
func spawn_item(type: int, building: Building):
	# instantiates new item
	var new_item = item_instances[type].instantiate()
	
	# set properties
	new_item.set_type(type)
	new_item.spawn_at_building(building)

	# add item to items list and add it to node tree
	items.append(new_item)
	WorldManager.add_child(new_item)
	
	# return the new item
	return new_item

# pre: item is a valid Item object
# post: none
# description: Deletes the specified item from the game.
func delete_item(item: Item):
	# gets rid of reference to item from its building
	item.get_stored_by().set_stored_item(null)
	
	# deletes item from item list and removes it from node tree
	items.erase(item)
	item.queue_free()

# pre: none
# post: returns the list of all items in the game
# description: Retrieves the list of all items.
func get_items():
	return items

# pre: none
# post: returns the dictionary of item instances
# description: Retrieves the dictionary of item instances.
func get_item_instances():
	return item_instances
