extends TileMapLayer

var resource_types = [ItemManager.GOLD_ORE, ItemManager.IRON_ORE, ItemManager.BRONZE_ORE, ItemManager.COAL]
var grid_min: Vector2 = Vector2(-250, -250)  # Minimum grid boundary
var grid_max: Vector2 = Vector2(250, 250)   # Maximum grid boundary
var max_resources = 3000  # Total number of resources to spawn
var min_distance = 6  # Minimum distance between spawned resources

var hub_padding = 4
var hub_margin = WorldManager.HUB_SIZE + hub_padding

var placed_positions = []  # Keep track of placed positions to ensure spacing

func _ready() -> void:
	var resources = ResourceManager.get_resources()
	if resources.size() == 0:
		
		randomize()
		# Spawn resources randomly
		for i in range(max_resources):
			var grid_position = get_random_grid_position()
			if grid_position != null:
				var resource_type = resource_types[randi() % resource_types.size()]
				
				spawn_resource(resource_type, grid_position)
				spawn_resource(resource_type, grid_position + Vector2(0, 1))
				spawn_resource(resource_type, grid_position + Vector2(1, 1))
				spawn_resource(resource_type, grid_position + Vector2(1, 0))
	else:
		for grid_position in resources:
			set_cell(grid_position, resources[grid_position], Vector2(0, 0), 0)

# Function to spawn a resource at a specific grid position
func spawn_resource(type: int, grid_position: Vector2):
	set_cell(grid_position, type, Vector2(0, 0), 0)
	ResourceManager.set_resource(grid_position, type)
	placed_positions.append(grid_position)

# Function to get a valid random grid position
func get_random_grid_position():
	for attempt in range(100):  # Try up to 100 times to find a valid position
		var x = randi_range(grid_min.x, grid_max.x)
		var y = randi_range(grid_min.y, grid_max.y)
		var random_position = Vector2(x, y)
		
		# Check if the position is far enough from other placed positions
		if is_valid_position(random_position):
			return random_position
	
	# If no valid position is found after 100 attempts, return null
	#return null

# Function to check if a position is valid (not too close to others)
func is_valid_position(position: Vector2) -> bool:
	
	if !(position.x < -hub_margin || position.x >= hub_margin || position.y < -hub_margin || position.y >= hub_margin):
		return false
	
	for existing_position in placed_positions:
		if position.distance_to(existing_position) < min_distance:
			return false
	return true
