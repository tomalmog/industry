extends Node2D

var goldIngot

var tick_timer: Timer
@export var ticks_per_second: int = 4
@export var tile_size = 64



var world: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world = get_tree().root
	goldIngot = preload("res://assets/goldIngot.png")
	
	
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
	
	
	ItemManager._on_tick()

	BuildingManager._on_tick()

	

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

	

func move_stored_item(building_one: Node, building_two: Node):
	if (building_one.stored_item != null && building_one.stored_item.was_moved == false):
		building_one.stored_item.was_moved = true
		
		building_one.stored_item.move_to_building(building_two)
		
		building_one.stored_item = null
		
		
