extends Node

# states
const IMMOVABLE = 0
const MOVABLE = 1

const GOLD_ID = 1
const IRON_ID = 2
const DIAMOND_ID = 3 

const GOLD_ORE = 10
const IRON_ORE = 20
const BRONZE_ORE = 30

const GOLD_NUGGET = 11
const IRON_NUGGET = 21
const BRONZE_NUGGET = 31

const GOLD_INGOT = 12
const IRON_INGOT = 22
const BRONZE_INGOT = 32

const GOLD_CUT = 13
const IRON_CUT = 23
const BRONZE_CUT = 33

var item_instances = {}


@export var items: Array[Item] = []  # List of all items in the game


func _ready() -> void:
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
	
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	
	pass

# Function to handle all items' movement every tick
func _on_tick():
	var visited_items = {}
	
	for item in items:
		if (item.state == ItemManager.IMMOVABLE):
			#item.set_state(ItemManager.MOVABLE)
			print(item, 'item immovable')
		item.is_moving = false

	var outer_chain = []
	
	for item in items:
		if item.get_state() == ItemManager.IMMOVABLE:
			visited_items[item] = true
			continue
		
		var visited_buildings = {}
		
		if not visited_items.has(item): 
			var building_stack = [item.stored_by]  # stack to process buildings
			var chain = []

			# run the DFS to check which items can move
			while building_stack.size() > 0:
				var building = building_stack.pop_back()
				var current_item = building.stored_item
				
				if visited_buildings.has(building):
					break
				if visited_items.has(current_item):
					continue
				
				if building:
					# Get the next belt position based on the belt's output_direction
					var next_pos = building.get_next()
					var next_building = BuildingManager.get_building(next_pos)
					
					chain.push_back([current_item, next_pos])
					visited_items[current_item] = true
					visited_buildings[building] = true

					if next_building == null || current_item == null:
						break
						
					building_stack.push_back(next_building)
										
					# Check if the next belt can accept the item
					if next_building and next_building.can_accept_item(current_item):
						for i in range(chain.size() - 1, -1, -1):
							var kvp = chain[i]
							move_item_to_next_tile(kvp[0], kvp[1])
							



#if WorldManager.is_hub_tile(next_pos):
						#for kvp in chain:
							#move_item_to_next_tile(kvp[0], kvp[1])


# Function to actually move the item to the next belt
func move_item_to_next_tile(item: Item, next_pos: Vector2) -> void:
	var next_belt = BuildingManager.get_building(next_pos)
	
	WorldManager.move_stored_item(item.stored_by, next_belt)
	
# Function to spawn an item
func spawn_item(type: int, state: int) -> Node:
	var new_item = item_instances[type].instantiate()
	new_item.type = type
	new_item.state = state
	
	items.append(new_item)
	WorldManager.world.add_child(new_item)
	return new_item
	
func delete_item(item: Item):
	
	item.stored_by.stored_item = null
	items.erase(item)
	item.queue_free()
