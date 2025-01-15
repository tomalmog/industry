# Author: Tom Almog
# File Name: item_manager.gd
# Project Name: Industry
# Creation Date: 1/3/2025
# Modified Date: 1/14/2025
# Description: Manages item behaviors, including spawning, movement, deletion, and interactions with buildings.
extends Node

# current state of inventory manager
var state = WorldManager.GAMEPLAY_STATE

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
# description: Initializes item instances and prepares the game state for gameplay
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
# this function performs an iterative depth first search to determine valid item movements through the  belt network
# it ensures items are moved to the next valid position, updates their state, and resolves any collisions or movement constraints
func _on_tick():
	# reset item movement
	stop_item_movement()
	
	# dictionary to keep track of visited items
	var visited_items = {}
	
	# loop through all items
	for item in items:
		
		# dictionary to track visited buildings
		var visited_buildings = {} 
		
		# if the item has not been visited before, run the DFS to see if it can move forward
		if not visited_items.has(item): 
			# stack to process buildings in the DFS
			var building_stack = [item.stored_by] 
			
			# list to hold the current chain of item movements 
			var chain = []                

			# run DFS to check which items can move
			while building_stack.size() > 0:
				# Pop a building from the stack and get the item stored in that building
				var building = building_stack.pop_back()  
				var current_item = building.stored_item  
				
				# if the building has already been visited, skip it
				if visited_buildings.has(building):
					break
				# if the item has already been visited, skip it
				if visited_items.has(current_item):
					continue
				
				# make sure building is not null
				if building:
					# get the next belt position based on the belt's output direction
					var next_pos = building.get_next()
					var next_building = BuildingManager.get_building(next_pos)
					
					# add the current item and next position to the movement chain
					chain.push_back([current_item, next_pos])
					
					# mark the item as visited and mark the building as visited
					visited_items[current_item] = true  
					visited_buildings[building] = true  

					# if there is no next building or the item is stored by a harvester (cant accept items), stop the chain
					if next_building == null or current_item == null or next_building.get_type() == BuildData.HARVESTER_ID:
						break
						
					# push the next building onto the stack so that it can be explored once the DFS continues
					building_stack.push_back(next_building)
					
					# check if the next building can accept the item
					if next_building and next_building.can_accept_item(current_item, building.output_direction * -1):
						# move the item along the chain from the last to the first
						for i in range(chain.size() - 1, -1, -1):
							var pair = chain[i]
							move_item_to_next_tile(pair[0], pair[1])
							
# pre: item is valid, next_pos is a valid position
# post: none
# description: Moves the specified item to the next tile
func move_item_to_next_tile(item: Item, next_pos: Vector2) -> void:
	if item != null:
		WorldManager.move_stored_item(item.get_stored_by(), BuildingManager.get_building(next_pos))

# pre: type is a valid item type, building is a valid Building object that the item will be added to
# post: returns the spawned item
# description: Spawns a new item of the specified type at the given building
func spawn_item(type: int, building: Building):
	# instantiates new item
	var new_item = item_instances[type].instantiate()
	
	# set properties
	new_item.spawn_at_building(building)

	# add item to items list and add it to node tree
	items.append(new_item)
	WorldManager.add_child(new_item)
	
	# return the new item
	return new_item

# pre: item is a valid Item object
# post: none
# description: Deletes the specified item from the game
func delete_item(item: Item):
	# gets rid of reference to item from its building
	item.get_stored_by().set_stored_item(null)
	
	# deletes item from item list and removes it from node tree
	items.erase(item)
	item.queue_free()

# pre: none
# post: returns the list of all items in the game
# description: retrieves the list of all items
func get_items():
	return items

# pre: none
# post: returns the dictionary of item instances
# description: Retrieves the dictionary of item instances
func get_item_instances():
	return item_instances

# pre: none
# post: returns the current state of the item manager
# description: returns item manager state
func get_state():
	return state
	
# pre: new state is a valid integer state
# post: none
# description: sets the item manager state
func set_state(new_state: int):
	state = new_state
	if state == WorldManager.GAMEPLAY_STATE:
		for item in items:
			item.set_visibility(true)
	else:
		stop_item_movement()
