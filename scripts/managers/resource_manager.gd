extends Node

var resources = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_resources():
	return resources

func get_resource(grid_position: Vector2):
	if resources.has(grid_position):
		return resources[grid_position]
	return -1
	
func set_resource(grid_position: Vector2, type: int):
	resources[grid_position] = type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
