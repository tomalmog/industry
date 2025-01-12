extends Node2D

var tick_timer: Timer
@export var ticks_per_second: int = 4
@export var tile_size = 64

var background_layer: Node2D
var world: Node





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world = get_tree().root
	
	background_layer = get_node("/root/World/BackgroundLayer")
	
	
	tick_timer = Timer.new()
	tick_timer.wait_time = 1.0 / ticks_per_second
	tick_timer.autostart = true
	tick_timer.one_shot = false
	add_child(tick_timer)
	
	tick_timer.connect("timeout", Callable(self, "_on_tick"))
	

	
	
	pass # Replace with function body.

func _on_tick() -> void:
	run_game_tick()
	pass


func run_game_tick() -> void:
	
	BuildingManager._on_tick()
	
	ItemManager._on_tick()

	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
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
		item.visible = true
		item.was_moved = true
		
		item.move_to_building(building_two)
		building_two.input_item()
		
		building_one.stored_item = null
		

func is_hub_tile(grid_position: Vector2):
	return !(grid_position.x < -background_layer.get_hub_size() || grid_position.x >= background_layer.get_hub_size() || grid_position.y < -background_layer.get_hub_size() || grid_position.y >= background_layer.get_hub_size())
		
