extends Node2D

@export var tiles = {}
var goldIngot

var tick_timer: Timer
@export var ticks_per_second: int = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	print(get_local_mouse_position(), " testing")
	pass

func run_game_tick() -> void:
	
	if Input.is_action_just_released("left_click"):
		#spawn_item(get_global_mouse_position(), goldIngot, 0, 0)
		pass
		
	var spawn = Vector2(-5, -4)
	if tiles.has(spawn) && tiles[spawn].is_empty():
		var tile = get_tile(spawn)
		var item = create_item(0)
		item.move(tile.position)
		
		tile.stored_item = item
		
		
		
	for building in tiles:
		tiles[building].update_state(1.0 / ticks_per_second)
		print(tiles[building].position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tile(pos: Vector2):
	if tiles.has(pos):
		return tiles[pos]
	
func set_tile(pos: Vector2, building: Node2D):
	
	delete_tile_item(pos)
	
	tiles[pos] = building
	
func delete_tile_item(pos: Vector2):
	if tiles.has(pos):	
		var item = tiles[pos].stored_item
		if item:
			item.queue_free()


func create_item(type: int) -> Node:
	var item_scene = preload("res://scenes/item.tscn")
	
	var new_item = item_scene.instantiate()
	
	#new_item.stored_by = WorldManager.get_tile(tile)

	add_child(new_item)
	return new_item
	

func spawn_item(building: Node):
	var item_scene = preload("res://scenes/item.tscn")
	var new_item = item_scene.instantiate()
	
	building.add_child(new_item)
