extends Node

const NO_SELECTION = -1

const BELT_ID = 2
const HARVESTER_ID = 3
const SMELTER_ID = 4
const HAMMER_ID = 5
const CUTTER_ID = 6
const TRASH_ID = 9

const ACCEPTER_ID = 10

const UP = 0;
const RIGHT = 1;
const DOWN = 2;
const LEFT = 3;

const directions = {0: Vector2.UP, 1: Vector2.RIGHT, 2: Vector2.DOWN, 3: Vector2.LEFT}

@export var current_tile_id = NO_SELECTION
@export var current_tile_rotations = {NO_SELECTION: 0, HARVESTER_ID: 0, BELT_ID: 0, SMELTER_ID: 0, HAMMER_ID: 0, CUTTER_ID: 0, TRASH_ID: 0, ACCEPTER_ID: 0}
@export var building_types = {BELT_ID: Belt, HARVESTER_ID: Harvester, SMELTER_ID: Smelter, HAMMER_ID: Hammer, CUTTER_ID: Cutter, TRASH_ID: Trash, ACCEPTER_ID: Accepter}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
