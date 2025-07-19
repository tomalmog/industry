extends TileMapLayer

# resource generation constants
const RESOURCE_TYPES = [ItemManager.GOLD_ORE, ItemManager.IRON_ORE, ItemManager.BRONZE_ORE, ItemManager.COAL] # types
const MAX_RESOURCES = 800  # total number of resources to spawn
const MIN_DISTANCE = 6  # minimum distance between spawned resources
const HUB_PADDING = 4 # min distance from hub
const HUB_MARGIN = WorldManager.HUB_SIZE + HUB_PADDING

var grid_min: Vector2 = Vector2(-100, -100)  # minimum grid boundary
var grid_max: Vector2 = Vector2(100, 100)   # maximum grid boundary

var placed_positions = []  # keep track of placed positions to ensure spacing

# pre: none
# post: none
# description: initializes the resource map and spawns resources if not already present
func _ready():
	# load in any existing resources
	var resources = ResourceManager.get_resources()
	
	# if no resources have been generated, generate them, otherwise, loop through resources and fill tilemap
	if resources.size() == 0:
		randomize()
		
		# loop through, spawning a resource MAX_RESOURCES times
		for i in range(MAX_RESOURCES):
			# pick random position
			var grid_position = get_random_grid_position()
			
			# if the position is valid, randomly select a resource type and spawn a 2x2 resource node
			if grid_position != null:
				var resource_type = RESOURCE_TYPES[randi() % RESOURCE_TYPES.size()]
				
				spawn_resource(resource_type, grid_position)
				spawn_resource(resource_type, grid_position + Vector2.UP)
				spawn_resource(resource_type, grid_position + Vector2.RIGHT)
				spawn_resource(resource_type, grid_position + Vector2.UP + Vector2.RIGHT)
	else:
		for grid_position in resources:
			set_cell(grid_position, resources[grid_position], Vector2(0, 0), 0)

# pre: type is the resource type, grid_position is the target position for the resource
# post: none
# description: spawns a resource of the specified type at the given grid position
func spawn_resource(type: int, grid_position: Vector2):
	# place resource node
	set_cell(grid_position, type, Vector2(0, 0), 0)
	ResourceManager.set_resource(grid_position, type)
	
	# add node to list to ensure other nodes arent placed too close
	placed_positions.append(grid_position)

# pre: none
# post: returns a valid random grid position or null if none is found
# description: generates a random grid position that is valid and far enough from other resources
func get_random_grid_position():
	for attempt in range(100):  # try up to 100 times to find a valid position, not forever incase there is no valid positions left
		# set random position
		var x = randi_range(grid_min.x, grid_max.x)
		var y = randi_range(grid_min.y, grid_max.y)
		var random_position = Vector2(x, y)
		
		# check if the position is far enough from other placed positions
		if is_valid_position(random_position):
			return random_position
	
	# if no valid position is found after 100 attempts, return null
	return null

# pre: position is the position to validate
# post: returns true if the position is valid, false otherwise
# description: checks if a position is valid based on its distance from the hub and other resources
func is_valid_position(position: Vector2) -> bool:
	# if position in hub return invalid
	if !(position.x < -HUB_MARGIN or position.x >= HUB_MARGIN or position.y < -HUB_MARGIN or position.y >= HUB_MARGIN):
		return false
	
	# loop through already placed nodes and make sure this node is far enough away from them
	for existing_position in placed_positions:
		if position.distance_to(existing_position) < MIN_DISTANCE:
			return false
	return true
