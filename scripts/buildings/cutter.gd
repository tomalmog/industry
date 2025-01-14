extends TransformBuilding

class_name Cutter

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	type = BuildData.CUTTER_ID
	operation_intervals = [16, 8, 4]
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]
	
	inputs = {BuildData.directions[(rotation + 2) % 4]: 2}
	pass
