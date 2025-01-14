extends Node2D

var tick_timer: Timer
var ticks_per_second = 4
var tile_size = 64

var state: int = GAMEPLAY_STATE

const GAMEPLAY_STATE = 0
const INVENTORY_STATE = 1
const UPGRADE_STATE = 2
const SETTINGS_STATE = 3

const HUB_SIZE = 3

var camera_data = [Vector2(0, 0), Vector2(1, 1)]
var tutorial_data = [false, false, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tick_timer = Timer.new()
	tick_timer.wait_time = 1.0 / ticks_per_second
	tick_timer.autostart = true
	tick_timer.one_shot = false
	add_child(tick_timer)
	
	tick_timer.connect("timeout", Callable(self, "_on_tick"))

func _on_tick() -> void:
	if state == GAMEPLAY_STATE:
		BuildingManager._on_tick()
		ItemManager._on_tick()
	else:
		ItemManager.set_state(state)
		
	SaveDataManager._on_tick()
	
func set_tile(pos: Vector2, building: Node2D):
	
	
	delete_tile_item(pos)
	
	BuildingManager.buildings[pos] = building
	
func delete_tile_item(pos: Vector2):
	if BuildingManager.buildings.has(pos):	
		var item = BuildingManager.buildings[pos].stored_item
		if is_instance_valid(item):
			item.queue_free()

	

func move_stored_item(building_one: Building, building_two: Building):
	var item = building_one.stored_item
	if (item != null && item.was_moved == false):
		item.set_visibility(true)
		item.was_moved = true
		
		item.move_to_building(building_two)
		building_two.input_item()
		
		building_one.stored_item = null
		
		
func get_state():
	return state
	
func set_state(new_state: int):
	state = new_state
	ItemManager.set_state(state)
	
func get_camera():
	return camera_data

func save_camera(pos: Vector2, zoom: Vector2):
	camera_data = [pos, zoom]
	
func get_tutorial_data():
	return tutorial_data

func set_tutorial_data(data, index: int):
	tutorial_data[index] = data
	
func tilemap_to_local(grid_position: Vector2):
	var building_layer = get_node("/root/World/BuildingLayer")
	
	return building_layer.get_map_to_local(grid_position)
