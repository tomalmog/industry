extends Node

var state = WorldManager.GAMEPLAY_STATE

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

const COAL_ORE = 49

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
	
	item_instances[COAL_ORE] = preload("res://scenes/items/coal_ore.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func stop_item_movement():
	for item in items:
		item.is_moving = false
		item.position = item.stored_by.position

# Function to handle all items' movement every tick
func _on_tick():
	
	var visited_items = {}
	stop_item_movement()

	var outer_chain = []
	
	for item in items:
		
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

					if next_building == null || current_item == null || next_building.type == BuildData.HARVESTER_ID:
						break
						
					building_stack.push_back(next_building)
										
					# Check if the next belt can accept the item
					if next_building and next_building.can_accept_item(current_item, building.output_direction * -1):
						for i in range(chain.size() - 1, -1, -1):
							var kvp = chain[i]
							move_item_to_next_tile(kvp[0], kvp[1])
							




# Function to actually move the item to the next belt
func move_item_to_next_tile(item: Item, next_pos: Vector2) -> void:
	var next_belt = BuildingManager.get_building(next_pos)
	
	WorldManager.move_stored_item(item.stored_by, next_belt)
	
# Function to spawn an item
func spawn_item(type: int) -> Node:
	var new_item = item_instances[type].instantiate()
	new_item.type = type
	
	items.append(new_item)
	WorldManager.world.add_child(new_item)
	return new_item
	
func delete_item(item: Item):
	
	item.stored_by.stored_item = null
	items.erase(item)
	item.queue_free()
	
func get_state():
	return state
	
func set_state(new_state: int):
	state = new_state
	if state == WorldManager.GAMEPLAY_STATE:
		for item in items:
			item.set_visibility(true)
	else:
		stop_item_movement()
		
