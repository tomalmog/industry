extends Node

const NO_SELECTION = -1

const BELT_ID = 2
const HARVESTER_ID = 3
const SMELTER_ID = 4
const HAMMER_ID = 5
const CUTTER_ID = 6
const TRASH_ID = 9
const ACCEPTER_ID = 10

var belt_icons
var harvester_icons
var smelter_icons
var hammer_icons
var cutter_icons
var trash_icons

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
	belt_icons = [preload("res://assets/icons/belt_one_icon.png"), preload("res://assets/icons/belt_two_icon.png"), preload("res://assets/icons/belt_three_icon.png")]
	harvester_icons = [preload("res://assets/icons/harvester_one_icon.png"), preload("res://assets/icons/harvester_two_icon.png"), preload("res://assets/icons/harvester_three_icon.png")]
	smelter_icons = [preload("res://assets/icons/smelter_one_icon.png"), preload("res://assets/icons/smelter_two_icon.png"), preload("res://assets/icons/smelter_three_icon.png")]
	hammer_icons = [preload("res://assets/icons/hammer_one_icon.png"), preload("res://assets/icons/hammer_two_icon.png"), preload("res://assets/icons/hammer_three_icon.png")]
	cutter_icons = [preload("res://assets/icons/cutter_one_icon.png"), preload("res://assets/icons/cutter_two_icon.png"), preload("res://assets/icons/cutter_three_icon.png")]
	trash_icons = [preload("res://assets/icons/trash_icon.png")]
	
	building_icons = {BELT_ID: belt_icons, HARVESTER_ID: harvester_icons, SMELTER_ID: smelter_icons, HAMMER_ID: hammer_icons, CUTTER_ID: cutter_icons, TRASH_ID: trash_icons}

func get_rotation(direction: Vector2):
	for rotation in directions:
		if directions[rotation] == direction:
			return rotation
			
func get_building_icon(id: int):
	return building_icons[id][UpgradeManager.get_building_level(id)]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
