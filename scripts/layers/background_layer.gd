extends TileMapLayer

# sets world info
const WORLD_SIZE = 150
const ACCEPTOR_TOP_LEFT = Vector2(0, 0)
const ACCEPTOR_TOP_RIGHT = Vector2(2, 0)
const ACCEPTOR_BOTTOM_LEFT = Vector2(3, 0)
const ACCEPTOR_BOTTOM_RIGHT = Vector2(1, 0)
const ACCEPTOR_CORNER_TL = Vector2(7, 0)
const ACCEPTOR_CORNER_TR = Vector2(6, 0)
const ACCEPTOR_CORNER_BL = Vector2(4, 0)
const ACCEPTOR_CORNER_BR = Vector2(5, 0)
const ACCEPTOR_MIDDLE = Vector2(8, 0)

var hub_size = WorldManager.HUB_SIZE
var top_left = Vector2(-WORLD_SIZE, -WORLD_SIZE)
var bottom_right = Vector2(WORLD_SIZE, WORLD_SIZE)

# pre: none
# post: none
# description: initializes the tilemap layer and sets up the grid
func _ready():
	# Initialize the world grid to empty tiles
	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			set_cell(Vector2(x, y), 0, Vector2(0, 0), 0)
	
	# Spawn the hub buildings
	for x in range(-hub_size, hub_size):
		for y in range(-hub_size, hub_size):
			set_cell(Vector2(x, y), BuildData.ACCEPTER_ID, ACCEPTOR_MIDDLE, 0)
			BuildingManager.spawn_building(Vector2(x, y), BuildData.ACCEPTER_ID, Vector2.UP)
	
	# Set the boundary tiles for the hub
	for x in range(-hub_size, hub_size):
		set_cell(Vector2(x, -hub_size), BuildData.ACCEPTER_ID, ACCEPTOR_TOP_LEFT, 0)
	
	for x in range(-hub_size, hub_size):
		set_cell(Vector2(x, hub_size - 1), BuildData.ACCEPTER_ID, ACCEPTOR_TOP_RIGHT, 0)
	
	for y in range(-hub_size, hub_size):
		set_cell(Vector2(-hub_size, y), BuildData.ACCEPTER_ID, ACCEPTOR_BOTTOM_LEFT, 0)
	
	for y in range(-hub_size, hub_size):
		set_cell(Vector2(hub_size - 1, y), BuildData.ACCEPTER_ID, ACCEPTOR_BOTTOM_RIGHT, 0)

	# Set the corner tiles
	set_cell(Vector2(-hub_size, -hub_size), BuildData.ACCEPTER_ID, ACCEPTOR_CORNER_TL, 0)
	set_cell(Vector2(-hub_size, hub_size - 1), BuildData.ACCEPTER_ID, ACCEPTOR_CORNER_TR, 0)
	set_cell(Vector2(hub_size - 1, -hub_size), BuildData.ACCEPTER_ID, ACCEPTOR_CORNER_BL, 0)
	set_cell(Vector2(hub_size - 1, hub_size - 1), BuildData.ACCEPTER_ID, ACCEPTOR_CORNER_BR, 0)
