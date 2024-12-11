#extends TileMapLayer
#
#var window = DisplayServer.window_get_size();
#var gridSize = tile_set.tile_size
#var grid = Vector2(window.x / gridSize.x, window.y / gridSize.y)
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#
	#print(gridSize)
	#
	#
	#for x in grid.x:
		#for y in grid.y:
			#set_cell(Vector2(x, y), 0, Vector2(0, 0), 0)
	#
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#
	#pass

extends TileMapLayer

@export var base_tile_id: int = 0  # The ID of the base tile in the TileSet
@export var update_frequency: float = 0.1  # How often to update the grid (in seconds)

var camera: Camera2D = null
var timer: float = 0.0

func _ready():
	# Find the Camera2D node
	camera = get_viewport().get_camera_2d()

func _process(delta):
	

	timer += delta
	if timer >= update_frequency:
		timer = 0
		update_visible_tiles()

func update_visible_tiles():
	if not camera:
		return

	# Calculate the visible world rectangle
	var zoom = camera.zoom
	var viewport_size = get_viewport_rect().size
	var visible_world_rect = Rect2(
		camera.global_position - (viewport_size * zoom * 0.5),
		viewport_size * zoom
	)

	# Convert world bounds to tile bounds
	var top_left = local_to_map(visible_world_rect.position)
	var bottom_right = local_to_map(visible_world_rect.position + visible_world_rect.size)

	# Iterate through visible tiles and place  base tile
	for x in range(top_left.x, bottom_right.x + 1):
		for y in range(top_left.y, bottom_right.y + 1):
			
			set_cell(Vector2(x, y), base_tile_id, Vector2(0, 0), 0)
			
			pass
			#if get_cell_source_id(Vector2(x, y)) == BuildData.no_selection:
				
				
