extends Node

const NO_SELECTION = -1

const BELT_ID = 2
const HARVESTER_ID = 3
const SMELTER_ID = 4
const HAMMER_ID = 5
const CUTTER_ID = 6
const TRASH_ID = 9
const ACCEPTER_ID = 10

var belt_icon
var harvester_icon
var smelter_icon
var hammer_icon
var cutter_icon
var trash_icon

const UP = 0;
const RIGHT = 1;
const DOWN = 2;
const LEFT = 3;

const directions = {UP: Vector2.UP, RIGHT: Vector2.RIGHT, DOWN: Vector2.DOWN, LEFT: Vector2.LEFT}

var current_tile_id = NO_SELECTION
var current_tile_rotations = {NO_SELECTION: 0, HARVESTER_ID: 0, BELT_ID: 0, SMELTER_ID: 0, HAMMER_ID: 0, CUTTER_ID: 0, TRASH_ID: 0, ACCEPTER_ID: 0}

var building_types = {BELT_ID: Belt, HARVESTER_ID: Harvester, SMELTER_ID: Smelter, HAMMER_ID: Hammer, CUTTER_ID: Cutter, TRASH_ID: Trash, ACCEPTER_ID: Accepter}
var building_icons


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	belt_icon = preload("res://assets/icons/belt_icon.png")
	harvester_icon = preload("res://assets/icons/harvester_icon.png")
	smelter_icon = preload("res://assets/icons/smelter_icon.png")
	hammer_icon = preload("res://assets/icons/hammer_icon.png")
	cutter_icon = preload("res://assets/icons/cutter_icon.png")
	trash_icon = preload("res://assets/icons/trash_icon.png")
	
	building_icons = {BELT_ID: belt_icon, HARVESTER_ID: harvester_icon, SMELTER_ID: smelter_icon, HAMMER_ID: hammer_icon, CUTTER_ID: cutter_icon, TRASH_ID: trash_icon}

func get_rotation(direction: Vector2):
	for rotation in directions:
		if directions[rotation] == direction:
			return rotation
			
func get_building_icon(id: int):
	return building_icons[id]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
