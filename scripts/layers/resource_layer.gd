extends TileMapLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(5, 9):
		for y in range(5, 9):
			spawn_resource(ItemManager.GOLD_ORE, Vector2(x, y))
			
	for x in range(-9, -5):
		for y in range(-9, -5):
			spawn_resource(ItemManager.IRON_ORE, Vector2(x, y))
	
	pass # Replace with function body.

func spawn_resource(type: int, grid_position: Vector2):
	set_cell(grid_position, type, Vector2(0, 0), 0)
	
	ResourceManager.set_resource(grid_position, type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	pass
