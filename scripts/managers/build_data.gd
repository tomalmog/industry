extends Node

const NO_SELECTION = -1
const BELT_ID = 2
const SMELTER_ID = 3
const CUTTER_ID = 4

const UP = 0;
const RIGHT = 1;
const DOWN = 2;
const LEFT = 3;

const DIRECTIONS = {0: Vector2.UP, 1: Vector2.RIGHT, 2: Vector2.DOWN, 3: Vector2.LEFT}

@export var current_tile_id = NO_SELECTION
@export var current_tile_rotations = {NO_SELECTION: 0, BELT_ID: 0, SMELTER_ID: 0, CUTTER_ID: 0}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
