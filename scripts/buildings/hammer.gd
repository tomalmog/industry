extends TransformBuilding

class_name Hammer

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	
	inputs = {BuildData.directions[(rotation + 2) % 4]: 1}
	
	type = BuildData.HAMMER_ID
	operation_intervals = [12, 6, 3]
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]
	pass
