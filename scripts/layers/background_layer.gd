extends TileMapLayer

@export var chunk_size = 150
var hub_size = 3

var top_left = Vector2(-chunk_size, -chunk_size)
var bottom_right = Vector2(chunk_size, chunk_size)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			set_cell(Vector2(x, y), 0, Vector2(0, 0), 0)
			
	for x in range(-hub_size, hub_size):
		for y in range(-hub_size, hub_size):
			set_cell(Vector2(x, y), BuildData.ACCEPTER_ID, Vector2(8, 0), 0)
			BuildingManager.spawn_building(Vector2(x, y), BuildData.ACCEPTER_ID)
			
	for x in range(-hub_size, hub_size):
		set_cell(Vector2(x, -hub_size), BuildData.ACCEPTER_ID, Vector2(0, 0), 0)
	for x in range(-hub_size, hub_size):
		set_cell(Vector2(x, hub_size - 1), BuildData.ACCEPTER_ID, Vector2(2, 0), 0)
	for y in range(-hub_size, hub_size):
		set_cell(Vector2(-hub_size, y), BuildData.ACCEPTER_ID, Vector2(3, 0), 0)
	for y in range(-hub_size, hub_size):
		set_cell(Vector2(hub_size - 1, y), BuildData.ACCEPTER_ID, Vector2(1, 0), 0)
	
	set_cell(Vector2(-hub_size, -hub_size), BuildData.ACCEPTER_ID, Vector2(7, 0), 0)
	set_cell(Vector2(-hub_size, hub_size - 1), BuildData.ACCEPTER_ID, Vector2(6, 0), 0)
	set_cell(Vector2(hub_size - 1, -hub_size), BuildData.ACCEPTER_ID, Vector2(4, 0), 0)
	set_cell(Vector2(hub_size - 1, hub_size - 1), BuildData.ACCEPTER_ID, Vector2(5, 0), 0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_hub_size():
	return hub_size
