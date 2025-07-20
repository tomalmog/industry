# Author: Tom Almog
# File Name: world_manager.gd
# Project Name: Industry
# Creation Date: 12/22/2024
# Modified Date: 1/14/2025
# Description: manages the game state, camera data, and interactions between game entities. controls game ticks and handles building and item operations
# this script acts as the "main.cs" for my program

<<<<<<< HEAD
### COURSE CONTENT (6/7)
=======
### CONTENT
>>>>>>> 1c6af5a (Fixed music and sound volume. Added documentation. Fixed visual bugs)

### OBJECT ORIENTED
### classes and objects are used everywhere throughout the program, most notably through the item and building classes
### inheritance present in all buildings as they derive from either the building class or transform_building class
### most buildings have some polymorphic method implemented

### 2D ARRAYS / LISTS / COLLECTIONS
### all tilemap and building information is stored in a dictionary that represents the 2D array that is the grid system
### all inventory data is stored in a dictionary containing a key of the item and a value of the amount that is stored
### items are stored in a list
### dictionaries used consistently throughout the program 
### notable uses include BuildingManager's building dictionary, InventoryManager's inventory, ItemManager's items
### ^^^ examples of use cases, can all be found in the scripts/managers folder

### FILE IO
### file io is used in the scripts/managers/save_data_manager.gd script
### this script allows for the saving, loading, and clearing of all game data
### there are buttons on screen to invoke this manager, the player can save their current game and delete their current save
### any saved data is loaded on startup
### autosave runs every minute incase the player forgets to manually save

### SORTING / SEARCHING
### sorting and searching used in the scripts/ui/inventory/control.gd script
### the player has the ability to sort the items present in their inventory based on either amount that they have, or alphabetic name of the item
### the player can also search for a specific item / item type by using the search bar and entering the item they are looking for
### the sorting is done using a recursive merge sort algorithm that accepts a comparison operator, so it can sort based on any metric
### the searching is done by filtering the items based on whether the searched term is contained in the item name

### RECURSION
### recursion is used in the scripts/ui/inventory/control.gd script
### used to implement merge sort

### STACKS / QUEUES
### stacks used in the scripts/managers/item_manager.gd script in the _on_tick() function
### the item manager script handles the movements of all items that are in the game
### for this to happen, it iterates through all items and performs a depth first search on their paths to see if they are able to move forward
### the depth first search uses a stack to keep track of the buildings that need to be checked to see if the item can move forward
### once the dfs reaches a building that has space for the items, the dfs is stopped and all items are moved forward
### if there are no more avaiable buildings to check in the stack, the dfs naturally ends
### algorithm explained in more detail in the comments on the item_manager.gd script itself

extends Node2D

# timer data
var tick_timer: Timer  # timer to control game ticks
const TICKS_PER_SECOND = 4  # number of ticks per second

# states
var state: int = GAMEPLAY_STATE  # current game state

const GAMEPLAY_STATE = 0  # state for regular gameplay
const INVENTORY_STATE = 1  # state for inventory management
const UPGRADE_STATE = 2  # state for upgrading buildings

# hub and tile sizes
const TILE_SIZE = 64  # size in pixels of each tile in the game grid
const HUB_SIZE = 3  # size of the hub in tiles

# camera position and zoom level
var camera_data = [Vector2(0, 0), Vector2(1, 1)]  

# tutorial data, [has_been_opened, is_open, current_stage]
var tutorial_data = [false, false, 0]

# pre: none
# post: none
# description: called when the node enters the scene tree for the first time. sets up the tick timer and connects it to the _on_tick function, starting our game
func _ready():
	# set up timer and add it to node tree
	tick_timer = Timer.new()
	tick_timer.wait_time = 1.0 / TICKS_PER_SECOND  # Set the tick rate
	tick_timer.autostart = true  # Start the timer automatically
	tick_timer.one_shot = false  # Timer repeats
	add_child(tick_timer)  # Add the timer to the scene tree
	
	# connect the timer's timeout signal to the _on_tick function
	tick_timer.connect("timeout", Callable(self, "_on_tick"))

# pre: none
# post: none
# description: handles game logic that runs every tick, updates the relevant managers depending on the current game state
func _on_tick():
	if state == GAMEPLAY_STATE:
		# Update gameplay managers for buildings and items
		BuildingManager._on_tick()
		ItemManager._on_tick()
	else:
		# Update item manager with the current state
		ItemManager.set_state(state)
		
	# Update save data manager on each tick, regardless of state
	SaveDataManager._on_tick()

# pre: building_one and building_two are valid Building objects
# post: none
# description: moves an item from one building to another, and updates their respective stored items
func move_stored_item(building_one: Building, building_two: Building):
	# define the item being moved
	var item = building_one.get_stored_item()
	
	# if the item is not null and hasnt already been moved
	if (item != null and not item.get_was_moved()):
		item.set_visibility(true)     # make the item visible if it isn't already
		item.set_was_moved(true)      # mark the item as moved
		
		# move the item to the new building
		item.move_to_building(building_two)
		
		# the second building now accepts the item
		building_two.input_item()  
		
		# clear the item from the first building
		building_one.stored_item = null

# pre: none
# post: returns the current state of the game
# description: gets the current game state. e.g gameplay, inventory, upgrade
func get_state():
	return state

# pre: new_state is a valid game state
# post: none
# description: Sets a new game state and updates the ItemManager to reflect the change.
func set_state(new_state: int):
	state = new_state
	ItemManager.set_state(state)

# pre: none
# post: returns the current camera position and zoom data
# description: Retrieves the current camera position and zoom level
func get_camera():
	return camera_data

# pre: pos is a valid position and zoom is a valid zoom factor
# post: none
# description: saves the current camera position and zoom level to camera_data.
func save_camera(pos: Vector2, zoom: Vector2):
	camera_data = [pos, zoom]

# pre: none
# post: returns the tutorial data 
# description: retrieves the tutorial data, including whether the tutorial is active and the current step
func get_tutorial_data():
	return tutorial_data

# pre: data is the tutorial progress to set, index is the tutorial step index
# post: none
# description: Sets the tutorial data for a specific index.
func set_tutorial_data(data, index: int):
	tutorial_data[index] = data

# pre: grid_position is a valid position in the tilemap
# post: returns the corresponding local position in the building layer
# description: converts a grid position to a local position in the building layer and returns it
func tilemap_to_local(grid_position: Vector2):
	var building_layer = get_node("/root/World/BuildingLayer")
	return building_layer.get_map_to_local(grid_position)
