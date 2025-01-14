extends Node

var BD = BuildData
var IM = ItemManager

var building_levels = {BD.HARVESTER_ID: 0, BD.BELT_ID: 0, BD.SMELTER_ID: 0, BD.HAMMER_ID: 0, BD.CUTTER_ID: 0, BD.TRASH_ID: 0}

var upgrade_requirements = {
	BD.HARVESTER_ID: [[IM.GOLD_ORE, 100], [IM.GOLD_ORE, 250]],
	BD.SMELTER_ID: [[IM.BRONZE_ORE, 100], [IM.BRONZE_ORE, 250]],
	BD.HAMMER_ID: [[IM.GOLD_INGOT, 100], [IM.IRON_INGOT, 200]], 
	BD.CUTTER_ID: [[IM.GOLD_CUT, 100], [IM.IRON_CUT, 250]]
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
	
func set_building_level(id: int, level: int):
	building_levels[id] = level

func upgrade_building(id: int):
	building_levels[id] += 1
	
	var buildings = BuildingManager.get_buildings()
	
	for building_pos in buildings:
		var building = buildings[building_pos]
		if building && building.get_type() == id:
			building.upgrade_building()

func get_building_levels():
	return building_levels
	
func set_building_levels(levels: Dictionary):
	building_levels = levels
	
	
	
	
