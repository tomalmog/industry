extends Node

var BD = BuildData
var IM = ItemManager

var building_levels = {BD.HARVESTER_ID: 0, BD.BELT_ID: 0, BD.SMELTER_ID: 0, BD.HAMMER_ID: 0, BD.CUTTER_ID: 0}

var upgrade_requirements = {
	BD.HARVESTER_ID: [[IM.GOLD_ORE, 100], [IM.GOLD_ORE, 250], [IM.GOLD_NUGGET, 300]],
	BD.BELT_ID: [[IM.IRON_ORE, 100], [IM.IRON_ORE, 250], [IM.IRON_NUGGET, 300]],
	BD.SMELTER_ID: [[IM.BRONZE_ORE, 100], [IM.BRONZE_ORE, 250], [IM.BRONZE_NUGGET, 300]],
	BD.HAMMER_ID: [[IM.GOLD_INGOT, 100], [IM.IRON_INGOT, 200], [IM.BRONZE_INGOT, 300]], 
	BD.CUTTER_ID: [[IM.GOLD_CUT, 100], [IM.IRON_CUT, 250], [IM.BRONZE_CUT, 300]]
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_upgrade_requirements():
	return upgrade_requirements
	
func get_building_level(id: int):
	return building_levels[id]

func upgrade_building(id: int):
	print("upgraded")
	building_levels[id] += 1
